# Define the database connection to be used for this model.
connection: "looker_partner_demo"


include: "/views/**/*.view.lkml"


explore: order_items {
  label: "Main Explore"
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: per_user_data {}
