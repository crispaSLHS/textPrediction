require(tm)
#require(rJava)
#require(NLP)
#require(openNLP)
#require(RWeka)
require(qdap)

setwd("~/projects/capstone")

ngramTokenizer <- function(x,y=2){
  options(warn = -1)
  #theNgrams <- NLP::ngrams(x,n= y)
  sentences <- qdap::sent_detect_nlp(as.character(x))
  theNgrams <- qdap::ngrams(sentences,n= y)
  theNgrams <- theNgrams$all_n[[paste("n_", y, sep="")]]
  theNgrams <- lapply(theNgrams, paste, collapse=" ")
  options(warn=0)
  unlist(theNgrams)
}

trigramTokenizer <- function(x, y=3){
  ngramTokenizer(x,y)
}
bigramTokenizer <- function(x, y=2){
  ngramTokenizer(x,y)
}

findTermFrequency <- function(x){
  capture.output(
    {
      temp<-inspect(x)
      freqs <- data.frame(Term=rownames(temp), Freq=rowSums(temp))
    }, file="/dev/null")
  freqs
}

dataDir <- "rawData/final/en_US"
#blogsFile <- "en_US.blogs.txt"
#newsFile <- "en_US.news.txt"
#twitterFile <- "en_US.twitter.txt"

#blogs <- readLines(paste(dataDir, blogsFile, sep="/"))
#news <- readLines(paste(dataDir, newsFile, sep="/"))
#twitter <- readLines(paste(dataDir, twitterFile, sep="/"))

myStopwords <- stopwords('english')

#myCorpus <- Corpus(VectorSource(twitter))
myCorpus <- VCorpus(DirSource(dataDir), readerControl = list(
  reader=readPlain, 
  language="en_US" 
  #load=TRUE
))

#termFreq(crude[[1]], control=list(removeNumbers=TRUE, stemming=TRUE, removePunctuation=TRUE))

removeHashtags <- function (x){
  gsub("#\\S+", "", x)
}

replaceWWWs <- function (x){
  gsub("www\\S+", "website", x)
}

funs <- list(stripWhitespace,
             removePunctuation,
             removeNumbers,
             content_transformer(tolower))
myCorpus <- tm_map(myCorpus, content_transformer(removeHashtags))
myCorpus <- tm_map(myCorpus, content_transformer(replaceWWWs))
myCorpus <- tm_map(myCorpus, FUN=tm_reduce, tmFuns=funs)
#myCorpus <- tm_map(myCorpus, tm::stripWhitespace)
#myCorpus <- tm_map(myCorpus, removeWords, myStopwords)

unigramTDM <- TermDocumentMatrix(myCorpus, control = list())
saveRDS(unigramTDM, "unigramTDM.rds")
unigramFrequency <- findTermFrequency(unigramTDM)
saveRDS(unigramFrequency, "unigramFrequency.rds")
rm(unigramFrequency)
rm(unigramTDM)

bigramTDM <- TermDocumentMatrix(myCorpus, control = list(tokenize = bigramTokenizer))
saveRDS(bigramTDM, "bigramTDM.rds")
bigramFrequency <- findTermFrequency(bigramTDM)
saveRDS(bigramFrequency, "bigramFrequency.rds")
rm(bigramFrequency)
rm(bigramTDM)

trigramTDM <- TermDocumentMatrix(myCorpus, control = list(tokenize = trigramTokenizer))
saveRDS(trigramTDM, "trigramTDM.rds")
trigramFrequency <- findTermFrequency(trigramTDM)
saveRDS(trigramFrequency, "trigramFrequency.rds")
rm(trigramFrequency)
rm(trigramTDM)

