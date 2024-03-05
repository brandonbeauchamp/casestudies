view: cross_view {

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  measure: count {
    type: count
  }

  measure: count_of_items_bought_by_repeat_customer {
    type: count
    filters: [per_user_data.is_repeat_customer: "yes"]
  }

  measure: repeat_purchase_rate {
    type: number
    sql: ${count_of_items_bought_by_repeat_customer}/nullif(${count},0) ;;
    value_format_name: percent_2
  }

  }
