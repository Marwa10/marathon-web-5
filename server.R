library(shiny)
library(dplyr)
library(DT)
library(ggplot2)
library(plotly)
library(shinymaterial)
library(leaflet)
library(plotly)
#source("carto.R")
#source("carto_fr.R")


shinyServer(function(input, output) {
  data = read.csv2("data/donnees.csv", stringsAsFactors = FALSE)
  
  data_ufr = read.csv2("data/donnees_ufr.csv", stringsAsFactors = FALSE) 
  
  
  data$Libellecomposante[which(data$Libellecomposante == "")] <- "Inconnue"
  data_ufr$Libellecomposante[which(data_ufr$Libellecomposante == "")] <- "Inconnue"
  
  
  data$Typeconvention[which(data$Typeconvention=="Formation Initiale - Obligatoire (=ECTS)")]<-"Obligatoire" 
  data$Typeconvention[which(data$Typeconvention=="Formation Initiale - Facultatif (non ECTS)")]<-"Facultatif"
  
  
  ##test avec data_ufr
  
  test  <- reactive({
    g = data_ufr %>% 
      filter(Libellecomposante == "Sciences du sujet et de la société")
    
    if(input$c1 & input$c2){
      g = data_ufr
    }else if (input$c1){
      g = data_ufr %>% 
        filter(Typeconvention == "Obligatoire")
      
    }else if(input$c2){
      g = data_ufr %>% 
        filter(Typeconvention == "Facultatif")
    }
    
  })
  
  
  

  toshow = data_ufr %>% 
    select(Anneeunivconvention,
           Originestage,
           Dureestageenheures,
           cycle,
           ufr,
           Libellecomposante,
           Indemnisation,
           Nometablissement,
           Paysetablissement,
           CodeDepartement,
           Numsiret,
           Libellenaf,
           Typeconvention
           ) %>% 
    rename(
      Année = Anneeunivconvention,
      Etablissement =  Nometablissement,
      Composante = Libellecomposante,
      Cycle = cycle,
      Pays = Paysetablissement,
      Département = CodeDepartement,
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
  
  # trend_year = data %>%
  #   group_by(Anneeunivconvention,Typeconvention) %>%
  #   summarise(total = n())
  
  # etablissement = as.data.frame(table(data$Nometablissement)) %>% 
  #   rename(
  #     `Nombre de stage` = Freq,
  #     Etablissement = Var1 ) %>% 
  #   arrange(desc(`Nombre de stage`))
  
## Valeur checkbox, 1 : stage obligatoire
##                  2 = stage facultatif 
  
  
  
 
  
  output$p1 <- renderPlotly({
    
    if(input$compo != "Toutes les composantes"){
      z<-data %>% 
        filter(Libellecomposante == input$compo)
      } else if (input$compo == "Toutes les composantes"){
          z<-data
        }
    
    trend_year = z %>% 
      group_by(Anneeunivconvention,Typeconvention) %>% 
      summarise(total = n())
    
    if(input$c1 & input$c2){
      g = trend_year
    }else if (input$c1){
      g = trend_year %>% 
        filter(Typeconvention == "Obligatoire")
      
    }else if(input$c2){
      g = trend_year %>% 
        filter(Typeconvention == "Facultatif")
    }else {
      renderPrint({"Désolé "})
    }
    ggplotly(ggplot(data = g, 
                    mapping = aes(x = Anneeunivconvention, y = total, color = Typeconvention)) +
               geom_line()+
               scale_color_manual(values=c("#1F73BB","#F2AF1A"))+
               labs( x = "Année de convention",
                     y = "Nombre de stage ",
                     color = "Type de convention"))
  }) 
  
  # GRAPHIQUE ENTREPRISES
  
  output$entre <- renderPlotly({
    
    if(input$compo != "Toutes les composantes"){
      y<-data %>% 
        filter(Libellecomposante == input$compo) } else if (input$compo == "Toutes les composantes"){
          y<-data
        }
    
    naf<- y %>% 
      group_by(Nometablissement) %>%
      summarise(total = n())%>% 
      top_n(10)
    
    
    ggplotly(ggplot(data= naf, aes(x=reorder(Nometablissement,total), y= total,
                                   fill= Nometablissement
                                   )) +
               geom_bar(stat="identity")+ 
               coord_flip()+
               ggtitle("") +
               xlab("") + 
               geom_text(aes(label = total),size=3.5, color = "Black")+
               ylab("Nombre de stages") +
               theme(legend.position="none")#+
            #scale_fill_manual(values=c("#1f73bb", "#f2af1a", "#7f549c","#e74d95", "#209b7f", "#d73a27","#e7e7e7", "#6d6e72", "#8fbbe7","#237ccc", "#ffcf69", "#7f6834","#e8d5ea", "#776b7f", "#fea1cd","#8050669", "#99d1cb", "#417f70","#1f73bb", "#f2af1a", "#7f549c","#e74d95", "#209b7f", "#d73a27","#e7e7e7", "#6d6e72", "#8fbbe7","#237ccc", "#ffcf69", "#7f6834","#e8d5ea", "#776b7f", "#fea1cd","#8050669", "#99d1cb", "#417f70","#1f73bb", "#f2af1a", "#7f549c","#e74d95", "#209b7f", "#d73a27","#e7e7e7", "#6d6e72", "#8fbbe7","#237ccc", "#ffcf69", "#7f6834","#e8d5ea", "#776b7f", "#fea1cd","#8050669", "#99d1cb", "#417f70"))
             #+ 
               #scale_fill_brewer(palette="Paired")
             )
    
  })
  
  # GRAPHIQUE TOP 10 PAYS 
  
  output$pays <- renderPlotly({
    
    if(input$compo != "Toutes les composantes"){
      w<-data %>% 
        filter(Libellecomposante == input$compo) } else if (input$compo == "Toutes les composantes"){
          w<-data
        }
    
    pays<-subset(w,Paysetablissement!="FRANCE")
    pays2<-as.data.frame(table(pays$Paysetablissement))
    t<-as.data.frame(arrange(pays2,desc(pays2$Freq)))
    dp<-t[1:10,]
    dp<-as.data.frame(t)
    dp
    
    p<-ggplot(data=dp, aes(x=reorder(dp$Var1,dp$Freq), y=dp$Freq,
                           fill=dp$Var1
                           )) + 
      geom_bar(stat="identity")+
      coord_flip()+ 
      ggtitle("") +
      xlab("") + 
      ylab("Nombre de stages")+
      labs(fill="Pays")+
      theme(legend.position="none") + 
      geom_text(aes(label = dp$Freq),size=3.5, color = "Black")+
      scale_fill_brewer(palette="Paired")
    
    
    ggplotly(p)
    
  })
  
  # GRAPHIQUE EVOLUTION TAUX STAGE ETRANGER
  
  output$tauxetr <- renderPlotly({
    
    if(input$compo != "Toutes les composantes"){
      t<-data %>% 
        filter(Libellecomposante == input$compo) } else if (input$compo == "Toutes les composantes"){
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
      geom_bar(stat="identity",fill = "#f2af1a"#,
               #color = "#C4961A"
               )+ 
      ggtitle("") +
      xlab("") + 
      geom_text(aes(label = total),size=3.5, color = "Black")+
      ylab("Nombre de stages effectués à l'étranger")+
      theme(legend.position="none")
    
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
    
    p<-ggplot(data=ta, aes(x=ta$Anneeunivconvention,y=ta$total)) + 
      geom_bar(stat="identity",fill = "#6d6e72"
               #, color = "#C4961A"
               )+ 
      ggtitle("") +
      xlab("") + 
      geom_text(aes(label = total),size=3,color = "Black")+
      ylab("Nombre de stages")+
      theme(legend.position="none")
    
    ggplotly(p)
    
  })
  

  # GRAPHIQUE DUREE STAGE
  
  
  output$duree <- renderPlotly({
    
    if(input$compo != "Toutes les composantes"){
      i<-data %>% 
        filter(Libellecomposante == input$compo) } else if (input$compo == "Toutes les composantes"){
          i<-data
        }
    
    i$Duree_calcul<-as.numeric(i$Duree_calcul)
    
    ggplotly(ggplot(data=i, aes(x=i$Duree_calcul)) + 
               geom_histogram()+xlab("Nombre de semaines de stage (calculé sur un ETP)"))
    #ggplotly(ggplot(data=tc, aes(x=" ",y=tc$total , fill=tc$Typeconvention)) + 
    #           geom_bar(width = 1, stat = "identity",color="white") + 
    #           coord_polar("y", start = 0)+
    #           theme_void()+
    #           theme(legend.position="bottom"))
    
    
    
  })
  
  
  # GRAPHIQUE DIAGRAMME TAUX FACULTATIF
  
  
  output$taux <- renderPlotly({
    
    if(input$compo != "Toutes les composantes"){
      o<-data %>% 
        filter(Libellecomposante == input$compo) } else if (input$compo == "Toutes les composantes"){
          o<-data
        }
    
    to<- o %>% 
      group_by(Typeconvention) %>% 
      summarise(total = n())
    to<-as.data.frame(to)
    to
    
    fig <- plot_ly(data, labels = ~to$Typeconvention, values = ~to$total, type = 'pie',
                   textinfo = 'label+percent',
                   marker = list(colors =c('rgb(31,115,187)', 'rgb(242,175,26)')),
                   showlegend = FALSE)
    fig <- fig %>% layout(title = '',
                          xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                          yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    
    fig
    
    
  })
  
  
  
  # GRAPHIQUE DIAGRAMME ORIGINE DU STAGE
  
  
  output$origine <- renderPlotly({
    
    if(input$compo != "Toutes les composantes"){
      oi<-data %>% 
        filter(Libellecomposante == input$compo) } else if (input$compo == "Toutes les composantes"){
          oi<-data
        }
    
    toi<- oi %>% 
      group_by(Originestage) %>% 
      summarise(total = n())
    toi<-as.data.frame(toi[-1,])
    toi
    
    fig <- plot_ly(data, labels = ~toi$Originestage, values = ~toi$total, type = 'pie',
                   textinfo = 'label+percent',
                   marker = list(colors =c('rgb(32,155,127)', 'rgb(242,175,26)','rgb(109,110,114)','rgb(31,115,187)')),
                   showlegend = FALSE)
    fig <- fig %>% layout(title = '',
                          xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                          yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    
    fig
    
    
  })
  
  # GRAPHIQUE INDEMNISATION
  
  output$indem <- renderPlotly({
    
    if(input$compo != "Toutes les composantes"){
      j<-data %>% 
        filter(Libellecomposante == input$compo) } else if (input$compo == "Toutes les composantes"){
          j<-data
        }
    
    tu<- j %>% 
      group_by(Indemnisation) %>% 
      summarise(total = n())
    tu<-as.data.frame(tu)
    tu
    
    fig <- plot_ly(data, labels = ~tu$Indemnisation, values = ~tu$total, type = 'pie',
                   textinfo = 'label+percent',
                   marker = list(colors =c('rgb(242,175,26)', 'rgb(109,110,114)','rgb(32,155,127)')),
                   showlegend = FALSE)
    fig <- fig %>% layout(title = '',
                          xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                          yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    
    fig
  })
  
  
  
  
  
  
  
  
  output$p2 <- renderPlotly({
    to_use = test()
    ggplotly(ggplot(to_use, aes(cycle, color=cycle, fill=cycle)) +
               geom_bar(position= "identity") +
               labs(x = "Année", y = "Nombre de stagiaire")+
               theme(legend.position="none"))
    
    
  })
  
  
  
  output$p3 <- renderPlotly({
    to_use = test()
    ggplotly(ggplot(to_use, aes(Libellecomposante, color=Libellecomposante, fill=Libellecomposante)) +
               geom_bar(position= "identity") +
               coord_flip()+ 
               labs(x = "Année",
                    y = "Nombre de stages",
                    fill = "Composante"))
    
  })
  
  
  
  
  output$p4 <- renderPlotly({
    to_use = test()
    ggplotly(ggplot(to_use, aes(ufr, color=ufr, fill=ufr)) +
               geom_bar(position= "identity") +
               labs(x = "UFR",
                    y = "Nombre de stages",
                    fill = "UFR")+
              theme(legend.position="none"))
   
  })

  
  #output$map <- renderLeaflet({
    #map
  #})
  
  
   #output$map_fr <- renderLeaflet({
     #m_dep 
   #})

  
})