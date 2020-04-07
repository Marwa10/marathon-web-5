library(shinydashboard)
library(DT)
library(shinymaterial)
library(plotly)



material_page(
  title = "Paul In",
  nav_bar_color = "pink",
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
        "Vis1" = "vis1",
        "Vis2" = "vis2",
        "Liste des stages" = "liste_stage"
      ),
      icons = c("code", "insert_chart", "insert_chart", "explore")
    )
  ),
  # Define side-nav tab content
  material_side_nav_tab_content(
    side_nav_tab_id = "accueil",
    tags$br()

  ),
  material_side_nav_tab_content(
    side_nav_tab_id = "vis1",
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
              choices = sort(unique(data$Libellecomposante)),
              color = "blue"
            )
          ),
          
          # SELECTION FILIERE
          
          material_column(
            width = 6,
            material_dropdown(
              input_id = "filiere",
              label = "Filière", 
              choices = sort(unique(data$Filiere)),
              color = "blue"
            )
          ),
          
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
          ),
          
          # SELECTION ANNEE
          
          material_slider(
            input_id = "from_year",
            label = "From Year",
            min_value = 2014,
            max_value = 2018,
            initial_value = 2016,
            color = "blue"
            ),
          material_slider(
            input_id = "to_year",
              label = "Through Year",
              min_value = 2014,
              max_value = 2018,
              initial_value = 2016,
              color = "blue"
            )
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
        )
      )
    )
  ),
  

  
  material_side_nav_tab_content(
    side_nav_tab_id = "vis2",
    material_row(
      material_column(
        width = 10,
        offset = 1,
        material_row(
          material_column(
            width = 6,
            material_dropdown(
              input_id = "Area_State",
              label = "Location", 
              choices = c('x', 'y', 'z'),
              color = "blue"
            )
          ),
          material_column(
            width = 3,
            material_slider(
              input_id = "from_year",
              label = "From Year",
              min_value = 1995,
              max_value = 2010,
              initial_value = 1995,
              color = "blue"
            )
          ),
          material_column(
            width = 3,
            material_slider(
              input_id = "to_year",
              label = "Through Year",
              min_value = 1996,
              max_value = 2010,
              initial_value = 1999,
              color = "blue"
            )
          )
        ),
        material_row(
          material_column(
            width = 12,
            material_card(
              title = "titre"
              #plotOutput("housing_plot"),
              #uiOutput("housing_plot_error")
            )
          )
        )
      )
    )
    
    
    
  ),
  material_side_nav_tab_content(
    side_nav_tab_id = "liste_stage",
    material_row(
      material_column(
        width = 4,
        offset = 1,
        dataTableOutput("plot")
        
      )
    )
  )
)

