#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  ELEMENT_INPUT=$1

  if [[ $ELEMENT_INPUT =~ ^[0-9]+$ ]]
  then
    ELEMENT_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$ELEMENT_INPUT")
    ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ELEMENT_INPUT")
    ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ELEMENT_INPUT")
    ELEMENT_TYPE=$($PSQL "SELECT type FROM elements WHERE atomic_number=$ELEMENT_INPUT")
    ELEMENT_ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ELEMENT_INPUT")
    ELEMENT_MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ELEMENT_INPUT")
    ELEMENT_BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ELEMENT_INPUT")

  elif [[ $ELEMENT_INPUT =~ ^[A-Z][a-z]?$ ]]
  then
    ELEMENT_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$ELEMENT_INPUT'")
    ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol='$ELEMENT_INPUT'")
    ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$ELEMENT_INPUT'")
    ELEMENT_TYPE=$($PSQL "SELECT type FROM elements WHERE atomic_number=(SELECT atomic_number FROM elements WHERE symbol='$ELEMENT_INPUT')")
    ELEMENT_ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties p JOIN elements e USING(atomic_number) WHERE e.symbol='$ELEMENT_INPUT'")
    ELEMENT_MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties p JOIN elements e USING(atomic_number) WHERE e.symbol='$ELEMENT_INPUT'")
    ELEMENT_BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties p JOIN elements e USING(atomic_number) WHERE e.symbol='$ELEMENT_INPUT'")

  elif [[ $ELEMENT_INPUT =~ ^[A-Za-z]+$ ]]
  then
    ELEMENT_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$ELEMENT_INPUT'")
    ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name='$ELEMENT_INPUT'")
    ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE name='$ELEMENT_INPUT'")
    ELEMENT_TYPE=$($PSQL "SELECT type FROM elements WHERE atomic_number=(SELECT atomic_number FROM elements WHERE name='$ELEMENT_INPUT')")
    ELEMENT_ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties p JOIN elements e USING(atomic_number) WHERE e.name='$ELEMENT_INPUT'")
    ELEMENT_MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties p JOIN elements e USING(atomic_number) WHERE e.name='$ELEMENT_INPUT'")
    ELEMENT_BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties p JOIN elements e USING(atomic_number) WHERE e.name='$ELEMENT_INPUT'")
  fi

  if [[ -z $ELEMENT_ATOMIC_NUMBER ]]
  then
    echo "I could not find that element in the database."
  else
    echo "The element with atomic number $ELEMENT_ATOMIC_NUMBER is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ELEMENT_ATOMIC_MASS amu. $ELEMENT_NAME has a melting point of $ELEMENT_MELTING_POINT celsius and a boiling point of $ELEMENT_BOILING_POINT celsius."
  fi
fi