## ----setup, include=FALSE-------------------------------------------------------------------------------
knitr::opts_chunk$set(warning = FALSE, message = FALSE, root.dir = "/Users/Shared/AttM") 
setwd("/Users/Shared/AttM")


## -------------------------------------------------------------------------------------------------------
library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)


## -------------------------------------------------------------------------------------------------------
load("./Datasets/fight_odds.RData")
load("./Datasets/event_info.RData")


## -------------------------------------------------------------------------------------------------------
event_info$Date = as.character(event_info$Date)


## -------------------------------------------------------------------------------------------------------
fight_odds %>%
  dplyr::mutate(Loser = ifelse(Winner == Fighter1, Fighter2, Fighter1)) -> fight_odds


## -------------------------------------------------------------------------------------------------------
fight_odds %>%
  dplyr::mutate(
    Winner_Odds = ifelse(Winner == Fighter1, Fighter1_Decimal_Odds, Fighter2_Decimal_Odds)
    , Loser_Odds = ifelse(Loser == Fighter1, Fighter1_Decimal_Odds, Fighter2_Decimal_Odds)
  ) -> fight_odds


## -------------------------------------------------------------------------------------------------------
fight_odds %>% dplyr::select(
  -c(
    "Events"
    , "Fighter1"
    , "Fighter1_Decimal_Odds"
    , "Fighter2"
    , "Fighter2_Decimal_Odds"
    )
  ) -> fight_odds_clean


## -------------------------------------------------------------------------------------------------------
setdiff(fight_odds_clean$Date, event_info$Date)


## -------------------------------------------------------------------------------------------------------
fight_odds_clean$Date = dplyr::recode(
  fight_odds_clean$Date
  , "2020-12-06" = "2020-12-05"
  , "2020-11-29" = "2020-11-28"
  , "2020-10-04" = "2020-10-03"
  , "2020-05-14" = "2020-05-13"
  , "2020-05-10" = "2020-05-09"
  , "2020-03-08" = "2020-03-07"
  , "2020-02-09" = "2020-02-08"
  , "2019-12-15" = "2019-12-14"
  , "2018-02-04" = "2018-02-03"
  , "2017-12-31" = "2017-12-30"
  , "2017-12-02" = "2017-12-01"
  , "2016-12-31" = "2016-12-30"
  , "2013-12-07" = "2013-12-06"
)


## -------------------------------------------------------------------------------------------------------
fight_odds_clean %>% dplyr::select(
  -c("Loser")
) -> fight_odds_clean_win
  
fight_odds_clean %>% dplyr::select(
  -c("Winner")
) -> fight_odds_clean_lose


## -------------------------------------------------------------------------------------------------------
df_fight_win = merge(event_info, fight_odds_clean_win, by = c("Winner", "Date"))
df_fight_lose = merge(event_info, fight_odds_clean_lose, by = c("Loser", "Date"))


## -------------------------------------------------------------------------------------------------------
df_fight_bind = rbind(df_fight_win, df_fight_lose)


## -------------------------------------------------------------------------------------------------------
df_fight_bind %>% distinct() -> event_and_odds 


## -------------------------------------------------------------------------------------------------------
nrow(fight_odds_clean) - nrow(event_and_odds )   


## -------------------------------------------------------------------------------------------------------
lost_fight_dates = unique(fight_odds_clean$Date)[!(unique(fight_odds_clean$Date) %in% unique(event_and_odds$Date))]


## -------------------------------------------------------------------------------------------------------
event_info %>%
  dplyr::filter(Date %in% lost_fight_dates) %>%
  group_by(Date) %>%
  dplyr::summarise(Events = unique(Event))


## -------------------------------------------------------------------------------------------------------
lost_winners = unique(fight_odds_clean$Winner)[!(unique(fight_odds_clean$Winner) %in% unique(event_and_odds$Winner))]
lost_losers = unique(fight_odds_clean$Loser)[!(unique(fight_odds_clean$Loser) %in% unique(event_and_odds$Loser))]


## -------------------------------------------------------------------------------------------------------
fight_odds_clean %>% 
  dplyr::select(
    Date
    , Winner_Odds
    , Loser_Odds
  ) -> fight_odds_clean_odds

event_and_odds %>%
  dplyr::select(
    Date
    , Winner_Odds
    , Loser_Odds
  ) -> event_and_odds_odds

fight_odds_clean_odds$Coder = "b"
event_and_odds_odds$ Coder = "d"

df_compare = rbind(event_and_odds_odds, fight_odds_clean_odds)

dupsBetweenGroups <- function (df, idcol) {
  # df: the data frame
  # idcol: the column which identifies the group each row belongs to
  
  # Get the data columns to use for finding matches
  datacols <- setdiff(names(df), idcol)
  
  # Sort by idcol, then datacols. Save order so we can undo the sorting later.
  sortorder <- do.call(order, df)
  df <- df[sortorder,]
  
  # Find duplicates within each id group (first copy not marked)
  dupWithin <- duplicated(df)
  
  # With duplicates within each group filtered out, find duplicates between groups. 
  # Need to scan up and down with duplicated() because first copy is not marked.
  dupBetween = rep(NA, nrow(df))
  dupBetween[!dupWithin] <- duplicated(df[!dupWithin,datacols])
  dupBetween[!dupWithin] <- duplicated(df[!dupWithin,datacols], fromLast=TRUE) | dupBetween[!dupWithin]
  
  # ============= Replace NA's with previous non-NA value ==============
  # This is why we sorted earlier - it was necessary to do this part efficiently
  
  # Get indexes of non-NA's
  goodIdx <- !is.na(dupBetween)
  
  # These are the non-NA values from x only
  # Add a leading NA for later use when we index into this vector
  goodVals <- c(NA, dupBetween[goodIdx])
  
  # Fill the indices of the output vector with the indices pulled from
  # these offsets of goodVals. Add 1 to avoid indexing to zero.
  fillIdx <- cumsum(goodIdx)+1
  
  # The original vector, now with gaps filled
  dupBetween <- goodVals[fillIdx]
  
  # Undo the original sort
  dupBetween[sortorder] <- dupBetween
  
  # Return the vector of which entries are duplicated across groups
  return(dupBetween)
}

dupRows <- dupsBetweenGroups(df_compare, "Coder")

df_dups = cbind(df_compare, dupRows)

lost_fight_odds = df_dups[df_dups$dupRows == F,]

lost_fights = merge(lost_fight_odds, fight_odds_clean)


## -------------------------------------------------------------------------------------------------------
lost_fights[,c(1,6,7)]


## -------------------------------------------------------------------------------------------------------
save(event_and_odds, file = "./Datasets/event_and_odds.RData")


## -------------------------------------------------------------------------------------------------------
load("./Datasets/fighter_stats.RData")


## -------------------------------------------------------------------------------------------------------
fighter_stats$WeightClass = dplyr::recode(
  fighter_stats$WeightClass
  , "lightweight" = "Lightweight"
  , "heavyweight" = "Heavyweight"
  , "featherweight" = "Featherweight"
  , "welterweight" = "Welterweight"
  , "middleweight" = "Middleweight"
  , "lightheavyweight" = "Light Heavyweight"
  , "catchweight" = "Catch Weight"
  , "flyweight" = "Flyweight"
  , "strawweight" = "Strawweight"
  , "bantamweight" = "Bantamweight"
)


## -------------------------------------------------------------------------------------------------------
fighter_stats %>%
  dplyr::rename(
    "FighterWeightClass" = "WeightClass"
    , "FighterWeight" = "Weight"
  ) -> fighter_stats

event_and_odds %>%
  dplyr::rename(
    "FightWeightClass" = "WeightClass"
  ) -> event_and_odds


## -------------------------------------------------------------------------------------------------------
event_and_odds %>%
  dplyr::mutate(
    Sex = ifelse(grepl("Women's ", FightWeightClass), "Female", "Male")
  ) -> event_and_odds


## -------------------------------------------------------------------------------------------------------
event_and_odds$FightWeightClass = gsub("Women's ", "", event_and_odds$FightWeightClass)


## -------------------------------------------------------------------------------------------------------
unique(event_and_odds$FightWeightClass)


## -------------------------------------------------------------------------------------------------------
event_and_odds$fight_id = 1:nrow(event_and_odds)


## -------------------------------------------------------------------------------------------------------
event_and_odds %>%
  gather(Result, NAME, c("Winner", "Loser")) -> event_and_odds_long


## -------------------------------------------------------------------------------------------------------
df_master = merge(event_and_odds_long, fighter_stats, by = c("NAME"))


## -------------------------------------------------------------------------------------------------------
nrow(df_master) - nrow(event_and_odds_long)


## -------------------------------------------------------------------------------------------------------
df_master %>% distinct() -> df_master


## -------------------------------------------------------------------------------------------------------
sum(duplicated(fighter_stats$NAME))


## -------------------------------------------------------------------------------------------------------
fighter_stats[duplicated(fighter_stats$NAME),]


## -------------------------------------------------------------------------------------------------------
fighter_stats[fighter_stats$NAME %in% fighter_stats$NAME[duplicated(fighter_stats$NAME)], ]


## -------------------------------------------------------------------------------------------------------
dup_names = fighter_stats$NAME[duplicated(fighter_stats$NAME)]

df_master %>%
  dplyr::filter(
    !((NAME %in% dup_names) & (FighterWeightClass != FightWeightClass))
  ) -> df_master 


## -------------------------------------------------------------------------------------------------------
df_master %>%
  group_by(fight_id) %>%
  summarize(count = length(Sex)) %>%
  dplyr::filter(count != 2) -> to_remove_from_master

df_master[df_master$fight_id %in% to_remove_from_master$fight_id,]

df_master = df_master[!(df_master$fight_id %in% to_remove_from_master$fight_id),]


## -------------------------------------------------------------------------------------------------------
save(df_master, file = "./Datasets/df_master.RData")


## -------------------------------------------------------------------------------------------------------
load("./Datasets/current_fighter_stats.RData")


## -------------------------------------------------------------------------------------------------------
current_fighter_stats$WeightClass = dplyr::recode(
  current_fighter_stats$WeightClass
  , "lightweight" = "Lightweight"
  , "heavyweight" = "Heavyweight"
  , "featherweight" = "Featherweight"
  , "welterweight" = "Welterweight"
  , "middleweight" = "Middleweight"
  , "lightheavyweight" = "Light Heavyweight"
  , "catchweight" = "Catch Weight"
  , "flyweight" = "Flyweight"
  , "strawweight" = "Strawweight"
  , "bantamweight" = "Bantamweight"
)


## -------------------------------------------------------------------------------------------------------
current_fighter_stats %>%
  dplyr::rename(
    "FighterWeightClass" = "WeightClass"
    , "FighterWeight" = "Weight"
  ) -> current_fighter_stats

current_fighter_stats %>%
  dplyr::rename(
    "Date" = "Event_Date" 
  ) -> current_fighter_stats


## -------------------------------------------------------------------------------------------------------
current_fighter_stats$Date = as.character(current_fighter_stats$Date)


## -------------------------------------------------------------------------------------------------------
df_current_master = merge(event_and_odds_long, current_fighter_stats, by = c("NAME", "Date"))


## -------------------------------------------------------------------------------------------------------
df_current_master %>% distinct() -> df_current_master


## -------------------------------------------------------------------------------------------------------
df_current_master %>%
  group_by(fight_id) %>%
  summarize(count = length(Sex)) %>%
  dplyr::filter(count != 2) -> to_remove_from_master

df_current_master[df_current_master$fight_id %in% to_remove_from_master$fight_id,]

df_current_master = df_current_master[!(df_current_master$fight_id %in% to_remove_from_master$fight_id),]


## -------------------------------------------------------------------------------------------------------
save(df_current_master, file = "./Datasets/df_current_master.RData")

