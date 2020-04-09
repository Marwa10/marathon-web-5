library(shinydashboard)
library(DT)
library(shinymaterial)
library(plotly)
library(leaflet)
#library(d3treeR)



material_page(
  tags$head(tags$link(rel="stylesheet", type="text/css", href="style.css")),
  #nav_bar_color = "#ffe082 amber lighten-3",
  #nav_bar_color = "#bdbdbd grey lighten-1",
  nav_bar_color = "#eeeeee grey lighten-2",
  title = HTML('<img src="img/logo-orange-vf2.png" alt="logo" id = "img_logo"><span id ="titre">Paul In </span>'),
  # tags$div(id = "header", tags$img(id="logo", src="img/logo-orange-vf2.png")), 
  # je sais que ça va pas mais il m'emmerde ce fucking logo --'

  include_nav_bar = TRUE,
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
    material_row(
      material_column(
        offset = 1,
        material_slider(input_id = "start_year",
                        label = "Start",
                        min_value = 2014,
                        max_value = 2018,
                        step_size = 1,
                        initial_value = 2016,
                        color = NULL),
        material_slider(input_id = "end_year",
                        label = "End",
                        min_value = 2014,
                        max_value = 2018,
                        step_size = 1,
                        initial_value = 2016,
                        color = NULL)
      )
    ),
    
    tags$br(),
    
    material_row(
      material_column(
        offset = 1,
        material_radio_button(input_id = "id_cycle",
                              label = "Cursus",
                              choices = c("DU/DUT",
                                          "Licence",
                                          "LP",
                                          "Master",
                                          "Doctorat"),
                              selected = "Licence",
                              with_gap = TRUE)
      )
      
    ),
    
    
    material_row(
      material_column(
        offset = 1,
        material_dropdown(
          input_id = "id_ufr",
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
          ),
          selected = "UFR5"
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
          selected = "Toutes les composantes",
          
          
          color = "green"
        )))
  ),
  
  
  # Define tabs
  material_tabs(
    #color = "Moccasin",
    color = "black",
    tabs = c(
      "Accueil" = "accueil",
      "Stages" = "stage",
      "Profil des stagiaire"= "stagiaire",
      "Cartographie"= "carto",
      "Recherche" = "recherche",
      "Trouves ton stage" = "test"
      
      
    )
  ),
  
  
  # material_tab_content(
  #   tab_id = "exemple"),
  
  
  
  # Define side-nav tab content
  material_tab_content(
    tab_id = "accueil",
    
    # material_row(
    #   material_column(
    #     offset = 0.5,
    #     width = 12,
      
    material_card( 
      #Fond1     
      material_row(
        material_column(
          width = 12,
          tags$div(id = "fond1", checked = NA,
                   tags$p(class="accueil", tags$img(id="logo2",src="img/logo2.png")),
                   tags$br(""),
                   tags$p(class="accueil", tags$img(id="barre",src="img/barre.jpg")),
                   tags$p(class="accueil", class="titre", "SCUIO-IP"),
                   tags$p(class="accueil", "Vous accompagne dans vos recherches de stage")
          ))),
      
      
      #Fond2      
      material_row(
        material_column(
          width = 12,
          tags$div(id = "fond2", checked = NA,
                   tags$p(class="accueil", "STAGES"),
                   tags$p(class="accueil", class="titre","Envie d'en découvrir davantage?"),
                   tags$p(class="accueil", tags$img(id="barre",src="img/barre.jpg")),
                   tags$div(class="accueil",id="cases", 
                            tags$div(class="case",tags$p(class="chiffre","4408"),tags$p("Stages réalisés"),tags$p("en 2018")),
                            tags$div(class="case",tags$p(class="chiffre","413"),tags$p("Stages réalisés à l'étranger"),tags$p("en 2018")),
                            tags$div(class="case",tags$p(class="chiffre","332"),tags$p("Stages réalisés avec l'organisme d'accueil Université Paul Valery Montpellier 3"))),
                   tags$p(class="accueil", "Les stages sont une grande question en début de parcours professionnel."),
                   tags$p(class="accueil", "En cliquant sur l'onglet Stages, constatez les données informatives et les statistiques que nous avons récoltées sur l'ensemble des stages.")
                   
          ))),
      
      #Fond3 
      material_row(
        material_column(
          width = 12,
          tags$div(id = "fond3", checked = NA,
                   tags$p(class="accueil", "STAGES"),
                   tags$p(class="accueil", class="titre","Envie d'en découvrir davantage?"),
                   tags$p(class="accueil", tags$img(id="barre",src="img/barre.jpg")),
                   tags$div(class="accueil",id="cases", 
                            tags$div(class="case",tags$p(class="chiffre","4408"),tags$p("Stages réalisés"),tags$p("en 2018")),
                            tags$div(class="case",tags$p(class="chiffre","413"),tags$p("Stages réalisés à l'étranger"),tags$p("en 2018")),
                            tags$div(class="case",tags$p(class="chiffre","332"),tags$p("Stages réalisés avec l'organisme d'accueil Université Paul Valery Montpellier 3"))),
                   tags$p(class="accueil", "Les stages sont une grande question en début de parcours professionnel."),
                   tags$p(class="accueil", "En cliquant sur l'onglet Stages, constatez les données informatives et les statistiques que nous avons récoltées sur l'ensemble des stages.")
                   
          )))  
      
    ),
    
    
    
    #Footer    
    material_column(
      width = 12,
      tags$a(id = "footer", checked = NA,
             tags$img(id="logo",src="img/logo-orange-vf2.png"),
             tags$p(class="footer","Route de Mende 34199 Montpellier Cedex 5 Standard de l'Université : 04 67 14 20 00")
             
      ))
    
  )
 # ))
,
  
  
  
  
  
  material_tab_content(
    offset = 1,
    tab_id = "stage",
    #tags$br(),
    material_row(
      material_column(
        width = 10,
        
        offset = 1,
        material_card(
          title = "Les stages et leurs caractéristiques",
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
            
            # GRAPHIQUE EVO STAGE ETRANGER
            
            material_column(
              width = 6,
              material_card(
                title = "Indemnisation",
                plotlyOutput("indem")
              )
            ),
            material_column(
              width = 6,
              material_card(
                title = "Durée de stage",
                plotlyOutput("p5")
              )
              
            )
          )
          
        ),
        
        
        # GRAPHIQUE TOP 10 ENTREPRISES
        
        material_card(
          title = "Employeurs",
          
          material_row(
            material_column(
              width = 12,
              material_card(
                title = "Les entreprises ayant recruté des stagiaires",
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
            material_card(title = HTML("<strong><center>20 334</center></strong>"),
                          HTML("</center> stages effectués depuis 2014 </center>") ,
                          #color = "#f5f5f5 grey lighten-4",
                          #depth = 5,
                          color = "white",
                          depth = 3)
          ),
          material_column(
            width = 3,
            material_card(title = HTML("<strong><center> 1,53 </center></strong>"), 
                          HTML("<center> stages en moyenne par étudiant </center>"),
                          color = "white",
                          depth = 3)
            
            
          ),
          material_column(
            width = 3,
            material_card(title = HTML("<strong><center> 43% </center></strong>"), 
                          HTML("<center>de candidature spontanée</center>"),
                          color = "white",
                          depth = 3)
          ),
          material_column(
            width = 3,
            material_card(title = HTML("<strong><center> 19,4% </center></strong>"), 
                          HTML("<center> de stages facultatifs </center>"),
                          color = "white",
                          depth = 3)
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
              title = "Distribution des stages en fonction de l'UFR",
              divider = TRUE,
              plotlyOutput("p4")
            ),
            material_card(
              title = "Distribution des stages en fonction de la composante",
              divider = TRUE,
              plotlyOutput("p3")
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
    material_row(
      material_column(
        offset = 1,
        width = 10,
        material_card(
          title = "Stages en France",
          leafletOutput("map_fr")
    ))),
    material_row(
      material_column(
        offset = 1,
        width = 10,
        material_card(
          title = "Stages à l'étranger", 
          leafletOutput("map")
        )
      )
    )
    # material_row(
    #   material_column(
    #     offset = 1,
    #     width = 10,
    #     d3tree2Output("t_dep")
    #   )
    # ),
    # material_row(
    #   material_column(
    #     offset = 1,
    #     width = 10,
    #     d3tree2Output("t_etab")
    #     
    #   )
    # )
  ),

material_tab_content(
  tab_id = "test",
  material_row(
    material_column(
      offset = 1,
      width = 10,
      material_card(
        title = "Je trouve mon stage grâce à Paul In"#,
        #leafletOutput("map_fr")
      ))),
  material_row(
    material_column(
      offset = 1,
      width = 10,
      material_dropdown(
        input_id = "id_UFR2",
        label = "Mon UFR",
        choices = c("UFR1",
                    "UFR2",
                    "UFR3",
                    "UFR4",
                    "UFR5",
                    "UFR6",
                    "Ecole doctorale",
                    "IEF",
                    "ITIC",
                    "RI"),
       # selected = "Tous",
        
        
        color = "green"
      )
    
  ),
  
  material_column(
    offset = 1,
    width = 10,
    material_dropdown(
      input_id = "niveau",
      label = "Mon niveau",
      choices = c("AUTRE (pluri?)"   , "Doctorat"  ,     "DU"       ,      "DUT"        ,    "Licence"   ,     "LP"            
                  , "Master"     ,    "Mobilit?"),
      selected = "Master",
      
      
      color = "green"
    )
    
  ),
    material_column(
      offset = 1,
      width = 10,
      material_dropdown(
        input_id = "compo2",
        label = "Ma composante",
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
        selected = "Toutes les composantes",
        
        
        color = "green"
      )
    ),
  material_column(
    offset = 1,
    width = 10,
    material_dropdown(
      input_id = "lieu_stage",
      label = "Envie d'un stage à l'étranger ?",
      choices=c(  "ACORES, MADERE"             ,              "AFRIQUE DU SUD"                          
                  , "ALGERIE"                       ,           "ALLEMAGNE"                               
                  , "ANDORRE"                       ,           "ANTILLES NEERLANDAISES"                  
                  , "ARABIE SAOUDITE"         ,                 "ARGENTINE"                               
                  , "ARMENIE"                       ,           "AUSTRALIE"                               
                  , "AUTRICHE"                     ,            "AZERBAIDJAN"                             
                  , "BELGIQUE"                      ,           "BENIN"                                   
                  , "BOLIVIE, l'ETAT PLURINATIONAL DE"    ,     "BOSNIE-HERZEGOVINE"                      
                  , "BRESIL"                       ,            "BULGARIE"                                
                  , "BURKINA FASO"         ,                    "CAMBODGE"                                
                  , "CAMEROUN"              ,                   "CANADA"                                  
                  , "CHILI"                        ,            "CHINE"                                   
                  , "CHYPRE"                   ,                "COLOMBIE"                                
                  , "COMORES"                ,                  "CONGO"                                   
                  , "CONGO, LA REPUBLIQUE DEMOCRATIQUE DU"   ,  "COREE, REPUBLIQUE DE"                    
                  , "COSTA RICA"               ,                "COTE D'IVOIRE"                           
                  , "CROATIE"                      ,            "CUBA"                                    
                  , "DANEMARK"                  ,               "DJIBOUTI"                                
                  , "DOMINICAINE, REPUBLIQUE"      ,            "DOMINIQUE"                               
                  , "EGYPTE"                   ,                "EMIRATS ARABES UNIS"                     
                  , "ESPAGNE"                 ,                 "ESTONIE"                                 
                  , "ETATS-UNIS"              ,                 "ETHIOPIE"                                
                  , "FINLANDE"                  ,               "FRANCE"                                  
                  , "GABON"                        ,            "GEORGIE"                                 
                  , "GHANA"                         ,           "GRECE"                                   
                  , "GUADELOUPE"              ,                 "GUATEMALA"                               
                  , "GUINEE"                          ,         "GUYANE FRANCAISE"                        
                  , "HAITI"                             ,       "HONG-KONG"                               
                  , "HONGRIE"                     ,             "ILE DE MAN"                              
                  , "ILES VIERGES BRITANNIQUES"     ,           "INDE"                                    
                  , "INDONESIE"                    ,            "IRAN, REPUBLIQUE ISLAMIQUE D'"           
                  , "IRLANDE"                  ,                "ISRAEL"                                  
                  , "ITALIE"                         ,          "JAPON"                                   
                  , "JERSEY"                       ,            "JORDANIE"                                
                  , "KAZAKHSTAN"              ,                 "KENYA"                                   
                  , "KOWEIT"                       ,            "LAO, REPUBLIQUE DEMOCRATIQUE POPULAIRE"  
                  , "LESOTHO"                     ,             "LETTONIE"                                
                  , "LIBAN"                             ,       "LITUANIE"                                
                  , "LUXEMBOURG"               ,                "MACEDOINE, L'EX-REPUBLIQUE YOUGOSLAVE DE"
                  , "MADAGASCAR"                ,               "MALI"                                    
                  , "MALTE"                            ,        "MAROC"                                   
                  , "MARTINIQUE"                  ,             "MAURICE"                                 
                  , "MAURITANIE"                   ,            "MAYOTTE"                                 
                  , "MEXIQUE"                        ,          "MOLDOVA, REPUBLIQUE DE"                  
                  , "MONACO"                          ,         "MONGOLIE"                                
                  , "MYANMAR (BIRMANIE)"       ,                "NICARAGUA"                               
                  , "NORVEGE"                          ,        "NOUVELLE-CALEDONIE"                      
                  , "NOUVELLE-ZELANDE"          ,               "PANAMA"                                  
                  , "PARAGUAY"                     ,            "PAYS-BAS"                                
                  , "PEROU"                         ,           "PHILIPPINES"                             
                  , "POLOGNE"                     ,             "POLYNESIE FRANCAISE"                     
                  , "PORTUGAL"                    ,             "QATAR"                                   
                  , "REUNION"                        ,          "ROUMANIE"                                
                  , "ROYAUME-UNI"                ,              "RUSSIE, FEDERATION DE"                   
                  , "SENEGAL"                     ,             "SERBIE"                                  
                  , "SINGAPOUR"                 ,               "SLOVAQUIE"                               
                  , "SLOVENIE"                      ,           "SRI LANKA"                               
                  , "SUEDE"                             ,       "SUISSE"                                  
                  , "SYRIENNE, REPUBLIQUE ARABE"      ,         "TAIWAN, PROVINCE DE CHINE"               
                  , "TANZANIE, REPUBLIQUE-UNIE DE"      ,       "TCHEQUE, REPUBLIQUE"                     
                  , "THAILANDE"                        ,        "TOGO"                                    
                  , "TRINITE-ET-TOBAGO"         ,               "TUNISIE"                                 
                  , "TURQUIE"                      ,            "UKRAINE"                                 
                  , "URUGUAY"                     ,             "VIET NAM"                                
                  , "ZAMBIE"    , "Peu importe !"  ),
      selected = "FRANCE",
      
      
      color = "green"
    )
  ),
  material_column(
    offset = 1,
    width = 10,
    material_text_box(
      input_id = "Motcle",
      label = "Une piste, une idée, un domaine qui me ferait plaisir...",
      
      
      color = "green"
    )
  )
  ), 
  material_tab_content(
    offset = 1,
    tab_id = "test",
    material_row(
      material_column(
        width = 10,
        offset = 1,
        dataTableOutput("plot2")
        
      )
    )
  )
)
)

