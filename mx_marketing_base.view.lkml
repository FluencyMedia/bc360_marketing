view: mx_marketing_base {
  # extension: required

  sql_table_name: mx_marketing.mx_marketing_base ;;

##########  METADATA    {

    dimension: adgroup_id {
      view_label: "Z - Metadata"
      group_label: "Database IDs"
      label: "Ad Group ID [MX_Master]"
      description: "Foreign Key from master metrics table"

      can_filter: no
      hidden: no

      type: string

      sql: ${TABLE}.adgroup_id ;;  }

    dimension: row_id {
      view_label: "Z - Metadata"
      group_label: "Database IDs"
      label: "Row ID [MX_Master]"
      description: "Unique row ID from master metrics table"

      primary_key: yes

      can_filter: no
      hidden: no

      type: string

      sql: ${TABLE}.row_id ;;  }

    dimension: outcome_tracker_id {
      view_label: "Z - Metadata"
      group_label: "Database IDs"
      label: "Outcome Tracker ID [MX_Master]"
      description: "Outcome Tracker ID from master metrics table"

      can_filter: no
      hidden: no

      type: string

      sql: ${TABLE}.outcome_tracker_id ;;  }

##########  METADATA  }  ##########



##########  DIMENSIONS  {

##### Time Dimensions {

    dimension_group: date {
      view_label: "4. Timeframes"
      label: "Timeframes"
      description: "Optional complex dimension for managing timeframes"

      type: time

      timeframes: [
        raw,
        date,
        day_of_week_index,
        day_of_week,
        week,
        month,
        quarter,
        year
      ]

      convert_tz: no
      datatype: date
      sql: ${TABLE}.date ;;  }

    measure: date_start {
      view_label: "4. Timeframes"
      label: "Start Date"

      type: date

      sql: MIN(${date_date})::DATE ;;  }

    measure: date_end {
      view_label: "4. Timeframes"
      label: "End Date"

      type: date

      sql: MAX(${date_date})::DATE ;;  }

    measure: date_diff {
      view_label: "4. Timeframes"
      label: "Duration - Days"

      type: number
      value_format_name: decimal_0

      sql: ${date_end} - ${date_start} ;;
    }

    measure: count_days {
      view_label: "Z - Metadata"
      group_label: "Category Counts"
      label: "# Days"

      can_filter: no
      hidden: no

      type: count_distinct
      value_format_name: decimal_0

      sql: ${date_date} ;;
    }

    dimension: year_str {
      view_label: "4. Timeframes"
      label: "Year [LABEL]"
      description: "'Year' as a string dimension for charts"

      can_filter: no

      type: string

      sql: ${date_year}::text ;;
    }

##### Time Dimensions } #####

      ##########  MEASURES   {

      ##### Base Measures {

      measure: impr_sum {
        view_label: "5. Performance"
        label: "# Impressions"

        type: number
        value_format_name: decimal_0

        sql: NULLIF(SUM(${TABLE}.impressions),0);;  }


      measure: clicks_sum {
        view_label: "5. Performance"
        label: "# Clicks"

        type: number
        value_format_name: decimal_0

        sql: NULLIF(SUM(${TABLE}.clicks),0);;  }


      measure: cost_sum {
        view_label: "5. Performance"
        label: "$ Cost"

        type: number
        value_format_name: usd_0

        sql: NULLIF(SUM(${TABLE}.cost), 0);; }

      measure: outcomes_sum {
        view_label: "6. Outcomes"
        group_label: "Z - Reference"
        label: "# Outcomes"

        hidden: no

        type: number
        value_format_name: decimal_0

        sql: NULLIF(SUM(${TABLE}.outcomes), 0);;  }

      measure: outcomes_bulk_sum {
        view_label: "6. Outcomes"
        group_label: "Z - Reference"
        label: "# Outcomes (Bulk)"

        hidden: no

        type: number
        value_format_name: decimal_0

        sql: NULLIF(SUM(${TABLE}.outcomes_bulk), 0);;  }

      ##### }
      ##### End Base Measures

      ##### Calculated Measures {

      measure: ctr {
        view_label: "5. Performance"
        label: "% CTR"

        type: number
        value_format_name: percent_2

        sql: 1.0*(${clicks_sum}) / nullif(${impr_sum},0) ;;  }

        measure: cpc {
          view_label: "5. Performance"
          label: "$ CPC"

          type: number
          value_format_name: usd

          sql: 1.0*(${cost_sum}) / nullif(${clicks_sum},0) ;;  }

        measure: cpm {
          view_label: "5. Performance"
          label: "$ CPM"

          type: number
          value_format_name: usd

          sql: 1.0*(${cost_sum}) / nullif((${impr_sum}/1000),0) ;;  }

        measure: cpo {
          view_label: "6. Outcomes"
          label: "$ CPO"
          description: "Cost / Outcome"

          type: number
          value_format_name: usd

          sql: 1.0*(${cost_sum}) / nullif(${outcomes_sum},0) ;;  }

        measure: otr {
          view_label: "6. Outcomes"
          label: "% OTR"
          description: "Outcomes / Clicks"

          type: number
          value_format_name: percent_2

          sql: 1.0*(${outcomes_sum}) / nullif(${clicks_sum},0) ;;  }

        ##########  MEASURES  }  ##########
      }
