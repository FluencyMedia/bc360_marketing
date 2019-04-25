connection: "bc360_main"

include: "//bc360_admin/bc360_triggers.lkml"
# include: "//bc360_admin/*.view.lkml"
include: "//bc360_clients/*.view.lkml"
include: "//bc360_services/*.view.lkml"
include: "//bc360_campaigns/*.view.lkml"

# include: "*.view.lkml"

explore: arch_client_orgs {
  label: "BC360 - Marketing [ADMIN]"

  join: arch_campaigns_admin {
    relationship: one_to_many
    type: inner
    sql_on: ${arch_client_orgs.organization_uid} = ${arch_campaigns_admin.organization_uid} ;;
  }
}

explore: arch_campaigns {
  label: "CAMPAIGNS"
}
