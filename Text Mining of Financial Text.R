# Load necessary libraries
library(tidyverse)
library(tidytext)
library(wordcloud)
library(RColorBrewer)

# Read the financial data CSV file
financial <- read.csv("financial data.csv")

# Rename columns for easier reference
colnames(financial) <- c("neutral", "text")

# Tokenize the text into words
financial_tokens <- financial %>%
  unnest_tokens(word, text)
head(financial_tokens)

# Remove stop words
data("stop_words")
financial_clean <- financial_tokens %>%
  anti_join(stop_words, by = "word")
head(financial_clean)

# Count word frequencies
financial_freq <- financial_clean %>%
  count(word, sort = TRUE)
head(financial_freq)

# Sentiment analysis with Bing lexicon
financial_sentiment <- get_sentiments("bing")
financial_sentiment_analysis <- financial_clean %>%
  inner_join(financial_sentiment, by = "word") %>%
  count(word, sentiment, sort = TRUE)
head(financial_sentiment_analysis)

# Create a word cloud
wordcloud(words = financial_freq$word, freq = financial_freq$n, 
          min.freq = 1, random.order = FALSE, 
          colors = brewer.pal(8,"Set1"))