connection: "bc360_main"

include: "//bc360_admin/bc360_triggers.lkml"
# include: "//bc360_admin/*.view.lkml"
include: "//bc360_clients/*.view.lkml"
include: "//bc360_services/*.view.lkml"
include: "//bc360_campaigns/*.view.lkml"
include: "//bc360_outcomes/*.view.lkml"
# include: "//bc360_users/*.view.lkml"

include: "*.view.lkml"

label: "BC360 - Admin"

explore: bc360_mx_main {
  from: arch_clients_admin
  label: "BC360 - Master [MAIN]"

  join: arch_campaigns_admin {
    relationship: one_to_many
    type: left_outer
    sql_on: ${bc360_mx_main.organization_id} = ${arch_campaigns_admin.organization_id} ;;
  }

  join: mx_marketing {
    relationship: one_to_many
    type: inner
    sql_on: ${arch_campaigns_admin.adgroup_id} = ${mx_marketing.adgroup_id} ;;
  }

  join: arch_outcomes_admin {
    relationship: many_to_one
    type: left_outer
    sql_on: ${mx_marketing.outcome_tracker_id} = ${arch_outcomes_admin.outcome_tracker_id} ;;
  }
}

explore: mx_marketing_base {
  label: "BC360 - Metrics [ADMIN]"

  join: arch_outcomes_admin {
    relationship: many_to_one
    type: left_outer
    sql_on: ${arch_outcomes_admin.outcome_tracker_id} = ${mx_marketing_base.outcome_tracker_id} ;;
  }
}
