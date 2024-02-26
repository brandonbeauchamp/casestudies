# The name of this view in Looker is "Order Items"
view: order_items {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `thelook.order_items` ;;
  drill_fields: [id]

  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.delivered_at ;;
  }
    # Here's what a typical dimension looks like in LookML.
    # A dimension is a groupable field that can be used to filter query results.
    # This dimension will be called "Inventory Item ID" in Explore.

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: product_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.product_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;  }

  measure: average_sale_price {
    type: average
    sql: ${sale_price} ;;
    }

    measure: total_gross_revenue {
      type: sum
      sql: ${sale_price} ;;
      filters: [status: "Complete"]
    }

    measure: total_gross_margin_amount {
      type: number
      sql: ${total_gross_revenue} - ${inventory_items.total_cost} ;;
    }

    measure: avg_total_gross_margin_amount {
      type: number
      sql: ${total_gross_margin_amount}/${number_of_items_sold} ;;
    }

    measure: number_of_items_sold {
      type: count
      filters: [returned_date: "null"]
    }

    measure: gross_margin_percentatge {
      type: number
      sql: ${total_gross_margin_amount}/${total_gross_revenue} ;;
      value_format_name: percent_2
    }

    measure: number_of_order_items_returned {
      type: count
      filters: [status: "Returned"]
    }

    measure: item_return_rate {
      type: number
      sql: ${number_of_order_items_returned}/${number_of_items_sold} ;;
      value_format_name: percent_2
    }

  dimension_group: shipped {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }
  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: count_users_returned_items {
    type: count_distinct
    sql: ${user_id} ;;
    filters: [status: "Returned"]
  }
  measure: count_users {
    type: count_distinct
    sql: ${user_id} ;;
  }
  measure: percent_of_users_with_returns {
    type: number
    sql: ${count_users_returned_items}/${count_users} ;;
    value_format_name: percent_2
  }
  measure: average_spend_per_customer {
    type: number
    sql: ${total_sale_price}/${count_users} ;;
    value_format_name: usd_0
  }
  measure: total_revenue_yesterday {
    type: sum
    sql: ${sale_price} ;;
    filters: [created_date: "yesterday"]
    value_format_name: decimal_2
  }

  dimension_group: days_since_user_created {
    type: duration
    intervals: [day]
    sql_start: ${created_raw} ;;
    sql_end: CURRENT_TIMESTAMP();;
  }

  dimension: is_new_customer_yesterday {
    type: yesno
    sql: ${days_days_since_user_created} = 1 ;;
  }

  measure: total_number_of_new_users_yesterday {
    type: count_distinct
    sql: ${is_new_customer_yesterday} ;;
    filters: [is_new_customer_yesterday: "yes"]

  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
  id,
  users.last_name,
  users.id,
  users.first_name,
  inventory_items.id,
  inventory_items.product_name,
  products.name,
  products.id
  ]
  }

}
