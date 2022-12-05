#!/bin/bash

# use --tuples-only to not get the header rows or summary row
# use -X "because" (running, or not running a setup script? not sure it makes any difference)
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

# function to list all services in the services table
LIST_SERVICES() {
  ALL_SERVICES=$($PSQL "SELECT service_id, name FROM services")
  echo "$ALL_SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
}

# main function loop
MAIN_MENU() {
  # if a message was passed as parameter, display it
  if [[ $1 ]]
  then
    echo -e "\n$1\n"
  fi

  # display a list of services
  LIST_SERVICES

  # get a choice
  read SERVICE_ID_SELECTED

  # check that it's valid - (a) is it a number?
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
    MAIN_MENU "Please select from the available options."
  
  # we have a sevice_id and it's a number, is it valid?
  else
    SERVICE_ID_FOUND=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    if [[ -z $SERVICE_ID_FOUND ]]
    # service ID not found => not a valid choice
    then
      MAIN_MENU "Please select from the available options."

    # we have a valid service ID so get customer
    else
      echo -e "\nWhat is your phone number?"
      read CUSTOMER_PHONE

      # look up the number to see if we know it
      CUSTOMER_ID_FOUND=$($PSQL "SELECT customer_id FROM customers WHERE phone ='$CUSTOMER_PHONE'")

      # is it a number we know?
      if [[ -z $CUSTOMER_ID_FOUND ]]
      then
        # ask for their name
        echo -e "\nI don't recognise that number. What is your name?"
        read CUSTOMER_NAME
        # store it
        NEW_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers (phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
        # retrieve the id
        CUSTOMER_ID_FOUND=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
      fi

      # we have a customer and a service, need a time
      echo -e "\nWhat time would you like?"
      read SERVICE_TIME

      NEW_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID_FOUND, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
      if [[ $NEW_APPOINTMENT_RESULT == 'INSERT 0 1' ]]
      then
        # success, print a message
        SELECTED_SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
        CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id = $CUSTOMER_ID_FOUND")
        echo -e "\nI have put you down for a$SELECTED_SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME."
      else
        echo -e "\nI'm sorry, there seems to have been a problem."
      fi

    fi
  fi
}

# print welcome and kick into main function loop
echo -e "\n~~~~~ WELCOME TO THE SALON ~~~~~\n"
MAIN_MENU "Welcome the The Salon, how may I help you today?"