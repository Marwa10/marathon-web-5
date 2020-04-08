
########### deuxième partie ######
## inspiration : https://asmquantmacro.com/2016/04/30/web-scraping-for-text-mining-in-r/
## inspiration : 
###### web scrapping et extraction des mots clefs #########


########################## méthode extract_keywords :  extratcion des mots clefs#########
## paramètres en entrée : url :  l'adresse web à  scrapper
##                       top_n_keywords :  le nombre de mots clefs à  extraire au maximum
## sortie:  la liste des mots clets  
extract_keywords <- function(url, top_n_keywords=10){
  
  
  my_webpage <- read_html(url)%>%
    html_nodes("body") %>% 
    html_text()
  
  #res<-strsplit(test, c(" ","[\n]","[,]","[ ]","","[.]",".",":","[:]","[:punct:]","[:blank:]"),fixed=TRUE)[[1]]
  my.corpus<-gsub("\r?\n|\r","",my_webpage)%>%
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
  result <-my.corpus[1:top_n_keywords,3]
  #tm::inspect(my.corpus[1:10,2])
 return(result)
}

################  demarrage du processus de web scrapping + extraction  mots clefs 


data_url_etab = read.csv2("data/etab_url_keywords.csv", sep = ";",stringsAsFactors = FALSE)
rows <-20#nrow(data_url_etab)
for (row in 1:rows) {
  print(data_url_etab[row,"url"])
  webpage <- data_url_etab[row,"url"]
  if (webpage!="" ){
    cat("\n","extract from web site : ",webpage,"\n")
    keywords <-extract_keywords(webpage, 10)
    print(keywords)
    class(keywords)
   data_url_etab[row,"keywords"] <- paste(keywords, collapse = " ")
  }
}

### écriture des mots clefs dnas le csv

write.csv2(data_url_etab,"data/etab_url_keywords.csv",row.names = TRUE)

########## fin du code  ##########
