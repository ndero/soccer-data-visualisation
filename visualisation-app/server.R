# Define server logic to summarize and view selected dataset
server <- function(input, output, session) {
 source("soccer_exploration.R", local=TRUE)
  # Returns the selected dataset
  datasetInput <- reactive({
    switch(input$league,
           "Epl" = epl_full,
           "Laliga" = laliga_prem,
           "Bundesliga" = bundes_one,
           "France League One" = france_prem,
           "Serie A" = serie_a,
           "Portugal Liga" = portugal_liga,
           "Scot Prem" = scot_prem,
           "Greece Ethniki" = greece_ethniki,
           "Bundes Two" = bundes_two,
           "Belgium Jupiler" = belgium_jupiler,
           "Turkey Ligi" = turkey_ligi,
           "Netherlands Eredivisie" = netherlands_eredivisie,
           "English Championship" = eng_champ,
           "Laliga Segunda" = laliga_segunda,
           "Bundes Two" = bundes_two,
           "Serie B" = serie_b,
           "English Conference" = eng_conference,
           "English League One" = eng_league_one,
           "English League Two" = eng_league_two
    )
  })

  # Generates a pie chart summary for the selected league and teams
  output$pie_chart <- renderPlotly({
    soccer_pie(home.team  = input$HomeTeam,
                away.team = input$AwayTeam,
                venue     =  "home and away",
                n         = input$games,
                df        = datasetInput())
  })

  # Generate a bar chart summary for the selected league and teams
  output$bar_chart <- renderPlotly({
    soccer_bar(home.team  = input$HomeTeam,
                away.team = input$AwayTeam,
                n         = input$games,
                df        = datasetInput())
  })

  # Generate summary statistics for the currently selected hometeam and awayteam
  output$head_to_head <- renderTable({
    soccer_score(home.team  = input$HomeTeam,
                  away.team = input$AwayTeam,
                  venue     = "home and away",
                  df        = datasetInput(),
                  n         = 15)
  })

  # Outputs the last six games played at home by the selected hometeam
  output$last_six_home <- renderTable({
    soccer_score(home.team  = input$HomeTeam,
                  away.team = input$AwayTeam,
                  venue     = "all",
                  df        = datasetInput(),
                  n         = 8)
  })

  # Outputs the last six away games played away by the selected hometeam
  output$last_six_away <- renderTable({
    soccer_score(home.team  = input$AwayTeam,
                  away.team = input$HomeTeam,
                  venue     = "all",
                  df        = datasetInput(),
                  n         = 8)
  })

  # Generate summary table for the selected league and teams
  output$soccer_summary <- renderTable({
    soccer_analyze(home.team = input$HomeTeam,
                  away.team  = input$AwayTeam,
                  df         = datasetInput(),
                  n          = input$games)[[1]]
  }, rownames = TRUE)

  # Generate current league table standings for the selected teams' league
  output$league_table <- renderTable({
    soccer_table(df = datasetInput())
  }, rownames = TRUE, digits = 0)

  # updates the current hometeam based on the selected league
  observe({
    input$league
    updateSelectInput(session,
                      inputId  = "HomeTeam",
                      label    = "Select the home team",
                      choices  = levels(datasetInput()$HomeTeam),
                      selected = levels(datasetInput()$HomeTeam)[2])
  })

  # update the current awayteam based on the selected league
  observe({
    input$league
    updateSelectInput(session,
                      inputId = "AwayTeam",
                      label   = "Select the away team",
                      choices = levels(datasetInput()$AwayTeam))
  })

}
