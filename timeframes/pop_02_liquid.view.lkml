###  Period over Period Method 2: Allow users to choose periods with parameters


include: "/**/*.view.lkml"

view: pop_02_liquid {
  extends: [pop_01_base]

  parameter: choose_breakdown {
    label: "Choose Grouping (Rows)"
    view_label: "_PoP"
    type: unquoted
    default_value: "Month"
    allowed_value: {label: "Month Name" value:"Month"}
    allowed_value: {label: "Day of Year" value: "DOY"}
    allowed_value: {label: "Day of Month" value: "DOM"}
    allowed_value: {label: "Day of Week" value: "DOW"}
    allowed_value: {value: "Date"}
  }

  parameter: choose_comparison {
    label: "Choose Comparison (Pivot)"
    view_label: "_PoP"
    type: unquoted
    default_value: "Year"
    allowed_value: {value: "Year" }
    allowed_value: {value: "Month"}
    allowed_value: {value: "Week"}
  }

  dimension: pop_row  {
    view_label: "_PoP"
    label_from_parameter: choose_breakdown
    type: string
    order_by_field: sort_by1 # Important
    sql:
    {% if choose_breakdown._parameter_value == 'Month' %} ${date_month_name}
    {% elsif choose_breakdown._parameter_value == 'DOY' %} ${date_day_of_year}
    {% elsif choose_breakdown._parameter_value == 'DOM' %} ${date_day_of_month}
    {% elsif choose_breakdown._parameter_value == 'DOW' %} ${date_day_of_week}
    {% elsif choose_breakdown._parameter_value == 'Date' %} ${date_date}
    {% else %}NULL{% endif %} ;;
  }

  dimension: pop_pivot {
    view_label: "_PoP"
    label_from_parameter: choose_comparison
    type: string
    order_by_field: sort_by2 # Important
    sql:
    {% if choose_comparison._parameter_value == 'Year' %} ${date_year}
    {% elsif choose_comparison._parameter_value == 'Month' %} ${date_month_name}
    {% elsif choose_comparison._parameter_value == 'Week' %} ${date_week}
    {% else %}NULL{% endif %} ;;
  }


  # These dimensions are just to make sure the dimensions sort correctly
  dimension: sort_by1 {
    hidden: yes
    type: number
    sql:
    {% if choose_breakdown._parameter_value == 'Month' %} ${date_month_num}
    {% elsif choose_breakdown._parameter_value == 'DOY' %} ${date_day_of_year}
    {% elsif choose_breakdown._parameter_value == 'DOM' %} ${date_day_of_month}
    {% elsif choose_breakdown._parameter_value == 'DOW' %} ${date_day_of_week_index}
    {% elsif choose_breakdown._parameter_value == 'Date' %} ${date_date}
    {% else %}NULL{% endif %} ;;
  }

  dimension: sort_by2 {
    hidden: yes
    type: string
    sql:
    {% if choose_comparison._parameter_value == 'Year' %} ${date_year}
    {% elsif choose_comparison._parameter_value == 'Month' %} ${date_month_num}
    {% elsif choose_comparison._parameter_value == 'Week' %} ${date_week}
    {% else %}NULL{% endif %} ;;
  }
}

# ---------- EXPLORE ---------- #

# explore: pop_simple {
#   label: "PoP Method 2: Allow users to choose periods with parameters"
#   always_filter: {
#     filters:{field:choose_comparison}
#     filters:{field:choose_breakdown}}
# }
