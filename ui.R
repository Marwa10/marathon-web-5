library(shinydashboard)
library(DT)
library(shinymaterial)
library(plotly)
library(leaflet)
#library(d3treeR)



material_page(
  tags$head(tags$link(rel="stylesheet", type="text/css", href="style.css")),
  nav_bar_color = "#ffe082 amber lighten-1",
  #nav_bar_color = "#bdbdbd grey lighten-1",
  
  title = HTML('<span id ="titre">Paul In </span>'),
  
  
  #include_nav_bar = TRUE,
  
  
  #Menu des filtres #### 
  material_side_nav(
    fixed = FALSE, 
    br(),
    br(),
    
    material_row(
      material_column(
    material_switch(
      input_id="activation", label="Filtrage des données", off_label = "OFF", on_label = "ON",
                    initial_value = FALSE, color = NULL
                    )
      )),
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
                              with_gap = TRUE,
                              color = "green")
      )
      
    ),
    
    
    material_row(
      material_column(
        offset = 1,
        material_dropdown(
          input_id = "id_ufr",
          label = "UFR",
          choices = NULL,
          color = "green"
        )
      )
    ),
    
    
    
    material_row(
      material_column(
        width = 12,
        material_dropdown(
          input_id = "compo",
          label = "Composante",
          # choices = c("Administration Economique et Social  " , "Aménagement, Géographie MTP  "        ,        "Archéologie et Histoire de l?Art MT  "       
          #             , "Arts du spectacle MTP"           ,           "Arts plastiques MTP  "                       
          #             , "Département carrières sociales BEZIERS"    ,   "Département carrières sociales MTP"          
          #             , "Ethnologie MTP  "             ,                "Etudes anglophones (Montpellier) MT  "       
          #             , "Etudes chinoises (Chinois) MTP  "       ,      "Etudes germaniques (Allemand) MTP  "         
          #             , "Etudes ibériques & ibéro américaine  "    ,    "Etudes italiennes et de roumain MTP  "       
          #             , "Etudes néo-helléniques (Grec-modern  "     ,   "Etudes occitanes MTP  "                      
          #             , "Etudes Portugaises, brésiliennes MT  "     ,   "Histoire BEZ  "                              
          #             , "Histoire MTP  "                ,               "Information et communication BEZ  "          
          #             , "Information et communication MTP  "      ,     "Information et Documentation MTP  "          
          #             , "Ingénierie sociale Montpellier"       ,        "Institut d'études françaises pour é  "       
          #             , "Institut des technosciences de l'IC  "    ,    "Langues Anciennes BEZ"                       
          #             , "Langues Anciennes MTP  "            ,          "Langues et cultures etrangères et régionales"
          #             , "Langues étrangères appliquées (LEA)  "    ,    "Langues, littératures, culture, civ  "       
          #             , "Lettres modernes BEZ  "          ,             "Lettres modernes MTP  "                      
          #             , "Lettres, arts, philosophie, Psychan  "    ,    "Musique MTP  "                               
          #             , "Philosophie MTP  "            ,                "Psychanalyse 3° cycle MTP  "                 
          #             , "Psychologie BEZ  "              ,              "Psychologie MTP  "                           
          #             , "Sciences de l'éducation MTP"          ,        "Sciences du Langage MTP  "                   
          #             , "Sciences du sujet et de la société"      ,     "Sciences éco , mathématiques et soc  "       
          #             , "Sciences humaines et de l'environne  "    ,    "Service des relations international  "       
          #             , "Sociologie MTP  "                ,             "Territoires, temps, sociétés et dvp  "       
          #             , "UFR 6"    ,"Toutes les composantes"),
          #selected = "Toutes les composantes",
          choices = NULL,
          color = "green"
        )))
  ),
  
  
  #Menu de navigation ####  
  
  material_tabs(
    #color = "Moccasin",
    color = "black",
    tabs = c(
      "Accueil" = "accueil",
      "Stage" = "stage",
      "Profil des stagiaires"= "stagiaire",
      "Cartographie"= "carto",
      "Recherche" = "recherche",
      "Trouve ton stage" = "test",
      "Contact" = "contact",
      "FAQ" = "FAQ"
      
      
    )
  ),
  
  
  #Onglet Accueil ####
  
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
                   tags$p(class="accueil", tags$img(id="logo2",src="img/logo3.png")),
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
                   tags$p(class="accueil", class="tete","STAGES"),
                   tags$p(class="accueil", class="titre2","Envie d'en découvrir davantage?"),
                   tags$p(class="accueil", tags$img(id="barre",src="img/barre2.jpg")),
                   tags$div(class="accueil",id="cases", 
                            tags$div(class="case",tags$p(class="chiffre","4 408"),tags$p("Stages réalisés"),tags$p("en 2018")),
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
                   tags$p(class="accueil", class="tete","PROFIL DES STAGIAIRES"),
                   tags$p(class="accueil", class="titre2","Les stagiaires au coeur des statistiques"),
                   tags$p(class="accueil", tags$img(id="barre",src="img/barre2.jpg")),
                   tags$div(class="accueil",id="cases", 
                            tags$div(class="case",tags$p(class="chiffre","20 334"),tags$p("Stages effectués"),tags$p("depuis 2014")),
                            tags$div(class="case",tags$p(class="chiffre","1.53"),tags$p("Stages en moyenne"),tags$p("par étudiant")),
                            tags$div(class="case",tags$p(class="chiffre","43%"),tags$p("de candidature spontanée")),
                            tags$div(class="case",tags$p(class="chiffre","19.4%"),tags$p("de stages facultatifs"))),
                   tags$p(class="accueil", "Les cycles universitaires, les composantes ainsi que les IFR regorgent d'informations quant à la distribution des stages."),
                   tags$p(class="accueil", "Cliquez sur l'onglet Profil des stagiaires afin d'en savoir plus.")
                   
          ))),
      
      #Fond4 
      material_row(
        material_column(
          width = 12,
          tags$div(id = "fond4", checked = NA,
                   tags$p(class="accueil", class="tete","CARTOGRAPHIE"),
                   tags$p(class="accueil", class="titre2","Visitez le monde à l'aide de notre cartographie"),
                   tags$p(class="accueil", tags$img(id="barre",src="img/barre2.jpg")),
                   tags$p(class="accueil", tags$img(id="carte",src="img/Carto.png")),
                   tags$p(class="accueil", "Découvrez avec l'onglet Cartographie où les étudiants de l'université Paul Valery Montpellier 3 ont voyagé grâce à leur stage, que ce soit à l'étranger ou en France.")
                   
          ))),
      
      #Fond5 
      material_row(
        material_column(
          width = 12,
          tags$div(id = "fond5", checked = NA,
                   tags$p(class="accueil", class="tete","RECHERCHE"),
                   tags$p(class="accueil", class="titre2","Une idée, une entreprise, une recherche ?"),
                   tags$p(class="accueil", tags$img(id="barre",src="img/barre2.jpg")),
                   tags$p(class="accueil", tags$img(id="rech",src="img/Rech.jpg")),
                   tags$p(class="accueil", "L'onglet Recherche vous permet de visualiser le détail des stages réalisés par les étudiants au cours de ces dernières années."),
                   tags$p(class="accueil", "De quoi ne pas vous laisser sur votre faim.")
                   
          ))),
      
      #Fond6 
      material_row(
        material_column(
          width = 12,
          tags$div(id = "fond6", checked = NA,
                   tags$p(class="accueil", class="tete","TROUVE TON STAGE"),
                   tags$p(class="accueil", class="titre2","Tu cherches un stage ?"),
                   tags$p(class="accueil", tags$img(id="barre",src="img/barre2.jpg")),
                   tags$p(class="accueil", tags$img(id="trouve",src="img/Reco.jpg")),
                   tags$p(class="accueil", "Pas toujours évident de savoir où candidater."),
                   tags$p(class="accueil", "Sur l'onglet Trouve ton stage, différents lieux de stage potentiellement adaptés à ton profil te seront proposés.")
                   
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
  
#Onglet Stage ####  
  material_tab_content(
    offset = 1,
    tab_id = "stage",
    #tags$br(),
    material_row(
      material_column(
        width = 10,
        
        offset = 1,
        material_card(
          title = "Les stages et leurs caractéristiques"

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
    ),
    #Footer    
    material_column(
      width = 12,
      tags$a(id = "footer", checked = NA,
             tags$img(id="logo",src="img/logo-orange-vf2.png"),
             tags$p(class="footer","Route de Mende 34199 Montpellier Cedex 5 Standard de l'Université : 04 67 14 20 00")
             
      ))
  ),

  
#Onglet Stagiaires ####  
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
                          depth = 1)
          ),
          material_column(
            width = 3,
            material_card(title = HTML("<strong><center> 1,53 </center></strong>"), 
                          HTML("<center> stages en moyenne par étudiant </center>"),
                          color = "white",
                          depth = 1)
            
            
          ),
          material_column(
            width = 3,
            material_card(title = HTML("<strong><center> 43% </center></strong>"), 
                          HTML("<center>de candidature spontanée</center>"),
                          color = "white",
                          depth = 1)
          ),
          material_column(
            width = 3,
            material_card(title = HTML("<strong><center> 19,4% </center></strong>"), 
                          HTML("<center> de stages facultatifs </center>"),
                          color = "white",
                          depth = 1)
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
    ),
    #Footer    
    material_column(
      width = 12,
      tags$a(id = "footer", checked = NA,
             tags$img(id="logo",src="img/logo-orange-vf2.png"),
             tags$p(class="footer","Route de Mende 34199 Montpellier Cedex 5 Standard de l'Université : 04 67 14 20 00")
             
      ))
    
    
    
  ),


#Onglet Recherche #### 
material_tab_content(
  offset = 1,
  tab_id = "recherche",
  material_row(
    material_column(
      width = 10,
      offset = 1,
      dataTableOutput("plot")
      
    )
  ),
  
  #Footer    
  material_column(
    width = 12,
    tags$a(id = "footer", checked = NA,
           tags$img(id="logo",src="img/logo-orange-vf2.png"),
           tags$p(class="footer","Route de Mende 34199 Montpellier Cedex 5 Standard de l'Université : 04 67 14 20 00")
           
    ))
),

#Onglet Contact  #### 
material_tab_content(
  offset = 1,
  tab_id = "contact",
  
  material_row(
    material_column(
      width = 12,
      tags$div(id = "fondcontact", checked = NA,
               tags$p(class="conta", class="tete","CONTACT"),
               tags$p(class="conta", class="titre3","Une question ?"),
               tags$p(class="conta", tags$img(id="barre",src="img/barre3.jpg")),
               tags$br(""),
               tags$p(class="conta", "Contactez votre service SCUIO-IP"),
               tags$p(class="conta", "du lundi au vendredi"),
               tags$p(class="conta", "de 9h30 � 12h30 et de 14h � 17h"),
               tags$p(class="conta", "(sauf le vendredi apr�s-midi)"),
               tags$br(""),
               tags$p(class="conta", class="adr", "Maison des Etudiants - B�t. U"),
               tags$p(class="conta", class="adr","04 67 14 26 11"),
               tags$p(class="conta", class="adr","scuio@univ-montp3.fr"),
      ))),
  
  #Footer    
  material_column(
    width = 12,
    tags$a(id = "footer", checked = NA,
           tags$img(id="logo",src="img/logo-orange-vf2.png"),
           tags$p(class="footer","Route de Mende 34199 Montpellier Cedex 5 Standard de l'Universit� : 04 67 14 20 00")
           
    ))
  
),

#Onglet FAQ  #### 
material_tab_content(
  offset = 1,
  tab_id = "FAQ",
  
  material_row(
    material_column(
      width = 12,
      tags$div(id = "fondfaq", checked = NA,
               
               tags$div(class="boxfaq",
                        tags$p(class="headfaq","Qui sommes-nous ?"),
                        tags$p(class="parfaq","Ce site est dirig� par le Service Commun Universitaire d'Information, d'Orientation et d'Insertion Professionnelle (SCUIO-IP) de l'Universit� Paul Val�ry 3. Nous accompagnons les �tudiants tout au long de leur projet d'�tudes et d'insertion professionnelle, au m�me titre que les enseignants dans le suivi de recherche de stage des �tudiants. La conception de ce site web nous permet de remplir notre mission : celle d'accro�tre pour les enseignants et administratifs la connaissance et l'aide � la d�cision quant aux stages pour accompagner au mieux ses �tudiants.")
               ),
               
               tags$div(class="boxfaq",
                        tags$p(class="headfaq","A qui s'adresse ce site web ?"),
                        tags$p(class="parfaq","Ce site web s'adresse aux enseignants et administratifs. Il permet de visualiser les tendances des stages, r�alis�s par les �tudiants depuis cinq ans, comme outil de connaissance et d'aide � la d�cision. Chaque enseignant pourra ainsi visualiser les stages des �tudiants, et de ceux de sa fili�re s'il le souhaite.")
               ),
               
               tags$div(class="boxfaq",
                        tags$p(class="headfaq","Je veux contacter un professionnel d'un �tablissement. Comment faire ?"),
                        tags$p(class="parfaq","Vous pouvez vous approcher des personnels du SCUIO-IP qui sauront vous diriger vers l'organisme en question.")
               ),
               
               tags$div(class="boxfaq",
                        tags$p(class="headfaq","A quoi servent les options de filtrage situ�s � gauche de mon �cran ?"),
                        tags$p(class="parfaq","Les filtres situ�s dans le menu, situ� � gauche de votre �cran, s'appliquent sur toutes les pages du site web, except�s sur l'onglet Recherche. En s�lectionnant les param�tres que vous souhaitez, vous pourriez visualiser les graphiques d�finis en fonction de vos choix.")
               )
               
      ))),
  
  #Footer    
  material_column(
    width = 12,
    tags$a(id = "footer", checked = NA,
           tags$img(id="logo",src="img/logo-orange-vf2.png"),
           tags$p(class="footer","Route de Mende 34199 Montpellier Cedex 5 Standard de l'Universit� : 04 67 14 20 00")
           
    ))
),


#Onglet Carto  #### 
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
  ),
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
  
  #Footer    
  material_column(
    width = 12,
    tags$a(id = "footer", checked = NA,
           tags$img(id="logo",src="img/logo-orange-vf2.png"),
           tags$p(class="footer","Route de Mende 34199 Montpellier Cedex 5 Standard de l'Université : 04 67 14 20 00")
           
    ))
  
),

material_tab_content(
  tab_id = "test",
  material_row(
    material_column(
      offset = 1,
      width = 10,
      material_card(
        title = "Je trouve mon stage grâce à Paul In"
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
        selected = "UFR5",
        
        
        color = "green"
      )
      
    ),
    
    material_column(
      offset = 1,
      width = 10,
      material_dropdown(
        input_id = "niveau",
        label = "Mon niveau",
        choices = NULL ,
        #selected = "Master",
        
        
        color = "green"
      )
      
    ),
    #  material_column(
    #  offset = 1,
    # width = 10,
    #  material_dropdown(
    #     input_id = "compo2",
    #      label = "Ma composante",
    # choices = NULL,
    #  #selected = "Toutes les composantes",
    
    
    #   color = "green"
    #  )
    # ),
    material_column(
      offset = 1,
      width = 10,
      material_dropdown(
        input_id = "lieu_stage",
        label = "Envie d'un stage à l'étranger ?",
        choices=NULL,
        #selected = "FRANCE",
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
  ),
  #Footer    
  material_column(
    width = 12,
    tags$a(id = "footer", checked = NA,
           tags$img(id="logo",src="img/logo-orange-vf2.png"),
           tags$p(class="footer","Route de Mende 34199 Montpellier Cedex 5 Standard de l'Université : 04 67 14 20 00")
           
    ))
)
)

