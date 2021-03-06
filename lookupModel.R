setwd("~/projects/capstone")
source("requirements.R")

lookupTerm <- function (searchTerm){
  searchTerm <- tolower(searchTerm)
  searchTerm <- removePunctuation(searchTerm)
  searchTerm <- removeNumbers(searchTerm)
  
  theNgrams <- strsplit(searchTerm, " ")[[1]]
  if(length(theNgrams)>3){
    theNgrams <- theNgrams[(length(theNgrams)-2):length(theNgrams)]
    searchTerm <- paste(theNgrams, collapse=" ")
  }
  regexTerm <- paste("(",searchTerm," )",sep="")
  ngramCount <- length(theNgrams)
  while(ngramCount < 3){
    regexTerm <- paste("(\\w+ )", regexTerm, sep="")
    ngramCount = ngramCount + 1
  }
  # regexTerm <- paste("(^)", regexTerm, sep="")
  regexTerm <- paste("(^",searchTerm,")($|\\s)",sep="")
  frequencyTable <- switch(
   length(theNgrams),
   bigramFrequency,
   trigramFrequency,
   quadgramFrequency
   #pentagramFrequency
  )
  #resultTable <- droplevels(frequencyTable[grepl(regexTerm,frequencyTable$Term),])
  resultTable <- data.frame(frequencyTable[grepl(regexTerm,frequencyTable$Term),], stringsAsFactors = FALSE)
  resultTable <- resultTable[order(resultTable$Freq, decreasing = TRUE),]
  resultTable <- head(resultTable, 5)
  if(length(theNgrams)>1){
    resultTable <- rbind(resultTable, lookupTerm(shrinkSearchTerm(searchTerm)))
  }
  
  #resultTable <- frequencyTable[grepl(regexTerm,frequencyTable$Term),]
  
  
  #resultTable <- droplevels(resultTable)
  resultTable
}

shrinkSearchTerm <- function(searchTerm){
  theNgrams <- strsplit(searchTerm, " ")[[1]]
  if(length(theNgrams) <=1 ){ return("")}
  theNgrams <- theNgrams[2:length(theNgrams)]
  searchTerm <- paste(theNgrams, collapse=" ")
  searchTerm
}

buildSearchTerm <- function (phrase,n){
  searchWords <- unlist(unname(qdap::word_split(phrase)))
  searchWords <- searchWords[(length(searchWords)-(n-1)):length(searchWords)]
  searchWords <- paste(searchWords, collapse = " ")
  searchWords <- removePunctuation(searchWords)
  searchWords
}

unigramFrequency <- readRDS(unigramModelFile)
bigramFrequency <- readRDS(bigramModelFile)
trigramFrequency <- readRDS(trigramModelFile)
quadgramFrequency <- readRDS(quadgramModelFile)
#pentagramFrequency <- readRDS(pentagramModelFile)
