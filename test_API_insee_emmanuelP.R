library(httr)
library(jsonlite)
library(dplyr)
library(tidyverse)
###################################
# Creation de la classe api_insee #
###################################
# constructeur de la classe 
api_insee <- function(consumer_key,consumer_secret) {

  #création de l'instance
  instance <- list()
  instance$consumer_key <- consumer_key
  instance$consumer_secret <- consumer_secret
  instance$url_insee  <- "https://api.insee.fr"
  instance$path <- "entreprises/sirene/V3"
  instance$siren_path  <- "entreprises/sirene/V3/siren"
  instance$siret_path <-"entreprises/sirene/V3/siret"
  instance$siret_multi_path <-"entreprises/sirene/V3/siret"
  ## methode get_siren #######
  ###  permet de récupérer les information SIRET ( 9 premiers caractères du SIREN) sous forme json 
  instance$get_siren <-function(num_siren){
    result_siren <- httr::GET( url = instance$url_insee,path=paste(instance$siren_path, num_siren,sep = "/"),  
                               accept_json(),
                               add_headers(Accept='application/json',
                                           Authorization=paste('Bearer',instance$token_insee,sep = ' ')), 
                               verbose())
    
    parsed_siren <- jsonlite::fromJSON(content(result_siren, "text"), simplifyVector = FALSE)
    return(parsed_siren)
    
  }
  ## Méthode get_siret ######
  ##, permet de récupérer les informations de l'établissement à  partir du SIRET
  instance$get_siret <-function(num_siret){
    
    result_siret <- httr::GET( url = instance$url_insee,path=paste(instance$siret_path, num_siret,sep = "/"),  
                               accept_json(),
                               add_headers(Accept='application/json',
                                           Authorization=paste('Bearer',instance$token_insee,sep = ' ')), 
                               verbose())
    
    parsed_siret <- jsonlite::fromJSON(content(result_siret, "text"), simplifyVector = FALSE)

    
   # adresse
    return(parsed_siret)
  }
  ### get_multiple_siret #####
  
  instance$get_multiple_siret <- function (list_of_siret){
   sirets=''
    for(siret in list_of_siret){
      siret= paste('siret',trimws(siret) ,sep = ':')
      if (sirets =='')
        sirets = siret
      else
        sirets <- paste(sirets,siret, sep = ' OR ')
    }
    print(sirets)
    params <- list()
    params$q <- sirets #"siret:19340119700010 OR siret:19340972900020"
    result_siret <- httr::POST( url = paste(instance$url_insee,instance$siret_multi_path,sep = '/'),
                               accept_json(),
                               body = params,
                               add_headers(#Accept='application/json',
                                           Authorization=paste('Bearer',instance$token_insee,sep = ' ')), 
                               encode='form',
                               verbose())
    
    parsed_siret <- jsonlite::fromJSON(content(result_siret, "text"), simplifyVector = FALSE)
    return(parsed_siret)
    
  }
  
  ## méthode transform_from_json_to_dataframe_infos
  instance$transform_from_json_to_dataframe_etab<- function(json){
    # creation du dataframe
    df <- data.frame(siren=character(),
                     siret=character(),
                     activitePrincipaleUniteLegale=character(),
                     trancheEffectifsEtablissement=character(),
                     denominationUniteLegale=character(),
                     categorieEntreprise=character(),
                     typeVoieEtablissement=character(),
                     libelleVoieEtablissement=character(),
                     codePostalEtablissement=character(),
                     libelleCommuneEtablissement=character(),
                     stringsAsFactors=FALSE)
    # recupération des etablissements
    etab <- json$etablissements
    
    
    # fill the datatframe
    for(i in etab){
      df[nrow(df) + 1,] = list(siren = i$siren,
                               siret=  i$siret,
                               activitePrincipaleUniteLegale= ifelse(is.null(i$uniteLegale$activitePrincipaleUniteLegale),'',i$uniteLegale$activitePrincipaleUniteLegale),
                               trancheEffectifsEtablissement= ifelse(is.null(i$trancheEffectifsEtablissement),'0',i$trancheEffectifsEtablissement) ,
                               denominationUniteLegale =  ifelse(is.null(i$uniteLegale$denominationUniteLegale),'',i$uniteLegale$denominationUniteLegale),
                               categorieEntreprise= ifelse(is.null(i$uniteLegale$categorieEntreprise),'',i$uniteLegale$categorieEntreprise),
                               typeVoieEtablissement=  ifelse(is.null(i$adresseEtablissement$typeVoieEtablissement),'',i$adresseEtablissement$typeVoieEtablissement),
                               libelleVoieEtablissement= ifelse(is.null(i$adresseEtablissement$libelleVoieEtablissement),'',i$adresseEtablissement$libelleVoieEtablissement),
                               codePostalEtablissement=  ifelse(is.null(i$adresseEtablissement$codePostalEtablissement),'',i$adresseEtablissement$codePostalEtablissement),
                               libelleCommuneEtablissement= ifelse(is.null(i$adresseEtablissement$libelleCommuneEtablissement),'',i$adresseEtablissement$libelleCommuneEtablissement)
      )
    }
    
    return(df)
    
  }
  ###  get_multiple_siret_dataframe ####
  ##
  instance$get_multiple_siret_dataframe<- function(list_of_siret){
  
    # appel de l'API get_multiple_siret
    result_json <-instance$get_multiple_siret(list_of_siret)
    # transform en dataframe
    return(instance$transform_from_json_to_dataframe_etab(result_json))

  }
  ### Méthode get_siret_dataframe 
  ##premet de renvoyer directement le dataframe de l'établissement
  instance$get_siret_dataframe <-function(num_siret){
    # appel de l'API get_multiple_siret
    result_json <-instance$get_siret(num_siret)
    # transform en dataframe
    return(instance$transform_from_json_to_dataframe_etab(result_json))
    
  }
  
  ## Constructeur ####
  params <- list()
  params$grant_type <- "client_credentials"
  instance$result_auth <- httr::POST(url = paste(instance$url_insee,'token',sep = "/"),
                            accept_json(),
                            body = params,
                           authenticate(instance$consumer_key, instance$consumer_secret),
                            encode='form',
                            verbose())
  
  
 # print(instance$result_auth)
  
  instance$parsed_auth <- jsonlite::fromJSON(content(instance$result_auth, "text"), 
                                             simplifyVector = FALSE)
  instance$token_insee <- instance$parsed_auth$access_token
 # print(instance$token_insee)
  
  #renvoyer l'instance de a classe 
  return(instance)
}

###########################################
# fin de la classe api_insee
############################################


##### exemple d'appel à  la classe INSEE #######

#######################   1:  création du Token  ###################################
### utiliser toujours ces credentials
consumer_key <-"6mrzM8nmQFfZZBoZvfpxa8mE_Jka"
consumer_secret <-"ndIxnvi8vaSyHaYHooIBS3OFUqMa"
## instanciation de la classe obligatoire avant tout appel
obj <- api_insee(consumer_key = consumer_key, consumer_secret = consumer_secret)


## premier test avec deux SIRET
#info_sirets<-obj$get_multiple_siret_dataframe( c( '47280138000016','17340131600208'))
#info_sirets

################################## 2. récupération des SIRET à  partir des données de stage ############
# récupération des données de stage
data_siret = read.csv2("data/donnees_ufr.csv", stringsAsFactors = FALSE)
# suppression des siret vides
#data_siret <- subset( data, "Numsiret" != "NA")
data_siret %>%
  drop_na(Numsiret)

# regrioupement des siret
data_siret<- data_siret %>%
  group_by(Numsiret,.drop = TRUE) %>%
  summarise(nb_stages = n(),
            nb_heures = sum(as.numeric( Duree_calcul))
  )
data_siret




#################### appel en batch pour récupérer les infos des etablissements à  partir de 
################### l'API INSEE ###########################################################

## nombre de numéros de siret à  passer par appel
# cette valeur peut-être augmentée pour passer plus de SIRET par apple à  l'API
max_num_by_call= 20


######## initialisation#########
## initialisation de la liste des sirets
c_sirets  <- vector()

# récupération du nombre de siret distinct à  utiliser
rows <-  nrow(data_siret)

current_num_by_call= 1
nb_loop_call =1

loop= 0
cat("rows : ",rows,  " nb_loop_call*max_num_by_call = ",nb_loop_call*max_num_by_call)
for (row in 1:rows #nrow(data_siret)
     ) {
  siret =  as.character( data_siret[row,"Numsiret"])
 
  #print(siret)
  if (!is.null(siret))
    if (!is.na (siret))
      if (siret !='NA'){
          #print(siret)
          c_sirets <- append (c_sirets, siret )
      }
  #print(nb_loop_call)
  #print(c_sirets)
  nb_siret_loop <- floor(rows / max_num_by_call)
  nb_siret_last_loop <- rows%%max_num_by_call
  #cat("current num by call:",current_num_by_call," nb_siret_last_loop: ",nb_siret_last_loop," nb_siret_dernier_loop: ",nb_siret_dernier_loop," nb_loop_call:",nb_loop_call,"  row:" , row, "siret :  ",siret,"\n")
  #cat( "nb_siret_loop: ",nb_siret_loop, " , ")
 
  if (   # on a atteint le nombre de siret par boucle
        (current_num_by_call== max_num_by_call) 
      || (
              ## on a atteind le deriner siret du dernier loop   
               current_num_by_call == nb_siret_last_loop
                 && 
                ## on a atteint le dernier loop
                nb_loop_call == nb_siret_dernier_loop+1
          ) 
    ){
    cat("\n ","###########    call : obj$get_multiple_siret_dataframe( c_sirets)")
    #cat(" is vector ? : ",is.vector(c_sirets))
    # deallocation du vecteur temporaire
    rm("current_info_siret")
    current_info_siret  <- obj$get_multiple_siret_dataframe( c_sirets)
   
    #print(current_info_siret)
    
    if (nb_loop_call!=1){
      ## binding
      print("binding")
      info_sirets<- merge(info_sirets, current_info_siret, all=TRUE)
      #info_sirets <- rbind( info_sirets, current_info_siret)
  
    }
    else {
      print("info_sirets<-current_info_siret")
      info_sirets<-current_info_siret
    }
    #print(info_sirets)
    ## reinitialisation
    c_sirets<-c()
    current_num_by_call=0
    nb_loop_call=nb_loop_call+1
   
  }
  current_num_by_call=  current_num_by_call+1
  loop =loop+1
}

## ecriture dans le fichier CSV

write.csv2(info_sirets,"data/siret_insee_all_etab.csv", row.names = TRUE)
#info_sirets


################ fin de l'intégration du compte ######



# print(info_sirets[["etablissements"]][[2]][["siren"]])
# print(info_sirets[["etablissements"]][[2]][["siret"]])
# info_sirets[["etablissements"]][[2]][["uniteLegale"]][["activitePrincipaleUniteLegale"]]
# info_sirets[["etablissements"]][[2]][["trancheEffectifsEtablissement"]]
# info_sirets[["etablissements"]][[2]][["uniteLegale"]][["denominationUniteLegale"]]
# info_sirets[["etablissements"]][[2]][["uniteLegale"]][["categorieEntreprise"]]
# info_sirets[["etablissements"]][[2]][["adresseEtablissement"]][["typeVoieEtablissement"]]
# info_sirets[["etablissements"]][[2]][["adresseEtablissement"]][["libelleVoieEtablissement"]]
# info_sirets[["etablissements"]][[2]][["adresseEtablissement"]][["codePostalEtablissement"]]
# info_sirets[["etablissements"]][[2]][["adresseEtablissement"]][["libelleCommuneEtablissement"]]
# 
# ## récupération des infos du SIRENE
# siren <- "193401197"
# info_siren <- obj$get_siren(num_siren =  siren)
# print(info_siren)
# # recupération des infos du SIRET
# siret <- "19340119700010"
# info_siret<-obj$get_siret(num_siret = siret)
# ## exemple dinfo
# print(info_siret$etablissement$uniteLegale$denominationUniteLegale)
# #Nom de l'etablissement
# info_siret$etablissement$uniteLegale$denominationUniteLegale
# # nbre d'emplyes
# info_siret$etablissement$uniteLegale$trancheEffectifsUniteLegale
# #NAF
# info_siret$etablissement$uniteLegale$activitePrincipaleUniteLegale
# #adresse
# adresse <- paste(info_siret$etablissement$adresseEtablissement$numeroVoieEtablissement,
#                  info_siret$etablissement$adresseEtablissement$typeVoieEtablissement,
#                  info_siret$etablissement$adresseEtablissement$libelleVoieEtablissement,
#                  info_siret$etablissement$adresseEtablissement$codePostalEtablissement,
#                  info_siret$etablissement$adresseEtablissement$libelleCommuneEtablissement,sep =' ')
