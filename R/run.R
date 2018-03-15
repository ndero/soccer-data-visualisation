# loads the functions in soccer_exploration and soccer_visualization
# and starts the browser for interactive visualization
# required libraries
#     1. Rshiny - allows visualizing data interactively on the browser

# load the required libraries
library(shiny)

# load required functions
source("soccer_exploration.R")

# set display width of the terminal to capture all the output in one screen
options(width=120)

# run the app and automatically start it in the default browser
runApp('soccer_visualisation.R', launch.browser =T)
