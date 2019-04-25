connection: "bc360_main"

include: "//bc360_admin/bc360_triggers.lkml"
# include: "//bc360_admin/*.view.lkml"
include: "//bc360_clients/*.view.lkml"
include: "//bc360_services/*.view.lkml"
include: "//bc360_campaigns/*.view.lkml"

# include: "*.view.lkml"

explore: arch_client_orgs {
  label: "BC360 - Marketing"

  join: arch_campaigns {
    relationship: one_to_many
    type: inner
    sql_on: ${arch_client_orgs.organization_id} = ${arch_campaigns.organization_id} ;;
  }
}
