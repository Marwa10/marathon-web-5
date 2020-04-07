library(treemap)
library(dplyr)
data = read.csv2("data/donnees.csv", stringsAsFactors = FALSE) 
head(data)
colnames(data)



data_resume<- data %>%
  group_by(Filiere_global,Paysetablissement,codeDepartement) %>%
  tally

treemap(data_resume,index = c("Filiere_global","Paysetablissement","codeDepartement"),
        vSize ="Dureestage",
        vColor = "n",type="value",
        title = "Nombre de stages par Fillère, pays et département",fontsize.labels = c(15,10))