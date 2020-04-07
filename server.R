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
 
  # GRAPHIQUE ENTREPRISES
  
  output$entre <- renderPlotly({
    
    naf<- data %>% 
     # filter(data$Libellecomposante==input$compo)
    #%>%
      group_by(Nometablissement)      %>%
      summarise(total = n()) %>% 
      top_n(10)
    
    
    ggplotly(ggplot(data= naf, aes(x=reorder(Nometablissement,total), y= total,fill= Nometablissement)) +
               geom_bar(stat="identity")+ 
               coord_flip()+
               ggtitle("") +
               xlab("") + 
               ylab("Nombre de stages") +
               theme(legend.position="none") )
    
  })
  
  # GRAPHIQUE TOP 10 PAYS 
    
  output$pays <- renderPlotly({
    pays<-subset(data,Paysetablissement!="FRANCE")
    pays2<-as.data.frame(table(pays$Paysetablissement))
    t<-as.data.frame(arrange(pays2,desc(pays2$Freq)))
    dp<-t[1:10,]
    dp<-as.data.frame(dp)
    dp
    
    p<-ggplot(data=dp, aes(x=reorder(dp$Var1,dp$Freq), y=dp$Freq,fill=dp$Var1)) + 
      geom_bar(stat="identity")+
      coord_flip()+ 
      ggtitle("Les pays étrangers préférés") +
      xlab("") + 
      ylab("Nombre de stages")+
      labs(fill="Pays")+
      theme(legend.position="none") 
    
    ggplotly(p)
    
  })

  # GRAPHIQUE EVOLUTION TAUX STAGE ETRANGER
  
  output$tauxetr <- renderPlotly({

    ta<- data %>% 
      group_by(Anneeunivconvention) %>% 
      summarise(total = n())
    pays<-subset(data,data$Paysetablissement!="FRANCE")
    ta2<- pays %>% 
      group_by(pays$Anneeunivconvention) %>% 
      summarise(total = n())
    ta2
    #ta2<-as.data.frame(table(pays$Anneeunivconvention))
    #ta2
    
    tauxetr<-as.data.frame(cbind(ta,ta2[,2]))
    tauxetr
    
    tauxetr["txetranger"]=tauxetr[,3]/tauxetr[,2]*100
    
    p<-ggplot(data=tauxetr, aes(x=tauxetr$Anneeunivconvention, y=tauxetr$txetranger,fill=tauxetr$txetranger)) + 
      geom_bar(stat="identity")+ 
      ggtitle("Part des stages effectués à l'étranger") +
      xlab("") + 
      ylab("Part des stages effectués à l'étranger (%)")+
      labs(fill="Taux stage étranger")
    
    ggplotly(p)
    
    
  })
  
  # GRAPHIQUE EVOLUTION NOMBRE DE STAGES
  
  output$nbstage <- renderPlotly({
    
    ta<- data %>% 
      group_by(Anneeunivconvention) %>% 
      summarise(total = n())
    #ta<-as.data.frame(table(Anneeunivconvention))
    #ta<-ta
    
    p<-ggplot(data=ta, aes(x=Anneeunivconvention, y=total)) + 
      geom_bar(stat="identity")+ 
      ggtitle("Evolution du nombre de stages effectués") +
      xlab("") + 
      ylab("Nombre de stages")
    
    ggplotly(p)
    
  })
  
  # GRAPHIQUE PART STAGES FACULTATIFS
  
  output$facultatif <- renderPlotly({
    
    tc<- data %>% 
      group_by(Typeconvention) %>% 
      summarise(total = n())
    tc<-as.data.frame(tc)
    tc
    
    ggplotly(ggplot(data=tc, aes(x=" ",y=tc$total , fill=tc$Typeconvention)) + 
               geom_bar(width = 1, stat = "identity") + 
               theme_minimal()+
               ylab("Nombre de stages")+
               xlab("")+
               labs(fill="Type de convention")+
               theme(legend.position="bottom"))
    
  })
 

})