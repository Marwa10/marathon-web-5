library(shiny)
library(dplyr)
library(DT)
library(ggplot2)
library(plotly)
library(shinymaterial)

shinyServer(function(input, output) {
  data = read.csv2("data/donnees.csv", stringsAsFactors = FALSE) 
  
  toshow = data %>% 
    select(Anneeunivconvention,
           cycle,
           Filiere,
           Nometablissement,
           Paysetablissement,
           codeDepartement,
           Numsiret
           ) %>% 
    rename(
      Année = Anneeunivconvention,
      Etablissement =  Nometablissement,
      Cycle = cycle,
      Filière = Filiere,
      Pays = Paysetablissement,
      Département = codeDepartement,
      `Numéro siret` = Numsiret)
  
  toshow$Cycle = as.factor(toshow$Cycle)
  toshow$Pays = as.factor(toshow$Pays)
  toshow$`Numéro siret` = as.factor(toshow$`Numéro siret`)
    
  output$plot <- DT::renderDataTable(
    toshow,
    server = TRUE,
    rownames = FALSE,
    filter = "top",
    options = list(searchHighlight = TRUE,
                   class = 'cell-border stripe',
                   autoWidth = TRUE ,
                   columnDefs = list(list(className = 'dt-center', targets = 4)),
                   #lengthMenu = c(50, 100, 150, 200),
                   pageLength = 10
                   #initComplete = JS(js)
                   #search = list(smart = FALSE, caseInsensitive = FALSE, regex = TRUE)
    )
  )
  
  trend_year = data %>% 
    group_by(Anneeunivconvention,Typeconvention) %>% 
    summarise(total = n())
  
 
  
## Valeur checkbox, 1 : stage obligatoire
##                  2 = stage facultatif 
  

  output$p1 <- renderPlotly({
    if(input$c1 & input$c2){
      g = trend_year
    }else if (input$c1){
      g = trend_year %>% 
        filter(Typeconvention == "Formation Initiale - Obligatoire (=ECTS)")
      
    }else if(input$c2){
      g = trend_year %>% 
        filter(Typeconvention == "Formation Initiale - Facultatif (non ECTS)")
    }else {
      renderPrint({"Désolé "})
    }
    ggplotly(ggplot(data = g, 
                    mapping = aes(x = Anneeunivconvention, y = total, color = Typeconvention)) +
               geom_line()+
               labs( x = "Année de convention",
                     y = "Nombre de stage ",
                     color = "Type de convention"))
  }) 
 
  
   

})