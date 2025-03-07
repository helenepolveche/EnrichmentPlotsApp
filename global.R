library(shiny)
library(ggplot2)
library(DT)
library(dplyr)
library(shinythemes)
library(bslib)

# Theme
theme_custom <- shinytheme("flatly")


# CSS navbar
navbar_style <- tags$style(HTML("
  .navbar { background-color: #003366 !important; }
  .navbar-default .navbar-brand { color: white !important; }
  .navbar-default .navbar-nav > li > a { color: white !important; }
"))