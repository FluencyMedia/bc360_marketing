view: mx_queries {
  view_label: "9. Terms"

  # sql_table_name: `bc360-main.mx_terms.mx_queries` ;;

  derived_table: {
    datagroup_trigger: dg_bc360_mx_flat

    sql:  SELECT
            ROW_NUMBER() OVER () row_id,
            *
          FROM`bc360-main.mx_terms.mx_queries`
    ;;
  }

  dimension: account_id {
    hidden: yes
    type: number
    sql: ${TABLE}.account_id ;;
  }

  dimension: row_id {
    hidden: yes
    type: number
    primary_key: yes

    sql: ${TABLE}.row_id ;;
  }

  dimension: adgroup_id {
    hidden: yes
    type: number
    sql: ${TABLE}.adgroup_id ;;
  }

  dimension: campaign_id {
    hidden: yes
    type: number
    sql: ${TABLE}.campaign_id ;;
  }

  dimension: creative_id {
    hidden: yes
    type: number
    sql: ${TABLE}.creative_id ;;
  }

  dimension: criterion_id {
    hidden: yes
    type: number
    sql: ${TABLE}.criterion_id ;;
  }

  dimension: query {
    type: string
    sql: ${TABLE}.query ;;
  }

  dimension: query_match_type {
    label: "Match Type [Query]"
    type: string
    sql: ${TABLE}.query_match_type ;;
  }

  dimension: timestamp {
    hidden: yes
    type: date_time
    sql: ${TABLE}.timestamp ;;
  }

}
