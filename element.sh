#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ $1 ]]
then
  # see whether the element exists
  # first see whether we have a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT_SEARCH_RESULT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1 ")
  else
    ELEMENT_SEARCH_RESULT=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1' OR name = '$1' ")
  fi
  if [[ -z $ELEMENT_SEARCH_RESULT ]]
  then
    # not found, message
    echo "I could not find that element in the database."
  else
    A_NUMBER="$(echo $ELEMENT_SEARCH_RESULT | sed 's/ //g')"
    # found
    ELEMENT_RESULT=$($PSQL "SELECT name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements LEFT JOIN  properties USING (atomic_number) LEFT JOIN types USING (type_id) WHERE atomic_number = $A_NUMBER")
    echo $ELEMENT_RESULT | while read NAME BAR SYMBOL BAR TYPE BAR MASS BAR MELT BAR BOIL
    do
      echo "The element with atomic number $A_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    done
  fi
else
  echo "Please provide an element as an argument."
fi