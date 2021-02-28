#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(DT)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Bharat EE"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            uiOutput("upload"),
            uiOutput("AdjMatrix_output"),
            uiOutput("Coord_output"),
            uiOutput("x_col_output"),
            uiOutput("y_col_output"),
            uiOutput("dp_output"),
            uiOutput("vertex_output"),
            uiOutput("length_output"),
            uiOutput("colour_output"),
            uiOutput("colour2_output")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(
                tabPanel(
                    "Data",
                    DT::dataTableOutput("data_adj"), 
                    DT::dataTableOutput("Coord"), 
                    helpText("Here is your data!")
                ),
                tabPanel(
                    "Plot",
                    plotOutput("plot"),
                    helpText("Here is your plot")
                )
            
            ),
        )
    )
))
