library(treemap)
library(dplyr)
library(d)

data = read.csv2("data/donnees.csv", stringsAsFactors = FALSE) 
head(data)
colnames(data)
#aggdata <-aggregate(data, by=list(Filiere_global,Paysetablissement,codeDepartement ), 
#                    FUN=co, na.rm=TRUE)


data_resume<- data %>%
  group_by(Filiere_global,Paysetablissement,codeDepartement,.drop = TRUE) %>%
  summarise(total = n(),
            nb_heures = sum(as.numeric( Duree_calcul)))
head(data_resume)

#group_by(Filiere_global/Paysetablissement/codeDepartement) %>% summarize(h = sum(heure), nb = n())

d3tree(
  treemap(data_resume,
          index=c("Filiere_global"install.packages("r2d3"),"codeDepartement"),
          vSize="total",
          vColor="total",
          type="value",
          palette="-RdGy",
          range=c(-30000,30000))
  , rootname="Nombre de stages par Fillère, pays et département"
)

treemap(data_resume,index = c("Filiere_global","Paysetablissement","codeDepartement"),
        vSize ="nb_heures",
        vColor = "total",
        type="value",
        title = "Nombre de stages par Fillère, pays et département",
        fontsize.labels = c(15,10))