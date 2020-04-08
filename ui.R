library(shinydashboard)
library(DT)
library(shinymaterial)
library(plotly)
library(leaflet)



material_page(
  title = "Paul In",
  #nav_bar_color = "pink",
  #data= read.csv2("data/donnees.csv", stringsAsFactors = FALSE),
  # nav_bar_fixed = TRUE,
  # include_fonts = TRUE,
  # Place side-nav in the beginning of the UI
  material_side_nav(
    fixed = FALSE, 
    image_source = "img/material.png",
    # Place side-nav tabs within side-nav
    material_side_nav_tabs(
      side_nav_tabs = c(
        "Accueil" = "accueil",
        "Stage" = "vis1",
        "Stagiaire" = "vis2",
        "Cartographie" = "carto",
        "Recherche" = "liste_stage"
      ),
      icons = c("code", "insert_chart", "insert_chart", "explore", "explore")
    )
  ),
  
  # Define tabs
  material_tabs(
    tabs = c(
      "Accueil" = "accueil",
      "Recherche" = "recherche",
      "Stage" = "stage",
      "Stagiaire"= "stagiaire",
      "Cartographie"= "carto"
      
      
    )
  ),
  # Define tab content
  material_tab_content(
    tab_id = "first_tab"),

  
  
  
  # Define side-nav tab content
  material_tab_content(
    tab_id = "accueil",
    material_parallax(
      image_source = "img/siora-photography-hgFY1mZY-Y0-unsplash.jpg"
    ),
    material_card(title= "Something",
                  br(),
                  br(),
                  br(),
                  br(),
                  br(),
                  br(),
                  br(),
                  br(),
                  depth = 5),
    material_parallax(
      image_source = "img/john-schnobrich-2FPjlAyMQTA-unsplash.jpg"
    ),
    material_card(title= "Something",
                  br(),
                  br(),
                  br(),
                  depth = 5)
    
    

  ),
  material_tab_content(
    tab_id = "stage",
    #tags$br(),
    material_row(
      material_column(
        width = 10,
        
        offset = 1,
        material_card(
          
          # SELECTION COMPOSANTE
          
          material_column(
            width = 6,
            material_dropdown(
              input_id = "compo",
              label = "Composante", 
              choices = c(   "Administration Economique et Social  "       
                             , "Aménagement, Géographie MTP  "        ,        "Archéologie et Histoire de l?Art MT  "       
                             , "Arts du spectacle MTP  "           ,           "Arts plastiques MTP  "                       
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
              color = "blue"
            )
          ),
          
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
          
          # GRAPHIQUE EVO TYPE CONVENTION
          
          material_row(
            material_column(
              width = 12,
              material_card(
                title = "Type de convention",
                plotlyOutput("p1")
              )
            ),
            
            # GRAPHIQUE EVO NB STAGE
            
            material_column(
              width = 6,
              material_card(
                title = "Evolution du nombre de stages effectués",
                plotlyOutput("nbstage")
              )
            ),
            
            # GRAPHIQUE PART STAGE FACULTATIFS
            
            material_column(
              width = 6,
              material_card(
                title = "Part des stages facultatifs",
                plotlyOutput("facultatif")
              )
            )#,
          #  material_column(
             # width = 12,
            #  material_card(
              #  title = "Evolution du nombre de stages effectués",
             #   plotlyOutput("")
            #  )
           # )
            
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
        material_card(
          title = "Durée des stages",
          
          material_row(
            material_column(
              width = 12,
              material_card(
                title = "Répartition des stages selon leur durée",
                plotlyOutput("duree")
              )
            )
          )
        ),
        material_card(
          title = "Indemnisation des stages",
          
          material_row(
            material_column(
              width = 12,
              material_card(
                title = "Proportion de stages indemnisés",
                plotlyOutput("indem")
              )
            )
          )
        )
      )
    )
  )
  
  
  
  
 ,
  
  
  material_tab_content(
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
    leafletOutput("map")
    
  )
)

