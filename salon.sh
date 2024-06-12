#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
MAIN_SERVICE(){
  if [[ $1 ]]
  then
    echo -e $1
   fi
  GET_SERVICE=$($PSQL "SELECT * FROM services")
echo "$GET_SERVICE" | while read SERVICE_ID BAR SERVICE
do 
echo "$SERVICE_ID) $SERVICE" 
done

echo -e "\n Pick up a service"
read SERVICE_ID_SELECTED
if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$  ]]
then 
MAIN_SERVICE "\n Please Pick up a number"
else
#check number
CHECK_NUMBER=$($PSQL "SELECT service_id from services where service_id=$SERVICE_ID_SELECTED")
  if [[ -z $CHECK_NUMBER ]]
    then
    MAIN_SERVICE "\n Please Pick up a number in list"
     else 
  # enter phone
  SERVICE_NAME=$($PSQL "SELECT name from services where service_id=$SERVICE_ID_SELECTED")
      echo -e "\n Enter your phone"
      read CUSTOMER_PHONE
  # get name
      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
      if [[ -z $CUSTOMER_NAME ]]
      then
      # get name
        echo -e "\n Enter your name"
        read  CUSTOMER_NAME
      # insert
        INSERT_CUSTOMER=$($PSQL "INSERT INTO customers (phone,name) values ('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
      
      fi
      #get the customer
      CUSTOMER_ID=$($PSQL "SELECT customer_id from customers where phone='$CUSTOMER_PHONE'")
   
      echo -e "\n Enter your time"
      read SERVICE_TIME
      INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments (customer_id,service_id,time) values ($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
      echo -e "\nI have put you down for a $(echo $SERVICE_NAME| sed -r 's/^ *| *$//g') at $SERVICE_TIME, $(echo $CUSTOMER_NAME| sed -r 's/^ *| *$//g' )."

  fi

#read phone
#check phone 

fi 

}
MAIN_SERVICE