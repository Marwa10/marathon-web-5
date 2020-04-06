library(shiny)
library(dplyr)
library(DT)
library(shinymaterial)

shinyServer(function(input, output) {
  data = read.csv2("data/donnees.csv", stringsAsFactors = FALSE) 
  
  toshow = data %>% 
    select(Anneeunivconvention,
           cycle,
           Nometablissement,
           Paysetablissement,
           codeDepartement,
           Numsiret
           ) %>% 
    rename(
      Année = Anneeunivconvention,
      Etablissement =  Nometablissement,
      Pays = Paysetablissement,
      Département = codeDepartement,
      `Numéro siret` = Numsiret)
  
  toshow$cycle = as.factor(toshow$cycle)
  toshow$Pays = as.factor(toshow$Pays)
    
  output$plot <- DT::renderDataTable(
    toshow,
    server = TRUE,
    rownames = FALSE,
    filter = "top",
    options = list(searchHighlight = TRUE,
                   class = 'cell-border stripe',
                   pageLength = 10
    )
    
    
  )
 
  
   

})