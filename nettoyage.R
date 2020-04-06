setwd("D:/_MIASHS & Bouygues Immo/MIASHS/Marathon du web/GIT/marathon-web-5/data") ## Deso j'arrive pas à faire le chemin relatif :(
donnees=read.csv2("donnees2.csv")
codenaf=read.csv2("codenaf.csv")

library(tidyverse)


# On ne garde que les stages facultatifs et les stages obligatoires
donnees=filter(donnees, Typeconvention != "Formation Continue" & Typeconvention !="Formation Initiale - Equivalence (=ECTS)")


#On crée une colonne "cycle" (licence, master, LP, etc.)

donnees=donnees %>% 
  mutate(cycle = case_when(
    str_detect(Libelleetape, fixed("DUT ")) ~ "DUT",
    str_detect(Libelleetape, fixed("Licence")) ~ "Licence",
    str_detect(Libelleetape, fixed("LP ")) ~ "LP",
    str_detect(Libelleetape, fixed("Master")) ~ "Master",
    str_detect(Libelleetape, fixed("Doctorat")) ~ "Doctorat",
    str_detect(Libelleetape, fixed("Préparation ")) ~ "Prep_concours",
    str_detect(Libelleetape, fixed("Mobilité internationale semestres pairs")) ~ "Mobilité",
    str_detect(Codeetape, fixed("MOB")) ~ "Mobilité",
    str_detect(Libelleetape, fixed("DU ")) ~ "DU"))

donnees$cycle[is.na(donnees$cycle)]<-"AUTRE (pluri?)"


#On calcule la durée du stage en semaines (à partir des dates de début - fin)
donnees$Datedebutstage=as.Date(donnees$Datedebutstage, format="%d/%m/%Y")
donnees$Datefinstage=as.Date(donnees$Datefinstage, format="%d/%m/%Y")
donnees$Duree_calcul=difftime(donnees$Datefinstage,donnees$Datedebutstage,units="weeks")


#On crée une colonne "filière"
# Sur excel avec dico des filières!! (peut être vérifié / modifié / précisé)


#On regroupe les codes NAF
donnees$code = substring(donnees$Codenafetablissement, 1, 2)
codenaf$code = as.character(codenaf$code)
join_donnees = inner_join(donnees, codenaf, by = c('code' = 'code'),"na_matches" = "never")


#Extraction du csv propre
write.csv2(donnees, file = "donnees_ok.csv")
write.csv2(join_donnees, file = "donnees_codenaf.csv")
