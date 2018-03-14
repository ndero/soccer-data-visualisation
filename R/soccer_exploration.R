# summary of home games and away games for each team
soccer_summary <- function(df=epl){
  df <- droplevels(na.omit(df)) # drop the "" level in FTR when there are NA's
  home_games <- with(df, tapply(FTR, list(HomeTeam, FTR), length))
  away_games <- with(df, tapply(FTR, list(AwayTeam, FTR), length))
  df <- as.data.frame(cbind(home_games, away_games))
  colnames(df) <- c("homeLoses", "homeDraws","homeWins", "awayWins",
                     "awayDraws", "awayLoses")
  df <- df[rev(order(df$homeWins, df$awayWins)), ]
  return(df)
}

# for any head to head, home games or away games summary
# the venue can either be
#        1. home - hometeam's n home games against awayteam
#        2. away - hometeam's n away games against awayteam
#        3. home and away - hometeam's n home and away games
#        4. all home - hometeam's n home games against all other teams
#        5. all away - hometeam's n haway games against all other teams
#        6. all - hometeam's n all games, whether away or home
soccer_score <- function(home.team="Chelsea", away.team="Tottenham",
                        venue="home", n=10, df=epl) {
  # helper function for determining the full time score
  soccer_ftr <- function(df) {
    ftr <- with(df,
                    ifelse((HomeTeam==home.team & FTR=="H") | (HomeTeam!=home.team & FTR=="A"), "won",
                    ifelse((HomeTeam==home.team & FTR=="A") | (HomeTeam!=home.team & FTR=="H"), "lost",
                    "draw")))
      return(ftr)
  }

   t <- na.omit(df)  # excludes the rows with NA values
   if (venue=="home" ) {
     # home against the away team
    df <- tail(t[t$HomeTeam==home.team
                    &t$AwayTeam==away.team, ], n)
  } else if (venue == "away") {
    # away against the away team
    df <- tail(t[t$HomeTeam==away.team &
                      t$AwayTeam==home.team, ], n)
  } else if (venue == "home and away") {
    # home and away against the away team
    df <- tail(t[(t$HomeTeam==home.team & t$AwayTeam==away.team) |(t$HomeTeam==away.team &
                                                    t$AwayTeam==home.team), ], n)
  } else if (venue == "all home") {
    # home team all games at home
    df <- tail(t[t$HomeTeam==home.team, ], n)
  } else if(venue == "all away") {
    # home team's all away games
    df <- tail(t[t$AwayTeam==home.team, ], n)
  } else if (venue == "all") {
    # hometeam's all away and home games
   df <- tail(t[t$HomeTeam==home.team | t$AwayTeam==home.team, ], n)
   }
   df$FTR <- soccer_ftr(df)
   df$Date <- as.Date(df$Date, format = "%d/%m/%y")
   df <- df[rev(order(df$Date)), ]
   df$Date <- format(df$Date, "%a, %d %b %Y")
   row.names(df) <- NULL
   return(df[, c("Date", "HomeTeam", "AwayTeam", "FTHG", "FTAG", "FTR", "season")])
}


