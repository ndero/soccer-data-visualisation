# Define UI for dataset viewer app
ui <- fluidPage(

  # App title
  titlePanel("soccer data exploration with R"),

  # Sidebar layout with  input and output definitions
  fluidRow(

    # Sidebar panel for inputs
    column(3,

      # Input: Selector for choosing the league
      selectInput(inputId = "league",
                  label   = "Select league",
                  choices = c("Epl", "Laliga", "Bundesliga", "France League One", "Serie A", "Portugal Liga",
                              "Scot Prem", "Greece Ethniki", "Bundes Two", "Belgium Jupiler",
                              "Turkey Ligi", "Netherlands Eredivisie", "English Championship",
                              "Laliga Segunda", "Bundes Two", "Serie B", "English Conference",
                              "English League One", "English League Two")),
      hr(),

      # Input: Selector for choosing the home team
      selectInput(inputId  = "HomeTeam",
                  label    = "select the home team",
                  choices  = levels(epl$HomeTeam),
                  selected = "Man United"),

      # Input: Selector for choosing away team
      selectInput(inputId  = "AwayTeam",
                  label    = "select the away team",
                  choices  = levels(epl$AwayTeam),
                  selected = "Chelsea"),

      # Input: Numeric entry for number of games to base the summary on
      numericInput(inputId = "games",
                   label   = "Number of games",
                   value   = 3,
                   step    = 5,
                   min     = 5)
    ),

    # Main panel for displaying outputs
    column(9,
      tabsetPanel(
        tabPanel("summary",
          column(6, hr(), plotlyOutput("bar_chart")),
          column(6, hr(), plotlyOutput("pie_chart")),
          fluidRow(
            column(12, tableOutput('soccer_summary'))
          )
        ),
        tabPanel("head to head", tableOutput("head_to_head")),
        tabPanel("most recent 8 games",
          fluidRow(
            column(12, tableOutput('last_six_home'))
          ),
          fluidRow(
            column(12, tableOutput('last_six_away'))
          )),
        tabPanel('league table', tableOutput("league_table"))
      )
    )
  )
)


# Define server logic to summarize and view selected dataset
server <- function(input, output, session) {

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

# Create Shiny app
shinyApp(ui = ui, server = server)
