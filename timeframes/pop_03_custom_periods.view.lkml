###  Period over Period Method 3: Custom choice of current and previous periods with parameters


# Like Method 2, but instead of using parameters to simply select the appropriate date dimension,
# we will use liquid to define the logic to pick out the correct periods for each selection.


include: "/**/*.view.lkml"

view: pop_03_custom_periods {
  extends: [mx_marketing_base, pop_02_liquid]

  dimension: adgroup_id { hidden: no }
  dimension: outcome_tracker_id { hidden: yes }
  dimension: row_id { hidden: yes }
  dimension: final_url { hidden: yes }
  dimension: subtype_codes_raw { hidden: yes }
  dimension: subtype_codes_str { hidden: yes }
  dimension: subtype_codes { hidden: yes }
  dimension: sc_service { hidden: yes }
  dimension: sc_offering { hidden: yes }
  dimension: sc_topic { hidden: yes }
  dimension: sc_medium { hidden: yes }

  measure: impr_avail { hidden: yes }
  measure: outcomes_bulk_sum { hidden: yes }
  measure: ctr_bar { hidden: yes }
  measure: o_referrals_num { hidden: no }
  measure: o_leads_num { hidden: no }
  measure: o_outcomes_num { hidden: no }
  measure: avg_conv_score { hidden: yes }


  filter: current_date_range {
    type: date
    view_label: "_PoP"
    label: "1. Current Date Range"
    description: "Select the current date range you are interested in. Make sure any other filter on Event Date covers this period, or is removed."
    sql: ${period} IS NOT NULL ;;
  }

  parameter: compare_to {
    view_label: "_PoP"
    description: "Select the templated previous period you would like to compare to. Must be used with Current Date Range filter"
    label: "2. Compare To:"
    type: unquoted
    allowed_value: {
      label: "Previous Period"
      value: "Period"
    }
    allowed_value: {
      label: "Previous Week"
      value: "WEEK"
    }
    allowed_value: {
      label: "Previous Month"
      value: "MONTH"
    }
    allowed_value: {
      label: "Previous Quarter"
      value: "QUARTER"
    }
    allowed_value: {
      label: "Previous Year"
      value: "YEAR"
    }
    default_value: "Period"
    # view_label: "_PoP"
  }



## ------------------ HIDDEN HELPER DIMENSIONS  ------------------ ##

  dimension: days_in_period {
    hidden:  yes
    view_label: "_PoP"
    description: "Gives the number of days in the current period date range"
    type: number
    # DATEDIFF(DAY, DATE({% date_start current_date_range %}), DATE({% date_end current_date_range %})) ;;
    ## CHECKED
    sql: DATE_DIFF(DATE({% date_start current_date_range %}), DATE({% date_end current_date_range %}), DAY) ;;
  }

  dimension: period_2_start {
    hidden:  yes
    view_label: "_PoP"
    description: "Calculates the start of the previous period"
    type: date

      # {% if compare_to._parameter_value == "Period" %}
      # DATEADD(DAY, -${days_in_period}, DATE({% date_start current_date_range %}))
      # {% else %}
      # DATEADD({% parameter compare_to %}, -1, DATE({% date_start current_date_range %}))
      # {% endif %};;
      ## CHECKED
    sql:
        {% if compare_to._parameter_value == "Period" %}
        CAST(DATE_ADD(DATE({% date_start current_date_range %}), INTERVAL -${days_in_period} DAY) AS TIMESTAMP)
        {% else %}
        CAST(DATE_ADD(DATE({% date_start current_date_range %}), INTERVAL -1 {% parameter compare_to %}) AS TIMESTAMP)
        {% endif %};;
  }

  dimension: period_2_end {
    hidden:  yes
    view_label: "_PoP"
    description: "Calculates the end of the previous period"
    type: date

      # {% if compare_to._parameter_value == "Period" %}
      # DATEADD(DAY, -1, DATE({% date_start current_date_range %}))
      # {% else %}
      # DATEADD({% parameter compare_to %}, -1, DATEADD(DAY, -1, DATE({% date_end current_date_range %})))
      # {% endif %};;
      ## CHECKED
    sql:
        {% if compare_to._parameter_value == "Period" %}
        CAST(DATE_ADD(DATE({% date_start current_date_range %}), INTERVAL -1 DAY) AS TIMESTAMP)
        {% else %}
        CAST(DATE_ADD(DATE(DATE_ADD(DATE({% date_end current_date_range %})), INTERVAL -1 DAY), INTERVAL -1 {% parameter compare_to %}) AS TIMESTAMP)
        {% endif %};;
  }

  dimension: day_in_period {
    hidden: yes
    description: "Gives the number of days since the start of each period. Use this to align the event dates onto the same axis, the axes will read 1,2,3, etc."
    type: number

      # CASE
      # WHEN {% condition current_date_range %} ${created_raw} {% endcondition %}
      # THEN DATEDIFF(DAY, DATE({% date_start current_date_range %}), ${created_date}) + 1
      # WHEN ${created_date} between ${period_2_start} and ${period_2_end}
      # THEN DATEDIFF(DAY, ${period_2_start}, ${created_date}) + 1
      # END
      ## CHECKED
    sql:
    {% if current_date_range._is_filtered %}
        CASE
        WHEN {% condition current_date_range %} CAST(${date_raw} AS TIMESTAMP) {% endcondition %}
        THEN DATE_DIFF(DATE({% date_start current_date_range %}), ${date_date}, DAY) + 1
        WHEN ${date_date} between ${period_2_start} and ${period_2_end}
        THEN DATE_DIFF(${period_2_start}, ${date_date}, DAY) + 1
        END
    {% else %} NULL
    {% endif %}
    ;;
  }

  dimension: order_for_period {
    hidden: yes
    type: number

          # CASE
          # WHEN {% condition current_date_range %} ${created_raw} {% endcondition %}
          # THEN 1
          # WHEN ${created_date} between ${period_2_start} and ${period_2_end}
          # THEN 2
          # END
          ## CHECKED
    sql:
        {% if current_date_range._is_filtered %}
            CASE
            WHEN {% condition current_date_range %} CAST(${date_raw} AS TIMESTAMP) {% endcondition %}
            THEN 1
            WHEN ${date_date} between ${period_2_start} and ${period_2_end}
            THEN 2
            END
        {% else %}
            NULL
        {% endif %}
        ;;
  }

  ## ------- HIDING FIELDS  FROM ORIGINAL VIEW FILE  -------- ##

  dimension_group: date {hidden: yes}
  dimension: ytd_only {hidden:yes}
  dimension: mtd_only {hidden:yes}
  dimension: wtd_only {hidden:yes}


## ------------------ DIMENSIONS TO PLOT ------------------ ##

  dimension_group: date_in_period {
    description: "Use this as your grouping dimension when comparing periods. Aligns the previous periods onto the current period"
    label: "Current Period"
    type: time
    # DATEADD(DAY, ${day_in_period} - 1, DATE({% date_start current_date_range %}))
    ## CHECKED
    sql: CAST(DATE_ADD(DATE({% date_start current_date_range %}), INTERVAL ${day_in_period} - 1 DAY) AS TIMESTAMP) ;;
    view_label: "_PoP"
    timeframes: [
      date,
      # hour_of_day,
      day_of_week,
      day_of_week_index,
      day_of_month,
      day_of_year,
      week_of_year,
      month,
      month_name,
      month_num,
      year]
  }


  dimension: period {
    view_label: "_PoP"
    label: "Period"
    description: "Pivot me! Returns the period the metric covers, i.e. either the 'This Period' or 'Previous Period'"
    type: string
    order_by_field: order_for_period

          # CASE
          # WHEN {% condition current_date_range %} ${created_raw} {% endcondition %}
          # THEN 'This {% parameter compare_to %}'
          # WHEN ${created_date} between ${period_2_start} and ${period_2_end}
          # THEN 'Last {% parameter compare_to %}'
          # END
          ## CHECKED
    sql:
        {% if current_date_range._is_filtered %}
            CASE
            WHEN {% condition current_date_range %} CAST(${date_raw} AS TIMESTAMP) {% endcondition %}
            THEN 'This {% parameter compare_to %}'
            WHEN ${date_date} between ${period_2_start} and ${period_2_end}
            THEN 'Last {% parameter compare_to %}'
            END
        {% else %}
            NULL
        {% endif %}
        ;;
  }


## ---------------------- TO CREATE FILTERED MEASURES ---------------------------- ##

  dimension: period_filtered_measures {
    hidden: yes
    description: "We just use this for the filtered measures"
    type: string

          # CASE
          # WHEN {% condition current_date_range %} ${created_raw} {% endcondition %} THEN 'this'
          # WHEN ${created_date} between ${period_2_start} and ${period_2_end} THEN 'last' END
          ## CHECKED
    sql:
        {% if current_date_range._is_filtered %}
            CASE
            WHEN {% condition current_date_range %} CAST(${date_raw} AS TIMESTAMP) {% endcondition %} THEN 'this'
            WHEN ${date_date} between ${period_2_start} and ${period_2_end} THEN 'last' END
        {% else %} NULL {% endif %} ;;
  }

# Filtered measures

  measure: cost_sum_current {
    view_label: "_PoP"
    label: "Cost (Current)"

    type: sum
    value_format_name: usd_0

    filters: {
      field: period_filtered_measures
      value: "this"
    }

    sql: ${TABLE}.cost ;;
  }

  measure: cost_sum_previous {
    view_label: "_PoP"
    label: "Cost (Previous)"

    type: sum
    value_format_name: usd_0

    filters: {
      field: period_filtered_measures
      value: "this"
    }

    sql: ${TABLE}.cost;;
  }

  #  measure: previous_period_sales {
  #    view_label: "_PoP"
  #    type: sum
  #    sql: ${sale_price};;
  #    filters: {
  #      field: period_filtered_measures
  #      value: "last"
  #    }
  #  }
  #
  measure: cost_sum_change {
    view_label: "_PoP"
    label: "Cost (% Change)"
    type: number
    sql: CASE WHEN ${cost_sum_current} = 0
            THEN NULL
            ELSE (1.0 * ${cost_sum_current} / NULLIF(${cost_sum_previous} ,0)) - 1 END ;;
    value_format_name: percent_2
  }

}

# ---------- EXPLORE ---------- #

# explore: pop_parameters {
#   label: "PoP Method 3: Custom choice of current and previous periods with parameters"
#   always_filter: {
#     filters:{field:current_date_range value:"6 months"}
#     filters:{field:compare_to value:"Year" }}
# }
