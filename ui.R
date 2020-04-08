library(shinydashboard)
library(DT)
library(shinymaterial)
library(plotly)
library(leaflet)



material_page(
  tags$head(tags$link(rel="stylesheet", type="text/css", href="style.css")),
  
  
  
  nav_bar_color = "#ffe082 amber lighten-3",

  #title = HTML('<img src="img/logo-orange-vf2.png" alt="Smiley face" height="50" width="50"> Paul In'),
  #tags$div(id = "header", tags$img(id="logo", src="img/logo-orange-vf2.png")), 
  # je sais que ça va pas mais il m'emmerde ce fucking logo --'

  include_nav_bar = TRUE,
  
  
  # Place side-nav in the beginning of the UI
  material_side_nav(
    fixed = FALSE, 
    br(),
    br(),
    material_row(
      material_column(
        offset = 1,
        width = 12,
      material_checkbox(
        input_id = "c1",
        label = "Stage obligatoire",
        initial_value = TRUE,
        color = "#209b7f"
      ),
      material_checkbox(
        input_id = "c2",
        label = "Stage facultatif",
        initial_value = TRUE,
        color = "#209b7f"
      )
      
    )),
    tags$br(),
    
    material_row(
      material_column(
        offset = 1,
        material_radio_button(input_id = "cycle",
                              label = "Niveau",
                              choices = c("DU",
                                          "DUT",
                                          "Licence",
                                          "LP",
                                          "Master",
                                          "Mobilité",
                                          "Doctorat"),
                              selected = "Licence",
                              with_gap = TRUE)
      )
      
    ),
    
    
    material_row(
      material_column(
        offset = 1,
        material_dropdown(
          input_id = "ufr",
          label = "UFR",
          choices = c("UFR1",
                      "UFR2",
                      "UFR3",
                      "UFR4",
                      "UFR5",
                      "UFR6",
                      "Ecole doctorale",
                      "IEF",
                      "ITIC",
                      "RI"
          )
        )
      )
    ),
    
    
  
    material_row(
      material_column(
        width = 12,
      material_dropdown(
      input_id = "compo",
      label = "Composante",
      choices = c("Administration Economique et Social  " , "Aménagement, Géographie MTP  "        ,        "Archéologie et Histoire de l?Art MT  "       
                  , "Arts du spectacle MTP"           ,           "Arts plastiques MTP  "                       
                  , "Département carrières sociales BEZIERS"    ,   "Département carrières sociales MTP"          
                  , "Ethnologie MTP  "             ,                "Etudes anglophones (Montpellier) MT  "       
                  , "Etudes chinoises (Chinois) MTP  "       ,      "Etudes germaniques (Allemand) MTP  "         
                  , "Etudes ibériques & ibéro américaine  "    ,    "Etudes italiennes et de roumain MTP  "       
                  , "Etudes néo-helléniques (Grec-modern  "     ,   "Etudes occitanes MTP  "                      
                  , "Etudes Portugaises, brésiliennes MT  "     ,   "Histoire BEZ  "                              
                  , "Histoire MTP  "                ,               "Information et communication BEZ  "          
                  , "Information et communication MTP  "      ,     "Information et Documentation MTP  "          
                  , "Ingénierie sociale Montpellier"       ,        "Institut d'études françaises pour é  "       
                  , "Institut des technosciences de l'IC  "    ,    "Langues Anciennes BEZ"                       
                  , "Langues Anciennes MTP  "            ,          "Langues et cultures etrangères et régionales"
                  , "Langues étrangères appliquées (LEA)  "    ,    "Langues, littératures, culture, civ  "       
                  , "Lettres modernes BEZ  "          ,             "Lettres modernes MTP  "                      
                  , "Lettres, arts, philosophie, Psychan  "    ,    "Musique MTP  "                               
                  , "Philosophie MTP  "            ,                "Psychanalyse 3° cycle MTP  "                 
                  , "Psychologie BEZ  "              ,              "Psychologie MTP  "                           
                  , "Sciences de l'éducation MTP"          ,        "Sciences du Langage MTP  "                   
                  , "Sciences du sujet et de la société"      ,     "Sciences éco , mathématiques et soc  "       
                  , "Sciences humaines et de l'environne  "    ,    "Service des relations international  "       
                  , "Sociologie MTP  "                ,             "Territoires, temps, sociétés et dvp  "       
                  , "UFR 6"    ,"Toutes les composantes"),
      
      
      color = "green"
    )))
    
 

  ),
  
  # Define tabs
  material_tabs(
    color = "Moccasin",
    tabs = c(
      "Accueil" = "accueil",
      "Stage" = "stage",
      "Stagiaire"= "stagiaire",
      "Cartographie"= "carto",
      "Recherche" = "recherche"
      
      
    )
  ),
  
  
  # Define tab content
  material_tab_content(
    offset = 1,
    tab_id = "first_tab"),
  
  
  
  
  # Define side-nav tab content
  material_tab_content(
    tab_id = "accueil",
    
    
    material_row(
      material_column(
        width = 12,
        tags$div(id = "fond", checked = NA,
                 tags$p(class="accueil", tags$img(id="logo2",src="img/logo2.png")),
                 tags$p(class="accueil", tags$img(id="barre",src="img/barre.jpg")),
                 tags$p(class="accueil", id="SCUIO", "SCUIO-IP"),
                 tags$p(class="accueil", "Vous accompagne dans vos recherches de stage")
                 
        ),
        
      )
    )
    

  ),
  
  
  
  
  
  material_tab_content(
    offset = 1,
    tab_id = "stage",
    #tags$br(),
    material_row(
      material_column(
        width = 10,
        
        offset = 1,
        material_card(
          
          # SELECTION COMPOSANTE
          
          material_column(
            width = 6

          )
          
          # # SELECTION FILIERE
          # 
          # material_column(
          #   width = 6,
          #   material_dropdown(
          #     input_id = "filiere",
          #     label = "Filière", 
          #     choices = sort(unique(data$Filiere)),
          #     color = "blue"
          #   )
          # ),
          
          # SELECTION TYPE CONVENTION
          
          
          
          # # SELECTION ANNEE
          # 
          # material_slider(
          #   input_id = "from_year",
          #   label = "From Year",
          #   min_value = 2014,
          #   max_value = 2018,
          #   initial_value = 2016,
          #   color = "blue"
          # ),
          # material_slider(
          #   input_id = "to_year",
          #   label = "Through Year",
          #   min_value = 2014,
          #   max_value = 2018,
          #   initial_value = 2016,
          #   color = "blue"
          # )
        ),
        
        
        material_card(
          title = "Stages effectués par les étudiants",
          
          # GRAPHIQUE EVO NB STAGE
          
          material_row(
            material_column(
              width = 6,
              material_card(
                title="Evolution du nombre de stages effectués",
                plotlyOutput("nbstage")
              )
            ),
            
            
            material_column(
              width = 6,
              material_card(
                title="Origine du stage",
                plotlyOutput("origine")
              )
            ),
            
            # GRAPHIQUE EVO TYPE CONVENTION
            
            material_column(
              width = 6,
              material_card(
                title = "Evolution du type de convention",
                plotlyOutput("p1")
              )
            ),
            
            # GRAPHIQUE PART STAGE FACULTATIFS
            
            material_column(
              width = 6,
              material_card(
                title = "Part des stages facultatifs",
                plotlyOutput("taux")
              )
            )
          )
          
        ),
        
        material_card(
          title = "Caractéristiques techniques des stages effetués",
          
          material_row(
            material_column(
              width = 6,
              material_card(
                title = "Durée",
                plotlyOutput("duree")
              )
            ),
            
            # GRAPHIQUE EVO STAGE ETRANGER
            
            material_column(
              width = 6,
              material_card(
                title = "Indemnisation",
                plotlyOutput("indem")
              )
            )
          )
          
        ),
        
        
        # GRAPHIQUE TOP 10 ENTREPRISES
        
        material_card(
          title = "Principaux employeurs",
          
          material_row(
            material_column(
              width = 12,
              material_card(
                title = "Top 10 des entreprises qui recrutent le plus de stagiaires",
                plotlyOutput("entre")
              )
            )
          )
        ),
        
        # GRAPHIQUE PAYS TOP 10
        
        material_card(
          title = "Stages à l'étranger",
          
          material_row(
            material_column(
              width = 6,
              material_card(
                title = "Top 10 des pays préférés",
                plotlyOutput("pays")
              )
            ),
            
            # GRAPHIQUE EVO STAGE ETRANGER
            
            material_column(
              width = 6,
              material_card(
                title = "Evolution des stages à l'étranger",
                plotlyOutput("tauxetr")
              )
            )
          )
          
        )
      )
    )
  )
  
  
  
  
 ,
  
  
  material_tab_content(
    offset = 1,
    tab_id = "stagiaire",
    material_row(
      material_column(
        width = 10,
        offset = 1,
        material_row(
          material_column(
            width = 3,
            material_card(title = HTML("<strong><center> +35% </center></strong>"),
                          HTML("</center>Ont effectué plus de 2 stages</center>") ,
                          color = "#f5f5f5 grey lighten-4",
                          depth = 5)
          ),
          material_column(
            width = 3,
            material_card(title = HTML("<strong><center> +39% </center></strong>"), 
                          HTML("<center>En Licence</center>"),
                          color = "#f5f5f5 grey lighten-4", 
                          depth = 5)
          ),
          material_column(
            width = 3,
            material_card(title = HTML("<strong><center> +43% </center></strong>"), 
                          HTML("<center>Candidature spontanée</center>"),
                          color = "#f5f5f5 grey lighten-4",
                          depth = 5)
          ),
          material_column(
            width = 3,
            material_card(title = HTML("<strong><center> +12 </center></strong>"), 
                          HTML("<center> stages effectués par un étudiant</center>"),
                          color = "#f5f5f5 grey lighten-4",
                          depth = 5)
          )
        ),
        material_row(
          material_column(
            width = 12,
            material_card(
              title = "Distribution des stages en fonction du cycle universitaire",
              divider = TRUE,
              plotlyOutput("p2")
            ),
            material_card(
              title = "Distribution des stages en fonction de la composante",
              divider = TRUE,
              plotlyOutput("p3")
            ),
            material_card(
              title = "Distribution des stages en fonction de l'UFR",
              divider = TRUE,
              plotlyOutput("p4")
            )
          )
        )
      )
    )
    
    
    
  ),
  material_tab_content(
    offset = 1,
    tab_id = "recherche",
    material_row(
      material_column(
        width = 10,
        offset = 1,
        dataTableOutput("plot")
        
      )
    )
  ),
  
  material_tab_content(
    tab_id = "carto",
    offset = 1,
    material_card(
      leafletOutput("map")
    ),
    material_card(
      title = "carte département"
      #leafletOutput("map_fr")
      
    )
    
   
  )
)

