view: per_user_data {
  derived_table: {
    explore_source: order_items {
      column: full_name { field: users.full_name }
      column: total_sale_price {}
      filters: {
        field: order_items.created_date
        value: "2023"
      }
    }
  }
  dimension: full_name {
    description: ""
  }
  dimension: total_sale_price {
    description: ""
    type: number
  }
  dimension: customer_lifetime_revenue_tier {
    type: string
    sql: case when ${total_sale_price} > 1200 then "Gold Tier Customer"
              when ${total_sale_price} > 700 then "Silver Tier Customer"
            else "Bronze Tier Customer"
              end;;
  }
}
