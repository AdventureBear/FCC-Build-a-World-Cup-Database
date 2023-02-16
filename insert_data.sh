#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")

# ADD TEAMS TO TEAMS TABLE FIRST
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
  then
    # get WINNER ID
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    # IF NOT AVAILABLE, INSERT WINNER
    if [[ -z $WINNER_ID ]]
      then
        echo "$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER')")"
        echo "Winning team '$WINNER' added to"
    fi
  
    # GET OPPONENT ID
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # IF NOT AVAIALBLE, INSERT OPPONENT
    if [[ -z $OPPONENT_ID ]]
      then
        echo "$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')")"
        echo "Opponent team '$OPPONENT' added to database"
    fi
  fi

done

#Now add to games table with team_ids already having been made
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 

  echo $YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPONENT_GOALS
  # GET TEAM IDS FOR WINNER & OPPONENT
    # get WINNER ID
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    
    # GET OPPONENT ID
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  

    #INSERT ROW INTO GAMES
    echo "$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ('$YEAR', '$ROUND', '$WINNER_ID',  '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")"
    echo "'$YEAR', Round: '$ROUND'.  Score: '$WINNER' '$WINNER_GOALS' - '$OPPONENT' '$OPPONENT_GOALS added to database"


done
