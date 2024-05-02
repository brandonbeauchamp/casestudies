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
    description: "Numeric ID of a user"
    type: number
  }

  dimension: count_orders {
    description: "Number of orders a customer has made"
    type: number
  }
  dimension: total_sale_price {
    description: "Total sales from items sold"
    value_format: "$#,##0"
    type: number
  }
  dimension: first_order_date {
    description: "Customers First Order Date"
    type: date
  }
  dimension: last_order_date {
    description: "Customers Last Order Date"
    type: date
  }

  dimension: customer_lifetime_orders {
    type: string
    label: "Customer Lifetime Orders"
    description: "Categorizes customers by the number of orders they have ever purchased"
    sql: CASE
      When ${count_orders} = 1 then "1 Time Customer"
      When ${count_orders} = 2 then "2 Time Customer"
      When ${count_orders} BETWEEN 3 and 5 then "Multi-time customer"
      When ${count_orders} > 6 then "Loyal customer"
      else "No time customer" end ;;
  }

  dimension: customer_lifetime_revenue {
    type: string
    label: "Customer Lifetime Revenue"
    description: "Categorizes customers by the total amount of money they have ever spent "
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
    label: "Total Lifetime Revenue"
    description: "Sums the total amount of money all customers have spent"
    type: sum
    sql: ${total_sale_price} ;;
    value_format_name: usd_0
  }
  measure: total_lifetime_orders {
    label: "Total Lifetime Orders"
    description: "Sums up the total number of orders all customers have purchased"
    type: sum
    sql: ${count_orders} ;;
  }

  # measure: average_lifetime_revenue {
  #   label: "Average Lifetime Revenue"
  #   description: "Averages the total amount of money all customers have spent"
  #   type: average
  #   sql: ${total_sale_price} ;;
  #   value_format_name: usd_0
  # }

  measure: aveerage_lifetime_orders {
    label: "Average Lifetime Orders"
    description: "Averages the total number of orders all customers have purchased"
    type: average
    sql: ${count_orders} ;;
  }

  dimension_group: days_since_first_to_last_order {
    type: duration
    label: "Days Since First to Last Order"
    description: "The duration in days of a customers first to last order "
    intervals: [day]
    sql_start: ${first_order_date} ;;
    sql_end: ${last_order_date};;
  }


  dimension_group: days_since_user_created_first_order {
    type: duration
    label: "Days Since User Purchased First Order"
    description: "The duration in days since a customer's first order until the present day"
    intervals: [day]
    sql_start: ${first_order_date} ;;
    sql_end: CURRENT_DATE;;
  }

  dimension_group: days_since_user_created_last_order {
    type: duration
    label: "Days Since User Purchased Last Order"
    description: "The duration in days since a customer's last order until the present day"
    intervals: [day]
    sql_start: ${last_order_date} ;;
    sql_end: CURRENT_DATE;;
  }

  dimension: is_customer_active  {
    label: "Is Customer Active"
    description: "Flags a customer as active if they have bought something in the last 90 days"
    type: yesno
    sql: ${days_days_since_user_created_last_order} <= 90 ;;
  }

  measure: average_days_since_latest_order {
    label: "Average Days Since Latest Order"
    description: "Averages the duration of days since a customer's last order until now "
    type: average
    sql: ${days_days_since_user_created_last_order} ;;
  }

  dimension: is_repeat_customer {
    label: "Is Repeat Customer"
    description: "Flags a customer as repeat if they have ever bough something before"
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
