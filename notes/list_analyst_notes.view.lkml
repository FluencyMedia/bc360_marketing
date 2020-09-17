view: list_analyst_notes {
  label: "Analyst Notes"
  sql_table_name: `bc360-main.mx_marketing.list_analyst_notes`
    ;;

  dimension: client_id {
    hidden: yes
    type: string
    sql: ${TABLE}.client_id ;;
  }

  dimension_group: month {
    label: "Month Of"
    description: "Optional complex dimension for managing timeframes"

    type: time

    timeframes: [
      month,
      month_name,
      month_num,
      quarter,
      year
    ]

    convert_tz: no
    datatype: date
    sql: ${TABLE}.month ;;  }

  dimension: notes {
    label: "Analyst Notes"
    type: string
    sql: ${TABLE}.notes ;;
  }

  dimension: severity {
    type: number
    sql: ${TABLE}.severity ;;
  }

  dimension: target {
    type: string
    sql: ${TABLE}.target ;;
  }

}

explore: list_analyst_notes {
  group_label: "BC360 - All Clients"
  label: "Analyst Notes"
}
