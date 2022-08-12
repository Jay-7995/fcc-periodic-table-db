#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT=$($PSQL "select * from elements where atomic_number=$1")
  else
    ELEMENT=$($PSQL "select * from elements where name='$1' or symbol='$1'")
  fi
  if [[ -z $ELEMENT ]]
  then
    echo I could not find that element in the database.
  else
    ELEMENT_RESULT= echo $ELEMENT | while read ATN BAR SYMBOL BAR NAME
    do
      PROPERTIES=$($PSQL "select atomic_mass, melting_point_celsius, boiling_point_celsius, type from properties inner join types using(type_id) where atomic_number=$ATN")
      PROPERTIES_RESULT= echo $PROPERTIES | while read AM BAR MPC BAR BPC BAR TYPE
      do
        echo "The element with atomic number $ATN is $NAME ($SYMBOL). It's a $TYPE, with a mass of $AM amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
      done
    done
  fi
fi
