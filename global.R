library(shiny)

if(!require(shiny.tailwind)) install.packages("shiny.tailwind")
library(shiny.tailwind)

if(!require(shinyjs)) install.packages("shinyjs")
library(shinyjs)

if(!require(tidyverse)) install.packages("tidyverse")
library(tidyverse)

if(!require(readr)) install.packages("readr")
library(readr)



names_df <- read_csv("www/names.csv")

Globals<-reactiveValues(sheet =read_csv("www/sheet.csv"),
                        sums=c())


group_lbls<-c("g1","g2","g3", "g4", "g5", "g6")
group_names<-c("Group 1","Group 2","Group 3", "Group 4", "Group 5", "Group 6")
