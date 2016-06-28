library(shiny)
library(shinydashboard)
library(knitr)
library(data.table)
library(plyr)
library(dplyr)
library(pROC)
library(caret)
library(utils)
library(lubridate)
library(doParallel)
library(ggplot2)
library(grid)
library(jpeg)
library(RCurl)

source("load.R")


# DB HEADER -----

dbHeader <- dashboardHeader(
  
  title = "Nhat Bui Profile"
  
)

# DB SIDEBAR ------

dbSide <- dashboardSidebar(
  
  sidebarSearchForm(
    
    textId = "search",
    
    buttonId = "search_button",
    
    label = "search",
    
    icon = icon("search")
    
    ),
  
  sidebarMenu(
    
    menuItem("Overview", tabName = "Overview", icon = icon("universal-access")),
    
    menuItem("My Resume", tabName = "resume", icon = icon("user")),
    
    menuItem("Personal Project", tabName = "personal project", icon = icon("spinner"),
             
             menuSubItem("Kobe Shots", tabName = "kobe", icon = icon("bullhorn")),
             
             menuSubItem("Movie Scraping", tabName = "movie", icon = icon("film")),
             
             menuSubItem("Titanic", tabName = "titanic", icon = icon("anchor")),
             
             menuSubItem("Predict Insurance Purchasers", tabName = "insurance", icon = icon("heartbeat")),
             
             menuSubItem("APIs", tabName = "api", icon = icon("facebook"))
      
      
    )
  )
)

# DB BODY ----------

dbBody <- dashboardBody(
  
  tabItems(
    
    tabItem(tabName = "Overview",
            
            h1("Brief Introduction"),
            
            h3("Hi everyone, I am an aspiring data scientist in NYC. Currently, I am a grad student at Pace University and interning as a data scientist  at Sawyer Studios marketing company.

               My goal would be working as a data analyst/scientist in NYC. I welcome everyone to connect to me on LinkedIn."),
            
            h3("This is my self-created dasboard which highlights my best personal data science projects as well as my resume"),
            
            h3("Simply click on the tab menu to check out my work")),
    
    tabItem(tabName = "resume",
            
            HTML('<iframe src=\"https://drive.google.com/file/d/0B9pUvwmm7j8_U0F0R0swYzZPUlU/preview\" width=\"900\" height=\"900\"></iframe>')),
    
    tabItem(tabName = "movie",
            
            withMathJax(includeMarkdown("www/Movie_Scraping.Rmd"))

            ),

    tabItem(tabName = "kobe",
            
            includeMarkdown("www/kobe.Rmd"),
            
            fluidPage(
              
              titlePanel("Kobe Bryant's Short Chart"),
              
              sidebarLayout(
                
                sidebarPanel( 
                  
                  selectInput("MatchUp", 
                              
                              label = h3("Select Matchup"), 
                              
                              choices = c(unique(as.character(raw$opponent)), "None"),
                              
                              selected = "None"),
                  
                  sliderInput("slider",
                              
                              label = h3("Choose year"),
                              
                              min = unique(min(raw$year)),
                              
                              max = unique(max(raw$year)),
                              
                              value = 1996,
                              
                              animate = TRUE,
                              
                              sep = ""
                  )),
                
                mainPanel("Kobe's Short Chart based on selected year", 
                          
                          plotOutput("shortchart", height = "800px" ))
              )
            ))))

    
  

#UI -----

ui <- dashboardPage(
  
  dbHeader,
  
  dbSide,
  
  dbBody
)

# Server -------

server <- function(input, output){
  
  #react to changes in input
  
  react <- reactive({
    sub <- subset(raw, year == input$slider)
    if (input$MatchUp == "None"){
      ggplot(sub, aes(x=loc_x, y=loc_y)) + 
        annotation_custom(court, -250, 250, -50, 420) +
        geom_point(aes(colour = shot_made_flag, shape = shot_made_flag)) +
        xlim(-250, 250) +
        ylim(-50, 420)
    } else {
      sub2 <- subset(sub, opponent == input$MatchUp)
      ggplot(sub2, aes(x=loc_x, y=loc_y)) + 
        annotation_custom(court, -250, 250, -50, 420) +
        geom_point(aes(colour = shot_made_flag, shape = shot_made_flag)) +
        xlim(-250, 250) +
        ylim(-50, 420)}
  })
  
  output$shortchart <-renderPlot({
    react()
  })

  }

#Shiny app -----

shinyApp(ui, server)

#deployApp()