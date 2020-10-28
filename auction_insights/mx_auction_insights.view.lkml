include: "/**/*.view.lkml"

view: mx_auction_insights {
  label: "8. Auction Insights"

  derived_table: {
    datagroup_trigger: dg_bc360_mx_flat

    sql:  SELECT
            ROW_NUMBER() OVER () row_id,
             *
          FROM bc360-main.flat_mx.mx_auction_insights;;
    partition_keys: ["date"]
    cluster_keys: ["adgroup_id", "timestamp"]
  }

  dimension: avail_impr_search {
    view_label: "Z - Metadata"
    group_label: "Auction Insights"
    label: "Available Impressions [AUCTION]"
    type: number
    value_format_name: decimal_0
    hidden: yes

    sql: ${TABLE}.avail_impr_search ;;
  }

  dimension: url_display_domain {
    label: "Domain URL [AUCTION]"
    type: string
    hidden: yes

    # order_by_field: "overlap_search_num"

    sql: ${TABLE}.url_display_domain ;;
  }

  ####### AGGREGATE RATE MEASURES { #######

  measure: share_overlap {
    label: "% Overlap"
    type: number
    value_format_name: percent_1

    sql: SAFE_DIVIDE(${overlap_search_num}, ${impr_sum_client}) ;;
  }

  measure: share_outranking {
    label: "% Outranking"
    type: number
    value_format_name: percent_1

    sql: SAFE_DIVIDE(${outranking_search_num}, ${impr_sum_client}) ;;
  }

  measure: share_position_above {
    label: "% Position Above"
    type: number
    value_format_name: percent_1

    sql: SAFE_DIVIDE(${position_above_num}, ${impr_sum_client}) ;;
  }

  measure: share_page_top {
    label: "% Top"
    type: number
    value_format_name: percent_1

    sql: SAFE_DIVIDE(${page_top_num}, ${impr_sum_client}) ;;
  }

  measure: share_page_top_abs {
    label: "% Top - Abs"
    type: number
    value_format_name: percent_1

    sql: SAFE_DIVIDE(${page_top_abs_num}, ${impr_sum_client}) ;;
  }

  measure: share_impr_search {
    view_label: "Z - Metadata"
    group_label: "Auction Insights"
    label: "% Share - Impressions [AUCTION]"
    hidden: yes

    type: number
    value_format_name: percent_1

    sql: SAFE_DIVIDE(${share_impr_search_numerator}, ${share_impr_search_denom}) ;;
  }

  ####### AGGREGATE RATE MEASURES } #######


  ####### AGGRETATE COUNT MEASURES { #######

  measure: impr_sum_client {
    view_label: "Z - Metadata"
    group_label: "Auction Insights"
    label: "# Impressions - Client [AUCTION]"
    hidden: yes

    type: number
    value_format_name: decimal_0

    sql: NULLIF(SUM(${TABLE}.impr_sum_client), 0) ;;
  }

  measure: outranking_search_num {
    group_label: "Occurrences"
    label: "# Outrankings"
    type: number
    value_format_name: decimal_0

    sql: NULLIF(SUM(${TABLE}.outranking_search_num), 0) ;;
  }

  measure: overlap_search_num {
    group_label: "Occurrences"
    label: "# Overlaps"
    type: number
    value_format_name: decimal_0

    sql: NULLIF(SUM(${TABLE}.overlap_search_num), 0) ;;
  }

  measure: page_top_abs_num {
    group_label: "Occurrences"
    label: "# Page Top Abs"
    type: number
    value_format_name: decimal_0

    sql: NULLIF(SUM(${TABLE}.page_top_abs_num), 0) ;;
  }

  measure: page_top_num {
    group_label: "Occurrences"
    label: "# Page Top"
    type: number
    value_format_name: decimal_0

    sql: NULLIF(SUM(${TABLE}.page_top_num), 0) ;;
  }

  measure: position_above_num {
    group_label: "Occurrences"
    label: "# Position Above"
    type: number
    value_format_name: decimal_0

    sql: NULLIF(SUM(${TABLE}.position_above_num), 0) ;;
  }

  measure: share_impr_search_numerator {
    view_label: "Z - Metadata"
    group_label: "Auction Insights"
    label: "% Share - Numerator"
    hidden: yes

    type: number
    value_format_name: decimal_0

    sql: NULLIF(SUM(${TABLE}.share_impr_search), 0) ;;
    }

  measure: share_impr_search_denom {
    view_label: "Z - Metadata"
    group_label: "Auction Insights"
    label: "100% Share Denominator"
    hidden: yes

    type: number
    value_format_name: decimal_0

    sql: NULLIF(SUM(${TABLE}.share_impr_search_denom), 0) ;;
  }

  ###### AGGREGATE COUNT MEASURES } ######


  ###### INDIVIDUAL ROW TALLY DIMENSIONS { #######

  dimension: position_above_num_dim {
    view_label: "Z - Metadata"
    group_label: "Auction Insights"
    label: "# Position Above [DIM]"
    hidden: yes

    type: number
    value_format_name: decimal_0

    sql: ${TABLE}.position_above_num ;;
  }

  dimension: impr_sum_client_dim {
    view_label: "Z - Metadata"
    group_label: "Auction Insights"
    label: "# Impressions - Client [DIM]"
    hidden: yes

    value_format_name: decimal_0

    sql: ${TABLE}.impr_sum_client ;;

  }

  dimension: outranking_search_num_dim {
    view_label: "Z - Metadata"
    group_label: "Auction Insights"
    label: "# Outranking Search [DIM]"
    hidden: yes

    type: number
    value_format_name: decimal_0

    sql: ${TABLE}.outranking_search_num ;;
  }

  dimension: overlap_search_num_dim {
    view_label: "Z - Metadata"
    group_label: "Auction Insights"
    label: "# Overlap Search [DIM]"
    hidden: yes

    type: number
    value_format_name: decimal_0

    sql: ${TABLE}.overlap_search_num ;;
  }

  dimension: page_top_abs_num_dim {
    view_label: "Z - Metadata"
    group_label: "Auction Insights"
    label: "# Page Top Abs [DIM]"
    hidden: yes

    type: number
    value_format_name: decimal_0

    sql: ${TABLE}.page_top_abs_num ;;
  }

  dimension: page_top_num_dim {
    view_label: "Z - Metadata"
    group_label: "Auction Insights"
    label: "# Page Top [DIM]"
    hidden: yes

    type: number
    value_format_name: decimal_0

    sql: ${TABLE}.page_top_num ;;
  }

  dimension: share_impr_search_denom_dim {
    view_label: "Z - Metadata"
    group_label: "Auction Insights"
    label: "100% Share Denominator [DIM]"
    hidden: yes

    type: number
    value_format_name: decimal_0

    sql: ${TABLE}.share_impr_search_denom ;;
  }

  ###### INDIVIDUAL ROW TALLY DIMENSIONS } #######


  ###### INDIVIDUAL RATE DIMENSIONS { ######

    dimension: rate_overlap_search {
      view_label: "Z - Metadata"
      group_label: "Auction Insights"
      label: "% Overlap Search [DIM]"
      hidden: yes

      type: number
      value_format_name: percent_1

      sql: ${TABLE}.rate_overlap_search ;;
    }

    dimension: rate_page_top {
      view_label: "Z - Metadata"
      group_label: "Auction Insights"
      label: "% Page Top [DIM]"
      hidden: yes

      type: number
      value_format_name: percent_1

      sql: ${TABLE}.rate_page_top ;;
    }

    dimension: rate_page_top_abs {
      view_label: "Z - Metadata"
      group_label: "Auction Insights"
      label: "% Page Top - Abs [DIM]"
      hidden: yes

      type: number
      value_format_name: percent_1

      sql: ${TABLE}.rate_page_top_abs ;;
    }

    dimension: rate_position_above {
      view_label: "Z - Metadata"
      group_label: "Auction Insights"
      label: "% Position Above [DIM]"
      hidden: yes

      type: number
      value_format_name: percent_1

      sql: ${TABLE}.rate_position_above ;;
    }


    dimension: share_impr_search_dim {
      view_label: "Z - Metadata"
      group_label: "Auction Insights"
      label: "% Share - Search [DIM]"
      hidden: yes

      type: number
      value_format_name: percent_1

      sql: ${TABLE}.share_impr_search ;;
    }

    dimension: share_outranking_search {
      view_label: "Z - Metadata"
      group_label: "Auction Insights"
      label: "% Share - Outranking Search [DIM]"
      hidden: yes

      type: number
      value_format_name: percent_1

      sql: ${TABLE}.share_outranking_search ;;
    }

  ###### INDIVIDUAL RATE DIMENSIONS } ######


  ###### METADATA { ######

    dimension: row_id {
      view_label: "Z - Metadata"
      group_label: "Auction Insights"
      label: "Row ID [AUCTION]"
      primary_key: yes
      hidden: yes
      value_format_name: id

      sql: ${TABLE}.row_id ;;
    }

    dimension: adgroup_id {
      view_label: "Z - Metadata"
      group_label: "Auction Insights"
      label: "Adgroup ID [AUCTION]"
      type: number
      value_format_name: id
      hidden: yes

      sql: ${TABLE}.adgroup_id ;;
    }

    dimension: campaign {
      view_label: "Z - Metadata"
      group_label: "Auction Insights"
      label: "Campaign [AUCTION]"
      type: string
      hidden: yes

      sql: ${TABLE}.campaign ;;
    }

    dimension: campaign_id {
      view_label: "Z - Metadata"
      group_label: "Auction Insights"
      label: "Campaign ID [AUCTION]"
      type: number
      value_format_name: id
      hidden: yes

      sql: ${TABLE}.campaign_id ;;
    }

    dimension: timestamp {
      view_label: "Z - Metadata"
      group_label: "Auction Insights"
      label: "Timestamp [AUCTION]"
      type: date_time
      hidden: yes

      sql: ${TABLE}.timestamp ;;
    }

    dimension_group: date {
      view_label: "Z - Metadata"
      group_label: "Auction Insights"
      type: time
      hidden: yes
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

  ###### METADATA } ######

}
