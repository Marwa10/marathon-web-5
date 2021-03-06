library(shiny)
library(dplyr)
library(DT)
library(ggplot2)
library(plotly)
library(shinymaterial)
library(leaflet)
library(plotly)
source("carto.R")
source("carto_fr.R")
#source("test_treemap_EmmanuelP.R")


shinyServer(function(session,input, output) {
  data = read.csv2("data/donnees_c2.csv", stringsAsFactors = FALSE)
  
  
  data$temps = factor(data$temps, levels = c("< 1jour",
                                             "1jour-1semaine",
                                             "1semaine-1mois",
                                             "1mois-2 mois",
                                             "> 2mois"))
  
  data_ufr = read.csv2("data/donnees_ufr.csv", stringsAsFactors = FALSE) 
  
  
  data$Libellecomposante[which(data$Libellecomposante == "")] <- "Inconnue"
  data_ufr$Libellecomposante[which(data_ufr$Libellecomposante == "")] <- "Inconnue"
  
  
  data$Typeconvention[which(data$Typeconvention=="Formation Initiale - Obligatoire (=ECTS)")]<-"Obligatoire" 
  data$Typeconvention[which(data$Typeconvention=="Formation Initiale - Facultatif (non ECTS)")]<-"Facultatif"
  
  
  ##test avec data_ufr
  # 
  # test  <- reactive({
  #   if(input$c1 & input$c2){
  #     g = data
  #   }else if (input$c1){
  #     g = data %>% 
  #       filter(Typeconvention == "Obligatoire")
  #     
  #   }else if(input$c2){
  #     g = data %>% 
  #       filter(Typeconvention == "Facultatif")
  #   }
  #   g
  #     
  # })
  
  
  
  ### Update des filtres en fonction des choix précédants
  
  choix_ufr <- reactive({
    data %>%
      filter(cycle == input$id_cycle)
  })
  
  
  
  observeEvent(input$id_cycle,{
    myfilter = choix_ufr()
    liste = unique(myfilter$ufr)
    update_material_dropdown(session,
                             input_id = "id_ufr",
                             choices = liste,
                             value = liste[2])}
  )
  
  
  choix_composante <- reactive({
    data %>% 
      filter(ufr == input$id_ufr)
    
  })
  
  
  observeEvent(input$id_ufr ,{
    myfilter = choix_composante()
    liste = unique(myfilter$Libellecomposante)
    update_material_dropdown(session,
                             input_id = "compo",
                             choices = liste,
                             value = liste[1])
    
  })
  
  
  
  
  ## Fonction reactive pour filtrer les bases de données
  
  type_convention <- reactive({
    if(input$c1 & input$c2){
      t <- data
    }else if (input$c1){
      t <- data %>% 
        filter(Typeconvention == "Obligatoire")
      
    }else if(input$c2){
      t <- data %>% 
        filter(Typeconvention == "Facultatif")
    }
    t
  })
  
  composante <- reactive({
    if(input$compo == "Toutes les composantes"){
      c = data
    } else{
      c = data %>%
        filter(Libellecomposante == input$compo)
    }
    c
  })
  
  
  
  composante_convention <- reactive({
    if(input$c1 & input$c2){
      t <- data
    }else if (input$c1){
      t <- data %>% 
        filter(Typeconvention == "Obligatoire")
      
    }else if(input$c2){
      t <- data %>% 
        filter(Typeconvention == "Facultatif")
    }
    
    if(input$compo == "Toutes les composantes"){
      c = t
    } else{
      c = t %>%
        filter(Libellecomposante == input$compo)
    }
    c
  })
  
  annee <- reactive({
    a <- data %>%
      filter( Anneeunivconvention >= input$start_year,
              Anneeunivconvention <= input$end_year)
    a
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
      `Type convention` = Typeconvention,
      URF= ufr,
      Durée = Dureestageenheures,
      Origine = Originestage,
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
                   scrollX = TRUE,
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
    
    if(input$activation){
      c = composante() %>% 
        filter(cycle == input$id_cycle,
               ufr == input$id_ufr)
      
      
      trend_year = c  %>% 
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
      }
    } else {
      g= data%>%group_by(Anneeunivconvention,Typeconvention) %>% 
        summarise(total = n())}
    
    ggplotly(ggplot(data = g, 
                    mapping = aes(x = Anneeunivconvention, y = total, color = Typeconvention)) +
               geom_line()+
               scale_color_manual(values=c('#1f73bb', '#f2af1a'))+
               labs( x = "Année de convention",
                     y = "Nombre de stage ",
                     color = "Type de convention"))
  }) 
  
  # GRAPHIQUE ENTREPRISES
  
  output$entre <- renderPlotly({
    
    if(input$activation){
      
      y <- composante_convention() %>% 
        filter(ufr == input$id_ufr,
               cycle == input$id_cycle,
               Anneeunivconvention >= input$start_year,
               Anneeunivconvention <= input$end_year
        ) } else {y=data}
    
    
    
    naf<- y %>% 
      group_by(Nometablissement) %>%
      summarise(total = n())%>% 
      top_n(10)
    
    
    ggplotly(ggplot(data= naf, aes(x=reorder(Nometablissement,total), y= total#,
                                   #fill= Nometablissement
    )) +
      geom_bar(stat="identity")+ 
      coord_flip()+
      ggtitle("") +
      xlab("") + 
      geom_text(aes(label = total),size=3.5, color = "Black")+
      ylab("Nombre de stages") +
      theme(legend.position="none")#+ 
    #scale_fill_brewer(palette="Spectral")
    )
    
  })
  
  # GRAPHIQUE TOP 10 PAYS 
  
  output$pays <- renderPlotly({
    
    if(input$activation){
      y <- composante_convention() %>% 
        filter(ufr == input$id_ufr,
               cycle == input$id_cycle,
               Anneeunivconvention >= input$start_year,
               Anneeunivconvention <= input$end_year
        ) } else {y<-data}
    
    pays = y %>% 
      filter(Paysetablissement!="FRANCE") %>% 
      group_by(Paysetablissement) %>% 
      summarise(total = n()) %>% 
      top_n(10)
    
    
    
    # 
    # pays<-subset(w,Paysetablissement!="FRANCE")
    # 
    # pays2<-as.data.frame(table(pays$Paysetablissement))
    # t<-as.data.frame(arrange(pays2,desc(pays2$Freq)))
    # #dp<-t[1:10,]
    # dp<-as.data.frame(t)
    # dp
    
    ggplotly(ggplot(data=pays, aes(x=reorder(Paysetablissement, total), y=total,	
                                   fill=Paysetablissement	
    )) + 	
      geom_bar(stat="identity")+	
      coord_flip()+ 	
      xlab("")+	
      ylab("Nombre de stages")+	
      labs(fill="Pays")+	
      theme(legend.position="none") + 	
      geom_text(aes(label = total),size=3.5, color = "Black")+	
      scale_fill_brewer(palette="PRGn")	
    )
  })
  
  # GRAPHIQUE EVOLUTION TAUX STAGE ETRANGER
  
  output$tauxetr <- renderPlotly({
    
    if(input$activation){
      
      if(input$compo != "Toutes les composantes"){
        t<-data %>% 
          filter(Libellecomposante == input$compo) } else if (input$compo == "Toutes les composantes"){
            t<-data
          }
      
    } else{t<-data}
    
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
    
    if(input$activation){
      u = composante_convention() %>% 
        filter(cycle == input$id_cycle,
               ufr == input$id_ufr) %>% 
        group_by(Anneeunivconvention) %>% 
        summarise(total = n())
    } else {u=data%>% 
      group_by(Anneeunivconvention) %>% 
      summarise(total = n())
    }
    
    p<-ggplot(data= u , aes(x=Anneeunivconvention,y= total)) + 
      geom_bar(stat="identity",fill = "#6d6e72"
               #, color = "#C4961A"
      )+ 
      ggtitle("") +
      xlab("") + 
      geom_text(aes(label = total),size=3.5, color = "Black")+
      ylab("Nombre de stages")+
      theme(legend.position="none")
    
    ggplotly(p)
    
  })
  
  
  
  
  
  # GRAPHIQUE DIAGRAMME TAUX FACULTATIF
  
  
  output$taux <- renderPlotly({
    
    if(input$activation){
      
      if(input$compo != "Toutes les composantes"){
        o<-data %>% 
          filter(Libellecomposante == input$compo) } else if (input$compo == "Toutes les composantes"){
            o<-data
          }} else {o<-data}
    
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
    
    if(input$activation){
      
      oi<- composante_convention() %>% 
        filter(ufr == input$id_ufr,
               cycle == input$id_cycle,
               Anneeunivconvention >= input$start_year,
               Anneeunivconvention <= input$end_year
        )} else {
          oi<-data}
    
    toi<- oi %>% 	
      group_by(Originestage) %>% 	
      summarise(total = n())	
    toi<-as.data.frame(toi)	
    
    fig <- plot_ly(data, labels = ~toi$Originestage, values = ~toi$total, type = 'pie',	
                   textinfo = 'label+percent',	
                   marker = list(colors =c('rgb(32,155,127)', 'rgb(242,175,26)','rgb(109,110,114)','rgb(31,115,187)','rgb(127,84,156)')),	
                   showlegend = FALSE)	
    fig <- fig %>% layout(title = '',	
                          xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),	
                          yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))	
    
    fig
    
    
  })
  
  # GRAPHIQUE INDEMNISATION
  
  output$indem <- renderPlotly({
    
    if(input$activation){
      
      j <- composante_convention() %>% 
        filter(ufr == input$id_ufr,
               cycle == input$id_cycle,
               Anneeunivconvention >= input$start_year,
               Anneeunivconvention <= input$end_year
        )
    }else{j<-data}
    
    tu<- j %>% 
      group_by(Indemnisation) %>% 
      summarise(total = n())
    
    fig <- plot_ly(data, labels = ~tu$Indemnisation, values = ~tu$total, type = 'pie',
                   textinfo = 'label+percent',
                   marker = list(colors =c('rgb(242,175,26)', 'rgb(215,58,39)','rgb(32,155,127)')),
                   showlegend = FALSE)
    fig <- fig %>% layout(
      xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
      yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    
    fig
  })
  
  
  
  
  
  
  ## Distribution des stages en fonction du cycle universitaire
  
  output$p2 <- renderPlotly({
    
    if(input$activation){
      
      to_use = type_convention() %>% 
        filter(Anneeunivconvention >= input$start_year,
               Anneeunivconvention <= input$end_year)
    } else {to_use=data}
    
    ggplotly(ggplot(to_use, aes(cycle, color=cycle, fill=cycle)) +
               geom_bar(position= "identity") +
               labs(x = "Cycle universitaire", y = "Nombre de stages")+
               theme(legend.position="none"))
    
  })
  
  
  
  
  ## Distribution des stages en fonction de la composante
  
  
  output$p3 <- renderPlotly({
    to_use = data
    ggplotly(ggplot(to_use, aes(Anneeunivconvention, color=Libellecomposante, fill=Libellecomposante)) +
               geom_bar(position= "identity") +
               # coord_flip()+ 
               labs(x = "Année",
                    y = "Nombre de stages",
                    fill = "Composante"))
    
  })
  
  
  ## Distribution des stages en fonction de l'UFR
  
  output$p4 <- renderPlotly({
    
    if(input$activation){
      to_use = type_convention() %>% 
        filter(Anneeunivconvention >= input$start_year,
               Anneeunivconvention <= input$end_year) }else{to_use=data}
    
    ggplotly(ggplot(to_use, aes(ufr, color=ufr, fill=ufr)) +
               geom_bar(position= "identity") +
               labs(x = "UFR",
                    y = "Nombre de stages",
                    fill = "UFR")+
               theme(legend.position="none"))
    
  })
  
  
  output$p5 <- renderPlotly({
    
    if(input$activation){
      to_use = data %>% 
        filter(!is.na(temps),
               ufr == input$id_ufr,
               cycle == input$id_cycle,
               Anneeunivconvention >= input$start_year,
               Anneeunivconvention <= input$end_year)
      
    }else{
      to_use=data %>% 
        filter(!is.na(temps))
    }
    
    ggplotly(ggplot(to_use, aes(temps, fill = temps)) +
               geom_bar(position= "identity") +
               labs(x = "Période",
                    y = "Nombre de stage",
                    fill = "Durée de stage")+
               #order(c("<1jour","1jour-1semaine","1semaine-1mois","1mois-2mois",">2 mois","1mois-2mois")	
               #)+	
               theme(legend.position="none",
                     axis.text.x = element_text(angle = 45, hjust = 1))	
             +scale_fill_manual(values=c("#1f73bb","#209b7f","#f2af1a","#7f549c","#6d6e72"))
    )
  })
  
  ### Cartographie
  
  output$map <- renderLeaflet({
    m
  })
  
  
  output$map_fr <- renderLeaflet({
    m_dep 
  })
  
  # output$t_dep<- renderD3tree2({
  #   d3tree2(dep)
  #   })
  # 
  # output$t_etab <- renderD3tree2({
  #   d3tree2(etab)
  # })
  
  
  # TABLEAU RECOMMANDATIONS
  # TABLEAU RECOMMANDATIONS
  
  choixcycle <-reactive({
    data %>% filter(ufr == input$id_UFR2 )
    
  })
  
  observeEvent(input$id_UFR2, { 
    a <- choixcycle()
    liste=unique(a$cycle)
    update_material_dropdown(session,
                             input_id = "niveau",
                             choices=liste,
                             value=liste[1])
  })
  
  
  choixcomposante <-reactive({
    data %>% filter(cycle == input$niveau )
  })
  
  observeEvent(input$niveau, { 
    a <- choixcomposante()
    liste=unique(a$Libellecomposante)
    update_material_dropdown(session,
                             input_id = "compo2",
                             choices=liste,value=liste[1])
  })
  
  
  
  
  
  choixpays <-reactive({
    data %>% filter(Libellecomposante == input$compo2 )
    
  })
  
  observeEvent(input$niveau, { 
    a <- choixpays()
    liste=unique(a$Paysetablissement)
    update_material_dropdown(session,
                             input_id = "lieu_stage",
                             choices=liste,
                             value=liste[1])
  })
  
  
  #   tps <-reactive({
  #    data %>%
  #     filter(ufr == input$id_UFR2,
  #           cycle == input$niveau,
  #          Paysetablissement == input$lieu_stage#,
  #             Libellecomposante == input$compo2
  #      )
  # #   
  # # })
  
  #choixcomposante <-reactive({
  # data %>% filter(cycle == input$niveau )
  
  #})
  
  #observeEvent(input$niveau, { 
  # a <- choixcomposante()
  #  liste=unique(a$Libellecomposante)
  #  update_material_dropdown(session,input_id = "compo2", choices=liste,value=liste[1])
  #})
  
  #toshow3$Pays = as.factor(toshow3$Pays)
  #toshow3$`Numéro siret` = as.factor(toshow3$`Numéro siret`)
  
  output$plot2 <- DT::renderDataTable(
    
    data_ufr %>% 
      filter(ufr == input$id_UFR2,
             cycle == input$niveau,
             Paysetablissement == input$lieu_stage) %>%
      select(Nometablissement,
             Paysetablissement,
             CodeDepartement,
             Numsiret,
             Libellenaf,
             #Typeconvention,
             Indemnisation) %>% 
      group_by(Nometablissement,
               Paysetablissement,
               CodeDepartement,
               Numsiret,
               Libellenaf,
               #Typeconvention,
               Indemnisation )%>% 
      summarise(`Nombre de stages`=n())%>% 
      arrange(desc(`Nombre de stages`)) %>%
      rename(
        #`Type convention` = Typeconvention,
        #URF= ufr,
        #Durée = Dureestageenheures,
        #Origine = Originestage,
        #Année = Anneeunivconvention,
        Etablissement =  Nometablissement,
        #Composante = Libellecomposante,
        #Cycle = cycle,
        Pays = Paysetablissement,
        Département = CodeDepartement,
        `Numéro siret` = Numsiret,
        `Secteur d'activité`=Libellenaf)
  )
  
  
  

  
})