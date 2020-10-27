include: "//bc360_marketing/**/*.view"

view: mx_share_impr_click {
  label: "7. Opportunity"

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
            timestamp,
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
    hidden: yes
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
    hidden: yes
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

  dimension: timestamp {
    view_label: "Z - Metadata"
    group_label: "Timestamps"
    label: "Timestamp [SHARE]"
    type: date_time
    hidden: no
    sql: ${TABLE}.timestamp ;;
  }

  dimension: dim_share_click {
    label: "% Share - Clicks"
    view_label: "Z - Metadata"
    group_label: "Shares"

    type: number
    value_format_name: percent_1

    sql: ${TABLE}.share_click ;;
  }

  measure: has_share_impr_search {
    label: "? Impr Share"
    description: "Does row have click share data?"
    view_label: "Z - Metadata"
    group_label: "Shares"
    type: yesno

    sql: ${count_shares_impr_search} > 0 ;;
  }

  measure: opportunity_unmet {
    label: "$ Unmet Opportunity"
    type: number
    value_format_name: usd_0

    sql: ${mx_marketing.cpc} * ${lost_clicks} ;;
  }

  measure: has_share_click {
    label: "? Click Share"
    description: "Does row have click share data?"
    view_label: "Z - Metadata"
    group_label: "Shares"
    type: yesno

    sql: ${count_shares_click} > 0 ;;
  }

  dimension: dim_share_impr_search {
    label: "% Share - Impressions"
    view_label: "Z - Metadata"
    group_label: "Shares"
    hidden: yes

    type: number
    value_format_name: percent_1

    sql: ${TABLE}.share_impr_search ;;
  }

  measure: earned_impr_sum {
    label: "* Impressions"
    description: "Raw sum of 'earned_impr' from DB"
    view_label: "Z - Metadata"
    group_label: "Shares"

    type: number
    value_format_name: decimal_0

    sql: NULLIF(SUM(${TABLE}.earned_impr),0) ;;
  }

  measure: earned_clicks_sum {
    label: "* Clicks"
    description: "Raw sum of 'earned_clicks' from DB"
    view_label: "Z - Metadata"
    group_label: "Shares"

    type: number
    value_format_name: decimal_0

    sql: NULLIF(SUM(${TABLE}.earned_clicks), 0) ;;
  }

  measure: avail_impr {
    label: "+ Impressions"
    description: "Total Impressions Available: Total Impressions / Share of Impressions Earned"
    type: number
    value_format_name: decimal_0

    sql: SAFE_DIVIDE(${mx_marketing.impr_sum}, ${earned_share_impr}) ;;
  }

  measure: avail_impr_sum {
    label: "! Impressions [SUM]"
    description: "Raw sum of 'avail_impr' from DB"
    view_label: "Z - Metadata"
    group_label: "Shares"

    type: number
    value_format_name: decimal_0

    sql: NULLIF(SUM(${TABLE}.avail_impr), 0) ;;
  }

  measure: lost_impr {
    label: "- Impressions"
    description: "Lost Impressions: Total Impressions Available - Total Impressions"
    type: number
    value_format_name: decimal_0

    sql: NULLIF((${avail_impr} - ${mx_marketing.impr_sum}), 0) ;;
  }

  measure: avail_clicks_sum {
    label: "! Clicks [SUM]"
    description: "Raw sum of 'avail_clicks' from DB"
    view_label: "Z - Metadata"
    group_label: "Shares"

    type: number
    value_format_name: decimal_0

    sql: NULLIF(SUM(${TABLE}.avail_clicks), 0) ;;
  }

  measure: avail_clicks {
    label: "+ Clicks"
    description: "Total Clicks Available: Total Clicks / Share of Clicks Earned"
    type: number
    value_format_name: decimal_0

    sql: SAFE_DIVIDE(${mx_marketing.clicks_sum}, ${earned_share_click}) ;;
    }

  measure: lost_clicks {
    label: "- Clicks"
    description: "Lost Clicks: Total Clicks Available - Total Clicks"
    type: number
    value_format_name: decimal_0

    sql: NULLIF((${avail_clicks} - ${mx_marketing.clicks_sum}), 0) ;;
  }

  measure: earned_share_impr {
    label: "% Earned - Impressions"
    type: number
    value_format_name: percent_1

    sql: SAFE_DIVIDE(${earned_impr_sum}, ${avail_impr_sum});;
  }

  measure: earned_share_click {
    label: "% Earned - Clicks"
    type: number
    value_format_name: percent_1

    sql: SAFE_DIVIDE(${earned_clicks_sum}, ${avail_clicks_sum});;
  }

  measure: count_shares_impr_search {
    view_label: "Z - Metadata"
    group_label: "Shares"
    label: "# rows with Impression Share data"
    type: count_distinct
    value_format_name: decimal_0

    sql: ${dim_share_impr_search} ;;
  }

  measure: count_shares_click {
    view_label: "Z - Metadata"
    group_label: "Shares"
    label: "# rows with Click Share data"
    type: count_distinct
    value_format_name: decimal_0

    sql: ${dim_share_click} ;;
  }

  measure: count_campaigns {
    view_label: "Z - Metadata"
    group_label: "Shares"
    label: "# Campaigns"
    type: count_distinct
    value_format_name: decimal_0

    sql: ${campaign_id} ;;

  }

  measure: count {
    view_label: "Z - Metadata"
    group_label: "Shares"
    label: "# Total Items"
    type: count
    value_format_name: decimal_0

    }
}
