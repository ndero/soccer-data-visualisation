# loads the functions in soccer_exploration and soccer_visualization
# and starts the browser for interactive visualization
# required libraries:
#       Rshiny - allows visualizing data interactively on the browser
#       dplyr - functions group_by and summarize used in grouping the data.
#               to prepare it for plotting, also has the pipe operator( %>% ).
#       plotly - function plot_ly, used to plot pie chart and bar graph.

# load required functions
source("soccer_exploration.R")

# automatically install required libraries if not installed
install_requirements(packages=c("dplyr", "plotly", "shiny"))

# load the required libraries
library(dplyr)
library(plotly)
library(shiny)

# load the soccer datasets into R - these are in the data folder
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
