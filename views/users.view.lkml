view: users {

  sql_table_name: `thelook.users` ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    description: "Age of the user"
    type: number
    sql: ${TABLE}.age ;;
  }

  measure: total_age {
    type: sum
    sql: ${age} ;;  }

  measure: average_age {
    type: average
    sql: ${age} ;;  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }
  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    description: "Gender of the user"
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: location {
    description: "The location of the user"
    type: location
    sql_longitude: ${longitude} ;;
    sql_latitude: ${latitude} ;;
  }

  dimension: postal_code {
    type: string
    sql: ${TABLE}.postal_code ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: street_address {
    type: string
    sql: ${TABLE}.street_address ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
    drill_fields: [age_tier,gender]
  }

  dimension: age_tier {
    type: tier
    tiers: [15, 26, 36, 51, 66]
    style: integer
    sql: ${age} ;;
  }

  measure: count {
    type: count
    drill_fields: [id, last_name, first_name]
  }

  measure: count_new_users_yesterday {
    description: "New users that were added yesterday"
    type: count
    filters: [created_date: "yesterday"]
  }

  dimension: last_month_end_date {
    type: date_raw
    sql: date_add(CURRENT_DATE(),INTERVAL -1 MONTH) ;;
  }
  dimension: extract_month_number{
    type: string
    sql: cast(extract(month FROM ${last_month_end_date}) as string);;
  }
  dimension: extract_year_number{
    type: string
    sql: cast(extract(year FROM ${last_month_end_date}) as string) ;;
  }
  dimension: last_month_start_date {
    type: date_raw
    sql: date(concat(${extract_year_number},'-',${extract_month_number},'-1')) ;;
  }
  dimension: in_last_month {
    type: yesno
    sql: ${created_date} >= ${last_month_start_date} and ${created_date} <= ${last_month_end_date} ;;
  }
  dimension: in_this_month {
    type: yesno
    sql: extract(month from ${created_date}) = extract(month from current_date) and extract(year from ${created_date}) = extract(year from current_date);;
  }
  measure: new_users_last_month {
    description: "New users last month to date"
    type: count_distinct
    sql: ${id} ;;
    filters: [in_last_month: "yes"]
  }
  measure: new_users_this_month {
    description: "New users this month to date"
    type: count_distinct
    sql: ${id};;
    filters: [created_date: "this month"]
  }

  dimension: days_since_user_sign_up {
    type: duration_day
    sql_start: ${created_raw} ;;
    sql_end: CURRENT_TIMESTAMP ;;
  }

  dimension: months_since_user_signed_up {
    type: duration_month
    sql_start: ${created_raw} ;;
    sql_end: CURRENT_TIMESTAMP ;;
  }

  dimension: is_prior_month {
    type: yesno
    sql: ${created_date} BETWEEN
      DATE_SUB(DATE_TRUNC( CURRENT_DATE(), month), INTERVAL 1 MONTH) AND LAST_DAY(DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH), Month);;
}

  dimension: is_prior_year {
    type: yesno
    sql: ${created_date} BETWEEN
      DATE_SUB(DATE_TRUNC( CURRENT_DATE(), year), INTERVAL 1 YEAR) AND LAST_DAY(DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR), YEAR);;
  }




}
