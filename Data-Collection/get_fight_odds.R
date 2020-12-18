## ----setup, include=FALSE-------------------------------------------------------------------------------------------
knitr::opts_chunk$set(warning = FALSE, message = FALSE, root.dir = "/Users/Shared/Rogue-MMA")
setwd("/Users/Shared/Rogue-MMA")


## -------------------------------------------------------------------------------------------------------------------
library(rvest)
library(dplyr)
library(tidyr)
library(stringr)
library(data.table)
library(dtplyr)
library(ggplot2)
library(lubridate)


## -------------------------------------------------------------------------------------------------------------------
url <- read_html("http://www.betmma.tips/past_mma_handicapper_performance_all.php")


## -------------------------------------------------------------------------------------------------------------------
links <- url %>% html_nodes("td td td a") %>% html_attr("href")


## -------------------------------------------------------------------------------------------------------------------
links <- paste0("http://www.betmma.tips/", links) 


## -------------------------------------------------------------------------------------------------------------------
titles <- url %>% html_nodes("td td td a") %>% html_text()
UFC_indices = grepl("UFC", trimws(titles))
links <- links[UFC_indices]


## -------------------------------------------------------------------------------------------------------------------
url2 <- read_html("http://www.betmma.tips/mma_betting_favorites_vs_underdogs.php?Org=1")
links2 <- url2 %>% html_nodes("td td td td a") %>% html_attr("href")
links2 <- paste0("http://www.betmma.tips/", links2) 
titles2 <- url2 %>% html_nodes("td td td td a")  %>% html_text()
links2 <- links2[!(trimws(titles2) %in% trimws(titles))]


## -------------------------------------------------------------------------------------------------------------------
links <- c(links, links2)

event <- c()
datez <- c()
fighter1 <- c()
fighter2 <- c()
fighter1_odds <- c()
fighter2_odds <- c()
win <- c()

wins_mismatch = 0
fighters_mismatch = 0
fighter1_mismatch = 0
fighter2_mismatch = 0
win_included = 0

wins_mismatch_event <- c()
fighters_mismatch_event <- c()
fighter1_mismatch_event <- c()
fighter2_mismatch_event <- c()
win_included_event <- c()


## -------------------------------------------------------------------------------------------------------------------

# start the clock
ptm <- proc.time()

for (i in 1:length(links)){
  
  # # print iteration
  # print(sprintf("%d of %d", i, length(links)))
  
  # # start the clock
  # ptm <- proc.time()
  
  # fighter info
  sub_link <- read_html(links[i])
  fighters_t <- sub_link %>% html_nodes("td td td a+ a") %>% html_text()  
  fighters_t <- fighters_t[fighters_t != " vs "]
  fighters_t <- fighters_t[fighters_t != ""]
  
  fighter1_t <- fighters_t[c(T, F)]
  fighter2_t <- fighters_t[c(F, T)]
  
  # event info
  event_t <- sub_link %>% html_nodes("td h1") %>% html_text()
  date_t <- sub_link %>% html_nodes("h2") %>% html_text()
  date_t <- strsplit(date_t, ";")[[1]][2]
  date_t <- as.character(parse_date_time(date_t, orders = "dmy"))
  # print(date_t)
  
  
  # odds info
  label <- c()
  label_t <- sub_link %>% html_nodes("td td td td tr~ tr+ tr td") %>% html_text()
  label_cleansed <- gsub("@", "",trimws(label_t))
  
  # fight outcome info
  win_t <- sub_link %>% html_nodes("td td td td br+ a") %>% html_text()
  
  # get every second odd (i.e. those corresponding to fighter 1)
  fighter1_odds_t <- label_cleansed[c(TRUE, FALSE)]
  
  # get every second odd (i.e. those corresponding to fighter 2)
  fighter2_odds_t <- label_cleansed[c(FALSE, TRUE)]
  
  
  # QUALITY CONTROL:
  # how many wins to we have?
  lwins = length(win_t)
  # how many odds do we have for f1?
  l1odds = length(fighter1_odds_t)
  # how many odds do we have for f2?
  l2odds = length(fighter2_odds_t)
  # how long is the list of fighter 1s?
  l1 = length(fighter1_t)
  # how long is the list of fighter 2s?
  l2 = length(fighter2_t)
  
  skip_this = F
  
  if (!(l1odds == l1)) {
    fighter1_mismatch = fighter1_mismatch + 1
    fighter1_mismatch_event = c(fighter1_mismatch_event, event_t)
    # print("fighter 1 mismatch")
    skip_this = T
  }
  if (!(l2odds == l2)) {
    fighter2_mismatch = fighter2_mismatch + 1
    fighter2_mismatch_event = c(fighter2_mismatch_event, event_t)
    # print("fighter 2 mismatch")
    skip_this = T
  }
  if (!(l1 == l2)) {
    fighters_mismatch = fighters_mismatch + 1
    fighters_mismatch_event = c(fighters_mismatch_event, event_t)
    # print("mismatch between fighters 1 and 2")
    skip_this = T
  }
  if (!(l1 == lwins)) {
    wins_mismatch = wins_mismatch + 1
    wins_mismatch_event = c(wins_mismatch_event, event_t)
    # print("wins mismatch with fighter 1")
    
    # if there is a mismatch between fighter1 and number of wins 
    # , and if fighter1 and fighter 2 lists are the same length
    # , then we can take out the fight for which there was no win
    if (l1 == l2 | l2odds == l2 | l1odds == l1) {
      keep_indices1_t = which(fighter1_t %in% win_t)
      keep_indices2_t = which(fighter2_t %in% win_t)
      
      keep_indices_t = sort(c(keep_indices1_t, keep_indices2_t))
      
      fighter1_t = fighter1_t[keep_indices_t]
      fighter2_t = fighter2_t[keep_indices_t]
      
      fighter1_odds_t = fighter1_odds_t[keep_indices_t]
      fighter2_odds_t = fighter2_odds_t[keep_indices_t]
      
      
      win_included = win_included + 1
      win_included_event = c(win_included_event, event_t)
    }
    
  }
  
  if (!(skip_this)) {
    # APPEND LONG LISTS
    fighter1 = c(fighter1, fighter1_t)
    fighter2 = c(fighter2, fighter2_t)
    fighter1_odds <- c(fighter1_odds, fighter1_odds_t)
    fighter2_odds <- c(fighter2_odds, fighter2_odds_t)
    win <- c(win, win_t)
    # replicate event name 
    event <- c(event, replicate(length(fighter1_t),event_t))
    # replicate event date
    datez <- c(datez, replicate(length(fighter1_t), date_t))
  }
  
  # # stop the clock
  # print(proc.time() - ptm)
}  

# stop the clock
print(proc.time() - ptm)


## -------------------------------------------------------------------------------------------------------------------
excluded_events = unique(c(fighter1_mismatch_event, fighter2_mismatch_event, fighters_mismatch_event))


## -------------------------------------------------------------------------------------------------------------------
excluded_events


## -------------------------------------------------------------------------------------------------------------------
length(excluded_events) / length(links)


## -------------------------------------------------------------------------------------------------------------------
fight_odds <- data.frame(
  Date = datez
  , Events = event
  , Fighter1 = fighter1
  , Fighter1_Decimal_Odds = fighter1_odds
  , Fighter2 = fighter2
  , Fighter2_Decimal_Odds = fighter2_odds
  , Winner = win
)

# save file for master script
save(fight_odds, file = "./Datasets/fight_odds.RData")

