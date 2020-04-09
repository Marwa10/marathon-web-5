library(SPARQL) # SPARQL querying package
library(tm)
library(dplyr)
library(xml2)
library(rvest)
library(rlang)
########### deuxième partie ######
## inspiration : https://asmquantmacro.com/2016/04/30/web-scraping-for-text-mining-in-r/
## inspiration : 
###### web scrapping et extraction des mots clefs #########




######## méthode get_comments_and_abstracts_from_dbpedia##########
get_comments_and_abstracts_from_dbpedia <- function(wiki_link){
  wiki_name <-basename(wiki_link)
  cat("extratcer wiki name : ",wiki_name)
  
# requete SPARQL
query_SPARQL <-paste("PREFIX dbpedia-owl: <http://dbpedia.org/ontology/>
PREFIX dbpedia: <http://dbpedia.org/resource/>
PREFIX dcterms: <http://purl.org/dc/terms/> 
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
  
 SELECT ?abstract ?comment
WHERE {
  dbpedia:",trimws (wiki_name)," dbpedia-owl:abstract ?abstract ;
  rdfs:comment ?comment.
 FILTER (lang(?abstract) = 'fr')
 FILTER (lang(?comment) = 'fr')
}
LIMIT 1", sep ="")

message("SPARQL",query_SPARQL)

endpoint <- "http://dbpedia.org/sparql"
# mise en place du try catch pour forcer l'execution
out <- tryCatch(
  {

    message("This is the 'try' part")
    
    resultList <- SPARQL(endpoint,query_SPARQL)
    queryResult<-resultList$results 
    #print(queryResult)
    pasted<-  paste(queryResult$comment , queryResult$abstract ,sep = " ") 
    #cat("pasted ",pasted)
    pasted
  }
  ,
  error=function(cond) {
    message(paste("URL does not seem to exist:", query_SPARQL))
    message("Here's the original error message:")
    message(cond)
   
    return("")
  }
 
  
  ) 
  
cat("out: ",out)  
return(out)
  
}






#########################methode analyse_text

analyse_text<- function(text_to_analyse,top_n_keywords=20,as_matrix=FALSE){
  
  #res<-strsplit(test, c(" ","[\n]","[,]","[ ]","","[.]",".",":","[:]","[:punct:]","[:blank:]"),fixed=TRUE)[[1]]
  my.corpus<-gsub("\r?\n|\r","",text_to_analyse)%>%
    tm::VectorSource()%>%
    tm::Corpus()%>%
    tm::tm_map(tm::content_transformer(tolower))%>%
    tm::tm_map(tm::removePunctuation)%>%
    tm::tm_map(tm::stripWhitespace)%>%
    tm::tm_map(tm::removeWords,tm::stopwords('french'))%>%
    tm::tm_map(tm::removeNumbers) %>%
    tm::tm_map(tm::PlainTextDocument)%>%
    tm::TermDocumentMatrix()%>%
    as.data.frame.matrix() %>%
    mutate(name = row.names(.)) %>%
    arrange(desc(content))
  
  #strwrap(my.corpus[[1]])
  # print(head(my.corpus, top_n_keywords))
  if(as_matrix){
    result <-my.corpus[1:top_n_keywords]}
  else{ 
    result <-my.corpus[1:top_n_keywords,3]}
  
  #tm::inspect(my.corpus[1:10,2])
  return(result)
}

#############Méthode extract_keywords_from_wiki: extraction des mots à  partir d'une adresse wiki#################### 
# cette methode permet de faire 
extract_keywords_from_dbpedia <-function(url,top_n_keywords=10){
  
  wiki_text<-get_comments_and_abstracts_from_dbpedia(url)
  result=""
  if (!is_empty(wiki_text) )
  {
    result <-analyse_text(wiki_text,top_n_keywords)
  }    
  return(result)
}
########################## méthode extract_keywords :  extratcion des mots clefs#########
## paramètres en entrée : url :  l'adresse web à  scrapper
##                       top_n_keywords :  le nombre de mots clefs à  extraire au maximum
## sortie:  la liste des mots clets  
extract_keywords_from_url <- function(url, top_n_keywords=10){
  result=""
  out <- tryCatch({
    my_webpage_as_text <- read_html(url)%>%
      html_nodes("body") %>% 
      html_text()
    my_webpage_as_text
  } ,
  error=function(cond) {
    message(paste("URL does not seem to exist:", query_SPARQL))
    message("Here's the original error message:")
    message(cond)
    # Choose a return value in case of error
    return("")
  })
  if (!is_empty(wiki_text) )
  {
  result <-analyse_text(out,top_n_keywords)
  }    
  return(result)
}

################ Fin des méthodes #################





################  demarrage du processus de web scrapping + extraction  mots clefs 


data_url_etab <- read.csv2("data/etab_url_keywords.csv", sep = ";",stringsAsFactors = FALSE)

rows <-nrow(data_url_etab)
for (row in 1:rows) {
  cat('row: ',row,' url:  ',data_url_etab[row,"url"],'\r')
  webpage <- data_url_etab[row,"url"]
  wiki<- data_url_etab[row,"wiki"]
  data_url_etab[row,"keywords_wiki_dbpedia"]=""
  if (webpage!="" ){
    cat("\n","extract from web site : ",webpage,"\n")
    keywords_web_pages <-extract_keywords_from_url(webpage, 10)
   # print(keywords)
  #  class(keywords)
   data_url_etab[row,"keywords"] <- paste(keywords_web_pages, collapse = " ")
  }
  if (wiki!="" ){
    cat("\n","extract from wiki site : ",wiki,"\n")
    keywords_wiki <-extract_keywords(wiki, 10)
    # print(keywords)
    #  class(keywords)
    data_url_etab[row,"keywords_wiki"] <- paste(keywords_wiki, collapse = " ")
    keywords_wiki_dbpedia <-extract_keywords_from_dbpedia(wiki, 10)
    data_url_etab[row,"keywords_wiki_dbpedia"] <- paste(keywords_wiki_dbpedia, collapse = " ")
    
    
  }
  

  
}

### écriture des mots clefs dnas le csv en supprimant les NA
data_final_csv <-data_url_etab %>% 
  mutate(keywords_wiki_dbpedia=replace(keywords_wiki_dbpedia, keywords_wiki_dbpedia=="NA", ""),
         keywords_wiki = replace(keywords_wiki, keywords_wiki == "NA", "")) %>%
  mutate(keywords_wiki_dbpedia = replace(keywords_wiki_dbpedia, is.na(keywords_wiki_dbpedia)  , ""),
         keywords_wiki = replace(keywords_wiki, is.na(keywords_wiki ), "")
         )
write.csv2(data_final_csv,"data/etab_url_keywords.csv",row.names = TRUE)

########## fin du code  ##########
