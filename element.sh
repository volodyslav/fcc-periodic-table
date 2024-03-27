#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]]
then 
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    SYMBOL=$($PSQL "select symbol from elements where atomic_number=$1")
    NAME=$($PSQL "select name from elements where atomic_number=$1")
    TYPE=$($PSQL "select types.type from types full join properties using(type_id) where atomic_number=$1")
    ATOMIC_MASS=$($PSQL "select atomic_mass from properties where atomic_number=$1")
    MELTING_POINT=$($PSQL "select melting_point_celsius from properties where atomic_number=$1")
    BOILING_POINT=$($PSQL "select boiling_point_celsius from properties where atomic_number=$1")
    if [[ -z $SYMBOL ]]
    then
      echo "I could not find that element in the database."
    else
      echo "The element with atomic number $1 is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    fi
  elif [[ $1 =~ ^[A-Za-z]{3,}$ ]] 
  then
    SYMBOL=$($PSQL "select symbol from elements where name='$1'")
    ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where name='$1'")
    TYPE=$($PSQL "select types.type from types full join properties using(type_id) full join elements using(atomic_number)  where elements.name='$1'")
    MELTING_POINT=$($PSQL "select properties.melting_point_celsius from properties full join elements ON properties.atomic_number = elements.atomic_number  where elements.name='$1'")
    BOILING_POINT=$($PSQL "select properties.boiling_point_celsius from properties full join elements ON properties.atomic_number = elements.atomic_number  where elements.name='$1'")
    ATOMIC_MASS=$($PSQL "select properties.atomic_mass from properties full join elements ON properties.atomic_number = elements.atomic_number  where elements.name='$1'")
    if [[ -z $SYMBOL ]]
    then
      echo "I could not find that element in the database."
    else
      echo "The element with atomic number $ATOMIC_NUMBER is $1 ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $1 has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    fi 
  elif [[ $1 =~ ^[A-Za-z]{1,3}$ ]] 
  then
    NAME=$($PSQL "select name from elements where symbol='$1'")
    ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where symbol='$1'")
    TYPE=$($PSQL "select types.type from types full join properties using(type_id) full join elements using(atomic_number) where elements.symbol='$1'")
    MELTING_POINT=$($PSQL "select properties.melting_point_celsius from properties full join elements ON properties.atomic_number = elements.atomic_number  where elements.symbol='$1'")
    BOILING_POINT=$($PSQL "select properties.boiling_point_celsius from properties full join elements ON properties.atomic_number = elements.atomic_number  where elements.symbol='$1'")
    ATOMIC_MASS=$($PSQL "select properties.atomic_mass from properties full join elements ON properties.atomic_number = elements.atomic_number  where elements.symbol='$1'")
    if [[ -z $NAME ]]
    then
      echo "I could not find that element in the database."
    else
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($1). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    fi
  fi
fi
