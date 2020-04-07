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
  

# GRAPH TYPE DE CONVENTION  
  
## Valeur checkbox, 1 : stage obligatoire
## Valeur checkbox, 2 = stage facultatif 
  

  output$p1 <- renderPlotly({
    
    if(input$compo != ""){
      z<-data %>% 
        filter(Libellecomposante == input$compo) } else if (input$compo == ""){
          z<-data
        }
    
    trend_year = z %>% 
      group_by(Anneeunivconvention,Typeconvention) %>% 
      summarise(total = n())
    
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
    
    if(input$compo != ""){
      y<-data %>% 
        filter(Libellecomposante == input$compo) } else if (input$compo == ""){
          y<-data
        }
    
    naf<- y %>% 
      group_by(Nometablissement) %>%
      summarise(total = n()) %>% 
      top_n(10)
    
    
    ggplotly(ggplot(data= naf, aes(x=reorder(Nometablissement,total), y= total,fill= Nometablissement)) +
               geom_bar(stat="identity")+ 
               coord_flip()+
               ggtitle("") +
               xlab("") + 
               ylab("Nombre de stages") +
               theme(legend.position="none")+ 
               scale_fill_brewer(palette="Spectral") )
    
  })
  
  # GRAPHIQUE TOP 10 PAYS 
    
  output$pays <- renderPlotly({
    
    if(input$compo != ""){
      w<-data %>% 
        filter(Libellecomposante == input$compo) } else if (input$compo == ""){
          w<-data
        }
    
    pays<-subset(w,Paysetablissement!="FRANCE")
    pays2<-as.data.frame(table(pays$Paysetablissement))
    t<-as.data.frame(arrange(pays2,desc(pays2$Freq)))
    dp<-t[1:10,]
    dp<-as.data.frame(dp)
    dp
    
    p<-ggplot(data=dp, aes(x=reorder(dp$Var1,dp$Freq), y=dp$Freq,fill=dp$Var1)) + 
      geom_bar(stat="identity")+
      coord_flip()+ 
      ggtitle("") +
      xlab("") + 
      ylab("Nombre de stages")+
      labs(fill="Pays")+
      theme(legend.position="none") + 
      scale_fill_brewer(palette="Spectral")

    
    ggplotly(p)
    
  })

  # GRAPHIQUE EVOLUTION TAUX STAGE ETRANGER
  
  output$tauxetr <- renderPlotly({
    
      if(input$compo != ""){
        t<-data %>% 
          filter(Libellecomposante == input$compo) } else if (input$compo == ""){
            t<-data
          }
    
    #ta<- t %>% 
      #group_by(t$Anneeunivconvention) %>% 
      #summarise(total = n())
    pays<-subset(t,t$Paysetablissement!="FRANCE")
    ta2<- pays %>% 
      group_by(Anneeunivconvention) %>% 
      summarise(total = n())
    
    #tauxetr<-as.data.frame(cbind(ta,ta2[,2]))
    #tauxetr["txetranger"]=tauxetr[,3]/tauxetr[,2]*100
    #tauxetr
    
    p<-ggplot(data=ta2, aes(x=ta2$Anneeunivconvention, y=ta2$total)) + 
      geom_bar(stat="identity")+ 
      ggtitle("") +
      xlab("") + 
      ylab("Nombre de stages effectués à l'étranger")
    
    ggplotly(p)
    
    
  })
  
  # GRAPHIQUE EVOLUTION NOMBRE DE STAGES
  
  output$nbstage <- renderPlotly({
    
    if(input$compo != ""){
    u<-data %>% 
      filter(Libellecomposante == input$compo) } else if (input$compo == ""){
        u<-data
      }
    
    ta<- u %>% 
      group_by(Anneeunivconvention) %>% 
      summarise(total = n())
    #ta<-as.data.frame(table(Anneeunivconvention))
    #ta<-ta
    
    p<-ggplot(data=ta, aes(x=Anneeunivconvention, y=total)) + 
      geom_bar(stat="identity")+ 
      ggtitle("") +
      xlab("") + 
      ylab("Nombre de stages")
    
    ggplotly(p)
    
  })
  
  # GRAPHIQUE PART STAGES FACULTATIFS
  
  output$facultatif <- renderPlotly({
    
      if(input$compo != ""){
        v<-data %>% 
          filter(Libellecomposante == input$compo) } else if (input$compo == ""){
            v<-data
          }
    
    tc<- v %>% 
      group_by(Typeconvention) %>% 
      summarise(total = n())
    tc<-as.data.frame(tc)
    tc
    
    ggplotly(ggplot(data=tc, aes(x=tc$Typeconvention,y=tc$total , fill=tc$Typeconvention)) + 
               geom_bar(stat="identity") + xlab("")+ylab("Nombre de stages"))
    #ggplotly(ggplot(data=tc, aes(x=" ",y=tc$total , fill=tc$Typeconvention)) + 
    #           geom_bar(width = 1, stat = "identity",color="white") + 
    #           coord_polar("y", start = 0)+
    #           theme_void()+
    #           theme(legend.position="bottom"))
    
  
    
})
  
  # GRAPHIQUE DUREE STAGE

  
  output$duree <- renderPlotly({
    
    if(input$compo != ""){
      i<-data %>% 
        filter(Libellecomposante == input$compo) } else if (input$compo == ""){
          i<-data
        }
    
    ggplotly(ggplot(data=i, aes(x=i$Duree_heure)) + 
               geom_histogram()+xlab("Durée en heures"))
    #ggplotly(ggplot(data=tc, aes(x=" ",y=tc$total , fill=tc$Typeconvention)) + 
    #           geom_bar(width = 1, stat = "identity",color="white") + 
    #           coord_polar("y", start = 0)+
    #           theme_void()+
    #           theme(legend.position="bottom"))
    
    
    
  })
  
  
})