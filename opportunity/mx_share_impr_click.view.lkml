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


  ####### UNMET OPPORTUNITY MEASURES { #######

    measure: opportunity_unmet {
      label: "$ Unmet Opportunity"
      type: number
      value_format_name: usd_0

      sql: ${mx_marketing.cpc} * ${lost_clicks} ;;
    }

    measure: opportunity_unmet_clicks {
      view_label: "Opportunities"
      label: "$ Unmet Opportunity [Clicks]"
      type: number
      value_format_name: usd_0
      hidden: yes

      sql: ${mx_marketing.cpc} * ${lost_clicks} ;;
    }

    measure: opportunity_unmet_outcomes {
      group_label: "Opportunities"
      label: "$ Unmet Opportunity [Outcomes]"
      type: number
      value_format_name: usd_0
      hidden: yes

      sql: ${mx_marketing.cpo} * ${lost_outcomes} ;;
    }

    measure: opportunity_unmet_referrals {
      group_label: "Opportunities"
      label: "$ Unmet Opportunity [Referrals]"
      type: number
      value_format_name: usd_0
      hidden: yes

      sql: ${mx_marketing.cpr} * ${lost_referrals} ;;
    }

  ####### UNMET OPPORTUNITY MEASURES } #######


  ####### LOST OPPORTUNITY MEASURES { #######

    measure: lost_impr {
      group_label: "Impressions"
      label: "- Impressions"
      description: "Lost Impressions: Total Impressions Available - Total Impressions"
      type: number
      value_format_name: decimal_0

      sql: NULLIF((${avail_impr} - ${mx_marketing.impr_sum}), 0) ;;
    }

    measure: lost_clicks {
      group_label: "Clicks"
      label: "- Clicks"
      description: "Lost Clicks: Total Clicks Available - Total Clicks"
      type: number
      value_format_name: decimal_0

      sql: NULLIF((${avail_clicks} - ${mx_marketing.clicks_sum}), 0) ;;
    }

    measure: lost_outcomes {
      group_label: "Outcomes"
      label: "- Outcomes"
      description: "Lost Outcomes: Total Outcomes Available - Total Outcomes"
      type: number
      value_format_name: decimal_0

      sql: NULLIF((${lost_clicks} * ${mx_marketing.otr}), 0) ;;
    }

    measure: lost_referrals {
      group_label: "Referrals"
      label: "- Referrals"
      description: "Lost Referrals: Total Referrals Available - Total Referrals"
      type: number
      value_format_name: decimal_0

      sql: NULLIF((${lost_clicks} * ${mx_marketing.rtr}), 0) ;;
    }

  ####### LOST OPPORTUNITY MEASURES } #######


  ####### AVAILABLE OPPORTUNITY MEASURES { #######

    measure: avail_impr {
      group_label: "Impressions"
      label: "+ Impressions"
      description: "Total Impressions Available: Total Impressions / Share of Impressions Earned"
      type: number
      value_format_name: decimal_0

      sql: SAFE_DIVIDE(${mx_marketing.impr_sum}, ${earned_share_impr}) ;;
    }

    measure: avail_clicks {
      group_label: "Clicks"
      label: "+ Clicks"
      description: "Total Clicks Available: Total Clicks / Share of Clicks Earned"
      type: number
      value_format_name: decimal_0

      sql: SAFE_DIVIDE(${mx_marketing.clicks_sum}, ${earned_share_click}) ;;
    }

    measure: avail_outcomes {
      group_label: "Outcomes"
      label: "+ Outcomes"
      description: "Total Outcomes Available: Total Outcomes / Share of Clicks Earned"
      type: number
      value_format_name: decimal_0

      sql: SAFE_DIVIDE(${mx_marketing.outcomes_sum}, ${earned_share_click}) ;;
    }

    measure: avail_referrals {
      group_label: "Referrals"
      label: "+ Referrals"
      description: "Total Referrals Available: Total Referrals / Share of Clicks Earned"
      type: number
      value_format_name: decimal_0

      sql: SAFE_DIVIDE(${mx_marketing.referrals_total}, ${earned_share_click}) ;;
    }

  ####### AVAILABLE OPPORTUNITY MEASURES } #######


  ####### EARNED SHARE MEASURES { #######

    measure: earned_share_impr {
      group_label: "Impressions"
      label: "% Impressions"
      type: number
      value_format_name: percent_1

      sql: SAFE_DIVIDE(${earned_impr_sum}, ${avail_impr_sum});;
    }

    measure: earned_share_click {
      group_label: "Clicks"
      label: "% Clicks"
      type: number
      value_format_name: percent_1

      sql: SAFE_DIVIDE(${earned_clicks_sum}, ${avail_clicks_sum});;
    }

    measure: earned_impr_sum {
      group_label: "Opportunity"
      label: "* Impressions"
      description: "Raw sum of 'earned_impr' from DB"
      view_label: "Z - Metadata"
      hidden: yes

      type: number
      value_format_name: decimal_0

      sql: NULLIF(SUM(${TABLE}.earned_impr),0) ;;
    }

    measure: earned_clicks_sum {
      group_label: "Opportunity"
      label: "* Clicks"
      description: "Raw sum of 'earned_clicks' from DB"
      view_label: "Z - Metadata"
      hidden: yes

      type: number
      value_format_name: decimal_0

      sql: NULLIF(SUM(${TABLE}.earned_clicks), 0) ;;
    }

  ####### EARNED SHARE MEASURES } #######


  ####### UNDERLYING AGGREGATES { #######

    measure: avail_impr_sum {
      label: "! Impressions [SUM]"
      description: "Raw sum of 'avail_impr' from DB"
      view_label: "Z - Metadata"
      group_label: "Opportunity"
      hidden: yes

      type: number
      value_format_name: decimal_0

      sql: NULLIF(SUM(${TABLE}.avail_impr), 0) ;;
    }

    measure: avail_clicks_sum {
      label: "! Clicks [SUM]"
      description: "Raw sum of 'avail_clicks' from DB"
      view_label: "Z - Metadata"
      group_label: "Opportunity"
      hidden: yes

      type: number
      value_format_name: decimal_0

      sql: NULLIF(SUM(${TABLE}.avail_clicks), 0) ;;
    }

  ####### UNDERLYING AGGREGATES } #######

  ####### ROW-LEVEL FIELDS { #######

    dimension: dim_share_impr_search {
      label: "% Share - Impressions"
      view_label: "Z - Metadata"
      group_label: "Opportunity"
      hidden: yes

      type: number
      value_format_name: percent_1

      sql: ${TABLE}.share_impr_search ;;
    }

    dimension: dim_share_click {
      label: "% Share - Clicks"
      view_label: "Z - Metadata"
      group_label: "Opportunity"
      hidden: yes

      type: number
      value_format_name: percent_1

      sql: ${TABLE}.share_click ;;
    }

    measure: has_share_impr_search {
      label: "? Impr Share"
      description: "Does row have click share data?"
      view_label: "Z - Metadata"
      group_label: "Opportunity"
      type: yesno
      hidden: yes

      sql: ${count_shares_impr_search} > 0 ;;
    }

    measure: has_share_click {
      label: "? Click Share"
      description: "Does row have click share data?"
      view_label: "Z - Metadata"
      group_label: "Opportunity"
      type: yesno
      hidden: yes

      sql: ${count_shares_click} > 0 ;;
    }

  ####### ROW-LEVEL FIELDS } #######


  ####### BASIC COUNTS { #######

    measure: count_shares_impr_search {
      view_label: "Z - Metadata"
      group_label: "Opportunity"
      label: "# rows with Impression Share data"
      type: count_distinct
      value_format_name: decimal_0
      hidden: yes

      sql: ${dim_share_impr_search} ;;
    }

    measure: count_shares_click {
      view_label: "Z - Metadata"
      group_label: "Opportunity"
      label: "# rows with Click Share data"
      type: count_distinct
      value_format_name: decimal_0
      hidden: yes

      sql: ${dim_share_click} ;;
    }

    measure: count_campaigns {
      view_label: "Z - Metadata"
      group_label: "Opportunity"
      label: "# Campaigns"
      type: count_distinct
      value_format_name: decimal_0
      hidden: yes

      sql: ${campaign_id} ;;
    }

    measure: count {
      view_label: "Z - Metadata"
      group_label: "Opportunity"
      label: "# Total Items"
      type: count
      value_format_name: decimal_0
      hidden: no
    }

  ####### BASIC COUNTS } #######


  ####### BASIC METADATA { #######

    dimension: row_id {
      view_label: "Z - Metadata"
      label: "Row ID [OPPTY]"
      type: number
      primary_key: yes
      hidden: yes
    }

    dimension: timestamp {
      view_label: "Z - Metadata"
      group_label: "Timestamps"
      label: "Timestamp [SHARE]"
      type: date_time
      hidden: no
      sql: ${TABLE}.timestamp ;;
    }

    dimension: hour_of_day {
      view_label: "Z - Metadata"
      label: "Hour of Day [OPPTY]"
      type: number
      hidden: yes
      sql: ${TABLE}.hour ;;
    }

    dimension: campaign {
      view_label: "Z - Metadata"
      label: "Campaign [OPPTY]"
      type: string
      hidden: yes
      sql: ${TABLE}.campaign ;;
    }

    dimension: campaign_id {
      view_label: "Z - Metadata"
      label: "Campaign ID [OPPTY]"
      hidden: yes
      type: number
      value_format_name: id

      sql: ${TABLE}.campaign_id ;;
    }

    dimension: adgroup {
      view_label: "Z - Metadata"
      label: "Adgroup [OPPTY]"
      type: string
      hidden: yes
      sql: ${TABLE}.adgroup ;;
    }

    dimension: adgroup_id {
      view_label: "Z - Metadata"
      label: "Adgroup ID [OPPTY]"
      type: number
      value_format_name: id
      hidden: yes
      sql: ${TABLE}.adgroup_id ;;
    }

  ####### BASIC METADATA } #######

}
