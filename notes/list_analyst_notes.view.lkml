view: list_analyst_notes {
  label: "Analyst Notes"

  derived_table: {
    datagroup_trigger: dg_bc360_mx_flat

    sql:  SELECT
            ROW_NUMBER() OVER () row_id,
            lan.*,
          FROM bc360-main.mx_marketing.list_analyst_notes lan;;
    partition_keys: ["date"]
    cluster_keys: ["campaign_group", "timestamp"]
  }

  # sql_table_name: `bc360-main.mx_marketing.list_analyst_notes` ;;

  dimension: row_id {
    view_label: "Z - Metadata"
    group_label: "IDs"
    label: "Row ID [ANALYST NOTES]"
    description: "Row ID from 'list_analyst_notes'"

    primary_key: yes
    type: number
    value_format_name: id

    sql: ${TABLE}.row_id ;;
  }

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
  label: "LIST - Analyst Notes"
}
