# library
library(dplyr)
library(treemap)
library(stringr)
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

################################## carto par departement ######

# regroupement des données pour avoir le nombre d'heures et le nombre de stages
# par departement
data_resume_tree_by_filliere<- data_stages %>%
  mutate(Filiere_global = str_replace_all(Filiere_global, "[[:punct:]]", " "),
         cycle= str_replace_all(cycle, "[[:punct:]]", " ")
  )%>%
  group_by(Filiere_global,cycle,codeDepartement,.drop = TRUE) %>%
  summarise(total = n(),
            nb_heures = sum(as.numeric( Duree_calcul))
            )%>%
  mutate(codeDepartement = coalesce(codeDepartement, as.integer(0) )
        )%>%
  filter(total>1)

# jointure entre les données de departement et les données de stage
data_resume_tree_by_filliere <-merge(data_resume_tree_by_filliere,departements,by.x="codeDepartement", by.y = "code", all= TRUE) 
# création du treemap
tree_map_filiere_dep <- treemap(data_resume_tree_by_filliere,
             title="Répartition des stages par fillière et départment(taille Nbre de stages, couleur :  nbre d'heures) ",
             index=c("Filiere_global","cycle","name"),
             vSize="total",
             vColor="nb_heures",
             palette="-RdGy",
            # type="value",
             type="value",
             #palette = "YlOrBr",
             bg.labels=c("white"),
             align.labels=list(
               c("center", "center"), 
               c("right", "top"),
               c("right", "top")
             )  
)            

# Mise en place de l'interactivité
titre= "Répartition des stages  par fillière et départment (taille Nbre de stages, couleur :  nbre d'heures) "
d3tree( tree_map_filiere_dep,rootname = titre)
d3tree2( tree_map_filiere_dep ,  rootname = titre )

 #############################


##### carto par etablissement#######################################

data_resume_tree_by_filliere_etab<- data_stages %>%
  mutate(Filiere_global = str_replace_all(Filiere_global, "[[:punct:]]", " "),
         Nometablissement= str_replace_all(Nometablissement, "[[:punct:]]", " "),
         cycle= str_replace_all(cycle, "[[:punct:]]", " ")
  )%>%
  group_by(Filiere_global,cycle,Nometablissement,.drop = TRUE) %>%
  summarise(total = n(),
            nb_heures = sum(as.numeric( Duree_calcul)) 
              )%>%
  filter(total>20)
  

# création du treemap
tree_map_filiere_etab <- treemap(data_resume_tree_by_filliere_etab,
                                title="Répartition des stages (taille Nbre de stages, couleur :  nbre d'heures) ",
                                index=c("Filiere_global","cycle","Nometablissement"),
                                vSize="total",
                                vColor="nb_heures",
                                #palette="-RdGy",
                                type="value",
                                #type="index",
                                palette = "YlOrBr",
                                bg.labels=c("white"),
                                align.labels=list(
                                  c("center", "center"), 
                                  c("right", "bottom"),
                                  c("right", "bottom")
                                )  
)            

# Mise en place de l'interactivité
titre= "Répartition des stages par filière, etablissement (taille Nbre de stages, couleur :  nbre d'heures) "
d3tree( tree_map_filiere_etab,rootname = titre)
d3tree2( tree_map_filiere_etab ,  rootname = titre )



####################### fin du code à  intégrer ############
