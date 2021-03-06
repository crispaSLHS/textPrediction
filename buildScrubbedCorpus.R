setwd("~/projects/capstone")
source("requirements.R")

convert_text_to_sentences <- function(text, lang = "en") {
  # Function to compute sentence annotations using the Apache OpenNLP Maxent sentence detector employing the default model for language 'en'. 
  sentence_token_annotator <- Maxent_Sent_Token_Annotator(language = lang)
  
  # Convert text to class String from package NLP
  text <- as.String(text)
  
  # Sentence boundaries in text
  sentence.boundaries <- annotate(text, sentence_token_annotator)
  
  # Extract sentences
  sentences <- text[sentence.boundaries]
  
  # return sentences
  return(sentences)
}

removeHashtags <- function (x){
  gsub("#\\S+", "", x)
}

removeUnicode <- function (x){
  gsub("([^a-z\\s])", "", x, perl = TRUE)
}

replaceWWWs <- function (x){
  gsub("www\\S+", "website", x)
}

reshape_corpus <- function(current.corpus, FUN, ...) {
  # Extract the text from each document in the corpus and put into a list
  text <- lapply(current.corpus, content)
  
  # Basically convert the text
  docs <- lapply(text, FUN, ...)
  docs <- as.vector(unlist(docs))
  
  # Create a new corpus structure and return it
  new.corpus <- Corpus(VectorSource(docs))
  return(new.corpus)
}

scrubLines <- function(myLines){
  scrubbedLines <- lapply(myLines, qdap::sent_detect)
  scrubbedLines <- unlist(scrubbedLines)
  
  scrubbedLines
}

myCorpus <- VCorpus(DirSource(rawDataDir))
myCorpus <- reshape_corpus(myCorpus, convert_text_to_sentences)

funs <- list(stripWhitespace,
             removePunctuation,
             removeNumbers,
             content_transformer(tolower))
myCorpus <- tm_map(myCorpus, content_transformer(removeHashtags))
myCorpus <- tm_map(myCorpus, content_transformer(replaceWWWs))
myCorpus <- tm_map(myCorpus, FUN=tm_reduce, tmFuns=funs)
myCorpus <- tm_map(myCorpus, content_transformer(removeUnicode))

saveRDS(myCorpus,"data/myScrubbedCorpus.rds")
