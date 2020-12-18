view: fact_keywords {
  sql_table_name: `bc360-main.mx_terms.fact_keywords`
    ;;

  dimension: account_id {
    type: number
    sql: ${TABLE}.account_id ;;
  }

  dimension: adgroup_id {
    type: number
    sql: ${TABLE}.adgroup_id ;;
  }

  dimension: bid_source_cpc {
    type: string
    sql: ${TABLE}.bid_source_cpc ;;
  }

  dimension: campaign_id {
    type: number
    sql: ${TABLE}.campaign_id ;;
  }

  dimension: cpc_first_page {
    type: string
    sql: ${TABLE}.cpc_first_page ;;
  }

  dimension: cpc_first_position {
    type: string
    sql: ${TABLE}.cpc_first_position ;;
  }

  dimension: cpc_top_of_page {
    type: string
    sql: ${TABLE}.cpc_top_of_page ;;
  }

  dimension: ctr_predicted_search {
    type: string
    sql: ${TABLE}.ctr_predicted_search ;;
  }

  dimension: enhanced_cpc_enabled {
    type: yesno
    sql: ${TABLE}.enhanced_cpc_enabled ;;
  }

  dimension: is_negative {
    type: yesno
    sql: ${TABLE}.is_negative ;;
  }

  dimension: keyword {
    type: string
    sql: ${TABLE}.keyword ;;
  }

  dimension: keyword_match_type {
    type: string
    sql: ${TABLE}.keyword_match_type ;;
  }

  dimension: quality_score {
    type: number
    sql: ${TABLE}.quality_score ;;
  }

  dimension: quality_score_creative {
    type: string
    sql: ${TABLE}.quality_score_creative ;;
  }

  dimension: quality_score_has {
    type: yesno
    sql: ${TABLE}.quality_score_has ;;
  }

  dimension: status_system_service {
    type: string
    sql: ${TABLE}.status_system_service ;;
  }

  dimension: urls_final {
    type: string
    sql: ${TABLE}.urls_final ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
