view: total_sales_by_user {
    derived_table: {
      explore_source: order_items {
        column: full_name { field: users.full_name }
        column: total_sale_price {}
      }
    }
    dimension: full_name {
      description: ""
    }
    dimension: total_sale_price {
      description: "Total sales from items sold"
      value_format: "$#,##0"
      type: number
    }
  }
