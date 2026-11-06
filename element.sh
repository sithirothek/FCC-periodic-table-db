
#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if an argument was provided
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

# Search for the element by atomic number, symbol, or name
RESULT=$($PSQL "
  SELECT
    'The element with atomic number ' || e.atomic_number ||
    ' is ' || e.name || ' (' || e.symbol || '). It''s a ' ||
    t.type || ', with a mass of ' || p.atomic_mass ||
    ' amu. ' || e.name ||
    ' has a melting point of ' || p.melting_point_celsius ||
    ' celsius and a boiling point of ' || p.boiling_point_celsius ||
    ' celsius.'
  FROM elements e
  INNER JOIN properties p USING(atomic_number)
  INNER JOIN types t USING(type_id)
  WHERE
    e.atomic_number::VARCHAR = '$1'
    OR LOWER(e.symbol) = LOWER('$1')
    OR LOWER(e.name) = LOWER('$1');
")

# Display the result
if [[ -z $RESULT ]]
then
  echo "I could not find that element in the database."
else
  echo "$RESULT"
fi

