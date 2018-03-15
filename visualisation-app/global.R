# loads the functions in soccer_exploration and soccer_visualization
# and starts the browser for interactive visualization
# required libraries
#     1. Rshiny - allows visualizing data interactively on the browser

# load the required libraries
library(shiny)

# set display width of the terminal to capture all the output in one screen
options(width=120)

# load required functions
source("soccer_exploration.R")

# loading the soccer datasets into R
# assumes the files are stored in the current working directory
epl_full <- read.csv("data/epl_full.csv")
eng_champ <- read.csv("data/eng_champ.csv")
eng_league_one <- read.csv("data/eng_league_one.csv")
eng_league_two <- read.csv("data/eng_league_two.csv")
eng_conference <- read.csv("data/eng_conference.csv")
scot_prem <- read.csv("data/scot_prem.csv")
bundes_one <- read.csv("data/bundes_one.csv")
bundes_two <- read.csv("data/bundes_two.csv")
serie_a <- read.csv("data/serie_a.csv")
serie_b <- read.csv("data/serie_b.csv")
laliga_prem <- read.csv("data/laliga_prem.csv")
laliga_segunda <- read.csv("data/laliga_segunda.csv")
france_prem <- read.csv("data/france_prem.csv")
france_div2 <- read.csv("data/france_div2.csv")
netherlands_eredivisie <- read.csv("data/netherlands_eredivisie.csv")
belgium_jupiler <- read.csv("data/belgium_jupiler.csv")
portugal_liga <- read.csv("data/portugal_liga.csv")
turkey_ligi <- read.csv("data/turkey_ligi.csv")
greece_ethniki <- read.csv("data/greece_ethniki.csv")

# run the app and automatically start it in the default browser
runApp('app.R', launch.browser =T)

