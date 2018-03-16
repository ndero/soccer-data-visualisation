# functions for obtaining different summaries for teams in given leagues

# summary of home games and away games for all the teams in a league
# gives an overall glimpse of the teams' long term performance in terms of
# games played both at home and away and their respective outcomes.
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
# the venue can either be:
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


# printing the league table for any league and season
soccer_table <- function(df=epl, season = "17/18"){
 # function for calculating the scores in terms of points
 #        win  - 3 points
 #        lose - 0 points
 #        draw - 1 point
 scores <- function(j, df) {
  u <-  df[with(df, HomeTeam == j | AwayTeam == j), ]
  point <- with(u,
                ifelse(HomeTeam==j,
                ifelse(FTR == "H", 3,
                ifelse(FTR == "A", 0 , 1)),
                ifelse(FTR == "H", 0,
                ifelse(FTR == "A", 3, 1))))
  won <- sum(point==3)
  draw <- sum(point==1)
  lost <- sum(point==0)
  played <- length(point)
  points <- sum(point)
  GD <- sum(with(u, ifelse(HomeTeam == j, (FTHG - FTAG), (FTAG - FTHG))))
  GF <- sum(with(u, ifelse(HomeTeam == j, FTHG, FTAG)))
  GA <- sum(with(u, ifelse(HomeTeam == j, FTAG, FTHG)))
  played <- nrow(u)
  c(played = played, won = won, draw = draw, lost = lost, GF = GF, GA = GA, GD = GD, points = points)
 }

  df <- na.omit(df) # get rid of missing values
  df <- df[with(df, season) == season, ]
  df$HomeTeam <- as.character(df$HomeTeam)
  df$AwayTeam <- as.character(df$AwayTeam)
  teams <- unique(with(df, c(HomeTeam, AwayTeam)))
  mat <- data.frame(t(sapply(teams, scores, df)))
  mat <- mat[with(mat, rev(order(points, GD))),  ]
  return(mat)
}

# head to head statistics about a team; usually with reference to another one
soccer_analyze <- function(home.team = "Chelsea", away.team = "Man United", df=epl, n=30) {

  # a function to calculate summary statistics, in terms of games drawn, lost or won
  summary_stat <- function(df) {
    played <- nrow(df)
    won <-  sum(with(df, FTR == "won"))
    draw <- sum(with(df, FTR == "draw"))
    lost <- sum(with(df, FTR == "lost"))
    prop.won <-  round(won/played, 4)
    prop.draw <- round(draw/played, 4)
    prop.lost <- round(lost/played, 4)
    stats <- c(played, won, draw, lost, prop.won, prop.draw, prop.lost)
    return(stats)
  }

  # hometeam home games summary
  home.games <- soccer_score(home.team, away.team, venue = "home", n, df)
  rownames(home.games) <- NULL
  goal.diff <- sum(with(home.games, FTHG - FTAG))
  a <- c(summary_stat(home.games), goal.diff)

  # hometeam away games summary
  away.games <- soccer_score(home.team, away.team, venue = "away", n, df)
  rownames(away.games) <- NULL
  goal.diff <- sum(with(away.games, FTAG - FTHG))
  b <- c(summary_stat(away.games), goal.diff)

  # hometeam home and away games summary
  home.away.games <- soccer_score(home.team, away.team, venue = "home and away", n, df)
  rownames(home.away.games) <- NULL
  goal.diff <- sum(with(home.away.games,
                        ifelse(HomeTeam==home.team, FTHG - FTAG, FTAG - FTHG)))
  c <- c(summary_stat(home.away.games), goal.diff)

  # hometeam all home games summary
  home.team.all.home.games <- soccer_score(home.team, away.team, venue = "all home", n, df)
  rownames(home.team.all.home.games) <- NULL
  goal.diff <- sum(with(home.team.all.home.games, FTHG - FTAG))
  d <- c(summary_stat(home.team.all.home.games), goal.diff)

  # awayteam all home games summary
  away.team.all.home.games <- soccer_score(away.team, home.team, venue = "all home", n, df)
  rownames(away.team.all.home.games) <- NULL
  goal.diff <- sum(with(away.team.all.home.games, FTHG - FTAG))
  e <- c(summary_stat(away.team.all.home.games), goal.diff)

  # hometeam all away games summary
  home.team.all.away.games <- soccer_score(home.team, away.team, venue = "all away", n, df)
  rownames(home.team.all.away.games) <- NULL
  goal.diff <- sum(with(home.team.all.away.games, FTAG - FTHG))
  f <- c(summary_stat(home.team.all.away.games), goal.diff)

  # awayteam all way games summary
  away.team.all.away.games <- soccer_score(away.team, home.team, venue = "all away", n, df)
  rownames(away.team.all.away.games) <- NULL
  goal.diff <- sum(with(away.team.all.away.games, FTAG - FTHG))
  g <- c(summary_stat(away.team.all.away.games), goal.diff)

  # hometeam all games summary
  home.team.all.games  <- soccer_score(home.team, away.team, venue = "all", n, df)
  rownames(home.team.all.games) <- NULL
  goal.diff <- sum(with(home.team.all.games, ifelse(HomeTeam==home.team, FTHG - FTAG, FTAG - FTHG)))
  h <- c(summary_stat(home.team.all.games), goal.diff)

  # awayteam all games summary
  away.team.all.games  <- soccer_score(away.team, home.team, venue = "all", n, df)
  rownames(away.team.all.games) <- NULL
  goal.diff <- sum(with(away.team.all.games, ifelse(HomeTeam==away.team, FTHG - FTAG, FTAG - FTHG)))
  i <- c(summary_stat(away.team.all.games), goal.diff)

  # putting everything together
  s <- as.character(tail(df[, "season"], 1))  # needed for the league table
  st <- data.frame(rbind(a, b, c, d, e, f, g, h, i))
  rownames(st) <- c(paste("Home against", away.team), paste("Away against", away.team),
                    paste("Home and Away against", away.team), paste(home.team, "home games"),
                    paste(away.team, "home games"), paste(home.team, "away games"),
                    paste(away.team, "away games"), paste(home.team, "home and away games"),
                    paste(away.team, "home and away games"))
  colnames(st) <- c("played", "won", "draw", "lost", "prop.won", "prop.draw", "prop.lost", "goal.diff")
  k <- list(st, head(home.away.games, 15), head(home.team.all.games ,10),
                head(away.team.all.games, 10), soccer_table(df, season = s))
  names(k) <- c(paste(home.team, "vs", away.team, "most recent", n, "games summary"), "Head to head",
                paste(home.team, "recent home and away games"),
                paste(away.team, "recent home and away games"),
                paste(" season", s, "league table"))
  return(k)
}

# plots a pie chart representing the proportion of games won, drawn or
# lost by the home team and away team both away and at home.
soccer_pie <- function(home.team, away.team, venue, n, df){
 d <- soccer_score(home.team, away.team, venue = "home and away", n, df)
 score <- d %>% group_by(FTR) %>%  summarize(count = n())
 plot_ly(score, labels = ~FTR, values = ~count,
        type = 'pie', textposition = 'inside',
        textinfo = 'label+percent') %>%
        layout(title = paste(home.team, ' against ', away.team, sep = ""))
}

# produces bar graph displaying match statistics for both home team
# and away team
soccer_bar <- function(home.team, away.team, df, n) {
  df <- soccer_analyze(home.team, away.team, df, n)[[1]]
  home <- df[8, c('won', 'draw', 'lost', 'goal.diff')]
  away <- df[9, c('won', 'draw', 'lost', 'goal.diff')]
  d <- rbind(home, away)
  d$names <- c(home.team, away.team)

plot_ly(d, x = ~ names, y = ~ draw, type = 'bar', name = 'draw',
       hoverinfo = 'name+y') %>%
  add_trace(y = ~ lost, name = 'lost') %>%
  add_trace(y = ~ won, name = 'won') %>%
  layout(yaxis = list(title = "Match Outcome"),
         xaxis = list(title = ""),
         title = paste("Recent", n, "games summary"))
}

# helper function for automatically installing required packages
# if not already installed
install_requirements <- function(packages=c("shiny", "plotly", "shiny")) {
  uninstalled_packages <- packages[!packages %in% installed.packages()[, "Package"]]
  if(length(uninstalled_packages)) install.packages(pkgs = uninstalled_packages, dependencies = TRUE)
}
