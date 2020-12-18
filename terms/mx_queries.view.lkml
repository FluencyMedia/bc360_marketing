view: mx_queries {
  view_label: "9. Terms"

  sql_table_name: `bc360-main.mx_terms.mx_queries`
    ;;

  dimension: account_id {
    type: number
    sql: ${TABLE}.account_id ;;
  }

  dimension: adgroup_id {
    type: number
    sql: ${TABLE}.adgroup_id ;;
  }

  dimension: campaign_id {
    type: number
    sql: ${TABLE}.campaign_id ;;
  }

  dimension: creative_id {
    type: number
    sql: ${TABLE}.creative_id ;;
  }

  dimension: criterion_id {
    type: number
    sql: ${TABLE}.criterion_id ;;
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

  dimension: query {
    type: string
    sql: ${TABLE}.query ;;
  }

  dimension: query_match_type {
    type: string
    sql: ${TABLE}.query_match_type ;;
  }

  dimension: timestamp {
    type: date_time
    sql: ${TABLE}.timestamp ;;
  }

}
