include: "/**/*view.lkml"
###  Period over Period Method 1: Use Looker's native date dimension groups


view: pop_01_base {
  label: "Period-over-Period 01"

  extends: [mx_marketing_base]

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


#(Method 1a) you may also wish to create MTD and YTD filters in LookML

  dimension: wtd_only {
    group_label: "To-Date Filters"
    label: "WTD"
    view_label: "_PoP"
    type: yesno
    sql:  (EXTRACT(DAYOFWEEK FROM ${date_raw}) >= EXTRACT(DAYOFWEEK FROM CURRENT_DATE())) ;;
  }

  dimension: mtd_only {
    group_label: "To-Date Filters"
    label: "MTD"
    view_label: "_PoP"
    type: yesno
    sql:  (EXTRACT(DAYOFMONTH FROM ${date_raw}) >= EXTRACT(DAYOFMONTH FROM CURRENT_DATE())) ;;
  }

  dimension: ytd_only {
    group_label: "To-Date Filters"
    label: "YTD"
    view_label: "_PoP"
    type: yesno
    sql:  (EXTRACT(DAYOFYEAR FROM ${date_raw}) >= EXTRACT(DAYOFYEAR FROM CURRENT_DATE())) ;;
  }

  measure: count {
    label: "Count of order_items"
    type: count
    hidden: yes
  }
  measure: total_cost {
    label: "Total Cost"
    view_label: "_PoP"
    type: number
    sql: ${cost_sum} ;;
    value_format_name: usd
    drill_fields: [date_date]
  }
}
