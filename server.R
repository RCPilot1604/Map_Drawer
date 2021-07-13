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
library(colourpicker);

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
        selectInput("dataSelect_Coord","Select your X/Y Coordinates from list of data",input$CSVIn$name)
    })
    
    output$x_col_output <- renderUI({
        if(is.null(input$CSVIn)){return();}
        selectInput("x_col","Choose the x column", colnames(Coord_input()));
    })
    output$y_col_output <- renderUI({
        if(is.null(input$CSVIn)){return();}
        selectInput("y_col","Choose the y column", colnames(Coord_input()));
    })
    output$dp_output <- renderUI({
        if(is.null(input$CSVIn)){return();}
        numericInput("dp","Choose Number of dp for labels", 2, min=0,max=5);
    })
    output$colour_output <- renderUI({
        if(is.null(input$CSVIn)){return();}
        colourInput("col", "Select colour of lines", "green");
    })
    output$colour2_output <- renderUI({
        if(is.null(input$CSVIn)){return();}
        colourInput("col2", "Select colour of text", "black");
    })
    output$vertex_output <- renderUI({
        if(is.null(input$CSVIn)){return();}
        sliderInput("vertex_size","Choose size of text for vertex labels",min=0.1,max=10,value=2, step = 0.1);
    })
    output$length_output <- renderUI({
        if(is.null(input$CSVIn)){return();}
        sliderInput("length_size","Choose size of text for vertex labels",min=0.1,max=10,value=2, step = 0.1);
    })

    AdjMatrix <- reactive({
        if(is.null(input$CSVIn)){return();}
        upload <- input$CSVIn$datapath[input$CSVIn$name==input$dataSelect_Adj] %>% read.csv();
        View(upload)
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
        id <- data[,1];
    
        gg <- ggplot(data = data, mapping = aes_string(x= input$x_col, y= input$y_col)) + geom_point()
        gg <- gg + theme_bw() + theme(panel.border = element_blank(), panel.grid.major = element_blank(),
                                      panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))
        for(i in 1:nrow(matrix)){
            for(j in 1:ncol(matrix)){
                if(matrix[i,j]==1){
                    print(i)
                    print(j)
                    print('next')
                    gg <- gg + geom_segment(x = x_col[i,], y = y_col[i,], xend = x_col[j,], yend = y_col[j,], color = input$col, data = data, size = 1)
                    midpoint <- c((x_col[i,] + x_col[j,])/2 , (y_col[i,] + y_col[j,])/2);
                    length <- round(sqrt((x_col[i,]-x_col[j,])**2 + (y_col[i,]-y_col[j,])**2),input$dp);
                    gg <- gg + geom_text(x=midpoint[1]+ 10,y=midpoint[2]- 10, label = length, size = input$length_size, colour = input$col2);
                }
            }
            gg <- gg + geom_text(x=x_col[i,],y=y_col[i,]-250, label = id[i], size = input$vertex_size);
        }
        pdf("ggplot.pdf")
        print(gg)
        dev.off()
        return(gg)
    })
})
