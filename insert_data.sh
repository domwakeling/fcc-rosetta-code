#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# empty tables
echo "$($PSQL "TRUNCATE TABLE games, teams")"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT W_GOAL O_GOAL
do
  if [[ $YEAR != 'year' ]]
  then
    # get winner id if in teams
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # if not
    if [[ -z $WINNER_ID ]]
    then
      # add team
      WINNER_ID_INSERT=$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER')")
      if [[ $WINNER_ID_INSERT == 'INSERT 0 1' ]]
      then
        echo Inserted team into teams: $WINNER
      fi
      # get team id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi

    # get opponent id if in teams
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # if not
    if [[ -z $OPPONENT_ID ]]
    then
      # add team
      OPPONENT_ID_INSERT=$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')")
      if [[ $OPPONENT_ID_INSERT == 'INSERT 0 1' ]]
      then
        echo Inserted team into teams: $OPPONENT
      fi
      # get team id
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi

    # add game to games
    GAME_INSERTED=$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $W_GOAL, $O_GOAL ) ")
    if [[ $GAME_INSERTED == 'INSERT 0 1' ]]
    then
      echo Inserted game into games: $YEAR, $ROUND, $WINNER, $OPPONENT, $W_GOAL, $O_GOAL
    fi

  fi
done