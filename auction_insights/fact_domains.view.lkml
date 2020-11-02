view: fact_domains {
  label: "8. Auction Insights"
  sql_table_name: `bc360-main.flat_mx.fact_domains`
    ;;

  dimension: domain {
    label: "  Domain"
    type: string

    link: {
      label: "{{ value }}"
      url: "http://{{ value }}"
      icon_url: "http://{{ value }}/favicon.ico"
      }

    sql: ${TABLE}.domain ;;
  }

  dimension: domain_orig {
    label: "Domain [ORIGINAL]"
    description: "Raw domain from Ads (not aggregated into main domain)"
    type: string
    primary_key: yes

    link: {
      label: "{{ value }}"
      url: "http://{{ value }}"
      icon_url: "http://{{ value }}/favicon.ico"
    }

    sql: ${TABLE}.domain_orig ;;
  }

  dimension: domain_category {
    label: "  Domain Category"
    description: "Healthcare System | Specialty Clinic | Pharmaceutical ..."
    type: string
    sql: IFNULL(${TABLE}.domain_category, "Other") ;;
  }

  dimension: domain_status_bh {
    group_label: "Domain Statuses"
    label: "Domain Category [BH]"
    type: string
    sql: ${TABLE}.domain_status_bh ;;
  }

  dimension: domain_status_scl {
    group_label: "Domain Statuses"
    label: "Domain Category [SCL]"
    type: string
    sql: ${TABLE}.domain_status_scl ;;
  }

  dimension: domain_status_ufh {
    group_label: "Domain Statuses"
    label: "Domain Category [UFH]"
    type: string
    sql: ${TABLE}.domain_status_ufh ;;
  }

  dimension: domain_status {
    label: "  Domain Status"
    description: "Competitor | Other ..."
    type: string
    sql: COALESCE(${domain_status_bh}, ${domain_status_scl}, ${domain_status_ufh}, "Other") ;;
  }
}
