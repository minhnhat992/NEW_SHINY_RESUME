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
library(DT)
library(doParallel)
library(stepPlr)
library(pROC)
library(ROCR)
library(psych)
library(ROSE)
library(caret)
library(Hmisc)
library(plyr)
library(dplyr)# for %>% 
library(data.table)
library(sqldf)
library(gdata)
library(utils)#read csv
library(car)# for multicollinearity
library(MASS)#chi-square test of independence


load("raw.rda")

#create short chart for kobe
court_img <- "http://robslink.com/SAS/democd54/nba_court_dimensions.jpg"
court <- rasterGrob(readJPEG(getURLContent(court_img)),
                    width=unit(1,"npc"), height=unit(1,"npc"))

trainning_set <- read.csv("www/trainning_set.txt")
test_set <- read.csv("www/test_set.txt")
titan_train <- read.csv("www/Titan_test.csv")
titan_test <- read.csv("www/Titan_train.csv")


load(file = "www/actor_final.rda")
load(file = "www/important_people.rda")
load(file = "www/first_row.rda")
load(file = "www/xmltop1.rda")
load(file = "www/xmlfile1.rda")
load(file = "www/train_titanic.rda")

