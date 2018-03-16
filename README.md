### Soccer data visualisation using R
<details><summary> An R app for visualising, interactively, soccer data across various leagues.
</summary>
 <h4>Features</h4>
<ul>
  <li>Bar graph showing team's performance over time.</li>
  <li>Pie chart visualizing head to head statistics between any two teams.</li>
  <li>Detailed summary table of each team's performance both at home and away.</li>
  <li>Most recent 15 games between the current two teams being compared.</li>
  <li>Most recent 8 games for each of the two teams being compared.</li>
  <li>Current league table standings.</li>
</ul>
</details>

< coming soon >

#### Requirements
You should have [R](https://www.r-project.org/), preferably version 3.4.4, installed on your machine and the following R packages:
- [tidyr](http://dplyr.tidyverse.org/)
- [plotly](https://plot.ly/)
- [Rshiny](https://shiny.rstudio.com/)

#### How to run the app on your machine
 After installing R start the terminal if on mac/linux or the command line if using windows, get this app running locally on your machine with these 3 easy steps:
1. If you've git installed on your machine, clone this repo.*Alternatively, if you don't have git installed just download the code and extract the files.*
  ```
    git clone https://github.com/ndero/soccer-data-visualisation-with-R.git
  ```
2. Start the terminal, or command line if on windows, and navigate to where the file `global.R` is located and start R from there. *Alternatively you can right click on `global.R` and choose open with R.*
  ```
    R   # to start R from the terminal or command line
  ```
3. Finally, to start and automatically launch the app on your browser, run the following two commands inside the R console.
  ```
    library(shiny)
    runApp()
  ```

#### Live demo
<p>Want to try out this app online? If yes, check it out [here](https://ndero.shinyapps.io/visualisation-app/).</p>

