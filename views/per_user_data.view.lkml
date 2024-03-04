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
      type: number
    }
    dimension: last_order_date {
      description: ""
      type: number
    }

    dimension: customer_lifetime_orders {
      type: string
      sql: CASE
      When ${count_orders} = 1 then "1 time customer"
      When ${count_orders} = 2 then "2 time customer"
      When ${count_orders} > 3 and < 5 then "Multi-time customer"
      When ${count_orders} > 6 then "Loyal customer"
      else "No time customer";;
    }


  }
