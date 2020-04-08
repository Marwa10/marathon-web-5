# library
library(dplyr)
library(treemap)
#inspiration : 
# http://www.buildingwidgets.com/blog/2015/7/22/week-29-d3treer-v2

###### Attention on doit installer ceci : 
# on doit installer la version sur github : 
#devtools::install_github("gluc/data.tree")
#devtools::install_github("timelyportfolio/d3treeR")
##########################


library(d3treeR)


## chargement du dataset :
data_stages = read.csv2("data/donnees.csv", stringsAsFactors = FALSE) 

# récupérationdes données de département
departements <-read.csv("data/departments.csv",sep = ',')

# je créé un département fictif pour l'étranger
newRow <- data.frame(id='0',region_code='0',code='0',name ='Etranger', slug='etranger') 
departements <- rbind(departements, newRow)


# regroupement des données pour avoir le nombre d'heures et le nombre de stages
data_resume_tree<- data_stages %>%
  group_by(Filiere_global,cycle,codeDepartement,.drop = TRUE) %>%
  summarise(total = n(),
            nb_heures = sum(as.numeric( Duree_calcul))
            )%>%
  mutate(codeDepartement = coalesce(codeDepartement, as.integer(0) )
        )

# jointure entre les données de departement et les données de stage
data_resume_tree <-merge(data_resume_tree,departements,by.x="codeDepartement", by.y = "code", all= TRUE) 
# création du treemap
p <- treemap(data_resume_tree,
             title="Répartition des stages (taille Nbre de stages, couleur :  nbre d'heures) ",
             index=c("Filiere_global","cycle","name"),
             vSize="total",
             vColor="nb_heures",
             palette="-RdGy",
            # type="value",
             type="index",
             #palette = "YlOrBr",
             bg.labels=c("white"),
             align.labels=list(
               c("center", "center"), 
               c("right", "bottom"),
               c("right", "bottom")
             )  
)            

# Mise en place de l'interactivité
titre= "Répartition des stages (taille Nbre de stages, couleur :  nbre d'heures) "
#d3tree( p,rootname = titre)
d3tree2( p ,  rootname = titre )


####################### fin du code à  intégrer ############
