#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ Salon Appointment Scheduler ~~~~~\n"
echo -e "How may I help you?\n"


MAIN_MENU() {
 
  SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id;")

  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done


  read SERVICE_ID_SELECTED
  SERVICE_ID_SELECTED_DB=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED;")

  if [[ -z $SERVICE_ID_SELECTED_DB ]]
  then
    MAIN_MENU "Please enter a valid service number."
  else
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    CUSTOMER_ID_DB=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")

    if [[ -z $CUSTOMER_ID_DB ]]
    then

      echo -e "\nWhat's your name?"
      read CUSTOMER_NAME

      CUSTOMER_PHONE_NAME_IN_DB=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE');")
      CUSTOMER_ID_DB=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")

    
    fi
    echo -e "\nWhat time would you like?"
    read SERVICE_TIME

    CUSTOMER_ID_SERVICE_ID_TIME_IN_DB=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID_DB, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")
    
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;")

    CUSTOMER_NAME_DB=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE';")

    echo "I have put you down for a$SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME_DB."
  
  fi

}

MAIN_MENU
