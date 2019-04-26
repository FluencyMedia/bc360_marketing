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

explore: arch_clients_admin {
  label: "BC360 - Marketing [ADMIN]"

  join: arch_campaigns_admin {
    relationship: one_to_many
    type: inner
    sql_on: ${arch_clients_admin.organization_uid} = ${arch_campaigns_admin.organization_uid} ;;
  }

  join: arch_services_admin {
    relationship: many_to_one
    type: inner
    sql_on: ${arch_campaigns_admin.service_line_code} = ${arch_services_admin.service_line_code} ;;
  }

  join: mx_marketing_base {
    relationship: many_to_many
    type: inner
    sql_on: ${arch_campaigns_admin.adgroup_id} = ${mx_marketing_base.adgroup_id} ;;
  }

  join: arch_outcomes_admin {
    relationship: many_to_one
    type: left_outer
    sql_on: ${arch_outcomes_admin.outcome_tracker_id} = ${mx_marketing_base.outcome_tracker_id} ;;
  }

}
