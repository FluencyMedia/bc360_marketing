include: "//bc360_marketing/**/*.view"

view: mx_share_impr_click {

  derived_table: {
    datagroup_trigger: dg_bc360_mx_flat

    sql:  SELECT
            ROW_NUMBER() OVER () row_id,
            campaign_id,
            campaign,
            adgroup_id,
            adgroup,
            date,
            hour,
            earned_impr,
            share_impr_search,
            avail_impr,
            earned_clicks,
            share_click,
            avail_clicks,
          FROM bc360-main.flat_mx.mx_share_impr_click mxs;;
    partition_keys: ["date"]
  }

  dimension: row_id {
    type: number
    primary_key: yes
    hidden: no
  }

  dimension: hour_of_day {
    type: number
    hidden: yes
    sql: ${TABLE}.hour ;;
  }

  dimension: campaign {
    type: string
    hidden: yes
    sql: ${TABLE}.campaign ;;
  }

  dimension: campaign_id {
    type: number
    value_format_name: id

    sql: ${TABLE}.campaign_id ;;
  }

 dimension: adgroup {
   type: string
   hidden: yes
   sql: ${TABLE}.adgroup ;;
 }

 dimension: adgroup_id {
   type: number
   value_format_name: id
   sql: ${TABLE}.adgroup_id ;;
 }

  dimension_group: date {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;
  }

  dimension: dim_share_click {
    label: "% Share - Clicks"
    type: number
    value_format_name: percent_1

    sql: ${TABLE}.share_click ;;
  }

  measure: has_share_impr_search {
    label: "? Impr Share"
    type: yesno

    sql: ${count_shares_impr_search} > 0 ;;
  }

  measure: has_share_click {
    label: "? Click Share"
    type: yesno

    sql: ${count_shares_click} > 0 ;;
  }

  dimension: dim_share_impr_search {
    label: "% Share - Impressions"
    type: number
    value_format_name: percent_1

    sql: ${TABLE}.share_impr_search ;;
  }

  measure: earned_impr {
    label: "Earned - Impressions"
    type: number
    value_format_name: decimal_0

    sql: NULLIF(SUM(${TABLE}.earned_impr),0) ;;
  }

  measure: earned_clicks {
    label: "Earned - Clicks"
    type: sum
    value_format_name: decimal_0

    sql: ${TABLE}.earned_clicks ;;
  }


  measure: avail_impr {
    label: "Available Impressions"
    type: sum
    value_format_name: decimal_0

    sql: ${TABLE}.avail_impr ;;
  }

  measure: avail_clicks {
    label: "Available Clicks"
    type: sum
    value_format_name: decimal_0

    sql: ${TABLE}.avail_clicks ;;
  }

  measure: earned_share_impr {
    label: "Earned % - Impressions"
    type: number
    value_format_name: percent_1

    sql: SAFE_DIVIDE(${earned_impr},${avail_impr});;
  }

  measure: earned_share_click {
    label: "Earned % - Clicks"
    type: number
    value_format_name: percent_1

    sql: SAFE_DIVIDE(${earned_clicks},${avail_clicks});;
  }

  measure: count_shares_impr_search {
    label: "# Impression Shares"
    type: count_distinct
    value_format_name: decimal_0

    sql: ${dim_share_impr_search} ;;
  }

  measure: count_shares_click {
    label: "# Click Shares"
    type: count_distinct
    value_format_name: decimal_0

    sql: ${dim_share_click} ;;
  }

  measure: count_campaigns {
    label: "# Campaigns"
    type: count_distinct
    value_format_name: decimal_0

    sql: ${campaign_id} ;;

  }

  measure: count {
    label: "# Total Items"
    type: count
    value_format_name: decimal_0

    }
}
