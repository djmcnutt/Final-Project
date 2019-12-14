library(ggplot2)
library(readxl)

goldData <- read_excel("GoldenState2015_16.xlsx")

shinyUI(fluidPage(
  
  # Application title
  titlePanel(uiOutput("infonew")),
  
  # Sidebar with options for the data set
  sidebarLayout(
    sidebarPanel(
      h5("Select a Player for Quick Player Details:"),
      selectizeInput("name", "Player Name", selected = "Stephen Curry", choices = levels(as.factor(goldData$player))),
      br(),
      h5("Select Size of Points or Check Box for Explore Tab"),
      sliderInput("size", "Size of Points on Graph (Used for ...)",
                  min = 1, max = 10, value = 5, step = 1),
      checkboxInput("team", h4("Color by Team", style = "color:black;")),
      h5("Select Variables and Cluster Count for Cluster Tab"),
      selectInput('xcol', 'X Variable', names(goldData),selected="age"),
      selectInput('ycol', 'Y Variable', names(goldData),
                  selected="fg_perc"),
      numericInput('clusters', 'Cluster count', 3,
                   min = 1, max = 9)  
      
    ),
    
    # Show outputs
    mainPanel(
      tabsetPanel(type="tabs",
         tabPanel("Background",
                   h4("About the Data"),
                   h5("The 2015-16 Golden State Warriors were one of if not THE greatest team of all time in NBA Basketball history. This season was the 70th season of the franchise and they entered the season as the defending champs from the previous year in which they went 67-15. This season they would do something even more incredible though posting an impressive and record-breaking 73-9. What's even more impressive was that this team didn't really have a major front man like Michael Jordan. Instead the entire team was working together and was known for its 3pt shooting even going as far as to shoot the 3pt shot BEYOND the 3 point line. I love this story because I love it when people overcome aribtrary boundaries. There is also data here for the Cleveland Cavaliers team that barely beat them in the NBA Finals of the same season."),
                  h4("Abilities of the App"),
                  h5("This app allows the user to select variables and other user specified information for clustering and for modeling as well as display stats for individually selected players and make changes to the plotting output."),
                  h4("Quick Player Details"),
                  textOutput("info")
                   ),
         tabPanel("Explore",plotOutput("teamPlot")),
         tabPanel("Cluster",plotOutput("plot1")),
         tabPanel("Modeling",
                  h4("Which Variable do you think best predicts 3 point Percentage?"),
                  h4("Choose from the x and y variables"),                
                  textOutput("info2")),   
         tabPanel("Table",tableOutput("table"))
      )
    )
  )
))