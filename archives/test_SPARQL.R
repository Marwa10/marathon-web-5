library(SPARQL)
library(utils)
name_page<- "Théâtre_des_13_vents"
query3 <-paste( "PREFIX dbpedia-owl: <http://dbpedia.org/ontology/>
  PREFIX dbpedia: <http://dbpedia.org/resource/>
  PREFIX dcterms: <http://purl.org/dc/terms/> 
  PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
SELECT ?abstract ?comment
WHERE {
  dbpedia:",name_page,
                " dbpedia-owl:abstract ?abstract ;
  rdfs:comment ?comment.
  FILTER (lang(?abstract) = 'fr')
  FILTER (lang(?comment) = 'fr')
}
LIMIT 1"
, 
sep ='')
print(query3)

endpoint <- "http://fr.dbpedia.org/sparql"
resultList <- SPARQL(endpoint,query3)
typeof(resultList)

summary(resultList)

queryResult <- resultList$results 
str(queryResult)
summary(queryResult)







PREFIX dbpedia-owl: <http://dbpedia.org/ontology/>
  PREFIX dbpedia: <http://dbpedia.org/resource/>
  PREFIX dcterms: <http://purl.org/dc/terms/> 
  PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?abstract ?comment
WHERE {
  dbpedia:Centre_hospitalier_Montfavet_Avignon dbpedia-owl:abstract ?abstract ;
  rdfs:comment ?comment.
  FILTER (lang(?abstract) = 'fr')
  FILTER (lang(?comment) = 'fr')
}
LIMIT 1





PREFIX dbpedia-owl: <http://dbpedia.org/ontology/>
  PREFIX dbpedia: <http://dbpedia.org/resource/>
  PREFIX dcterms: <http://purl.org/dc/terms/> 
  PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?abstract ?comment
WHERE {
  dbpedia:Théâtre_des_13_vents dbpedia-owl:abstract ?abstract ;
  rdfs:comment ?comment.
  FILTER (lang(?abstract) = 'fr')
  FILTER (lang(?comment) = 'fr')
}
LIMIT 1




PREFIX dbpedia-owl: <http://dbpedia.org/ontology/>
  PREFIX dbpedia: <http://dbpedia.org/resource/>
  PREFIX dcterms: <http://purl.org/dc/terms/> 
  PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?abstract ?comment
WHERE {
  dbpedia:Montpellier_Méditerranée_Métropole dbpedia-owl:abstract ?abstract ;
  rdfs:comment ?comment.
  FILTER (lang(?abstract) = 'fr')
  FILTER (lang(?comment) = 'fr')
}
LIMIT 1



# inspiration
#http://www.snee.com/bobdc.blog/2015/01/r-and-sparql-part-1.html

https://fr.wikipedia.org/wiki/Centre_hospitalier_universitaire_de_Montpellier 


https://fr.wikipedia.org/wiki/@Centre_hospitalier_universitaire_de_Montpellier    


# PREFIX dbpedia: <http://dbpedia.org/resource/>
# select ?p ?o where { 
#   dbpedia:2009 ?p ?o .
#   filter ( isLiteral(?o) && langMatches(lang(?o),'en') )
# }
# 
# 
# 
# PREFIX dbpedia-owl: <http://dbpedia.org/ontology/>
# PREFIX dbpedia: <http://dbpedia.org/resource/>
# PREFIX dcterms: <http://purl.org/dc/terms/> 
# PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
#   
#   SELECT ?abstract ?subject ?name #?WikiLink #?comment
# WHERE {
#   
#   dbpedia:2009 dbpedia-owl:abstract ?abstract ;
#   dcterms:subject ?subject.
#   #dbpedia-owl:wikiPageWikiLink ?WikiLink
#   #rdfs:label ?name.
#   #rdfs:comment ?comment.
#   FILTER(LANG(?name) = "en").
# }
# LIMIT 100
# 
SELECT ?abstract ?subject

WHERE {


  <http://fr.dbpedia.org/page/Théâtre_des_13_vents> http://dbpedia.org/ontology/abstract ?abstract .
  <http://fr.dbpedia.org/page/Théâtre_des_13_vents> http://purl.org/dc/terms/subject ?subject .
}

LIMIT 100
# 
# 
# 
# 
# PREFIX dbpedia-owl: <http://dbpedia.org/ontology/>
#   PREFIX dbpedia: <http://dbpedia.org/resource/>
#   SELECT ?name , ?abstract
# WHERE { 
#   <http://dbpedia.org/resource/2009> ?p ?o;
#   rdfs:label ?name;
#   dbpedia-owl:abstract ?abstract
#   #dbpedia-owl:wikiPageWikiLink ?wikiPageWikiLink;
#   filter ( langMatches(lang(?name),'fr') )        
# }
# LIMIT 100
# 
# 
# PREFIX geo: <http://www.w3.org/2003/01/geo/wgs84_pos#>
# PREFIX dbo: <http://dbpedia.org/ontology/>
#   SELECT ?name, ?univ, ?lat WHERE {
#     ?p rdf:type dbo:Place.
#     ?p rdfs:label ?name.
#     ?u dbo:campus ?p.
#     ?u geo:lat ?lat.
#     ?u geo:long ?long.
#     ?u rdfs:label ?univ
#     FILTER(LANG(?name) = "en").
#     FILTER(?name = "Paris"@en)
#   }
# 
# 
# 
# 
# PREFIX dbpedia-owl: <http://dbpedia.org/ontology/>
#   PREFIX dbpedia: <http://dbpedia.org/resource/>
#   SELECT *
#   WHERE { 
#     <http://dbpedia.org/resource/2009> ?p ?o.
#     ?p rdfs:label ?name.
#     dbpedia-owl:abstract ?abstract
#     #dbpedia-owl:wikiPageWikiLink ?wikiPageWikiLink;
#     filter ( isLiteral(?o) && langMatches(lang(?o),'fr') )        
#   }
# LIMIT 100
# 
# query3 <-"select * where { 
#   ?s dbpedia-owl:abstract ?abstract .
#   ?abstract bif:contains "Monadnock" .
#   filter langMatches(lang(?abstract),"en")
# }
# limit 10"
# query2 <-"PREFIX  dbpedia-owl:  <http://dbpedia.org/ontology/>
# SELECT ?film_title ?star_name ?nameDirector ?link WHERE {
#   {  
#     SELECT DISTINCT ?movies ?film_title
#     WHERE {
#        ?movies rdf:type <http://dbpedia.org/ontology/Film>; 
#        rdfs:label ?film_title.
#     } 
#   }. 
#   ?movies dbpedia-owl:starring ?star;
#   foaf:isPrimaryTopicOf ?link;
#   dbpedia-owl:director ?director. 
#   ?director foaf:name ?nameDirector.
#   ?star foaf:name ?star_name.
#   FILTER LANGMATCHES( LANG(?film_title), 'en')
# } LIMIT 100"
# query <- "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
# PREFIX dcterms: <http://purl.org/dc/terms/>
# PREFIX dbo: <http://dbpedia.org/ontology/>
# PREFIX dbpprop: <http://dbpedia.org/property/>
# PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
# SELECT ?label ?numEmployees ?netIncome  
# WHERE {
#   ?s dcterms:subject <http://dbpedia.org/resource/Category:Companies_in_the_Dow_Jones_Industrial_Average> ;
#      rdfs:label ?label ;
#      dbo:netIncome ?netIncomeDollars ;
#      dbpprop:numEmployees ?numEmployees . 
#      BIND(replace(?numEmployees,',','') AS ?employees)  # lose commas
#      FILTER ( lang(?label) = 'en' )
#      FILTER(contains(?netIncomeDollars,'E'))
#      # Following because DBpedia types them as dbpedia:datatype/usDollar
#      BIND(xsd:float(?netIncomeDollars) AS ?netIncome)
#      # original query on following line had two slashes, but 
#      # R needed both escaped
#      FILTER(!(regex(?numEmployees,'\\\\d+')))
# }
# ORDER BY ?numEmployees"
# 
# 
