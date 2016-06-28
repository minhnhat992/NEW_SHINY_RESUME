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

load("raw.rda")

#create short chart for kobe
court_img <- "http://robslink.com/SAS/democd54/nba_court_dimensions.jpg"
court <- rasterGrob(readJPEG(getURLContent(court_img)),
                    width=unit(1,"npc"), height=unit(1,"npc"))




