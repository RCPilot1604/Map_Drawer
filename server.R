#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny);
library(ggplot2);
library(dplyr);
library(DT);

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$upload <- renderUI({
       fileInput("CSVIn", "Upload your .csv file here", multiple = TRUE, accept = c(
           "text/csv",
           "text/comma-separated-values,text/plain",
           ".csv"), width = NULL, buttonLabel = "Browse...", placeholder = "No file selected")
   })
    output$AdjMatrix_output <- renderUI({
        if(is.null(input$CSVIn)){return(helpText("Please input CSV!"));}
        selectInput("dataSelect_Adj","Select your Adjacency Matrix from list of data",input$CSVIn$name)
    })
    output$Coord_output <- renderUI({
        if(is.null(input$CSVIn)){return();}
        selectInput("dataSelect_Coord","Select your X_Coordinates from list of data",input$CSVIn$name)
    })
    
    output$x_col_output <- renderUI({
        if(is.null(input$CSVIn)){return();}
        selectInput("x_col","Choose the x column", colnames(Coord_input()));
    })
    output$y_col_output <- renderUI({
        if(is.null(input$CSVIn)){return();}
        selectInput("y_col","Choose the x column", colnames(Coord_input()));
    })

    AdjMatrix <- reactive({
        if(is.null(input$CSVIn)){return();}
        upload <- input$CSVIn$datapath[input$CSVIn$name==input$dataSelect_Adj] %>% read.csv();
        upload[is.na(upload)] <- 0; #Replace all the NAs with 0
        return(upload);
    })
    
    Coord_input <- reactive({
        if(is.null(input$CSVIn)){return();}
        upload <- input$CSVIn$datapath[input$CSVIn$name==input$dataSelect_Coord] %>% read.csv();
        upload[is.na(upload)] <- 0; #Replace all the NAs with 0
        return(upload);
    })
    
    
    output$data_adj <- DT::renderDataTable({ 
        if(is.null(input$CSVIn)){return();}
        DT::datatable(AdjMatrix())
    })
    output$Coord <- DT::renderDataTable({ 
        if(is.null(input$CSVIn)){return();}
        DT::datatable(Coord_input())
    })
    output$plot <- renderPlot({
        data <- Coord_input();
        matrix <- AdjMatrix();
        x_col <- data[input$x_col];
        y_col <- data[input$y_col];
        print(x_col)
        gg <- ggplot(data = data, mapping = aes_string(x= input$x_col, y= input$y_col)) + geom_point()
        for(i in 1:nrow(matrix)){
            for(j in 1:ncol(matrix)){
                if(matrix[i,j]==1){
                    gg <- gg + geom_segment(x = x_col[j,], y = y_col[j,], xend = x_col[i,], yend = y_col[i,], color = "green", data = data, size = 1)
                }
            }
        }
        return(gg)
    })
})
