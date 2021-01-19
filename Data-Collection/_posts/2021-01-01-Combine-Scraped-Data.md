---
category: science
---

<br>

Description
-----------

This script combines fight data that has been scraped from various
sites.

<br>

### Libraries

    library(dplyr)
    library(tidyr)
    library(stringr)
    library(ggplot2)

<br>

### Combine Databases Events & Odds

<br>

#### Pre-process

Load data.

    load("./Datasets/fight_odds.RData")
    load("./Datasets/event_info.RData")

Ensure that dates are characters.

    event_info$Date = as.character(event_info$Date)

Add loser column.

    fight_odds %>%
      dplyr::mutate(Loser = ifelse(Winner == Fighter1, Fighter2, Fighter1)) -> fight_odds

Identify odds by Winner/Loser label.

    fight_odds %>%
      dplyr::mutate(
        Winner_Odds = ifelse(Winner == Fighter1, Fighter1_Decimal_Odds, Fighter2_Decimal_Odds)
        , Loser_Odds = ifelse(Loser == Fighter1, Fighter1_Decimal_Odds, Fighter2_Decimal_Odds)
      ) -> fight_odds

Only keep columns of interest.

    fight_odds %>% dplyr::select(
      -c(
        "Events"
        , "Fighter1"
        , "Fighter1_Decimal_Odds"
        , "Fighter2"
        , "Fighter2_Decimal_Odds"
        )
      ) -> fight_odds_clean

Identify date discrepancies as odds website appears to have some of the
dates wrong if compared to UFC website.

    setdiff(fight_odds_clean$Date, event_info$Date)

    ##  [1] "2020-12-06" "2020-11-29" "2020-10-04" "2020-05-14" "2020-05-10"
    ##  [6] "2020-03-08" "2020-02-09" "2019-12-15" "2018-02-04" "2017-12-31"
    ## [11] "2016-12-31" "2013-12-07"

Correct manually for these discrepancies

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

Get rid of either the Loser or Winner column to merge below.

    fight_odds_clean %>% dplyr::select(
      -c("Loser")
    ) -> fight_odds_clean_win
      
    fight_odds_clean %>% dplyr::select(
      -c("Winner")
    ) -> fight_odds_clean_lose

Merge by (either Winner or Loser) and Date

    df_fight_win = merge(event_info, fight_odds_clean_win, by = c("Winner", "Date"))
    df_fight_lose = merge(event_info, fight_odds_clean_lose, by = c("Loser", "Date"))

Add these databases together.

    df_fight_bind = rbind(df_fight_win, df_fight_lose)

Remove duplicates.

    df_fight_bind %>% distinct() -> event_and_odds 

<br>

#### Quality Control

How much data (\# rows) do we lose if compared to fight\_odds\_clean
data frame?

    nrow(fight_odds_clean) - nrow(event_and_odds )   

    ## [1] 52

Which fight dates, if any, did we lose entirely?

    lost_fight_dates = unique(fight_odds_clean$Date)[!(unique(fight_odds_clean$Date) %in% unique(event_and_odds$Date))]

Which events do these dates correspond to?

    event_info %>%
      dplyr::filter(Date %in% lost_fight_dates) %>%
      group_by(Date) %>%
      dplyr::summarise(Events = unique(Event))

    ## # A tibble: 1 x 2
    ##   Date       Events                                           
    ##   <chr>      <chr>                                            
    ## 1 2017-12-01 The Ultimate Fighter: A New World Champion Finale

Which Winners and Losers were lost during merging?

    lost_winners = unique(fight_odds_clean$Winner)[!(unique(fight_odds_clean$Winner) %in% unique(event_and_odds$Winner))]
    lost_losers = unique(fight_odds_clean$Loser)[!(unique(fight_odds_clean$Loser) %in% unique(event_and_odds$Loser))]

What other data did we lose (based on Odds and Date)?

The below code identifies the discrepancies between the
fight\_oods\_clean and event\_and\_odds dataframes.

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

The following fight data were lost.

Unsure of exact reason for these lost fights but finding out could be
tedious. They could be cases where both fight names were mismatches.

    lost_fights[,c(1,6,7)]

    ##          Date                      Winner              Loser
    ## 1  2013-04-27                   Pat Healy         Jim Miller
    ## 2  2014-07-26                Brian Ortega   Mike de la Torre
    ## 3  2014-08-23               Ning Guangyou      Yang Jianping
    ## 4  2015-05-16             Jon delos Reyes  Roldan Sangcha-an
    ## 5  2015-11-07             Matheus Nicolau        Bruno Korea
    ## 6  2015-11-07               Gleison Tibau      Abel Trujillo
    ## 7  2015-11-21              Alvaro Herrera       Vernon Ramos
    ## 8  2015-11-28              Freddy Serrano        Zhuikui Yao
    ## 9  2015-12-12            Tatsuya Kawajiri       Jason Knight
    ## 10 2015-12-12                Ryan LaFlare        Mike Pierce
    ## 11 2015-12-12                 Evan Dunham         Joe Lauzon
    ## 12 2015-12-12               Tony Ferguson      Edson Barboza
    ## 13 2015-12-12         Chris Gruetzemacher     Abner Lloveras
    ## 14 2015-12-12               Frankie Edgar        Chad Mendes
    ## 15 2015-12-12               Geane Herrera       Joby Sanchez
    ## 16 2015-12-12                Julian Erosa     Marcin Wrzosek
    ## 17 2015-12-12             Gabriel Gonzaga Konstantin Erokhin
    ## 18 2015-12-12                   Ryan Hall        Artem Lobov
    ## 19 2016-11-19              Darren Stewart  Francimar Barroso
    ## 20 2017-02-04              Curtis Blaydes      Adam Milstead
    ## 21 2017-02-04                  Niko Price        Alex Morono
    ## 22 2017-03-11             Kelvin Gastelum      Vitor Belfort
    ## 23 2017-07-29                   Jon Jones     Daniel Cormier
    ## 24 2017-11-25                 Yadong Song    Bharat Khandare
    ## 25 2017-12-01               Amanda Cooper      Angela Magana
    ## 26 2017-12-01              Dominick Reyes     Jeremy Kimball
    ## 27 2017-12-01                Henry Cejudo      Sergio Pettis
    ## 28 2017-12-01        Abdul Razak Alhassan       Sabah Homasi
    ## 29 2017-12-01                Max Holloway          Jose Aldo
    ## 30 2017-12-01               Justin Willis      Allen Crowder
    ## 31 2017-12-01             Francis Ngannou   Alistair Overeem
    ## 32 2017-12-01                Tecia Torres  Michelle Waterson
    ## 33 2017-12-01                David Teymur      Drakkar Klose
    ## 34 2017-12-01               Felice Herrig      Cortney Casey
    ## 35 2017-12-01                 Paul Felder   Charles Oliveira
    ## 36 2017-12-01               Eddie Alvarez     Justin Gaethje
    ## 37 2017-12-01              Yancy Medeiros      Alex Oliveira
    ## 38 2017-12-30         Michal Oleksiejczuk    Khalil Rountree
    ## 39 2018-06-09                Mike Jackson        Phil Brooks
    ## 40 2018-11-10               Bobby Moffett        Chas Skelly
    ## 41 2018-11-24                 Yadong Song    Vincent Morales
    ## 42 2018-12-29                 Walt Harris    Andrei Arlovski
    ## 43 2019-03-16            Saparbek Safarov   Nick Negumereanu
    ## 44 2019-07-13                  John Allan     Mike Rodriguez
    ## 45 2019-08-10               Alex da Silva     Rodrigo Vargas
    ## 46 2019-08-31                Mizuki Inoue           Yanan Wu
    ## 47 2020-02-08              Journey Newson    Domingo Pilarte
    ## 48 2020-05-16 Rodrigo Nascimento Ferreira     Don'tale Mayes
    ## 49 2020-07-25                Jesse Ronson      Nicolas Dalby
    ## 50 2020-08-22                Trevin Jones       Timur Valiev
    ## 51 2020-09-12                 Kevin Croom  Roosevelt Roberts

<br>

#### Save Data

    save(event_and_odds, file = "./Datasets/event_and_odds.RData")

<br>

### Add Fighter Stats Database

NOTE: the following fighter stats are dated to when the data were
scrapped from the UFC website. Therefore, once merged with the events
and odds database, the stats will not necessarily be representative of
what they were the night a given fighter was fighting.

<br>

#### Pre-process

Load data:

    load("./Datasets/fighter_stats.RData")

Redefine weight classes.

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

Rename columns.

    fighter_stats %>%
      dplyr::rename(
        "FighterWeightClass" = "WeightClass"
        , "FighterWeight" = "Weight"
      ) -> fighter_stats

    event_and_odds %>%
      dplyr::rename(
        "FightWeightClass" = "WeightClass"
      ) -> event_and_odds

Add Sex category.

    event_and_odds %>%
      dplyr::mutate(
        Sex = ifelse(grepl("Women's ", FightWeightClass), "Female", "Male")
      ) -> event_and_odds

Remove mention of Sex from Weight Class category.

    event_and_odds$FightWeightClass = gsub("Women's ", "", event_and_odds$FightWeightClass)

Check that Weight Class labels make sense.

    unique(event_and_odds$FightWeightClass)

    ##  [1] "Welterweight"      "Light Heavyweight" "Lightweight"      
    ##  [4] "Middleweight"      "Heavyweight"       "Bantamweight"     
    ##  [7] "Strawweight"       "Featherweight"     "Flyweight"        
    ## [10] "Catch Weight"

Create unique fight id for each fight (i.e. each row).

    event_and_odds$fight_id = 1:nrow(event_and_odds)

Gather data frame by fighter (i.e. go from short to long format).

    event_and_odds %>%
      gather(Result, NAME, c("Winner", "Loser")) -> event_and_odds_long

Merge databases.

    df_master = merge(event_and_odds_long, fighter_stats, by = c("NAME"))

<br>

#### Quality Control

Examine difference in data frame length between df\_master and
event\_and\_odds long.

    nrow(df_master) - nrow(event_and_odds_long)

    ## [1] 7

Are there any duplicate rows in df\_master?

    df_master %>% distinct() -> df_master

Where are the additional rows coming from?

    sum(duplicated(fighter_stats$NAME))

    ## [1] 4

Who are these duplicate fighters?

    fighter_stats[duplicated(fighter_stats$NAME),]

    ##                  NAME FighterWeight FighterWeightClass REACH SLPM SAPM STRA
    ## 1132       Joey Gomez           155        Lightweight    71 3.73 3.33 0.49
    ## 1528     Tony Johnson           265        Heavyweight    NA 2.00 4.73 0.53
    ## 2029 Michael McDonald           135       Bantamweight    70 2.69 2.76 0.42
    ## 2990      Bruno Silva           185       Middleweight    NA 0.00 0.00 0.00
    ##      STRD   TD  TDA  TDD SUBA
    ## 1132 0.50 2.00 0.28 0.00  0.0
    ## 1528 0.31 2.00 0.22 0.00  0.0
    ## 2029 0.57 1.09 0.66 0.52  1.4
    ## 2990 0.00 0.00 0.00 0.00  0.0

What are the duplicate entries?

    fighter_stats[fighter_stats$NAME %in% fighter_stats$NAME[duplicated(fighter_stats$NAME)], ]

    ##                  NAME FighterWeight FighterWeightClass REACH SLPM SAPM STRA
    ## 1130       Joey Gomez           135       Bantamweight    73 2.44 4.46 0.28
    ## 1132       Joey Gomez           155        Lightweight    71 3.73 3.33 0.49
    ## 1520     Tony Johnson           205  Light Heavyweight    76 4.00 3.67 0.92
    ## 1528     Tony Johnson           265        Heavyweight    NA 2.00 4.73 0.53
    ## 2027 Michael McDonald           205  Light Heavyweight    NA 0.00 0.40 0.00
    ## 2029 Michael McDonald           135       Bantamweight    70 2.69 2.76 0.42
    ## 2989      Bruno Silva           125          Flyweight    65 2.60 3.51 0.42
    ## 2990      Bruno Silva           185       Middleweight    NA 0.00 0.00 0.00
    ##      STRD   TD  TDA  TDD SUBA
    ## 1130 0.55 0.62 1.00 0.50  0.0
    ## 1132 0.50 2.00 0.28 0.00  0.0
    ## 1520 0.22 0.00 0.00 0.90  0.0
    ## 1528 0.31 2.00 0.22 0.00  0.0
    ## 2027 0.50 0.00 0.00 0.00  0.0
    ## 2029 0.57 1.09 0.66 0.52  1.4
    ## 2989 0.55 3.14 0.30 0.61  0.0
    ## 2990 0.00 0.00 0.00 0.00  0.0

Remove these entries if they have Weight Class mismatches.

    dup_names = fighter_stats$NAME[duplicated(fighter_stats$NAME)]

    df_master %>%
      dplyr::filter(
        !((NAME %in% dup_names) & (FighterWeightClass != FightWeightClass))
      ) -> df_master 

Remove fight IDs without pair.

    df_master %>%
      group_by(fight_id) %>%
      summarize(count = length(Sex)) %>%
      dplyr::filter(count != 2) -> to_remove_from_master

    df_master[df_master$fight_id %in% to_remove_from_master$fight_id,]

    ##  [1] NAME               Date               Event              City              
    ##  [5] State              Country            FightWeightClass   Round             
    ##  [9] Method             Winner_Odds        Loser_Odds         Sex               
    ## [13] fight_id           Result             FighterWeight      FighterWeightClass
    ## [17] REACH              SLPM               SAPM               STRA              
    ## [21] STRD               TD                 TDA                TDD               
    ## [25] SUBA              
    ## <0 rows> (or 0-length row.names)

    df_master = df_master[!(df_master$fight_id %in% to_remove_from_master$fight_id),]

<br>

#### Save File

    save(df_master, file = "./Datasets/df_master.RData")

<br>

### Instead, Add CURRENT Fighter Stats Database

NOTE: unlike the previously fighter stats database that was added, these
fighter stats are as they were at the time of the actual UFC events
(hence “current”). This current fighter stats database will be added to
the events and odds database in the same manner as the previous fighter
stats database.

<br>

#### Pre-process

Load data.

    load("./Datasets/current_fighter_stats.RData")

Redefine weight classes.

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

Rename columns.

    current_fighter_stats %>%
      dplyr::rename(
        "FighterWeightClass" = "WeightClass"
        , "FighterWeight" = "Weight"
      ) -> current_fighter_stats

    current_fighter_stats %>%
      dplyr::rename(
        "Date" = "Event_Date" 
      ) -> current_fighter_stats

Convert Date to character type.

    current_fighter_stats$Date = as.character(current_fighter_stats$Date)

Merge current fighter database with events and odds database.

    df_current_master = merge(event_and_odds_long, current_fighter_stats, by = c("NAME", "Date"))

Get distinct entries.

    df_current_master %>% distinct() -> df_current_master

Get rid of fight IDs without pair.

    df_current_master %>%
      group_by(fight_id) %>%
      summarize(count = length(Sex)) %>%
      dplyr::filter(count != 2) -> to_remove_from_master

    df_current_master[df_current_master$fight_id %in% to_remove_from_master$fight_id,]

    ##               NAME       Date                                  Event      City
    ## 9     Alex Caceres 2020-08-29       UFC Fight Night: Smith vs. Rakic Las Vegas
    ## 50  Brian Kelleher 2020-09-05     UFC Fight Night: Overeem vs. Sakai Las Vegas
    ## 233  Mirsad Bektic 2020-09-19 UFC Fight Night: Covington vs. Woodley Las Vegas
    ##      State Country FightWeightClass Round Method Winner_Odds Loser_Odds  Sex
    ## 9   Nevada     USA    Featherweight     1    SUB        1.54       2.80 Male
    ## 50  Nevada     USA    Featherweight     1    SUB        1.28       4.25 Male
    ## 233 Nevada     USA    Featherweight     3    SUB        4.05       1.30 Male
    ##     fight_id Result FighterWeight REACH SLPM SAPM STRA STRD   TD  TDA  TDD SUBA
    ## 9         73 Winner           145    73 4.14 2.90 0.49 0.65 0.55 0.76 0.59  0.7
    ## 50       372 Winner           145    66 4.48 6.00 0.40 0.53 1.21 0.25 0.76  0.6
    ## 233      623  Loser           145    70 2.59 1.89 0.41 0.58 3.32 0.47 0.92  0.5
    ##     Num_Fights  Data_Date FighterWeightClass
    ## 9           22 2020-08-24      Featherweight
    ## 50           9 2020-08-29      Featherweight
    ## 233         10 2020-09-18      Featherweight

    df_current_master = df_current_master[!(df_current_master$fight_id %in% to_remove_from_master$fight_id),]

<br>

#### Save File

    save(df_current_master, file = "./Datasets/df_current_master.RData")
