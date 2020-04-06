library(shinydashboard)



header <- dashboardHeader( title = "Marathon du web")

sidebar <- dashboardSidebar(
  collapsed = TRUE,
  sidebarMenu(
    menuItem("xxx", tabName = "xxx", icon = icon("dashboard")),
    menuItem("yyy", tabName = "yyy", icon = icon("far fa-address-card")),
    menuItem("zzz", tabName = "zzz", icon = icon("far fa-chart-bar")),
    menuItem("ttt", tabName = "ttt", icon = icon("th"))
  )
)



body <- dashboardBody(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),
  
  tabItems(
    tabItem(tabName = "xxx"),
            
    tabItem(tabName = "yyy"
            
            #, fluidRow(
            #   
            #   box()
            ),
    tabItem(tabName = "zzz"),
    tabItem(tabName = "ttt")
    )
)

dashboardPage(header,
              sidebar,
              body,
              skin = "black")
