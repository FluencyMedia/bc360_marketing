connection: "bc360_main"

include: "//bc360_admin/**/bc360_triggers.lkml"
include: "//bc360_clients/**/*.view.lkml"
include: "//bc360_services/**/*.view.lkml"
include: "//bc360_campaigns/**/*.view.lkml"
include: "//bc360_outcomes/**/*.view.lkml"
# include: "//bc360_users/**/*.view.lkml"

include: "/**/*.view.lkml"

label: "BC360 - All Clients"

explore: bc360_mx_main {
  from: arch_clients_admin
  label: "BC360 - Digital Marketing"

  join: arch_campaigns {
    relationship: one_to_many
    type: left_outer
    sql_on: ${bc360_mx_main.organization_id} = ${arch_campaigns.organization_id} ;;
  }

  #  join: arch_financials {
  #    relationship: one_to_many
  #    type: left_outer
  #    sql_on: ${arch_campaigns.service_line_code} = ${arch_financials.service_line_code} ;;
  #  }

  join: mx_marketing {
    relationship: one_to_many
    type: inner
    sql_on: ${arch_campaigns.adgroup_id} = ${mx_marketing.adgroup_id} ;;
  }

  join: arch_outcomes_admin {
    relationship: many_to_one
    type: left_outer
    sql_on: ${mx_marketing.outcome_tracker_id} = ${arch_outcomes_admin.outcome_tracker_id} ;;
  }

}

explore: bc360_mx_shares {
  from: arch_clients_admin
  label: "BC360 - DM Shares"

  join: arch_campaigns {
    relationship: one_to_many
    type: left_outer
    sql_on: ${bc360_mx_shares.organization_id} = ${arch_campaigns.organization_id} ;;
  }

  join: mx_marketing {
   relationship: one_to_many
   type: inner
   sql_on: ${arch_campaigns.adgroup_id} = ${mx_marketing.adgroup_id} ;;
  }

  join: arch_outcomes_admin {
   relationship: many_to_one
   type: left_outer
   sql_on: ${mx_marketing.outcome_tracker_id} = ${arch_outcomes_admin.outcome_tracker_id} ;;
  }

  join: mx_share_impr_click {
    relationship: one_to_many
    type: left_outer
    sql_on: ((${mx_marketing.adgroup_id} = ${mx_share_impr_click.adgroup_id})
                AND (${mx_marketing.date_date} = ${mx_share_impr_click.date_date})
                AND (${mx_marketing.hour_of_day} = ${mx_share_impr_click.hour_of_day})
                ) ;;
  }

}

###############################################

explore: bc360_mx_pop_01 {
  from: arch_clients_admin
  label: "BC360 - DM - PoP 01"
  hidden: yes

  join: arch_campaigns {
    relationship: one_to_many
    type: left_outer
    sql_on: ${bc360_mx_pop_01.organization_id} = ${arch_campaigns.organization_id} ;;
  }

  join: mx_marketing {
    from: pop_01_base
    relationship: one_to_many
    type: inner
    sql_on: ${arch_campaigns.adgroup_id} = ${mx_marketing.adgroup_id} ;;
  }

  join: arch_outcomes_admin {
    relationship: many_to_one
    type: left_outer
    sql_on: ${mx_marketing.outcome_tracker_id} = ${arch_outcomes_admin.outcome_tracker_id} ;;
  }

}

explore: bc360_mx_pop_02 {
  from: arch_clients_admin
  label: "BC360 - DM - PoP 02"
  hidden: yes

  join: arch_campaigns {
    relationship: one_to_many
    type: left_outer
    sql_on: ${bc360_mx_pop_02.organization_id} = ${arch_campaigns.organization_id} ;;
  }

  always_filter: {
    # filters:{field:bc360_mx_pop_02.choose_comparison}
    # filters:{field:bc360_mx_pop_02.choose_breakdown}
    }


  join: mx_marketing {
    from: pop_02_liquid
    relationship: one_to_many
    type: inner
    sql_on: ${arch_campaigns.adgroup_id} = ${mx_marketing.adgroup_id} ;;
  }

  join: arch_outcomes_admin {
    relationship: many_to_one
    type: left_outer
    sql_on: ${mx_marketing.outcome_tracker_id} = ${arch_outcomes_admin.outcome_tracker_id} ;;
  }

}


explore: bc360_mx_pop_03 {
  from: arch_clients_admin
  label: "BC360 - DM - PoP 03"
  hidden: yes

  join: arch_campaigns {
    relationship: one_to_many
    type: left_outer
    sql_on: ${bc360_mx_pop_03.organization_id} = ${arch_campaigns.organization_id} ;;
  }

  always_filter: {
    # filters:{field:bc360_mx_pop_02.choose_comparison}
    # filters:{field:bc360_mx_pop_02.choose_breakdown}
  }


  join: mx_marketing {
    from: pop_03_custom_periods
    relationship: one_to_many
    type: inner
    sql_on: ${arch_campaigns.adgroup_id} = ${mx_marketing.adgroup_id} ;;
  }

  join: arch_outcomes_admin {
    relationship: many_to_one
    type: left_outer
    sql_on: ${mx_marketing.outcome_tracker_id} = ${arch_outcomes_admin.outcome_tracker_id} ;;
  }

}
