# Define the database connection to be used for this model.
connection: "looker_partner_demo"


include: "/views/**/*.view.lkml"


datagroup: case_study_brandon_beauchamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: case_study_brandon_beauchamp_default_datagroup


explore: distribution_centers {}

# explore: events {
#   join: users {
#     type: left_outer
#     sql_on: ${events.user_id} = ${users.id} ;;
#     relationship: many_to_one
#   }
# }

explore: order_items {

  # access_filter: {
  #   field: users.country
  #   user_attribute: brandon_use_case_attribute
  # }

  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${order_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }

  join: per_user_data {
    type: left_outer
    sql_on: ${order_items.user_id} = ${per_user_data.user_id} ;;
    relationship: many_to_one
  }

  # join: cross_view {
  #   type: left_outer
  #   sql_on: ${cross_view.id} = ${order_items.id} ;;
  #   relationship: one_to_one
  # }

}

explore: order_items_test {}

# explore: users {}

explore: products {
  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

# explore: inventory_items {
#   join: products {
#     type: left_outer
#     sql_on: ${inventory_items.product_id} = ${products.id} ;;
#     relationship: many_to_one
#   }

#   join: distribution_centers {
#     type: left_outer
#     sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
#     relationship: many_to_one
#   }

#   join: order_items {
#     type: left_outer
#     sql_on: ${inventory_items.id} = ${order_items.inventory_item_id} ;;
#     relationship: one_to_many
#   }
# }

  explore: per_user_data {
    # join: order_items {
    #   type: left_outer
    #   sql_on: ${per_user_data.user_id} = ${order_items.user_id} ;;
    #   relationship: one_to_many
    # }
  }
