library(shinydashboard)
library(DT)
library(shinymaterial)



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
        "XXX" = "xx",
        "YYY" = "yy",
        "Base de données" = "zz"
      ),
      icons = c("insert_chart", "code", "explore")
    )
  ),
  # Define side-nav tab content
  material_side_nav_tab_content(
    side_nav_tab_id = "xx",
    tags$br(),
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
    side_nav_tab_id = "yy",
    #tags$br(),
    material_row(
      material_column(
        width = 10,
        material_card(
          title = "Source",
          tags$a(href = "https://www.fhfa.gov/DataTools/Downloads",
                 target = "_blank",
                 "Federal Housing Finance Agency (FHFA)")
        )
      )
    )
  ),
  material_side_nav_tab_content(
    side_nav_tab_id = "zz",
    material_row(
      material_column(
        width = 4,
        offset = 1,
        dataTableOutput("plot")
        
      )
    )
  )
)





# 
# 
# header <- dashboardHeader( title = "Marathon du web")
# 
# sidebar <- dashboardSidebar(
#   collapsed = TRUE,
#   sidebarMenu(
#    
#     menuItem("Intro", tabName = "yyy", icon = icon("far fa-address-card")),
#     menuItem("zzz", tabName = "zzz", icon = icon("far fa-chart-bar")),
#     menuItem("ttt", tabName = "ttt", icon = icon("th")),
#     menuItem("xxx", tabName = "xxx", icon = icon("dashboard"))
#   )
# )
# 
# 
# 
# body <- dashboardBody(
#   tags$head(
#     tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
#   ),
#   
#   tabItems(
#     tabItem(tabName = "xxx",
#             DT::dataTableOutput("plot")),
#             
#     tabItem(tabName = "yyy"),
#     tabItem(tabName = "zzz"),
#     tabItem(tabName = "ttt")
#     )
# )
# 
# dashboardPage(header,
#               sidebar,
#               body,
#               skin = "black")
