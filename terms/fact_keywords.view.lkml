view: fact_keywords {
  view_label: "9. Terms"
  sql_table_name: `bc360-main.mx_terms.fact_keywords` ;;


  dimension: account_id {
    hidden: yes
    type: number
    sql: ${TABLE}.account_id ;;
  }

  dimension: adgroup_id {
    hidden: yes
    type: number
    sql: ${TABLE}.adgroup_id ;;
  }

  dimension: criterion_id {
    hidden: yes
    type: number
    sql: ${TABLE}.criterion_id ;;
  }

  dimension: bid_source_cpc {
    hidden: yes
    type: string
    sql: ${TABLE}.bid_source_cpc ;;
  }

  dimension: campaign_id {
    hidden: yes
    type: number
    sql: ${TABLE}.campaign_id ;;
  }

  dimension: cpc_first_page {
    hidden: yes
    type: string
    sql: ${TABLE}.cpc_first_page ;;
  }

  dimension: cpc_first_position {
    hidden: yes
    type: string
    sql: ${TABLE}.cpc_first_position ;;
  }

  dimension: cpc_top_of_page {
    hidden: yes
    type: string
    sql: ${TABLE}.cpc_top_of_page ;;
  }

  dimension: ctr_predicted_search {
    hidden: yes
    type: string
    sql: ${TABLE}.ctr_predicted_search ;;
  }

  dimension: enhanced_cpc_enabled {
    hidden: yes
    type: yesno
    sql: ${TABLE}.enhanced_cpc_enabled ;;
  }

  dimension: is_negative {
    hidden: yes
    type: yesno
    sql: ${TABLE}.is_negative ;;
  }

  dimension: keyword {
    type: string
    sql: ${TABLE}.keyword ;;
  }

  dimension: keyword_match_type {
    label: "Match Type [KW]"
    type: string
    sql: ${TABLE}.keyword_match_type ;;
  }

  dimension: quality_score {
    hidden: yes
    type: number
    sql: ${TABLE}.quality_score ;;
  }

  dimension: quality_score_creative {
    hidden: yes
    type: string
    sql: ${TABLE}.quality_score_creative ;;
  }

  dimension: quality_score_has {
    hidden: yes
    type: yesno
    sql: ${TABLE}.quality_score_has ;;
  }

  dimension: status_system_service {
    hidden: yes
    type: string
    sql: ${TABLE}.status_system_service ;;
  }

  dimension: urls_final {
    hidden: yes
    type: string
    sql: ${TABLE}.urls_final ;;
  }

}
