include: "//bc360_outcomes/*.view.lkml"
include: "mx_marketing_base.view"

view: mx_marketing {
  extends: [mx_marketing_base]

  dimension: adgroup_id { hidden: yes }
  dimension: outcome_tracker_id { hidden: yes }
  dimension: row_id { hidden: yes }
  dimension: final_url { hidden: yes }
  dimension: subtype_codes_raw { hidden: yes }
  dimension: subtype_codes_str { hidden: yes }
  dimension: subtype_codes { hidden: yes }
  dimension: sc_service { hidden: yes }
  dimension: sc_offering { hidden: yes }
  dimension: sc_topic { hidden: yes }
  dimension: sc_medium { hidden: yes }

  measure: impr_avail { hidden: yes }
  measure: oucomes_bulk_sum { hidden: yes }
  measure: ctr_bar { hidden: yes }
  measure: o_referrals_num { hidden: yes }
  measure: o_leads_num { hidden: yes }
  measure: o_outcomes_num { hidden: yes }
  measure: avg_conv_score { hidden: yes }
}
