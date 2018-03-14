# Define UI for dataset viewer app
ui <- fluidPage(

  # App title
  titlePanel("soccer data exploration with R"),

  # Sidebar layout with a input and output definitions
  fluidRow(

    # Sidebar panel for inputs
    column(3,

      # Input: Selector for choosing the league
      selectInput(inputId = "league",
                  label = "Select league",
                  choices = c("Epl", "Laliga", "Bundesliga", "France League One", "Serie A", "Portugal Liga",
                              "Scot Prem", "Greece Ethniki", "Bundes Two", "Belgium Jupiler",
                              "Turkey Ligi", "Netherlands Eredivisie", "English Championship",
                              "Laliga Segunda", "Bundes Two", "Serie B", "English Conference",
                              "English League One", "English League Two")),
      hr(),

      # Input: Selector for choosing the home team
      selectInput(inputId = "HomeTeam",
                  label = "select the home team",
                  choices = levels(epl$HomeTeam),
                  selected = "Man United"),

      # Input: Selector for choosing away team
      selectInput(inputId = "AwayTeam",
                  label = "select the away team",
                  choices = levels(epl$AwayTeam),
                  selected = "Chelsea"),

      # Input: Numeric entry for number of games to base the summary on
      numericInput(inputId = "games",
                   label = "Number of games",
                   value = 3,
                   step = 2,
                   min = 3)
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

