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

