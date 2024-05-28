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

  measure: count {
    type: count
    drill_fields: [id, last_name, first_name]
  }

  #####################.           AUTO GENERATED BUSINESS LOGIC ABOVE ^^.    #############



  dimension: age_tier {
    type: tier
    tiers: [15, 26, 36, 51, 66]
    style: integer
    sql: ${age} ;;
  }

  measure: total_age {
    type: sum
    sql: ${age} ;;  }

  measure: average_age {
    type: average
    sql: ${age} ;;  }

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

  # dimension: is_prior_year {
  #   type: yesno
  #   sql: ${created_date} BETWEEN
  #     DATE_SUB(DATE_TRUNC( CURRENT_DATE(), year), INTERVAL 1 YEAR) AND LAST_DAY(DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR), YEAR);;
  # }

  parameter: months_ago_category {
    type: unquoted
    default_value: " "
    allowed_value: {
      label: "One Month Ago"
      value: "onemonth"
    }
    allowed_value: {
      label: "Two Months Ago"
      value: "twomonth"
    }
    allowed_value: {
      label: "Three Months Ago"
      value: "threemonth"
    }
    allowed_value: {
      label: "Four Months Ago "
      value: "fourmonth"
    }
    allowed_value: {
      label: "Five Months Ago "
      value: "fivemonth"
    }
    allowed_value: {
      label: "Six Months Ago "
      value: "sixmonth"
    }
    allowed_value: {
      label: "Seven Months Ago "
      value: "sevenmonth"
    }
    allowed_value: {
      label: "Eight Months Ago "
      value: "eightmonth"
    }
    allowed_value: {
      label: "Nine Months Ago "
      value: "ninemonth"
    }
    allowed_value: {
      label: "Ten Months Ago "
      value: "tenmonth"
    }
    allowed_value: {
      label: "Eleven Months Ago "
      value: "elevenmonth"
    }
  }


  dimension: dynamic_months_ago_category {
    type: string
    sql:

          {% if months_ago_category._parameter_value == "onemonth" %}
                  ${created_date} BETWEEN
      DATE_SUB(DATE_TRUNC( CURRENT_DATE(), month), INTERVAL 1 MONTH) AND LAST_DAY(DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH), Month)
          {% elsif months_ago_category._parameter_value == 'twomonth' %}
                  ${created_date} BETWEEN
      DATE_SUB(DATE_TRUNC( CURRENT_DATE(), month), INTERVAL 2 MONTH) AND LAST_DAY(DATE_SUB(CURRENT_DATE(), INTERVAL 2 MONTH), Month)
          {% elsif months_ago_category._parameter_value == 'threemonth' %}
                  ${created_date} BETWEEN
      DATE_SUB(DATE_TRUNC( CURRENT_DATE(), month), INTERVAL 3 MONTH) AND LAST_DAY(DATE_SUB(CURRENT_DATE(), INTERVAL 3 MONTH), Month)
          {% elsif months_ago_category._parameter_value == 'fourmonth' %}
                  ${created_date} BETWEEN
      DATE_SUB(DATE_TRUNC( CURRENT_DATE(), month), INTERVAL 4 MONTH) AND LAST_DAY(DATE_SUB(CURRENT_DATE(), INTERVAL 4 MONTH), Month)
          {% elsif months_ago_category._parameter_value == 'fivemonth' %}
                  ${created_date} BETWEEN
      DATE_SUB(DATE_TRUNC( CURRENT_DATE(), month), INTERVAL 5 MONTH) AND LAST_DAY(DATE_SUB(CURRENT_DATE(), INTERVAL 5 MONTH), Month)
          {% elsif months_ago_category._parameter_value == 'sixmonth' %}
                  ${created_date} BETWEEN
      DATE_SUB(DATE_TRUNC( CURRENT_DATE(), month), INTERVAL 6 MONTH) AND LAST_DAY(DATE_SUB(CURRENT_DATE(), INTERVAL 6 MONTH), Month)
          {% elsif months_ago_category._parameter_value == 'sevenmonth' %}
                  ${created_date} BETWEEN
      DATE_SUB(DATE_TRUNC( CURRENT_DATE(), month), INTERVAL 7 MONTH) AND LAST_DAY(DATE_SUB(CURRENT_DATE(), INTERVAL 7 MONTH), Month)
          {% elsif months_ago_category._parameter_value == 'eightmonth' %}
                  ${created_date} BETWEEN
      DATE_SUB(DATE_TRUNC( CURRENT_DATE(), month), INTERVAL 8 MONTH) AND LAST_DAY(DATE_SUB(CURRENT_DATE(), INTERVAL 8 MONTH), Month)
          {% elsif months_ago_category._parameter_value == 'ninemonth' %}
                  ${created_date} BETWEEN
      DATE_SUB(DATE_TRUNC( CURRENT_DATE(), month), INTERVAL 9 MONTH) AND LAST_DAY(DATE_SUB(CURRENT_DATE(), INTERVAL 9 MONTH), Month)
          {% elsif months_ago_category._parameter_value == 'tenmonth' %}
                  ${created_date} BETWEEN
      DATE_SUB(DATE_TRUNC( CURRENT_DATE(), month), INTERVAL 10 MONTH) AND LAST_DAY(DATE_SUB(CURRENT_DATE(), INTERVAL 10 MONTH), Month)
          {% else %}
                  ${created_date} BETWEEN
      DATE_SUB(DATE_TRUNC( CURRENT_DATE(), month), INTERVAL 11 MONTH) AND LAST_DAY(DATE_SUB(CURRENT_DATE(), INTERVAL 11 MONTH), Month)
          {% endif %}
    ;;
  }

  parameter: date_granularity {
    type: unquoted
    allowed_value: {
      label: "Day"
      value: "day"
    }
    allowed_value: {
      label: "Month"
      value: "month"
    }
    allowed_value: {
      label: "Year"
      value: "year"
    }
  }


  dimension: dynamic_date {
    type: string
    label_from_parameter: date_granularity
    sql:

          {% if date_granularity._parameter_value == 'day' %}
                  ${created_date}
          {% elsif date_granularity._parameter_value == 'month' %}
                   ${created_month}
          {% elsif date_granularity._parameter_value == 'year' %}
                   ${created_year}
          {% else %}
                   ${created_date}
          {% endif %}
    ;;
  }

  dimension: dynamic_days_since_sign_up{
    type: number
    label_from_parameter: date_granularity
    sql:

          {% if date_granularity._parameter_value == 'day' %}
                   ${since_signup_days}
          {% elsif date_granularity._parameter_value == 'month' %}
                  ${since_signup_months}
          {% elsif date_granularity._parameter_value == 'year' %}
                  ${since_signup_years}
          {% else %}
                 ${since_signup_days}
          {% endif %}
    ;;
  }

  dimension: since_signup_days {
    type: number
    sql: date_diff(date(current_timestamp()),date(${created_date}), day);;
  }

  dimension: since_signup_months {
    type: number
    sql: date_diff(date(current_timestamp()),date(${created_date}), month);;
  }

  dimension: since_signup_years {
    type: number
    sql: date_diff(date(current_timestamp()),date(${created_date}), year);;
  }

  measure: count_distict_user_id {
    type: count_distinct
    sql: ${id} ;;
  }

###   {% elsif customer_category._parameter_value == 'country' %} ${users.country}
  # dimension: prior_month {
  #   type: date
  #   sql: ${created_date} BETWEEN
  #     DATE_SUB(DATE_TRUNC( CURRENT_DATE(), month), INTERVAL 1 MONTH) AND LAST_DAY(DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH), Month) ;;
  # }

  # dimension: prior_year {
  #   type: date
  #   sql: ${created_date} BETWEEN
  #     DATE_SUB(DATE_TRUNC( CURRENT_DATE(), year), INTERVAL 1 YEAR) AND LAST_DAY(DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR), YEAR) ;;
  # }




}
