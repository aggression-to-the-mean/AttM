## ----setup, include = FALSE-----------------------------------------------------------------------------
knitr::opts_chunk$set(warning = FALSE, message = FALSE, root.dir = "/Users/Shared/AttM")
setwd("/Users/Shared/AttM")


## -------------------------------------------------------------------------------------------------------
library(rvest)
library(dplyr)
library(tidyr)
library(stringr)


## -------------------------------------------------------------------------------------------------------

read_html("http://ufcstats.com/statistics/events/completed") %>% 
  html_nodes(".b-link") %>%
  html_attr("href") -> url_event_list 

url_upcoming = url_event_list[1]

read_html(url_upcoming) %>%
  html_nodes(".l-page_align_left .b-link_style_black") %>%
  html_attr("href") -> url_list

read_html(url_upcoming) %>%
  html_nodes(".b-list__box-list-item:nth-child(1)") %>%
  html_text() -> rough_date

clean_date2 = trimws(strsplit(trimws(rough_date), ":")[[1]][2])
clean_date <- as.Date(clean_date2, format = "%B %d, %Y")


## -------------------------------------------------------------------------------------------------------
load("./Datasets/current_fighter_stats.RData")
master_temp = current_fighter_stats
rm(current_fighter_stats)  
most_recent_date = max(unique(master_temp$Event_Date))


## -------------------------------------------------------------------------------------------------------
name <- character(length(url_list))
weightclass <- numeric(length(url_list))
reach <- numeric(length(url_list))
slpm <- numeric(length(url_list))
td <- numeric(length(url_list))
tda <- numeric(length(url_list))
tdd <- numeric(length(url_list))
stra <- numeric(length(url_list))
strd <- numeric(length(url_list))
suba <- numeric(length(url_list))
sapm <- numeric(length(url_list))
num_fights <- numeric(length(url_list))


## -------------------------------------------------------------------------------------------------------

# start the clock
ptm <- proc.time()

for(i in 1:length(url_list)) {
  
  # # print iteration
  # print(i)
  # # start the clock
  # ptm <- proc.time()
  
  # fighter url
  fighter_url <- read_html(url_list[i])
  
  # fighter name
  name_t <- fighter_url %>% html_nodes(".b-content__title-highlight") %>% html_text()
  name_t <- gsub("\n", "", name_t)
  name[i] <- as.character(trimws(name_t))
  
  #weightclass
  weightclass_t <- fighter_url %>% html_nodes(".b-list__info-box_style_small-width .b-list__box-list-item_type_block:nth-child(2)") %>% html_text()
  weightclass_t <- gsub(" ", "", weightclass_t)
  weightclass_t <- gsub("\n", "", weightclass_t)
  weightclass_t <- strsplit(weightclass_t, ":")
  weightclass_t <- weightclass_t[[1]][2]
  weightclass_t <- strsplit(weightclass_t, "l")
  weightclass[i] <- as.numeric(as.character(weightclass_t[[1]][1]))
  
  #reach
  reach_t <- fighter_url %>% html_nodes(".b-list__info-box_style_small-width .b-list__box-list-item_type_block:nth-child(3)") %>% html_text()
  reach_t <- gsub(" ", "", reach_t)
  reach_t <- gsub("\n", "", reach_t)
  reach_t <- strsplit(reach_t, ":")
  reach_t <- reach_t[[1]][2]
  reach_t <- strsplit(reach_t, "\"")
  reach[i] <- as.numeric(as.character(reach_t[[1]][1]))
  
  #feature 1: slpm
  slpm_t <- fighter_url %>% html_nodes(".b-list__info-box-left .b-list__info-box-left .b-list__box-list-item_type_block:nth-child(1)") %>% html_text()
  slpm_t <- gsub(" ", "", slpm_t)
  slpm_t <- gsub("\n", "", slpm_t)
  slpm_t <- strsplit(slpm_t, ":")
  slpm_t <- slpm_t[[1]][2]
  slpm[i] <- as.numeric(slpm_t)
  
  #feature 2: takedown avg
  td_t <- fighter_url %>% html_nodes(".b-list__info-box_style-margin-right .b-list__box-list-item_type_block:nth-child(2)") %>% html_text()
  td_t<- gsub(" ", "", td_t)
  td_t <- gsub("\n", "", td_t)
  td_t <- strsplit(td_t, ":")
  td_t <- td_t[[1]][2]
  td[i] <- as.numeric(td_t)
  
  #feature 3: significant striking accuracy
  stra_t <- fighter_url %>% html_nodes(".b-list__info-box-left .b-list__info-box-left .b-list__box-list-item_type_block:nth-child(2)") %>% html_text()
  stra_t <- gsub(" ", "", stra_t)
  stra_t <- gsub("\n", "", stra_t)
  stra_t <- strsplit(stra_t, ":")
  stra_t <- stra_t[[1]][2]
  stra_t <- strsplit(stra_t, "%")
  stra[i] <- as.numeric(stra_t) / 100
  
  #feature 4: takedown accuracy 
  tda_t <- fighter_url %>% html_nodes(".b-list__info-box_style-margin-right .b-list__box-list-item_type_block:nth-child(3)") %>% html_text()
  tda_t <- gsub(" ", "", tda_t)
  tda_t <- gsub("\n", "", tda_t)
  tda_t <- strsplit(tda_t, ":")
  tda_t <- tda_t[[1]][2]
  tda_t <- strsplit(tda_t, "%")
  tda[i] <- as.numeric(tda_t) / 100
  
  #feature 5: significant absorbed stras per minute
  sapm_t <- fighter_url %>% html_nodes(".b-list__info-box-left .b-list__info-box-left .b-list__box-list-item_type_block:nth-child(3)") %>% html_text()
  sapm_t <- gsub(" ", "", sapm_t)
  sapm_t <- gsub("\n", "", sapm_t)
  sapm_t <- strsplit(sapm_t, ":")
  sapm_t <- sapm_t[[1]][2]
  sapm[i] <- as.numeric(sapm_t)
  
  #feature 6: takedown def
  tdd_t <- fighter_url %>% html_nodes(".b-list__info-box_style-margin-right .b-list__box-list-item_type_block:nth-child(4)") %>% html_text()
  tdd_t <- gsub(" ", "", tdd_t)
  tdd_t <- gsub("\n", "", tdd_t)
  tdd_t <- strsplit(tdd_t, ":")
  tdd_t <- tdd_t[[1]][2]
  tdd_t <- strsplit(tdd_t, "%")
  tdd[i] <- as.numeric(tdd_t) / 100
  
  #feature 7: striking def
  strd_t <- fighter_url %>% html_nodes(".b-list__info-box-left .b-list__info-box-left .b-list__box-list-item_type_block:nth-child(4)") %>% html_text()
  strd_t <- gsub(" ", "", strd_t)
  strd_t <- gsub("\n", "", strd_t)
  strd_t <- strsplit(strd_t, ":")
  strd_t <- strd_t[[1]][2]
  strd_t <- strsplit(strd_t, "%")
  strd[i] <- as.numeric(strd_t) / 100
  
  #feature 8: submission average
  suba_t <- fighter_url %>% html_nodes(".b-list__box-list_margin-top .b-list__box-list-item_type_block:nth-child(5)") %>% html_text()
  suba_t <- gsub(" ", "", suba_t)
  suba_t <- gsub("\n", "", suba_t)
  suba_t <- strsplit(suba_t, ":")
  suba_t <- suba_t[[1]][2]
  suba[i] <- as.numeric(suba_t)
  
  # number of fights on record
  num_fights_t <- fighter_url %>% html_nodes(".b-flag__text") %>% html_text()
  num_fights[i] <- length(num_fights_t)
  
  # # stop the clock
  # print(proc.time() - ptm) 
}

# stop the clock
print(proc.time() - ptm) 


## -------------------------------------------------------------------------------------------------------

data_date = Sys.Date()

database <- data.frame(
  NAME = name
  , Weight = weightclass
  , REACH = reach
  , SLPM = slpm
  , SAPM = sapm
  , STRA = stra
  , STRD = strd
  , TD = td
  , TDA = tda
  , TDD = tdd
  , SUBA = suba 
  , Num_Fights = num_fights
  , Event_Date = clean_date
  , Data_Date = data_date
)

data_add_wc <- mutate(
  database
  , WeightClass = ifelse(Weight == 115, "strawweight"
                         , ifelse(Weight == 125, "flyweight"
                                  , ifelse(Weight == 135, "bantamweight"
                                           , ifelse(Weight == 145, "featherweight"
                                                    , ifelse(Weight == 155, "lightweight"
                                                             , ifelse(Weight == 170, "welterweight"
                                                                      , ifelse(Weight == 185, "middleweight"
                                                                               , ifelse(Weight == 205, "lightheavyweight"
                                                                                        , ifelse(Weight > 205, "heavyweight"
                                                                                                 , "catchweight"))))))))))


## -------------------------------------------------------------------------------------------------------
data_add_wc[is.na(data_add_wc$Weight), ]


## -------------------------------------------------------------------------------------------------------
data_clean <- data_add_wc[!is.na(data_add_wc$Weight), ]


## -------------------------------------------------------------------------------------------------------
data_clean %>% filter(WeightClass == "catchweight")


## -------------------------------------------------------------------------------------------------------
summary(data_clean)


## -------------------------------------------------------------------------------------------------------
 
if (most_recent_date < clean_date) {

  print(sprintf("We are updating the database to include event on %s", clean_date))

} else if(most_recent_date == clean_date) {
  
  # most recent addition
  most_recent_add = max(unique(master_temp$Data_Date))
  
  print(sprintf("Info from %s will be replaced by that from %s", most_recent_add, data_date))
  
  # get rid of past addition for more up-to-date addition
  master_temp %>%
    dplyr::filter(Event_Date != clean_date) -> master_temp
  
} else {
  print("ERROR: The next event date may be greater than what is recorded in this data set...")
}

# combine data
current_fighter_stats = rbind(master_temp, data_clean)


## -------------------------------------------------------------------------------------------------------
save(current_fighter_stats, file = "./Datasets/current_fighter_stats.RData")

