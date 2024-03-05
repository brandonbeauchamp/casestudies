view: per_user_data {
    derived_table: {
      explore_source: order_items {
        column: user_id {}
        column: count_orders {}
        column: total_sale_price {}
        column: first_order_date {}
        column: last_order_date {}
      }
    }
    dimension: user_id {
      primary_key: yes
      description: ""
      type: number
    }

    dimension: count_orders {
      description: ""
      type: number
    }
    dimension: total_sale_price {
      description: "Total sales from items sold"
      value_format: "$#,##0"
      type: number
    }
    dimension: first_order_date {
      description: ""
      type: date
    }
    dimension: last_order_date {
      description: ""
      type: date
    }

    dimension: customer_lifetime_orders {
      type: string
      sql: CASE
      When ${count_orders} = 1 then "1 time customer"
      When ${count_orders} = 2 then "2 time customer"
      When ${count_orders} BETWEEN 3 and 5 then "Multi-time customer"
      When ${count_orders} > 6 then "Loyal customer"
      else "No time customer" end ;;
    }

  dimension: customer_lifetime_revenue {
    type: string
    sql: CASE
      When ${total_sale_price} BETWEEN 0 and 4.99 then "Bronze Tier Customer"
      When ${total_sale_price} BETWEEN 5 and 19.99 then "Silver Tier Customer"
      When ${total_sale_price} BETWEEN 20 and 49.99 then "Gold Tier Customer"
      When ${total_sale_price} BETWEEN 50.00 and 99.99 then "Platinum Tier Customer"
      When ${total_sale_price} BETWEEN 100 and 499.99 then "Diamond Tier Customer"
      When ${total_sale_price} BETWEEN 500 and 999.99 then "Ruby Tier Customer"
      When ${total_sale_price} >= 1000 then "Signature Tier Customer"
      else "Level zero Customer" end ;;
  }

  measure: total_lifetime_revenue {
    type: sum
    sql: ${total_sale_price} ;;
    value_format_name: usd_0
  }
  measure: total_lifetime_orders {
    type: sum
    sql: ${count_orders} ;;
  }

  measure: average_lifetime_revenue {
    type: average
    sql: ${total_sale_price} ;;
    value_format_name: usd_0
  }

  measure: aveerage_lifetime_orders {
    type: average
    sql: ${count_orders} ;;
  }

  dimension_group: days_since_first_to_last_order {
    type: duration
    intervals: [day]
    sql_start: ${first_order_date} ;;
    sql_end: ${last_order_date};;
  }

  # dimension: is_customer_active {
  #   type: yesno
  #   sql: ${days_days_since_first_to_last_order} ;;
  # }

  dimension_group: days_since_user_created_first_order {
    type: duration
    intervals: [day]
    sql_start: ${first_order_date} ;;
    sql_end: CURRENT_DATE;;
  }

  dimension_group: days_since_user_created_last_order {
    type: duration
    intervals: [day]
    sql_start: ${last_order_date} ;;
    sql_end: CURRENT_DATE;;
  }

  dimension: is_customer_active  {
    type: yesno
    sql: ${days_days_since_user_created_last_order} <= 90 ;;
  }

  measure: average_days_since_latest_order {
    type: average
    sql: ${days_days_since_user_created_last_order} ;;
  }

  dimension: is_repeat_customer {
    type: yesno
    sql: ${count_orders} > 1 ;;
  }

  measure: count_active_users {
    type: count
    filters: [is_customer_active: "yes"]
  }



  measure: count {
    type: count
  }





  }
