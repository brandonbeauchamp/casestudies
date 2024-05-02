view: order_items {

  sql_table_name: `thelook.order_items` ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, month_num, quarter, year]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.delivered_at ;;
  }

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

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_sale_price {
    description: "Total sales from items sold"
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd_0
    }

  measure: average_sale_price {
    description: "Average sale price from items sold"
    type: average
    sql: ${sale_price} ;;
    }

    measure: running_total_sale_price {
      type: running_total
      sql: ${total_sale_price} ;;
    }

    measure: total_gross_revenue {
      type: sum
      sql: ${sale_price} ;;
      filters: [is_order_complete: "Yes"]
      value_format_name: usd
    }

    measure: total_gross_margin_amount {
      type: number
      sql: ${total_gross_revenue} - ${inventory_items.total_cost} ;;
      value_format_name: decimal_2
      drill_fields: [products.brand, products.category]
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
      description: "Total Gross Margin Amount / Total Gross Revenue"
      type: number
      sql: ${total_gross_margin_amount}/nullif(${total_gross_revenue},0)  ;;
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
    description: "On average how much a customer will spend"
    type: number
    sql: ${total_sale_price}/${count_users} ;;
    value_format_name: usd_0
  }
  measure: total_revenue_yesterday {
    description: "Yesterday's total revenue generated "
    type: sum
    sql: ${sale_price} ;;
    filters: [created_date: "yesterday"]
    value_format_name: usd_0
  }

  measure: count_orders {
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: first_order_date {
    type: date
    sql: MIN(${created_raw}) ;;
  }

  measure: last_order_date {
    type: date
    sql: MAX(${created_raw}) ;;
  }


  dimension: is_order_complete {
    type: yesno
    sql: ${status} not in ("Cancelled", "Returned") ;;
  }


  measure: count_of_items_bought_by_repeat_customer {
    type: count
    filters: [per_user_data.is_repeat_customer: "yes"]
  }

  measure: repeat_purchase_rate {
    type: number
    label: "Repeat Purchase Rate"
    description: "Count of items bought by repeat customer / all items from all customers"
    sql: ${count_of_items_bought_by_repeat_customer}/nullif(${count},0) ;;
    value_format_name: percent_2
  }

  parameter: customer_category {
    type: unquoted
    default_value: " "
    allowed_value: {
      label: "Gender"
      value: "gender"
    }
    allowed_value: {
      label: "Country"
      value: "country"
    }
    allowed_value: {
      label: "Revenue Tier"
      value: "revenuetier"
    }
    allowed_value: {
      label: "Order Count Tier"
      value: "ordercounttier"
    }
  }


  dimension: dynamic_customer_category {
    type: string
    sql:

          {% if customer_category._parameter_value == 'gender' %}
                  ${users.gender}
          {% elsif customer_category._parameter_value == 'country' %}
                   ${users.country}
          {% elsif customer_category._parameter_value == 'revenuetier' %}
                   ${per_user_data.customer_lifetime_revenue}
          {% else %}
                   ${per_user_data.customer_lifetime_orders}
          {% endif %}
    ;;
  }

### If the parameter value is selected to gender, by the end user, then the dimension in the tile will switch to Gender.


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
