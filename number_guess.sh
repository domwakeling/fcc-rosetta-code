#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess --tuples-only --no-align -c"

# set the target number
TARGET_NUM=$(( RANDOM % 999 + 1 ))

# get the users name
echo "Enter your username:"
read USERNAME

# check if they're in the database
USER_ID_FOUND=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME'")
if [[ $USER_ID_FOUND ]]
then
  # user found
  GAMES_FOUND=$($PSQL "SELECT COUNT(*), MIN(guesses) FROM games WHERE user_id = $USER_ID_FOUND")
  echo "$GAMES_FOUND" | while IFS="|" read COUNT BEST
  do
    echo "Welcome back, $USERNAME! You have played $COUNT games, and your best game took $BEST guesses."
  done
else
  # user not found
  USER_INSERT_RESULT=$($PSQL "INSERT INTO users (username) VALUES ('$USERNAME')")
  USER_ID_FOUND=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME'")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
fi

echo "Guess the secret number between 1 and 1000:"

FOUND=0
GUESSES=0
while [[ $FOUND == 0 ]]
do
  read GUESS
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  else
    GUESSES=$(( GUESSES + 1 ))
    if [[ $GUESS -gt $TARGET_NUM ]] # using -gt and -lt appears to ensure they are cast as ints?
    then
      echo "It's lower than that, guess again:"
    elif [[ $GUESS -lt $TARGET_NUM ]]
    then
      echo "It's higher than that, guess again:"
    else
      FOUND=1
    fi
  fi
done

GAME_INSERT_RESULT=$($PSQL "INSERT INTO games (user_id, guesses) VALUES($USER_ID_FOUND, $GUESSES)")
echo "You guessed it in $GUESSES tries. The secret number was $TARGET_NUM. Nice job!"
