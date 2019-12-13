library(shiny)
library(dplyr)
library(ggplot2)

shinyServer(function(input, output, session) {
  
  getData <- reactive({
    newData <- msleep %>% filter(vore == input$vore)
  })
  
  #create plot
  output$sleepPlot <- renderPlot({
    #get filtered data
    newData <- getData()
    
    #create plot
    g <- ggplot(newData, aes(x = bodywt, y = sleep_total))
    
    if(input$conservation){
      
      if (input$rem) {
        
        g + geom_point(size = input$size, aes(col = conservation, alpha=0.5))
        
      } else {
        
      g + geom_point(size = input$size, aes(col = conservation))
        
      }
      
    } else {
      g + geom_point(size = input$size)
    }
  })
  
  
  #create text info
  output$info <- renderText({
    #get filtered data
    newData <- getData()
    
    paste("The average body weight for order", input$vore, "is", round(mean(newData$bodywt, na.rm = TRUE), 2), "and the average total sleep time is", round(mean(newData$sleep_total, na.rm = TRUE), 2), sep = " ")
  })
  
  #create output of observations    
  output$table <- renderTable({
    getData()
  })
  
  observe({
  
  if (input$rem) { updateSliderInput(session, "size", min=3) 
    
  } else { updateSliderInput(session, "size", min=1) 
  }
    
  })
  
  output$infonew <- renderUI({
    text <- paste0("Investigation of ", input$vore, "vore Mammal Sleep Data:")
    h1(text)
  })
  
})