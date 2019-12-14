library(shiny)
library(dplyr)
library(ggplot2)
library(readxl)
library(knitr)
library(MuMIn)

goldData <- read_excel("GoldenState2015_16.xlsx")

shinyServer(function(input, output, session) {
  
  getData3 <- reactive({
    newData3 <- goldData
  })
  
  getData2 <- reactive({
    newData2 <- goldData %>% filter(player == input$name)
  })
  
  getData <- reactive({
    newData <- msleep %>% filter(vore == input$vore)
  })
  
  selectedData <- reactive({
    goldData[, c(input$xcol, input$ycol)]
  })
  
  clusters <- reactive({
    kmeans(selectedData(), input$clusters)
  })
  
  output$plot1 <- renderPlot({
    palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
              "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))
    
    par(mar = c(5.1, 4.1, 0, 1))
    plot(selectedData(),
         col = clusters()$cluster,
         pch = 20, cex = 3)
    points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
  })
  
  model <- reactive({
    
    compareFitStats <- function(fit1, fit2){
      
      require(MuMIn)
      fitStats <- data.frame(fitStat = c("Adj R Square", "AIC", "AICc", "BIC"),
                             col1 = round(c(summary(fit1)$adj.r.squared, AIC(fit1), 
                                            MuMIn::AICc(fit1), BIC(fit1)), 3),
                             col2 = round(c(summary(fit2)$adj.r.squared, AIC(fit2), 
                                            MuMIn::AICc(fit2), BIC(fit2)), 3))
      #put names on returned df
      calls <- as.list(match.call())
      calls[[1]] <- NULL
      names(fitStats)[2:3] <- unlist(calls)
      fitStats
    }
    
    fgFit1 <- lm(fg_perc ~ avg_dist, data = selectedData())
    fgFit2 <- lm(input$ycol ~ input$xcol)
    
    compareFitStats(fgFit1,fgFit2)
  })
  
  prediction <- reactive({
    
    fgFit2 <- lm(input$ycol ~ input$xcol, data = selectedData())
    
    predict(fgFit2,newData=selectedData())
  })

  #create text info
  output$info2 <- renderText({
    #get filtered data

    paste("The variables you chose were ", input$xcol, " and ", input$ycol, ". Here is the model:", model(),  "Here's your prediction: ", prediction(), sep = " ")
    
  })
  
  #create plot
  output$teamPlot <- renderPlot({
    #get filtered data
    newData <- getData3()
    
    #create plot
    g <- ggplot(newData, aes(x = player, y = fg_3pt))
    
    if(input$team) {
        
        g + geom_point(size = input$size, aes(col = team,size=qsec))
      
    } else {
        g + geom_point(size = input$size,aes(size=qsec))
    }
  })
  
  
  #create text info
  output$info <- renderText({
    #get filtered data
    newData <- getData2()
    
    paste("The field goal percentage for shots made from the 3 point range for", input$name, "is", newData$fg_3pt[newData$player==input$name], "and the field goal percentage for shots made from the corner 3 point range is", newData$fg_3pt_corner[newData$player==input$name],  sep = " ")
  })
  
  #create output of observations    
  output$table <- renderTable({
    data.frame(getData3())
  })
  
  output$infonew <- renderUI({
    text <- paste0("Investigation of ", input$vore, "vore Mammal Sleep Data:")
    h1(text)
  })
  
})