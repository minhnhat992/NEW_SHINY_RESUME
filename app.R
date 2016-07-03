source("load.R")


# DB HEADER -----

dbHeader <- dashboardHeader(
  
  title = "Nhat Bui Profile"
  
)

# DB SIDEBAR ------

dbSide <- dashboardSidebar(
  
  sidebarSearchForm( textId = "search",  buttonId = "search_button", label = "search", icon = icon("search")
    
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
#Overview -------    
    tabItem(tabName = "Overview",
            
            h1("Brief Introduction"),
            
            h3("Hi everyone, I am an aspiring data scientist in NYC. Currently, I am a grad student at Pace University and interning as a data scientist  at Sawyer Studios marketing company.

               My goal would be working as a data analyst/scientist in NYC. I welcome everyone to connect to me on LinkedIn."),
            
            h3("This is my self-created dasboard which highlights my best personal data science projects as well as my resume"),
            
            h3("Simply click on the tab menu to check out my work")),
# Resume -----    
    tabItem(tabName = "resume",
            
            HTML('<iframe src=\"https://drive.google.com/file/d/0B9pUvwmm7j8_U0F0R0swYzZPUlU/preview\" width=\"900\" height=\"900\"></iframe>')),
# Titanic -----     
    tabItem(tabName = "titanic",
            
            tabsetPanel(
              
              tabPanel("Overview",
                       
                       includeMarkdown("www/Overview_Titanic_1.Rmd"),
                       
                       h4("Train Dataset"),
                       
                       DT::dataTableOutput("Train_Titan"),
                       
                       downloadButton("downloadTrainTitan", label = "Download"),
                       
                       h4("Test Dataset"),
                       
                       DT::dataTableOutput("Test_Titan"),
                       
                       downloadButton("downloadTestTitan", label = "Download")
                       ),
              
              tabPanel("EDA",
                       
                       includeMarkdown("www/EDA_Titanic_1.Rmd"),
                       
                       DT::dataTableOutput("Train_Titan_2"),
                       
                       includeMarkdown("www/EDA_Titanic_2.Rmd")),
              
              tabPanel("Algorithm",
                       
                       htmlOutput("algorithm_titanic")),
              
              tabPanel("Result",
                       
                       htmlOutput("result_titanic")))),

# Insurance -----       
    tabItem(tabName = "insurance",
# Insucrance : Overview Tab ------            
            tabsetPanel(
              tabPanel("Overview",
                       includeMarkdown("www/Overview_1.Rmd"),
                       
                       h4("Train Dataset"),
                       
                       DT::dataTableOutput("Train"),
                       
                       downloadButton("downloadTrain", label = "Download"),
                       
                       h4("Test Dataset"),
                       
                       DT::dataTableOutput("Test"),
                       
                       downloadButton("downloadTest", label = "Download")
                       
                       ),
# Insurance: EDA tab -------------              
              tabPanel("EDA",
                       
                       htmlOutput("EDA_Insurance")),
              
              tabPanel("Algorithm",
                       
                       htmlOutput("algo_Insu")),
              
              tabPanel("Result",
                       
                       htmlOutput("result_Insu")))),
# Scrape ---------------    
    tabItem(tabName = "movie",
            
            htmlOutput("movie_scraper")),
# kobe tab -------
    tabItem(tabName = "kobe",
            
            tabsetPanel(
              
              tabPanel("EDA",
                       
                       includeMarkdown("www/kobe.Rmd"),
                       
                       fluidPage(
                         
                         titlePanel("Kobe Bryant's Short Chart"),
                         
                         sidebarLayout(
                           
                           sidebarPanel( 
                             
                             selectInput("MatchUp",  label = h3("Select Matchup"), 
                                         
                                         choices = c(unique(as.character(raw$opponent)), "None"),
                                         
                                         selected = "None"),
                             
                             sliderInput("slider", label = h3("Choose year"),
                                         
                                         min = unique(min(raw$year)),
                                         
                                         max = unique(max(raw$year)),
                                         
                                         value = 1996,
                                         
                                         animate = TRUE,
                                         
                                         sep = "" )),
                           
                           mainPanel("Kobe's Short Chart based on selected year", 
                                     
                                     plotOutput("shortchart", height = "800px" ))))))),
# API -------------    
    tabItem(tabname = "api",
            
            tabsetPanel(
              
              tabPanel("Overview"),
              
              tabPanel("Twitter"),
              
              tabPanel("Steam"),
              
              tabPanel("Reddit"),
              
              tabPanel("Facebook")
            ))

))

  

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
        annotation_custom(court) +
        geom_point(aes(colour = shot_made_flag, shape = shot_made_flag)) +
        xlim(-250, 250) +
        ylim(-50, 420)
    } else {
      sub2 <- subset(sub, opponent == input$MatchUp)
      ggplot(sub2, aes(x=loc_x, y=loc_y)) + 
        annotation_custom(court) +
        geom_point(aes(colour = shot_made_flag, shape = shot_made_flag)) +
        xlim(-250, 250) +
        ylim(-50, 420)}
  })
  
  output$shortchart <-renderPlot({
    react()
  })
  
  getPage<-function() {
    return(includeHTML("www/Movie_Scraping.html"))
  }
  output$movie_scraper<-renderUI({getPage()})

  output$Train <- DT::renderDataTable(trainning_set, server = TRUE, options=list(scrollX=TRUE))
  
  output$Test  <- DT::renderDataTable(test_set, server = TRUE, options=list(scrollX=TRUE))
  
  output$downloadTrain <- downloadHandler(filename = function(){"trainning_set.csv"},
                                          
                                          content = function(file){file.copy("www/trainning_set.txt",file)}) #work fine in browser, dont' worry
  
  output$downloadTest  <- downloadHandler(filename = function(){"test_set.csv"}, 
                                          
                                          content = function(file){file.copy("www/test_set.txt")})
  InsuranceEDA <- function() {
    return(includeHTML("www/EDA_Insurance.html"))
  }
  
  output$EDA_Insurance <- renderUI({InsuranceEDA()})
  
  output$Train_Titan <- DT::renderDataTable(titan_train, server = TRUE, options=list(scrollX=TRUE))
  
  output$Test_Titan  <- DT::renderDataTable(titan_test, server = TRUE, options=list(scrollX=TRUE))
  
  output$downloadTrainTitan <- downloadHandler(filename = function(){"trainning_set.csv"},
                                          
                                          content = function(file){file.copy("www/Titan_train.csv",file)}) #work fine in browser, dont' worry
  
  output$downloadTestTitan  <- downloadHandler(filename = function(){"test_set.csv"}, 
                                          
                                          content = function(file){file.copy("www/Titan_test.csv")})
  
  output$Train_Titan_2 <- DT::renderDataTable(train, server = TRUE, options=list(scrollX=TRUE))
  
  algo_titan <- function() {
    return(includeHTML("www/algorithm_Titanic.html"))
  }
  
  output$algorithm_titanic <- renderUI({algo_titan()})
  
  result_titan <- function() {
    return(includeHTML("www/result_Titanic.html"))
  }
  
  output$result_titanic <- renderUI({result_titan()})
  
  algo_insurance <- function() {
    return(includeHTML("www/algorithm.html"))
  }
  
  output$algo_Insu <- renderUI({algo_insurance()})
  
  result_insurance <- function() {
    return(includeHTML("www/result_Insurance.html"))
  }
  
  output$result_Insu <- renderUI({result_insurance()})
    
}
  


#Shiny app -----

shinyApp(ui, server)

#deployApp()
