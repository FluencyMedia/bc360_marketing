include: "//bc360_outcomes/**/*.view"

view: mx_marketing_base {
  # extension: required

  derived_table: {
    datagroup_trigger: dg_bc360_mx_flat

    sql:  SELECT
            ROW_NUMBER() OVER () row_id,
             CAST(date AS DATE) date,
             CAST(medium AS STRING) medium,
             CAST(adgroup_id AS INT64) adgroup_id,
             CAST(outcome_tracker_id AS INT64) outcome_tracker_id,
             CAST(device AS STRING) device,
             CAST(impressions AS INT64) impressions,
             CAST(NULL AS INT64) impressions_available,
             CAST(NULL AS INT64) impressions_bulk,
             CAST(cost AS FLOAT64) cost,
             CAST(clicks AS INT64) clicks,
             CAST(outcomes AS INT64) outcomes,
             CAST(outcomes_bulk AS INT64) outcomes_bulk,
             CAST(hour AS INT64) hour
          FROM flat_mx.mx_marketing_master_hour mxm;;
    partition_keys: ["date"]
    }

##########  METADATA    {

    dimension: adgroup_id {
      view_label: "Z - Metadata"
      group_label: "Database IDs"
      label: "Ad Group ID [MX_Master]"
      description: "Foreign Key from master metrics table"

      can_filter: no
      hidden: no

      type: string

      sql: ${TABLE}.adgroup_id ;;  }

    dimension: row_id {
      view_label: "Z - Metadata"
      group_label: "Database IDs"
      label: "Row ID [MX_Master]"
      description: "Unique row ID from master metrics table"

      primary_key: yes

      can_filter: no
      hidden: no

      type: string

      sql: ${TABLE}.row_id ;;  }

    dimension: outcome_tracker_id {
      view_label: "Z - Metadata"
      group_label: "Database IDs"
      label: "Outcome Tracker ID [MX_Master]"
      description: "Outcome Tracker ID from master metrics table"

      can_filter: no
      hidden: no

      type: string

      sql: ${TABLE}.outcome_tracker_id ;;  }

##########  METADATA  }  ##########



##########  DIMENSIONS  {

##### Field Sets {

# } #####

##### Time Dimensions {

    dimension_group: date {
      view_label: "4. Timeframes"
      label: "Timeframes"
      description: "Optional complex dimension for managing timeframes"

      type: time

      timeframes: [
        raw,
        time,
        hour_of_day,
        date,
        day_of_week,
        day_of_week_index,
        day_of_month,
        day_of_year,
        week,
        week_of_year,
        month,
        month_name,
        month_num,
        quarter,
        year
      ]

      convert_tz: no
      datatype: date
      sql: ${TABLE}.date ;;  }

    measure: date_start {
      view_label: "4. Timeframes"
      label: "Start Date"

      type: date

      sql: CAST(MIN(${date_date}) AS DATE) ;;  }

    measure: date_end {
      view_label: "4. Timeframes"
      label: "End Date"

      type: date

      sql: CAST(MAX(${date_date}) AS DATE) ;;  }

    measure: date_diff {
      view_label: "4. Timeframes"
      label: "Duration - Days"

      type: number
      value_format_name: decimal_0

      sql: DATE_DIFF(${date_end}, ${date_start}, DAY) ;;
    }

    measure: count_days {
      view_label: "Z - Metadata"
      group_label: "Category Counts"
      label: "# Days"

      can_filter: no
      hidden: yes

      type: count_distinct
      value_format_name: decimal_0

      sql: ${date_date} ;;
    }

    dimension: year_str {
      view_label: "4. Timeframes"
      label: "Year [LABEL]"
      description: "'Year' as a string dimension for charts"

      can_filter: no

      type: string

      sql: ${date_year}::text ;;
    }

    dimension: hour_of_day {
      view_label: "4. Timeframes"
      label: "Hour of Day"
      description: "0 - 23: To use as hidden sort index for 'time_of_day'"

      type: number
      value_format_name: decimal_0

      sql: ${TABLE}.hour ;;
    }

    dimension: month_of_year_index {
      view_label: "4. Timeframes"
      group_item_label: "Month of Year - INDEX"
      type: number
      hidden: yes
      value_format_name: decimal_0

      sql: EXTRACT(MONTH FROM ${TABLE}.date) ;;
    }

    dimension: month_of_year {
      view_label: "4. Timeframes"
      group_item_label: "Month of Year"
      type: string

      sql: FORMAT_DATE("%B", ${TABLE}.date) ;;
      order_by_field: month_of_year_index
    }


    dimension: day_of_month {
      view_label: "4. Timeframes"
      label: "Day of Month"
      description: "1 - 30/31: Numeric Day of Month"

      type: number
      value_format_name: decimal_0

      sql: EXTRACT(DAY FROM ${TABLE}.date) ;;
    }

    dimension: time_of_day {
      view_label: "4. Timeframes"
      label: "Time of Day"
      description: "'Midnight' - '6AM' - 'Noon'"

      type: string

      case: {
        when: {
          sql: ${hour_of_day} = 0 ;;
          label: "Midnight"
        }
        when: {
          sql: ${hour_of_day} = 1 ;;
          label: "1AM"
        }
        when: {
          sql: ${hour_of_day} = 2 ;;
          label: "2AM"
        }
        when: {
          sql: ${hour_of_day} = 3 ;;
          label: "3AM"
        }
        when: {
          sql: ${hour_of_day} = 4 ;;
          label: "4AM"
        }
        when: {
          sql: ${hour_of_day} = 5 ;;
          label: "5AM"
        }
        when: {
          sql: ${hour_of_day} = 6 ;;
          label: "6AM"
        }
        when: {
          sql: ${hour_of_day} = 7 ;;
          label: "7AM"
        }
        when: {
          sql: ${hour_of_day} = 8 ;;
          label: "8AM"
        }
        when: {
          sql: ${hour_of_day} = 9 ;;
          label: "9AM"
        }
        when: {
          sql: ${hour_of_day} = 10 ;;
          label: "10AM"
        }
        when: {
          sql: ${hour_of_day} = 11 ;;
          label: "11AM"
        }
        when: {
          sql: ${hour_of_day} = 12 ;;
          label: "Noon"
        }
        when: {
          sql: ${hour_of_day} = 13 ;;
          label: "1PM"
        }
        when: {
          sql: ${hour_of_day} = 14 ;;
          label: "2PM"
        }
        when: {
          sql: ${hour_of_day} = 15 ;;
          label: "3PM"
        }
        when: {
          sql: ${hour_of_day} = 16 ;;
          label: "4PM"
        }
        when: {
          sql: ${hour_of_day} = 17 ;;
          label: "5PM"
        }
        when: {
          sql: ${hour_of_day} = 18 ;;
          label: "6PM"
        }
        when: {
          sql: ${hour_of_day} = 19 ;;
          label: "7PM"
        }
        when: {
          sql: ${hour_of_day} = 20 ;;
          label: "8PM"
        }
        when: {
          sql: ${hour_of_day} = 21 ;;
          label: "9PM"
        }
        when: {
          sql: ${hour_of_day} = 22 ;;
          label: "10PM"
        }
        when: {
          sql: ${hour_of_day} = 23 ;;
          label: "11PM"
        }
        else: "[UNKNOWN]"
      }

    }

##### Time Dimensions } #####

##### Creative Dimensions  {

    dimension: creative {
      view_label: "5. Creative"
      label: "Creative"

      hidden: yes

      type: string
      sql:  ${TABLE}.creative;;
    }


##### Creative Dimensions } #####

##### Channel Dimensions {

    dimension: device {
      view_label: "3. Channel"
      label: "Device"

      type: string

      case: {
        when: {
          sql: ${TABLE}.device = "HIGH_END_MOBILE" ;;
          label: "Mobile"
        }
        when: {
          sql: ${TABLE}.device = "DESKTOP" ;;
          label: "Desktop"
        }
        when: {
          sql: ${TABLE}.device = "TABLET" ;;
          label: "Tablet"
        }
        else: "[Unknown Device]"
      }
    }

    dimension: final_url {
      view_label: "3. Channel"
      label: "Final URL"

      hidden: yes
      type: string

      sql: ${TABLE}.final_url ;;  }

    dimension: subtype_codes_raw {
      view_label: "7. Subtype Codes"
      label: "Subtype List [RAW]"
      description: "Exact 'subtypelist=' parameter string from incoming URL"

      hidden: yes
      type: string

      # Quick crappy hack to do this as a LookML dimension
      # TODO: Needs to be processed and cached in source data
      sql: split_part(split_part(split_part(${final_url},'?',2),'subtypelist=',2),'&',1) ;;
    }

    dimension: subtype_codes_str {
      view_label: "7. Subtype Codes"
      label: "Subtype List"
      description: "Subtype List - Cleansed"

      hidden: yes
      type: string

      # Quick crappy hack to do this as a LookML dimension
      # Needs to be processed and cached in source data
      sql: replace(replace(replace(${subtype_codes_raw},'%20','X'),'HeartXScreeningXPPC','HeartXXScreeningXPPC'),'HVTScrn','HeartXXScreeningXEmail') ;;
    }

    dimension: subtype_codes {
      view_label: "7. Subtype Codes"
      label: "Subtype Codes"
      description: "Subtypes as array of individual items"

      hidden: yes
      type: string

      # Quick crappy hack to do this as a LookML dimension
      # Needs to be processed and cached in source data
      sql: string_to_array(${subtype_codes_str},'X') ;;
    }

    dimension: sc_service {
      view_label: "7. Subtype Codes"
      label: "Subtype - Service"
      description: "[SERVICE]XofferingXtopicXmedium"

      hidden: yes
      type: string

      sql: ${subtype_codes}[1] ;;
    }

    dimension: sc_offering {
      view_label: "7. Subtype Codes"
      label: "Subtype - Offering"
      description: "serviceX[OFFERING]XtopicXmedium"

      hidden: yes
      type: string

      sql: ${subtype_codes}[2] ;;
    }

    dimension: sc_topic {
      view_label: "7. Subtype Codes"
      label: "Subtype - Topic"
      description: "serviceXofferingX[TOPIC]Xmedium"

      hidden: yes
      type: string

      sql: ${subtype_codes}[3] ;;
    }

    dimension: sc_medium {
      view_label: "7. Subtype Codes"
      label: "Subtype - Medium"
      description: "serviceXofferingXtopicX[MEDIUM]"

      hidden: yes
      type: string

      sql: ${subtype_codes}[4] ;;
    }

##### Channel Dimensions } #####

##### Dynamic Dimensions  {


    ##### Dynamic Dimensions } #####

    ##########  DIMENSIONS  }  ##########



    ##########  MEASURES   {

    ##### Base Measures {

    measure: impr_sum {
      view_label: "5. Performance"
      label: "# Impressions"

      type: number
      value_format_name: decimal_0

      sql: NULLIF(SUM(${TABLE}.impressions),0);;  }

    measure: impr_avail {
      view_label: "7. Opportunity"
      label: "# Impressions Available"

      hidden: yes
      type: number
      value_format_name: decimal_0

      sql: NULLIF(SUM(${TABLE}.impressions_available),0) ;;
    }

    measure: impr_pct {
      view_label: "7. Opportunity"
      label: "% Impression Share"

      hidden: yes
      type: number
      value_format_name: percent_1

      sql: 1.0*(${impr_sum}) / nullif(${impr_avail},0);;  }

    measure: clicks_sum {
      view_label: "5. Performance"
      label: "# Clicks"

      type: number
      value_format_name: decimal_0

      sql: NULLIF(SUM(${TABLE}.clicks),0);;

    }

    measure: cost_sum {
      view_label: "5. Performance"
      label: "$ Cost"

      type: number
      value_format_name: usd_0

      sql: NULLIF(SUM(${TABLE}.cost), 0);; }

    measure: outcomes_sum {
      view_label: "6. Outcomes"
      label: "# Outcomes"

      hidden: no

      type: number
      value_format_name: decimal_0

      sql: NULLIF(SUM(${TABLE}.outcomes), 0) ;;  }

    measure: outcomes_bulk_sum {
      view_label: "6. Outcomes"
      group_label: "Z - Reference"
      label: "# Outcomes (Bulk)"

      hidden: yes

      type: number
      value_format_name: decimal_0

      sql: NULLIF(SUM(${TABLE}.outcomes_bulk), 0);;  }

    ##### }
    ##### End Base Measures

    ##### Calculated Measures {

    measure: ctr {
      view_label: "5. Performance"
      label: "% CTR"

      type: number
      value_format_name: percent_2

      sql: 1.0*(${clicks_sum}) / nullif(${impr_sum},0) ;;  }

    measure: ctr_bar {
      view_label: "5. Performance"
      label: "% CTR [BAR]"

      hidden: yes
      type: number
      value_format_name: percent_1

      html:
        <div style="float: left
        ; width:50%
        ; text-align:right
        ; margin-right: 4px"> <p>{{rendered_value}}</p>
        </div>
        <div style="float: left
        ; width:{{ value | times:50}}%
        ; background-color: rgba(0,180,0,{{ value | times:100 }})
        ; text-align:left
        ; color: #FFFFFF
        ; border-radius: 2px"> <p style="margin-bottom: 0; margin-left: 4px;"> &nbsp; </p>
        </div>
        ;;

        sql: 1.0*(${clicks_sum}) / nullif(${impr_sum},0) ;;  }

      measure: cpc {
        view_label: "5. Performance"
        label: "$ CPC"

        type: number
        value_format_name: usd

        sql: 1.0*(${cost_sum}) / nullif(${clicks_sum},0) ;;  }

      measure: cpm {
        view_label: "5. Performance"
        label: "$ CPM"

        type: number
        value_format_name: usd

        sql: 1.0*(${cost_sum}) / nullif((${impr_sum}/1000),0) ;;  }

      measure: cpo {
        view_label: "6. Outcomes"
        label: "$ CPO"
        description: "Cost / Outcome"

        hidden: no
        type: number
        value_format_name: usd

        sql: 1.0*(${cost_sum}) / nullif(${outcomes_sum},0) ;;  }


      measure: opc {

        view_label: "6. Outcomes"
        label: "$ OPC"
        description: "# Outcomes / $1K: 'Bigger is Better' inversion of 'Cost per Outcome'"

        type: number
        value_format_name: decimal_1

        sql: 1000.0*(${outcomes_sum}) / nullif(${cost_sum},0) ;;}

      measure: otr {
        view_label: "6. Outcomes"
        label: "% OTR"
        description: "Outcomes / Clicks"

        hidden: no
        type: number
        value_format_name: percent_2

        sql: 1.0*(${outcomes_sum}) / nullif(${clicks_sum},0) ;;  }

      measure: o_referrals_num {
        view_label: "Z - Metadata"
        group_label: "Isolated Measures"
        label: "= 'Referrals'"
        description: "ISOLATED: Outcome Quality = 'Referrals'"

        hidden: no
        type: sum
        sql: ${TABLE}.outcomes ;;
        value_format_name: decimal_0

        filters: {
          field: arch_outcomes_admin.outcome_quality
          value: "Referrals"  }  }

      measure: o_leads_num {
        view_label: "Z - Metadata"
        group_label: "Isolated Measures"
        label: "= 'Leads'"
        description: "ISOLATED: Outcome Quality = 'Leads'"

        hidden: no
        type: sum
        sql: ${TABLE}.outcomes_bulk ;;
        value_format_name: decimal_0

        filters: {
          field: arch_outcomes_admin.outcome_quality
          value: "Leads"    }  }

      measure: o_outcomes_num {
        view_label: "Z - Metadata"
        group_label: "Isolated Measures"
        label: "= 'Outcomes'"
        description: "ISOLATED: Outcome Quality = 'Outcomes'"

        hidden: no
        type: sum
        sql: ${TABLE}.outcomes ;;
        value_format_name: decimal_0

        filters: {
          field: arch_outcomes_admin.outcome_quality
          value: "Outcomes" }  }

      measure: leads_total {
        view_label: "6. Outcomes"
        label: ">= Leads"
        description: "'# Leads' + '# Referrals"

        hidden: no
        type: number
        sql: ${o_leads_num} + ${o_referrals_num} ;;
        value_format_name: decimal_0
      }

      measure: cpl {
        view_label: "6. Outcomes"
        label: "$ CPL"
        description: "$ Cost / # Leads"

        hidden: no
        type: number
        value_format_name: usd

        sql: 1.0*(${cost_sum}) / nullif(${leads_total},0) ;;  }

      measure: lpc {

        view_label: "6. Outcomes"
        label: "$ LPC"
        description: "# Leads / $1K: 'Bigger is Better' inversion of 'Cost per Lead'"

        type: number
        value_format_name: decimal_1

        sql: 1000.0*(${leads_total}) / nullif(${cost_sum},0) ;;}

      measure: ltr {
        view_label: "6. Outcomes"
        label: "% Leads"
        description: "# Leads / # Clicks"

        hidden: no
        type: number
        value_format_name: percent_2

        sql: 1.0*(${leads_total}) / nullif(${clicks_sum},0) ;;  }

      measure: referrals_total {
        view_label: "6. Outcomes"
        label: "# Referrals"
        description: "= '# Referrals'"

        type: number
        sql: NULLIF(${o_referrals_num}, 0) ;;
        value_format_name: decimal_0
      }

      measure: cpr {
        view_label: "6. Outcomes"
        label: "$ CPR"
        description: "$ Cost / # Referrals"

        type: number
        value_format_name: usd

        sql: 1.0*(${cost_sum}) / nullif(${referrals_total},0) ;;  }

      measure: rpc {

        view_label: "6. Outcomes"
        label: "$ RPC"
        description: "# Referrals / $1K: 'Bigger is Better' inversion of 'Cost per Referral'"

        type: number
        value_format_name: decimal_1

        sql: 1000.0*(${referrals_total}) / nullif(${cost_sum},0) ;;}

      measure: rtr {
        view_label: "6. Outcomes"
        label: "% Referrals"
        description: "# Referrals / # Clicks"

        type: number
        value_format_name: percent_2

        sql: 1.0*(${referrals_total}) / nullif(${clicks_sum},0) ;;  }



        #measure: avg_conv_score {
        #  view_label: "6. Outcomes"
        #  label: "Avg. Outcome Score"
        #
        #  hidden: yes
        #  type: average
        #  value_format_name: decimal_1
        #  sql: ${arch_outcomes_admin.outcome_score} ;;  }

    ##### }
  ##### Calculated Measures

  ##########  MEASURES  }  ##########



    }
