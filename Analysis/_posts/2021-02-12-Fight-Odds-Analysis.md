---
category: science
---

<br>

Description
-----------

This script analyzes UFC fight odds data.

<br>

### Libraries

    library(tidyverse)
    library(knitr)

<br>

### Examine Data

Load data.

    load("./Datasets/df_master.RData")

Get summary.

    summary(df_master)

    ##      NAME               Date              Event               City          
    ##  Length:5986        Length:5986        Length:5986        Length:5986       
    ##  Class :character   Class :character   Class :character   Class :character  
    ##  Mode  :character   Mode  :character   Mode  :character   Mode  :character  
    ##                                                                             
    ##                                                                             
    ##                                                                             
    ##                                                                             
    ##     State             Country          FightWeightClass       Round     
    ##  Length:5986        Length:5986        Length:5986        Min.   :1.00  
    ##  Class :character   Class :character   Class :character   1st Qu.:1.00  
    ##  Mode  :character   Mode  :character   Mode  :character   Median :3.00  
    ##                                                           Mean   :2.43  
    ##                                                           3rd Qu.:3.00  
    ##                                                           Max.   :5.00  
    ##                                                                         
    ##     Method          Winner_Odds         Loser_Odds            Sex           
    ##  Length:5986        Length:5986        Length:5986        Length:5986       
    ##  Class :character   Class :character   Class :character   Class :character  
    ##  Mode  :character   Mode  :character   Mode  :character   Mode  :character  
    ##                                                                             
    ##                                                                             
    ##                                                                             
    ##                                                                             
    ##     fight_id       Result          FighterWeight   FighterWeightClass
    ##  Min.   :   1   Length:5986        Min.   :115.0   Length:5986       
    ##  1st Qu.: 749   Class :character   1st Qu.:135.0   Class :character  
    ##  Median :1497   Mode  :character   Median :155.0   Mode  :character  
    ##  Mean   :1497                      Mean   :163.8                     
    ##  3rd Qu.:2245                      3rd Qu.:185.0                     
    ##  Max.   :2993                      Max.   :265.0                     
    ##                                                                      
    ##      REACH            SLPM             SAPM             STRA       
    ##  Min.   :58.00   Min.   : 0.000   Min.   : 0.100   Min.   :0.0000  
    ##  1st Qu.:69.00   1st Qu.: 2.680   1st Qu.: 2.630   1st Qu.:0.3900  
    ##  Median :72.00   Median : 3.440   Median : 3.230   Median :0.4400  
    ##  Mean   :71.77   Mean   : 3.531   Mean   : 3.435   Mean   :0.4417  
    ##  3rd Qu.:75.00   3rd Qu.: 4.250   3rd Qu.: 4.030   3rd Qu.:0.4900  
    ##  Max.   :84.00   Max.   :11.140   Max.   :23.330   Max.   :0.8800  
    ##  NA's   :215                                                       
    ##       STRD              TD              TDA              TDD        
    ##  Min.   :0.0900   Min.   : 0.000   Min.   :0.0000   Min.   :0.0000  
    ##  1st Qu.:0.5100   1st Qu.: 0.560   1st Qu.:0.2700   1st Qu.:0.5100  
    ##  Median :0.5600   Median : 1.210   Median :0.3700   Median :0.6400  
    ##  Mean   :0.5527   Mean   : 1.518   Mean   :0.3745   Mean   :0.6157  
    ##  3rd Qu.:0.6000   3rd Qu.: 2.160   3rd Qu.:0.5000   3rd Qu.:0.7600  
    ##  Max.   :0.9200   Max.   :14.190   Max.   :1.0000   Max.   :1.0000  
    ##                                                                     
    ##       SUBA        
    ##  Min.   : 0.0000  
    ##  1st Qu.: 0.1000  
    ##  Median : 0.4000  
    ##  Mean   : 0.5516  
    ##  3rd Qu.: 0.8000  
    ##  Max.   :12.1000  
    ## 

Redefine variables.

    df_master$NAME = as.factor(df_master$NAME)
    df_master$Date = as.Date(df_master$Date)
    df_master$Event = as.factor(df_master$Event)
    df_master$City= as.factor(df_master$City)
    df_master$State = as.factor(df_master$State)
    df_master$Country = as.factor(df_master$Country)
    df_master$FightWeightClass = as.factor(df_master$FightWeightClass)
    df_master$Method = as.factor(df_master$Method)
    df_master$Winner_Odds = as.numeric(df_master$Winner_Odds)
    df_master$Loser_Odds = as.numeric(df_master$Loser_Odds)
    df_master$fight_id = as.factor(df_master$fight_id)
    df_master$Sex = as.factor(df_master$Sex)
    df_master$Result = as.factor(df_master$Result)
    df_master$FighterWeightClass = as.factor(df_master$FighterWeightClass)

Summarize again… There are infinite odds and overturned / DQ fight
outcomes. These will have to be removed.

    summary(df_master)

    ##                  NAME           Date           
    ##  Donald Cerrone    :  24   Min.   :2013-04-27  
    ##  Ovince Saint Preux:  21   1st Qu.:2015-08-23  
    ##  Jim Miller        :  19   Median :2017-05-28  
    ##  Neil Magny        :  19   Mean   :2017-06-19  
    ##  Derrick Lewis     :  18   3rd Qu.:2019-04-20  
    ##  Tim Means         :  18   Max.   :2021-02-06  
    ##  (Other)           :5867                       
    ##                                   Event                  City     
    ##  UFC Fight Night: Chiesa vs. Magny   :  28   Las Vegas     :1246  
    ##  UFC Fight Night: Poirier vs. Gaethje:  28   Abu Dhabi     : 258  
    ##  UFC Fight Night: Whittaker vs. Till :  28   Boston        : 124  
    ##  UFC 190: Rousey vs Correia          :  26   Rio de Janeiro: 124  
    ##  UFC 193: Rousey vs Holm             :  26   Chicago       : 118  
    ##  UFC 210: Cormier vs. Johnson 2      :  26   Newark        : 114  
    ##  (Other)                             :5824   (Other)       :4002  
    ##         State                      Country          FightWeightClass
    ##  Nevada    :1246   USA                 :3464   Welterweight : 986   
    ##  Abu Dhabi : 258   Brazil              : 532   Lightweight  : 984   
    ##  Texas     : 256   Canada              : 378   Bantamweight : 852   
    ##  New York  : 252   United Arab Emirates: 258   Featherweight: 724   
    ##  California: 250   Australia           : 236   Middleweight : 654   
    ##  Florida   : 176   United Kingdom      : 184   Flyweight    : 498   
    ##  (Other)   :3548   (Other)             : 934   (Other)      :1288   
    ##      Round             Method      Winner_Odds     Loser_Odds       Sex      
    ##  Min.   :1.00   DQ        :  14   Min.   :1.06   Min.   :1.07   Female: 766  
    ##  1st Qu.:1.00   KO/TKO    :1910   1st Qu.:1.42   1st Qu.:1.77   Male  :5220  
    ##  Median :3.00   M-DEC     :  34   Median :1.71   Median :2.38                
    ##  Mean   :2.43   Overturned:  20   Mean   : Inf   Mean   : Inf                
    ##  3rd Qu.:3.00   S-DEC     : 628   3rd Qu.:2.33   3rd Qu.:3.36                
    ##  Max.   :5.00   SUB       :1060   Max.   : Inf   Max.   : Inf                
    ##                 U-DEC     :2320                                              
    ##     fight_id       Result     FighterWeight       FighterWeightClass
    ##  1      :   2   Loser :2993   Min.   :115.0   Welterweight :1007    
    ##  2      :   2   Winner:2993   1st Qu.:135.0   Lightweight  : 980    
    ##  3      :   2                 Median :155.0   Bantamweight : 799    
    ##  4      :   2                 Mean   :163.8   Featherweight: 731    
    ##  5      :   2                 3rd Qu.:185.0   Middleweight : 659    
    ##  6      :   2                 Max.   :265.0   Flyweight    : 561    
    ##  (Other):5974                                 (Other)      :1249    
    ##      REACH            SLPM             SAPM             STRA       
    ##  Min.   :58.00   Min.   : 0.000   Min.   : 0.100   Min.   :0.0000  
    ##  1st Qu.:69.00   1st Qu.: 2.680   1st Qu.: 2.630   1st Qu.:0.3900  
    ##  Median :72.00   Median : 3.440   Median : 3.230   Median :0.4400  
    ##  Mean   :71.77   Mean   : 3.531   Mean   : 3.435   Mean   :0.4417  
    ##  3rd Qu.:75.00   3rd Qu.: 4.250   3rd Qu.: 4.030   3rd Qu.:0.4900  
    ##  Max.   :84.00   Max.   :11.140   Max.   :23.330   Max.   :0.8800  
    ##  NA's   :215                                                       
    ##       STRD              TD              TDA              TDD        
    ##  Min.   :0.0900   Min.   : 0.000   Min.   :0.0000   Min.   :0.0000  
    ##  1st Qu.:0.5100   1st Qu.: 0.560   1st Qu.:0.2700   1st Qu.:0.5100  
    ##  Median :0.5600   Median : 1.210   Median :0.3700   Median :0.6400  
    ##  Mean   :0.5527   Mean   : 1.518   Mean   :0.3745   Mean   :0.6157  
    ##  3rd Qu.:0.6000   3rd Qu.: 2.160   3rd Qu.:0.5000   3rd Qu.:0.7600  
    ##  Max.   :0.9200   Max.   :14.190   Max.   :1.0000   Max.   :1.0000  
    ##                                                                     
    ##       SUBA        
    ##  Min.   : 0.0000  
    ##  1st Qu.: 0.1000  
    ##  Median : 0.4000  
    ##  Mean   : 0.5516  
    ##  3rd Qu.: 0.8000  
    ##  Max.   :12.1000  
    ## 

How many events does the dataset include?

    length(unique(df_master$Event))

    ## [1] 261

How many fights?

    length(unique(df_master$fight_id))

    ## [1] 2993

Over what time frame?

    range(sort(unique(df_master$Date)))

    ## [1] "2013-04-27" "2021-02-06"

<br>

### Analyse Odds

Make copy for analysis.

    df_odds = df_master
    rm(df_master)

Filter out controversial results and infinite odds.

    df_odds %>%
      dplyr::filter(
        (Method != "DQ") & (Method != "Overturned")
        , is.finite(Winner_Odds)
        , is.finite(Loser_Odds)
      ) -> df_odds

Get rid of fighter-specifics so that we can spread the data frame. This
will give us one event per row.

    df_odds %>%
      dplyr::select(-c(FighterWeight:SUBA)) %>%
      spread(Result, NAME) -> df_odds_short

How often were the (best) odds equal?

    mean(df_odds$Winner_Odds == df_odds$Loser_Odds)

    ## [1] 0.005410889

    sum(df_odds$Winner_Odds == df_odds$Loser_Odds)

    ## [1] 32

Filter out equal odds and identify if Favorite won the fight.

    df_odds_short %>%
      dplyr::filter(Winner_Odds != Loser_Odds) %>%  # filter out equal odds
      dplyr::mutate(
        Favorite_was_Winner = ifelse(Winner_Odds < Loser_Odds, T, F)
        , Favorite_Unit_Profit = ifelse(Favorite_was_Winner, Winner_Odds - 1, -1)
        , Underdog_Unit_Profit = ifelse(!Favorite_was_Winner, Winner_Odds - 1, -1)
      ) -> df_odds_short

What was the mean unit profit (i.e. ROI) if one bet solely on the
Favorite?

    mean(df_odds_short$Favorite_Unit_Profit)

    ## [1] -0.02309419

What was the mean unit profit if one bet solely on the Underdog?

    mean(df_odds_short$Underdog_Unit_Profit)

    ## [1] -0.002040122

What proportion of the time does the Favorite win?

    mean(df_odds_short$Favorite_was_Winner)

    ## [1] 0.6460388

Calculate implied probability of each fight based on odds.

    df_odds_short %>% dplyr::mutate(
      Favorite_Probability = ifelse(Favorite_was_Winner, 1/Winner_Odds, 1/Loser_Odds)
      , Underdog_Probability = ifelse(!Favorite_was_Winner,  1/Winner_Odds, 1/Loser_Odds)
    ) -> df_odds_short

Calculate overround for each fight.

NOTE: these odds are the best available odds for each fight / fighter.
Therefore, this is not overround in the traditional sense (looking at
one particular odds maker).

    df_odds_short %>%
      dplyr::mutate(
        Total_Probability = Favorite_Probability + Underdog_Probability
        , Overround = Total_Probability - 1
      ) -> df_odds_short

There is very little overround. This is because we are picking the best
odds for each fight / fighter. By picking the best odds, we are
counteracting the built-in overround of any particular odds-maker
(typically around 5% as a rough estimate).

    mean(df_odds_short$Overround)

    ## [1] 0.004461755

    mean(df_odds_short$Total_Probability)

    ## [1] 1.004462

<br>

#### Odds Performance

Add year as variable.

    df_odds_short %>%
      dplyr::mutate(
        Year = format(Date,"%Y")
      ) -> df_odds_short

Compute Adjusted Implied Probability to account for the overround and
get an unbiased estimate of the probability of victory implied by the
odds.

    df_odds_short %>%
      dplyr::mutate(
        Adjusted_Favorite_Probability = Favorite_Probability - Overround/2
        , Adjusted_Underdog_Probability = Underdog_Probability - Overround/2
        , Adjusted_Total_Probability = Adjusted_Favorite_Probability + Adjusted_Underdog_Probability
      ) -> df_odds_short

Looking at summary, we see that Adjusted Total Probability is always
equal to 100%. Moreover, the Favorite Probability never dips below 50%,
whereas the Underdog Probability never exceeds it.

    summary(df_odds_short)

    ##       Date                                             Event     
    ##  Min.   :2013-04-27   UFC Fight Night: Chiesa vs. Magny   :  14  
    ##  1st Qu.:2015-08-23   UFC Fight Night: Poirier vs. Gaethje:  14  
    ##  Median :2017-05-13   UFC Fight Night: Whittaker vs. Till :  14  
    ##  Mean   :2017-06-17   UFC 190: Rousey vs Correia          :  13  
    ##  3rd Qu.:2019-04-20   UFC 193: Rousey vs Holm             :  13  
    ##  Max.   :2021-02-06   UFC 210: Cormier vs. Johnson 2      :  13  
    ##                       (Other)                             :2860  
    ##              City             State                      Country    
    ##  Las Vegas     : 607   Nevada    : 607   USA                 :1699  
    ##  Abu Dhabi     : 127   Abu Dhabi : 127   Brazil              : 258  
    ##  Rio de Janeiro:  60   Texas     : 127   Canada              : 187  
    ##  Boston        :  59   California: 123   United Arab Emirates: 127  
    ##  Chicago       :  57   New York  : 123   Australia           : 117  
    ##  Newark        :  57   Florida   :  88   United Kingdom      :  92  
    ##  (Other)       :1974   (Other)   :1746   (Other)             : 461  
    ##       FightWeightClass     Round              Method      Winner_Odds    
    ##  Welterweight :486     Min.   :1.000   DQ        :   0   Min.   : 1.060  
    ##  Lightweight  :484     1st Qu.:2.000   KO/TKO    : 942   1st Qu.: 1.420  
    ##  Bantamweight :420     Median :3.000   M-DEC     :  17   Median : 1.710  
    ##  Featherweight:355     Mean   :2.435   Overturned:   0   Mean   : 1.975  
    ##  Middleweight :316     3rd Qu.:3.000   S-DEC     : 312   3rd Qu.: 2.300  
    ##  Flyweight    :246     Max.   :5.000   SUB       : 521   Max.   :12.990  
    ##  (Other)      :634                     U-DEC     :1149                   
    ##    Loser_Odds         Sex          fight_id                Loser     
    ##  Min.   : 1.070   Female: 378   1      :   1   Jim Miller     :  10  
    ##  1st Qu.: 1.760   Male  :2563   2      :   1   Ross Pearson   :  10  
    ##  Median : 2.380                 3      :   1   Angela Hill    :   9  
    ##  Mean   : 2.813                 4      :   1   Donald Cerrone :   9  
    ##  3rd Qu.: 3.350                 5      :   1   Gian Villante  :   9  
    ##  Max.   :14.050                 6      :   1   Jeremy Stephens:   9  
    ##                                 (Other):2935   (Other)        :2885  
    ##                 Winner     Favorite_was_Winner Favorite_Unit_Profit
    ##  Donald Cerrone    :  15   Mode :logical       Min.   :-1.00000    
    ##  Derrick Lewis     :  14   FALSE:1041          1st Qu.:-1.00000    
    ##  Francisco Trinaldo:  13   TRUE :1900          Median : 0.31000    
    ##  Neil Magny        :  13                       Mean   :-0.02309    
    ##  Dustin Poirier    :  12                       3rd Qu.: 0.57000    
    ##  Max Holloway      :  12                       Max.   : 1.10000    
    ##  (Other)           :2862                                           
    ##  Underdog_Unit_Profit Favorite_Probability Underdog_Probability
    ##  Min.   :-1.00000     Min.   :0.4000       Min.   :0.07117     
    ##  1st Qu.:-1.00000     1st Qu.:0.5780       1st Qu.:0.27397     
    ##  Median :-1.00000     Median :0.6410       Median :0.35971     
    ##  Mean   :-0.00204     Mean   :0.6579       Mean   :0.34658     
    ##  3rd Qu.: 1.30000     3rd Qu.:0.7299       3rd Qu.:0.42553     
    ##  Max.   :11.99000     Max.   :0.9434       Max.   :0.52356     
    ##                                                                
    ##  Total_Probability   Overround             Year          
    ##  Min.   :0.7639    Min.   :-0.236148   Length:2941       
    ##  1st Qu.:0.9988    1st Qu.:-0.001198   Class :character  
    ##  Median :1.0085    Median : 0.008472   Mode  :character  
    ##  Mean   :1.0045    Mean   : 0.004462                     
    ##  3rd Qu.:1.0147    3rd Qu.: 0.014713                     
    ##  Max.   :1.0684    Max.   : 0.068376                     
    ##                                                          
    ##  Adjusted_Favorite_Probability Adjusted_Underdog_Probability
    ##  Min.   :0.5012                Min.   :0.0673               
    ##  1st Qu.:0.5780                1st Qu.:0.2725               
    ##  Median :0.6408                Median :0.3592               
    ##  Mean   :0.6557                Mean   :0.3443               
    ##  3rd Qu.:0.7275                3rd Qu.:0.4220               
    ##  Max.   :0.9327                Max.   :0.4988               
    ##                                                             
    ##  Adjusted_Total_Probability
    ##  Min.   :1                 
    ##  1st Qu.:1                 
    ##  Median :1                 
    ##  Mean   :1                 
    ##  3rd Qu.:1                 
    ##  Max.   :1                 
    ## 

Create function to graphically assess over performance as a function of
several variables. These are not inferential analyses but are instead
meant to visualize the data to observe trends for further analysis. Use
adjusted implied probabilities along with unit profits derived from
non-adjusted odds to simulate what one actually would have won using
best available odds.

    gauge_over_performance = function(num_bin = 10, min_bin_size = 30, variable = NULL) {

      # get bins for Favorite
      df_odds_short$Favorite_Probability_Bin = cut(df_odds_short$Adjusted_Favorite_Probability, num_bin)
      # get bins for Underdog
      df_odds_short$Underdog_Probability_Bin = cut(df_odds_short$Adjusted_Underdog_Probability, num_bin)

      if (is.null(variable)) {
        # check over/under performance for Favorites
        df_odds_short %>%
          dplyr::group_by(Favorite_Probability_Bin) %>%
          dplyr::summarise(
            Prop_of_Victory = mean(Favorite_was_Winner)
            , Size_of_Bin = length(Favorite_was_Winner)
            , ROI = mean(Favorite_Unit_Profit)
          ) -> fav_perf
      } else {

        # create dummy variable for function
        df_odds_short$Dummy = df_odds_short[
          ,which(colnames(df_odds_short) == sprintf("%s", variable))
        ]

        # check over/under performance for Favorites
        df_odds_short %>%
          dplyr::group_by(Favorite_Probability_Bin, Dummy) %>%
          dplyr::summarise(
            Prop_of_Victory = mean(Favorite_was_Winner)
            , Size_of_Bin = length(Favorite_was_Winner)
            , ROI = mean(Favorite_Unit_Profit)
          ) -> fav_perf
      }

      # extract bins
      fav_labs <- as.character(fav_perf$Favorite_Probability_Bin)
      fav_bins = as.data.frame(
        cbind(
          lower = as.numeric( sub("\\((.+),.*", "\\1", fav_labs) )
          , upper = as.numeric( sub("[^,]*,([^]]*)\\]", "\\1", fav_labs) )
        )
      )
      # get value in middle of bin
      fav_bins %>% dplyr::mutate(mid_bin = (lower + upper)/2 ) -> fav_bins
      # add mid bin column
      fav_perf$Mid_Bin = fav_bins$mid_bin
      # add Over performance column
      fav_perf %>% dplyr::mutate(Over_Performance = Prop_of_Victory - Mid_Bin) -> fav_perf


      if (is.null(variable)) {

        # plot over/under performance
        fav_perf %>%
          dplyr::filter(Size_of_Bin >= min_bin_size) %>%
          ggplot(aes(x=Mid_Bin*100, y=Over_Performance * 100))+
          geom_point()+
          geom_smooth(se=F)+
          geom_hline(yintercept = 0, linetype = "dotted")+
          ylab("Over Performance (%)")+
          xlab("Adjusted Implied Probability (%)")+
          ggtitle("Favorites")->gg
        print(gg)

        # plot over/under performance
        fav_perf %>%
          dplyr::filter(Size_of_Bin >= min_bin_size) %>%
          ggplot(aes(x=Mid_Bin * 100, y=Prop_of_Victory*100))+
          geom_point()+
          geom_smooth(se=F)+
          ylab("Probability of Victory (%)")+
          xlab("Adjusted Implied Probability (%)")+
          geom_abline(slope=1, intercept=0, linetype = "dotted")+
          ggtitle("Favorites")->gg
        print(gg)

        # plot ROI - only real difference is scale along y axis
        fav_perf %>%
          dplyr::filter(Size_of_Bin >= min_bin_size) %>%
          ggplot(aes(x=Mid_Bin*100, y= ROI* 100))+
          geom_point()+
          geom_smooth(se=F)+
          geom_hline(yintercept = 0, linetype = "dotted")+
          ylab("ROI (%)")+
          xlab("Adjusted Implied Probability (%)")+
          ggtitle("Favorites") -> gg
        print(gg)

      } else {
        # plot over/under performance
        fav_perf %>%
          dplyr::filter(Size_of_Bin >= min_bin_size) %>%
          ggplot(aes(x=Mid_Bin*100, y=Over_Performance * 100, group=Dummy, colour = Dummy))+
          geom_point()+
          geom_smooth(se=F)+
          geom_hline(yintercept = 0, linetype = "dotted")+
          ylab("Over Performance (%)")+
          xlab("Adjusted Implied Probability (%)")+
          ggtitle("Favorites")+
          labs(color=sprintf("%s", variable)) -> gg
        print(gg)

        # plot ROI - only real difference is scale along y axis
        fav_perf %>%
          dplyr::filter(Size_of_Bin >= min_bin_size) %>%
          ggplot(aes(x=Mid_Bin*100, y= ROI* 100, group=Dummy, colour = Dummy))+
          geom_point()+
          geom_smooth(se=F)+
          geom_hline(yintercept = 0, linetype = "dotted")+
          ylab("ROI (%)")+
          xlab("Adjusted Implied Probability (%)")+
          ggtitle("Favorites")+
          labs(color=sprintf("%s", variable)) -> gg
        print(gg)
      }


      if (is.null(variable)) {

        # check over/under performance for Underdogs
        df_odds_short %>%
          dplyr::group_by(Underdog_Probability_Bin) %>%
          dplyr::summarise(
            Prop_of_Victory = mean(!Favorite_was_Winner)
            , Size_of_Bin = length(!Favorite_was_Winner)
            , ROI = mean(Underdog_Unit_Profit)
          ) -> under_perf

      } else {

        # check over/under performance for Underdogs
        df_odds_short %>%
          dplyr::group_by(Underdog_Probability_Bin, Dummy) %>%
          dplyr::summarise(
            Prop_of_Victory = mean(!Favorite_was_Winner)
            , Size_of_Bin = length(!Favorite_was_Winner)
            , ROI = mean(Underdog_Unit_Profit)
          ) -> under_perf
      }

      # extract bins
      under_labs <- as.character(under_perf$Underdog_Probability_Bin)
      under_bins = as.data.frame(
        cbind(
          lower = as.numeric( sub("\\((.+),.*", "\\1", under_labs) )
          , upper = as.numeric( sub("[^,]*,([^]]*)\\]", "\\1", under_labs) )
        )
      )
      # get value in middle of bin
      under_bins %>% dplyr::mutate(mid_bin = (lower + upper)/2 ) -> under_bins
      # add mid bin column
      under_perf$Mid_Bin = under_bins$mid_bin
      # add Over performance column
      under_perf %>% dplyr::mutate(Over_Performance = Prop_of_Victory - Mid_Bin) -> under_perf


      if (is.null(variable)) {
        # plot over/under performance
        under_perf %>%
          dplyr::filter(Size_of_Bin >= min_bin_size) %>%
          ggplot(aes(x=Mid_Bin*100, y=Over_Performance * 100))+
          geom_point()+
          geom_smooth(se=F)+
          geom_hline(yintercept = 0, linetype = "dotted")+
          ylab("Over Performance (%)")+
          xlab("Adjusted Implied Probability (%)")+
          ggtitle("Underdogs")->gg
        print(gg)

        # plot over/under performance
        under_perf %>%
          dplyr::filter(Size_of_Bin >= min_bin_size) %>%
          ggplot(aes(x=Mid_Bin * 100, y=Prop_of_Victory*100))+
          geom_point()+
          geom_smooth(se=F)+
          ylab("Probability of Victory (%)")+
          xlab("Adjusted Implied Probability (%)")+
          geom_abline(slope=1, intercept=0, linetype = "dotted")+
          ggtitle("Underdogs")->gg
        print(gg)

        under_perf %>%
          dplyr::filter(Size_of_Bin >= min_bin_size) %>%
          ggplot(aes(x=Mid_Bin*100, y=ROI * 100))+
          geom_point()+
          geom_smooth(se=F)+
          geom_hline(yintercept = 0, linetype = "dotted")+
          ylab("ROI (%)")+
          xlab("Adjusted Implied Probability (%)")+
          ggtitle("Underdogs")-> gg
        print(gg)

      } else {

        # plot over/under performance
        under_perf %>%
          dplyr::filter(Size_of_Bin >= min_bin_size) %>%
          ggplot(aes(x=Mid_Bin*100, y=Over_Performance * 100, group=Dummy, colour = Dummy))+
          geom_point()+
          geom_smooth(se=F)+
          geom_hline(yintercept = 0, linetype = "dotted")+
          ylab("Over Performance (%)")+
          xlab("Adjusted Implied Probability (%)")+
          ggtitle("Underdogs")+
          labs(color=sprintf("%s", variable)) -> gg
        print(gg)

        under_perf %>%
          dplyr::filter(Size_of_Bin >= min_bin_size) %>%
          ggplot(aes(x=Mid_Bin*100, y=ROI * 100, group=Dummy, colour = Dummy))+
          geom_point()+
          geom_smooth(se=F)+
          geom_hline(yintercept = 0, linetype = "dotted")+
          ylab("ROI (%)")+
          xlab("Adjusted Implied Probability (%)")+
          ggtitle("Underdogs")+
          labs(color=sprintf("%s", variable)) -> gg
        print(gg)
      }
      
      # process to return()
      under_perf$Is_Fav = F
      under_perf %>%
        rename(Probability_Bin = Underdog_Probability_Bin) -> under_perf
      
      fav_perf$Is_Fav = T
      fav_perf %>%
        rename(Probability_Bin = Favorite_Probability_Bin) -> fav_perf
      
      return(rbind(fav_perf, under_perf))

    }

Look at how expected performance predicts over performance.

    odds_perf = gauge_over_performance(num_bin = 10, min_bin_size = 100, variable = NULL)

![](/AttM/rmd_images/2021-02-12-fight_odds_analysis/unnamed-chunk-24-1.png)![](/AttM/rmd_images/2021-02-12-fight_odds_analysis/unnamed-chunk-24-2.png)![](/AttM/rmd_images/2021-02-12-fight_odds_analysis/unnamed-chunk-24-3.png)![](/AttM/rmd_images/2021-02-12-fight_odds_analysis/unnamed-chunk-24-4.png)![](/AttM/rmd_images/2021-02-12-fight_odds_analysis/unnamed-chunk-24-5.png)![](/AttM/rmd_images/2021-02-12-fight_odds_analysis/unnamed-chunk-24-6.png)

    kable(odds_perf)

<table>
<colgroup>
<col style="width: 18%" />
<col style="width: 18%" />
<col style="width: 13%" />
<col style="width: 12%" />
<col style="width: 9%" />
<col style="width: 19%" />
<col style="width: 8%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Probability_Bin</th>
<th style="text-align: right;">Prop_of_Victory</th>
<th style="text-align: right;">Size_of_Bin</th>
<th style="text-align: right;">ROI</th>
<th style="text-align: right;">Mid_Bin</th>
<th style="text-align: right;">Over_Performance</th>
<th style="text-align: left;">Is_Fav</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">(0.501,0.544]</td>
<td style="text-align: right;">0.5160494</td>
<td style="text-align: right;">405</td>
<td style="text-align: right;">-0.0155802</td>
<td style="text-align: right;">0.52250</td>
<td style="text-align: right;">-0.0064506</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.544,0.587]</td>
<td style="text-align: right;">0.5361050</td>
<td style="text-align: right;">457</td>
<td style="text-align: right;">-0.0585558</td>
<td style="text-align: right;">0.56550</td>
<td style="text-align: right;">-0.0293950</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.587,0.631]</td>
<td style="text-align: right;">0.5376984</td>
<td style="text-align: right;">504</td>
<td style="text-align: right;">-0.1169643</td>
<td style="text-align: right;">0.60900</td>
<td style="text-align: right;">-0.0713016</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.631,0.674]</td>
<td style="text-align: right;">0.6410256</td>
<td style="text-align: right;">390</td>
<td style="text-align: right;">-0.0204615</td>
<td style="text-align: right;">0.65250</td>
<td style="text-align: right;">-0.0114744</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.674,0.717]</td>
<td style="text-align: right;">0.7078947</td>
<td style="text-align: right;">380</td>
<td style="text-align: right;">0.0163947</td>
<td style="text-align: right;">0.69550</td>
<td style="text-align: right;">0.0123947</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.717,0.76]</td>
<td style="text-align: right;">0.7589577</td>
<td style="text-align: right;">307</td>
<td style="text-align: right;">0.0231922</td>
<td style="text-align: right;">0.73850</td>
<td style="text-align: right;">0.0204577</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.76,0.803]</td>
<td style="text-align: right;">0.8384279</td>
<td style="text-align: right;">229</td>
<td style="text-align: right;">0.0692576</td>
<td style="text-align: right;">0.78150</td>
<td style="text-align: right;">0.0569279</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.803,0.846]</td>
<td style="text-align: right;">0.8271605</td>
<td style="text-align: right;">162</td>
<td style="text-align: right;">-0.0021605</td>
<td style="text-align: right;">0.82450</td>
<td style="text-align: right;">0.0026605</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.846,0.89]</td>
<td style="text-align: right;">0.8961039</td>
<td style="text-align: right;">77</td>
<td style="text-align: right;">0.0325974</td>
<td style="text-align: right;">0.86800</td>
<td style="text-align: right;">0.0281039</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.89,0.933]</td>
<td style="text-align: right;">0.9333333</td>
<td style="text-align: right;">30</td>
<td style="text-align: right;">0.0236667</td>
<td style="text-align: right;">0.91150</td>
<td style="text-align: right;">0.0218333</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.0669,0.11]</td>
<td style="text-align: right;">0.0666667</td>
<td style="text-align: right;">30</td>
<td style="text-align: right;">-0.2100000</td>
<td style="text-align: right;">0.08845</td>
<td style="text-align: right;">-0.0217833</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.11,0.154]</td>
<td style="text-align: right;">0.1038961</td>
<td style="text-align: right;">77</td>
<td style="text-align: right;">-0.1935065</td>
<td style="text-align: right;">0.13200</td>
<td style="text-align: right;">-0.0281039</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.154,0.197]</td>
<td style="text-align: right;">0.1728395</td>
<td style="text-align: right;">162</td>
<td style="text-align: right;">-0.0545062</td>
<td style="text-align: right;">0.17550</td>
<td style="text-align: right;">-0.0026605</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.197,0.24]</td>
<td style="text-align: right;">0.1615721</td>
<td style="text-align: right;">229</td>
<td style="text-align: right;">-0.2699127</td>
<td style="text-align: right;">0.21850</td>
<td style="text-align: right;">-0.0569279</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.24,0.283]</td>
<td style="text-align: right;">0.2410423</td>
<td style="text-align: right;">307</td>
<td style="text-align: right;">-0.0922150</td>
<td style="text-align: right;">0.26150</td>
<td style="text-align: right;">-0.0204577</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.283,0.326]</td>
<td style="text-align: right;">0.2921053</td>
<td style="text-align: right;">380</td>
<td style="text-align: right;">-0.0502105</td>
<td style="text-align: right;">0.30450</td>
<td style="text-align: right;">-0.0123947</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.326,0.369]</td>
<td style="text-align: right;">0.3589744</td>
<td style="text-align: right;">390</td>
<td style="text-align: right;">0.0181795</td>
<td style="text-align: right;">0.34750</td>
<td style="text-align: right;">0.0114744</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.369,0.413]</td>
<td style="text-align: right;">0.4623016</td>
<td style="text-align: right;">504</td>
<td style="text-align: right;">0.1802976</td>
<td style="text-align: right;">0.39100</td>
<td style="text-align: right;">0.0713016</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.413,0.456]</td>
<td style="text-align: right;">0.4638950</td>
<td style="text-align: right;">457</td>
<td style="text-align: right;">0.0675055</td>
<td style="text-align: right;">0.43450</td>
<td style="text-align: right;">0.0293950</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.456,0.499]</td>
<td style="text-align: right;">0.4839506</td>
<td style="text-align: right;">405</td>
<td style="text-align: right;">0.0109136</td>
<td style="text-align: right;">0.47750</td>
<td style="text-align: right;">0.0064506</td>
<td style="text-align: left;">FALSE</td>
</tr>
</tbody>
</table>

Is there any stability across years? Need to reduce minimum bin size to
get estimates. As a result, estimates will be more noisy.

    odds_perf_by_year = gauge_over_performance(num_bin = 10, min_bin_size = 30, variable = "Year")

![](/AttM/rmd_images/2021-02-12-fight_odds_analysis/unnamed-chunk-25-1.png)![](/AttM/rmd_images/2021-02-12-fight_odds_analysis/unnamed-chunk-25-2.png)![](/AttM/rmd_images/2021-02-12-fight_odds_analysis/unnamed-chunk-25-3.png)![](/AttM/rmd_images/2021-02-12-fight_odds_analysis/unnamed-chunk-25-4.png)

    kable(odds_perf_by_year)

<table>
<colgroup>
<col style="width: 17%" />
<col style="width: 6%" />
<col style="width: 17%" />
<col style="width: 12%" />
<col style="width: 11%" />
<col style="width: 8%" />
<col style="width: 18%" />
<col style="width: 7%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Probability_Bin</th>
<th style="text-align: left;">Dummy</th>
<th style="text-align: right;">Prop_of_Victory</th>
<th style="text-align: right;">Size_of_Bin</th>
<th style="text-align: right;">ROI</th>
<th style="text-align: right;">Mid_Bin</th>
<th style="text-align: right;">Over_Performance</th>
<th style="text-align: left;">Is_Fav</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">(0.501,0.544]</td>
<td style="text-align: left;">2013</td>
<td style="text-align: right;">0.6000000</td>
<td style="text-align: right;">10</td>
<td style="text-align: right;">0.1580000</td>
<td style="text-align: right;">0.52250</td>
<td style="text-align: right;">0.0775000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.501,0.544]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">0.6086957</td>
<td style="text-align: right;">23</td>
<td style="text-align: right;">0.1791304</td>
<td style="text-align: right;">0.52250</td>
<td style="text-align: right;">0.0861957</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.501,0.544]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.4791667</td>
<td style="text-align: right;">48</td>
<td style="text-align: right;">-0.0906250</td>
<td style="text-align: right;">0.52250</td>
<td style="text-align: right;">-0.0433333</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.501,0.544]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">0.5777778</td>
<td style="text-align: right;">90</td>
<td style="text-align: right;">0.0936667</td>
<td style="text-align: right;">0.52250</td>
<td style="text-align: right;">0.0552778</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.501,0.544]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">0.5869565</td>
<td style="text-align: right;">46</td>
<td style="text-align: right;">0.1126087</td>
<td style="text-align: right;">0.52250</td>
<td style="text-align: right;">0.0644565</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.501,0.544]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">0.3859649</td>
<td style="text-align: right;">57</td>
<td style="text-align: right;">-0.2568421</td>
<td style="text-align: right;">0.52250</td>
<td style="text-align: right;">-0.1365351</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.501,0.544]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.4383562</td>
<td style="text-align: right;">73</td>
<td style="text-align: right;">-0.1578082</td>
<td style="text-align: right;">0.52250</td>
<td style="text-align: right;">-0.0841438</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.501,0.544]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.5714286</td>
<td style="text-align: right;">56</td>
<td style="text-align: right;">0.0882143</td>
<td style="text-align: right;">0.52250</td>
<td style="text-align: right;">0.0489286</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.501,0.544]</td>
<td style="text-align: left;">2021</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">2</td>
<td style="text-align: right;">-0.0250000</td>
<td style="text-align: right;">0.52250</td>
<td style="text-align: right;">-0.0225000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.544,0.587]</td>
<td style="text-align: left;">2013</td>
<td style="text-align: right;">0.4444444</td>
<td style="text-align: right;">9</td>
<td style="text-align: right;">-0.1977778</td>
<td style="text-align: right;">0.56550</td>
<td style="text-align: right;">-0.1210556</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.544,0.587]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">0.4324324</td>
<td style="text-align: right;">37</td>
<td style="text-align: right;">-0.2456757</td>
<td style="text-align: right;">0.56550</td>
<td style="text-align: right;">-0.1330676</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.544,0.587]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.4848485</td>
<td style="text-align: right;">66</td>
<td style="text-align: right;">-0.1515152</td>
<td style="text-align: right;">0.56550</td>
<td style="text-align: right;">-0.0806515</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.544,0.587]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">0.4590164</td>
<td style="text-align: right;">61</td>
<td style="text-align: right;">-0.1957377</td>
<td style="text-align: right;">0.56550</td>
<td style="text-align: right;">-0.1064836</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.544,0.587]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">0.5915493</td>
<td style="text-align: right;">71</td>
<td style="text-align: right;">0.0374648</td>
<td style="text-align: right;">0.56550</td>
<td style="text-align: right;">0.0260493</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.544,0.587]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">0.6000000</td>
<td style="text-align: right;">55</td>
<td style="text-align: right;">0.0556364</td>
<td style="text-align: right;">0.56550</td>
<td style="text-align: right;">0.0345000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.544,0.587]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.6025641</td>
<td style="text-align: right;">78</td>
<td style="text-align: right;">0.0608974</td>
<td style="text-align: right;">0.56550</td>
<td style="text-align: right;">0.0370641</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.544,0.587]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.5479452</td>
<td style="text-align: right;">73</td>
<td style="text-align: right;">-0.0369863</td>
<td style="text-align: right;">0.56550</td>
<td style="text-align: right;">-0.0175548</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.544,0.587]</td>
<td style="text-align: left;">2021</td>
<td style="text-align: right;">0.4285714</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">-0.2457143</td>
<td style="text-align: right;">0.56550</td>
<td style="text-align: right;">-0.1369286</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.587,0.631]</td>
<td style="text-align: left;">2013</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">18</td>
<td style="text-align: right;">-0.1722222</td>
<td style="text-align: right;">0.60900</td>
<td style="text-align: right;">-0.1090000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.587,0.631]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">0.6046512</td>
<td style="text-align: right;">43</td>
<td style="text-align: right;">-0.0016279</td>
<td style="text-align: right;">0.60900</td>
<td style="text-align: right;">-0.0043488</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.587,0.631]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.4545455</td>
<td style="text-align: right;">66</td>
<td style="text-align: right;">-0.2554545</td>
<td style="text-align: right;">0.60900</td>
<td style="text-align: right;">-0.1544545</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.587,0.631]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">0.4791667</td>
<td style="text-align: right;">96</td>
<td style="text-align: right;">-0.2204167</td>
<td style="text-align: right;">0.60900</td>
<td style="text-align: right;">-0.1298333</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.587,0.631]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">0.6557377</td>
<td style="text-align: right;">61</td>
<td style="text-align: right;">0.0716393</td>
<td style="text-align: right;">0.60900</td>
<td style="text-align: right;">0.0467377</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.587,0.631]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">84</td>
<td style="text-align: right;">-0.1680952</td>
<td style="text-align: right;">0.60900</td>
<td style="text-align: right;">-0.1090000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.587,0.631]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.5068493</td>
<td style="text-align: right;">73</td>
<td style="text-align: right;">-0.1689041</td>
<td style="text-align: right;">0.60900</td>
<td style="text-align: right;">-0.1021507</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.587,0.631]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.6315789</td>
<td style="text-align: right;">57</td>
<td style="text-align: right;">0.0371930</td>
<td style="text-align: right;">0.60900</td>
<td style="text-align: right;">0.0225789</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.587,0.631]</td>
<td style="text-align: left;">2021</td>
<td style="text-align: right;">0.8333333</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">0.3666667</td>
<td style="text-align: right;">0.60900</td>
<td style="text-align: right;">0.2243333</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.631,0.674]</td>
<td style="text-align: left;">2013</td>
<td style="text-align: right;">0.6666667</td>
<td style="text-align: right;">15</td>
<td style="text-align: right;">0.0280000</td>
<td style="text-align: right;">0.65250</td>
<td style="text-align: right;">0.0141667</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.631,0.674]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">0.5744681</td>
<td style="text-align: right;">47</td>
<td style="text-align: right;">-0.1161702</td>
<td style="text-align: right;">0.65250</td>
<td style="text-align: right;">-0.0780319</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.631,0.674]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.6029412</td>
<td style="text-align: right;">68</td>
<td style="text-align: right;">-0.0769118</td>
<td style="text-align: right;">0.65250</td>
<td style="text-align: right;">-0.0495588</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.631,0.674]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">0.7500000</td>
<td style="text-align: right;">56</td>
<td style="text-align: right;">0.1391071</td>
<td style="text-align: right;">0.65250</td>
<td style="text-align: right;">0.0975000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.631,0.674]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">0.5476190</td>
<td style="text-align: right;">42</td>
<td style="text-align: right;">-0.1669048</td>
<td style="text-align: right;">0.65250</td>
<td style="text-align: right;">-0.1048810</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.631,0.674]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">0.6400000</td>
<td style="text-align: right;">50</td>
<td style="text-align: right;">-0.0222000</td>
<td style="text-align: right;">0.65250</td>
<td style="text-align: right;">-0.0125000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.631,0.674]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.6938776</td>
<td style="text-align: right;">49</td>
<td style="text-align: right;">0.0622449</td>
<td style="text-align: right;">0.65250</td>
<td style="text-align: right;">0.0413776</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.631,0.674]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.6491228</td>
<td style="text-align: right;">57</td>
<td style="text-align: right;">-0.0077193</td>
<td style="text-align: right;">0.65250</td>
<td style="text-align: right;">-0.0033772</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.631,0.674]</td>
<td style="text-align: left;">2021</td>
<td style="text-align: right;">0.6666667</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">0.0016667</td>
<td style="text-align: right;">0.65250</td>
<td style="text-align: right;">0.0141667</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.674,0.717]</td>
<td style="text-align: left;">2013</td>
<td style="text-align: right;">0.8235294</td>
<td style="text-align: right;">17</td>
<td style="text-align: right;">0.2058824</td>
<td style="text-align: right;">0.69550</td>
<td style="text-align: right;">0.1280294</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.674,0.717]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">0.7254902</td>
<td style="text-align: right;">51</td>
<td style="text-align: right;">0.0450980</td>
<td style="text-align: right;">0.69550</td>
<td style="text-align: right;">0.0299902</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.674,0.717]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.6551724</td>
<td style="text-align: right;">58</td>
<td style="text-align: right;">-0.0601724</td>
<td style="text-align: right;">0.69550</td>
<td style="text-align: right;">-0.0403276</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.674,0.717]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">0.6956522</td>
<td style="text-align: right;">69</td>
<td style="text-align: right;">-0.0079710</td>
<td style="text-align: right;">0.69550</td>
<td style="text-align: right;">0.0001522</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.674,0.717]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">0.7272727</td>
<td style="text-align: right;">33</td>
<td style="text-align: right;">0.0348485</td>
<td style="text-align: right;">0.69550</td>
<td style="text-align: right;">0.0317727</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.674,0.717]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">0.8372093</td>
<td style="text-align: right;">43</td>
<td style="text-align: right;">0.2097674</td>
<td style="text-align: right;">0.69550</td>
<td style="text-align: right;">0.1417093</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.674,0.717]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.6250000</td>
<td style="text-align: right;">40</td>
<td style="text-align: right;">-0.1007500</td>
<td style="text-align: right;">0.69550</td>
<td style="text-align: right;">-0.0705000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.674,0.717]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.7142857</td>
<td style="text-align: right;">63</td>
<td style="text-align: right;">0.0231746</td>
<td style="text-align: right;">0.69550</td>
<td style="text-align: right;">0.0187857</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.674,0.717]</td>
<td style="text-align: left;">2021</td>
<td style="text-align: right;">0.3333333</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">-0.5216667</td>
<td style="text-align: right;">0.69550</td>
<td style="text-align: right;">-0.3621667</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.717,0.76]</td>
<td style="text-align: left;">2013</td>
<td style="text-align: right;">0.9411765</td>
<td style="text-align: right;">17</td>
<td style="text-align: right;">0.2811765</td>
<td style="text-align: right;">0.73850</td>
<td style="text-align: right;">0.2026765</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.717,0.76]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">0.8250000</td>
<td style="text-align: right;">40</td>
<td style="text-align: right;">0.1090000</td>
<td style="text-align: right;">0.73850</td>
<td style="text-align: right;">0.0865000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.717,0.76]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.7187500</td>
<td style="text-align: right;">32</td>
<td style="text-align: right;">-0.0362500</td>
<td style="text-align: right;">0.73850</td>
<td style="text-align: right;">-0.0197500</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.717,0.76]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">0.7872340</td>
<td style="text-align: right;">47</td>
<td style="text-align: right;">0.0582979</td>
<td style="text-align: right;">0.73850</td>
<td style="text-align: right;">0.0487340</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.717,0.76]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">0.7500000</td>
<td style="text-align: right;">48</td>
<td style="text-align: right;">0.0143750</td>
<td style="text-align: right;">0.73850</td>
<td style="text-align: right;">0.0115000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.717,0.76]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">0.7380952</td>
<td style="text-align: right;">42</td>
<td style="text-align: right;">-0.0042857</td>
<td style="text-align: right;">0.73850</td>
<td style="text-align: right;">-0.0004048</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.717,0.76]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.7352941</td>
<td style="text-align: right;">34</td>
<td style="text-align: right;">-0.0094118</td>
<td style="text-align: right;">0.73850</td>
<td style="text-align: right;">-0.0032059</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.717,0.76]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.6666667</td>
<td style="text-align: right;">42</td>
<td style="text-align: right;">-0.0973810</td>
<td style="text-align: right;">0.73850</td>
<td style="text-align: right;">-0.0718333</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.717,0.76]</td>
<td style="text-align: left;">2021</td>
<td style="text-align: right;">0.8000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.0600000</td>
<td style="text-align: right;">0.73850</td>
<td style="text-align: right;">0.0615000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.76,0.803]</td>
<td style="text-align: left;">2013</td>
<td style="text-align: right;">0.9090909</td>
<td style="text-align: right;">11</td>
<td style="text-align: right;">0.1609091</td>
<td style="text-align: right;">0.78150</td>
<td style="text-align: right;">0.1275909</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.76,0.803]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">0.7500000</td>
<td style="text-align: right;">24</td>
<td style="text-align: right;">-0.0437500</td>
<td style="text-align: right;">0.78150</td>
<td style="text-align: right;">-0.0315000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.76,0.803]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.7560976</td>
<td style="text-align: right;">41</td>
<td style="text-align: right;">-0.0409756</td>
<td style="text-align: right;">0.78150</td>
<td style="text-align: right;">-0.0254024</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.76,0.803]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">0.9090909</td>
<td style="text-align: right;">33</td>
<td style="text-align: right;">0.1600000</td>
<td style="text-align: right;">0.78150</td>
<td style="text-align: right;">0.1275909</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.76,0.803]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">0.8857143</td>
<td style="text-align: right;">35</td>
<td style="text-align: right;">0.1317143</td>
<td style="text-align: right;">0.78150</td>
<td style="text-align: right;">0.1042143</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.76,0.803]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">0.8214286</td>
<td style="text-align: right;">28</td>
<td style="text-align: right;">0.0521429</td>
<td style="text-align: right;">0.78150</td>
<td style="text-align: right;">0.0399286</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.76,0.803]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.8400000</td>
<td style="text-align: right;">25</td>
<td style="text-align: right;">0.0748000</td>
<td style="text-align: right;">0.78150</td>
<td style="text-align: right;">0.0585000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.76,0.803]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.8709677</td>
<td style="text-align: right;">31</td>
<td style="text-align: right;">0.1067742</td>
<td style="text-align: right;">0.78150</td>
<td style="text-align: right;">0.0894677</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.76,0.803]</td>
<td style="text-align: left;">2021</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">0.2900000</td>
<td style="text-align: right;">0.78150</td>
<td style="text-align: right;">0.2185000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.803,0.846]</td>
<td style="text-align: left;">2013</td>
<td style="text-align: right;">0.8000000</td>
<td style="text-align: right;">10</td>
<td style="text-align: right;">-0.0350000</td>
<td style="text-align: right;">0.82450</td>
<td style="text-align: right;">-0.0245000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.803,0.846]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">0.8571429</td>
<td style="text-align: right;">21</td>
<td style="text-align: right;">0.0380952</td>
<td style="text-align: right;">0.82450</td>
<td style="text-align: right;">0.0326429</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.803,0.846]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.8205128</td>
<td style="text-align: right;">39</td>
<td style="text-align: right;">-0.0102564</td>
<td style="text-align: right;">0.82450</td>
<td style="text-align: right;">-0.0039872</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.803,0.846]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">0.7368421</td>
<td style="text-align: right;">19</td>
<td style="text-align: right;">-0.1110526</td>
<td style="text-align: right;">0.82450</td>
<td style="text-align: right;">-0.0876579</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.803,0.846]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">0.7619048</td>
<td style="text-align: right;">21</td>
<td style="text-align: right;">-0.0819048</td>
<td style="text-align: right;">0.82450</td>
<td style="text-align: right;">-0.0625952</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.803,0.846]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">0.8636364</td>
<td style="text-align: right;">22</td>
<td style="text-align: right;">0.0309091</td>
<td style="text-align: right;">0.82450</td>
<td style="text-align: right;">0.0391364</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.803,0.846]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.8666667</td>
<td style="text-align: right;">15</td>
<td style="text-align: right;">0.0506667</td>
<td style="text-align: right;">0.82450</td>
<td style="text-align: right;">0.0421667</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.803,0.846]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.9166667</td>
<td style="text-align: right;">12</td>
<td style="text-align: right;">0.1108333</td>
<td style="text-align: right;">0.82450</td>
<td style="text-align: right;">0.0921667</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.803,0.846]</td>
<td style="text-align: left;">2021</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">3</td>
<td style="text-align: right;">0.2200000</td>
<td style="text-align: right;">0.82450</td>
<td style="text-align: right;">0.1755000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.846,0.89]</td>
<td style="text-align: left;">2013</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">0.1500000</td>
<td style="text-align: right;">0.86800</td>
<td style="text-align: right;">0.1320000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.846,0.89]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">0.8000000</td>
<td style="text-align: right;">15</td>
<td style="text-align: right;">-0.0713333</td>
<td style="text-align: right;">0.86800</td>
<td style="text-align: right;">-0.0680000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.846,0.89]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.8823529</td>
<td style="text-align: right;">17</td>
<td style="text-align: right;">0.0088235</td>
<td style="text-align: right;">0.86800</td>
<td style="text-align: right;">0.0143529</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.846,0.89]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.1420000</td>
<td style="text-align: right;">0.86800</td>
<td style="text-align: right;">0.1320000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.846,0.89]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">0.8571429</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">-0.0142857</td>
<td style="text-align: right;">0.86800</td>
<td style="text-align: right;">-0.0108571</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.846,0.89]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">10</td>
<td style="text-align: right;">0.1530000</td>
<td style="text-align: right;">0.86800</td>
<td style="text-align: right;">0.1320000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.846,0.89]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.8750000</td>
<td style="text-align: right;">8</td>
<td style="text-align: right;">0.0150000</td>
<td style="text-align: right;">0.86800</td>
<td style="text-align: right;">0.0070000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.846,0.89]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.8888889</td>
<td style="text-align: right;">9</td>
<td style="text-align: right;">0.0300000</td>
<td style="text-align: right;">0.86800</td>
<td style="text-align: right;">0.0208889</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.89,0.933]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">4</td>
<td style="text-align: right;">0.0900000</td>
<td style="text-align: right;">0.91150</td>
<td style="text-align: right;">0.0885000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.89,0.933]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.8750000</td>
<td style="text-align: right;">8</td>
<td style="text-align: right;">-0.0487500</td>
<td style="text-align: right;">0.91150</td>
<td style="text-align: right;">-0.0365000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.89,0.933]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">3</td>
<td style="text-align: right;">0.0933333</td>
<td style="text-align: right;">0.91150</td>
<td style="text-align: right;">0.0885000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.89,0.933]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">3</td>
<td style="text-align: right;">0.1100000</td>
<td style="text-align: right;">0.91150</td>
<td style="text-align: right;">0.0885000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.89,0.933]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.1080000</td>
<td style="text-align: right;">0.91150</td>
<td style="text-align: right;">0.0885000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.89,0.933]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">4</td>
<td style="text-align: right;">0.1050000</td>
<td style="text-align: right;">0.91150</td>
<td style="text-align: right;">0.0885000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.89,0.933]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.6666667</td>
<td style="text-align: right;">3</td>
<td style="text-align: right;">-0.2766667</td>
<td style="text-align: right;">0.91150</td>
<td style="text-align: right;">-0.2448333</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.0669,0.11]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">0.0000000</td>
<td style="text-align: right;">4</td>
<td style="text-align: right;">-1.0000000</td>
<td style="text-align: right;">0.08845</td>
<td style="text-align: right;">-0.0884500</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.0669,0.11]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.1250000</td>
<td style="text-align: right;">8</td>
<td style="text-align: right;">0.6237500</td>
<td style="text-align: right;">0.08845</td>
<td style="text-align: right;">0.0365500</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.0669,0.11]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">0.0000000</td>
<td style="text-align: right;">3</td>
<td style="text-align: right;">-1.0000000</td>
<td style="text-align: right;">0.08845</td>
<td style="text-align: right;">-0.0884500</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.0669,0.11]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">0.0000000</td>
<td style="text-align: right;">3</td>
<td style="text-align: right;">-1.0000000</td>
<td style="text-align: right;">0.08845</td>
<td style="text-align: right;">-0.0884500</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.0669,0.11]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">0.0000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-1.0000000</td>
<td style="text-align: right;">0.08845</td>
<td style="text-align: right;">-0.0884500</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.0669,0.11]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.0000000</td>
<td style="text-align: right;">4</td>
<td style="text-align: right;">-1.0000000</td>
<td style="text-align: right;">0.08845</td>
<td style="text-align: right;">-0.0884500</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.0669,0.11]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.3333333</td>
<td style="text-align: right;">3</td>
<td style="text-align: right;">2.5700000</td>
<td style="text-align: right;">0.08845</td>
<td style="text-align: right;">0.2448833</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.11,0.154]</td>
<td style="text-align: left;">2013</td>
<td style="text-align: right;">0.0000000</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">-1.0000000</td>
<td style="text-align: right;">0.13200</td>
<td style="text-align: right;">-0.1320000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.11,0.154]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">0.2000000</td>
<td style="text-align: right;">15</td>
<td style="text-align: right;">0.5980000</td>
<td style="text-align: right;">0.13200</td>
<td style="text-align: right;">0.0680000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.11,0.154]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.1176471</td>
<td style="text-align: right;">17</td>
<td style="text-align: right;">-0.1276471</td>
<td style="text-align: right;">0.13200</td>
<td style="text-align: right;">-0.0143529</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.11,0.154]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">0.0000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-1.0000000</td>
<td style="text-align: right;">0.13200</td>
<td style="text-align: right;">-0.1320000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.11,0.154]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">0.1428571</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">-0.0671429</td>
<td style="text-align: right;">0.13200</td>
<td style="text-align: right;">0.0108571</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.11,0.154]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">0.0000000</td>
<td style="text-align: right;">10</td>
<td style="text-align: right;">-1.0000000</td>
<td style="text-align: right;">0.13200</td>
<td style="text-align: right;">-0.1320000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.11,0.154]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.1250000</td>
<td style="text-align: right;">8</td>
<td style="text-align: right;">0.0937500</td>
<td style="text-align: right;">0.13200</td>
<td style="text-align: right;">-0.0070000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.11,0.154]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.1111111</td>
<td style="text-align: right;">9</td>
<td style="text-align: right;">-0.1088889</td>
<td style="text-align: right;">0.13200</td>
<td style="text-align: right;">-0.0208889</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.154,0.197]</td>
<td style="text-align: left;">2013</td>
<td style="text-align: right;">0.2000000</td>
<td style="text-align: right;">10</td>
<td style="text-align: right;">0.0550000</td>
<td style="text-align: right;">0.17550</td>
<td style="text-align: right;">0.0245000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.154,0.197]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">0.1428571</td>
<td style="text-align: right;">21</td>
<td style="text-align: right;">-0.2428571</td>
<td style="text-align: right;">0.17550</td>
<td style="text-align: right;">-0.0326429</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.154,0.197]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.1794872</td>
<td style="text-align: right;">39</td>
<td style="text-align: right;">-0.0174359</td>
<td style="text-align: right;">0.17550</td>
<td style="text-align: right;">0.0039872</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.154,0.197]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">0.2631579</td>
<td style="text-align: right;">19</td>
<td style="text-align: right;">0.4815789</td>
<td style="text-align: right;">0.17550</td>
<td style="text-align: right;">0.0876579</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.154,0.197]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">0.2380952</td>
<td style="text-align: right;">21</td>
<td style="text-align: right;">0.3666667</td>
<td style="text-align: right;">0.17550</td>
<td style="text-align: right;">0.0625952</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.154,0.197]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">0.1363636</td>
<td style="text-align: right;">22</td>
<td style="text-align: right;">-0.2586364</td>
<td style="text-align: right;">0.17550</td>
<td style="text-align: right;">-0.0391364</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.154,0.197]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.1333333</td>
<td style="text-align: right;">15</td>
<td style="text-align: right;">-0.3406667</td>
<td style="text-align: right;">0.17550</td>
<td style="text-align: right;">-0.0421667</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.154,0.197]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.0833333</td>
<td style="text-align: right;">12</td>
<td style="text-align: right;">-0.5541667</td>
<td style="text-align: right;">0.17550</td>
<td style="text-align: right;">-0.0921667</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.154,0.197]</td>
<td style="text-align: left;">2021</td>
<td style="text-align: right;">0.0000000</td>
<td style="text-align: right;">3</td>
<td style="text-align: right;">-1.0000000</td>
<td style="text-align: right;">0.17550</td>
<td style="text-align: right;">-0.1755000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.197,0.24]</td>
<td style="text-align: left;">2013</td>
<td style="text-align: right;">0.0909091</td>
<td style="text-align: right;">11</td>
<td style="text-align: right;">-0.5772727</td>
<td style="text-align: right;">0.21850</td>
<td style="text-align: right;">-0.1275909</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.197,0.24]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">0.2500000</td>
<td style="text-align: right;">24</td>
<td style="text-align: right;">0.1258333</td>
<td style="text-align: right;">0.21850</td>
<td style="text-align: right;">0.0315000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.197,0.24]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.2439024</td>
<td style="text-align: right;">41</td>
<td style="text-align: right;">0.1065854</td>
<td style="text-align: right;">0.21850</td>
<td style="text-align: right;">0.0254024</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.197,0.24]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">0.0909091</td>
<td style="text-align: right;">33</td>
<td style="text-align: right;">-0.5712121</td>
<td style="text-align: right;">0.21850</td>
<td style="text-align: right;">-0.1275909</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.197,0.24]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">0.1142857</td>
<td style="text-align: right;">35</td>
<td style="text-align: right;">-0.4914286</td>
<td style="text-align: right;">0.21850</td>
<td style="text-align: right;">-0.1042143</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.197,0.24]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">0.1785714</td>
<td style="text-align: right;">28</td>
<td style="text-align: right;">-0.1767857</td>
<td style="text-align: right;">0.21850</td>
<td style="text-align: right;">-0.0399286</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.197,0.24]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.1600000</td>
<td style="text-align: right;">25</td>
<td style="text-align: right;">-0.2760000</td>
<td style="text-align: right;">0.21850</td>
<td style="text-align: right;">-0.0585000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.197,0.24]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.1290323</td>
<td style="text-align: right;">31</td>
<td style="text-align: right;">-0.4500000</td>
<td style="text-align: right;">0.21850</td>
<td style="text-align: right;">-0.0894677</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.197,0.24]</td>
<td style="text-align: left;">2021</td>
<td style="text-align: right;">0.0000000</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-1.0000000</td>
<td style="text-align: right;">0.21850</td>
<td style="text-align: right;">-0.2185000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.24,0.283]</td>
<td style="text-align: left;">2013</td>
<td style="text-align: right;">0.0588235</td>
<td style="text-align: right;">17</td>
<td style="text-align: right;">-0.7847059</td>
<td style="text-align: right;">0.26150</td>
<td style="text-align: right;">-0.2026765</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.24,0.283]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">0.1750000</td>
<td style="text-align: right;">40</td>
<td style="text-align: right;">-0.3487500</td>
<td style="text-align: right;">0.26150</td>
<td style="text-align: right;">-0.0865000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.24,0.283]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.2812500</td>
<td style="text-align: right;">32</td>
<td style="text-align: right;">0.0665625</td>
<td style="text-align: right;">0.26150</td>
<td style="text-align: right;">0.0197500</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.24,0.283]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">0.2127660</td>
<td style="text-align: right;">47</td>
<td style="text-align: right;">-0.1972340</td>
<td style="text-align: right;">0.26150</td>
<td style="text-align: right;">-0.0487340</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.24,0.283]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">0.2500000</td>
<td style="text-align: right;">48</td>
<td style="text-align: right;">-0.0447917</td>
<td style="text-align: right;">0.26150</td>
<td style="text-align: right;">-0.0115000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.24,0.283]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">0.2619048</td>
<td style="text-align: right;">42</td>
<td style="text-align: right;">0.0047619</td>
<td style="text-align: right;">0.26150</td>
<td style="text-align: right;">0.0004048</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.24,0.283]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.2647059</td>
<td style="text-align: right;">34</td>
<td style="text-align: right;">-0.0150000</td>
<td style="text-align: right;">0.26150</td>
<td style="text-align: right;">0.0032059</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.24,0.283]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.3333333</td>
<td style="text-align: right;">42</td>
<td style="text-align: right;">0.2304762</td>
<td style="text-align: right;">0.26150</td>
<td style="text-align: right;">0.0718333</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.24,0.283]</td>
<td style="text-align: left;">2021</td>
<td style="text-align: right;">0.2000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-0.2200000</td>
<td style="text-align: right;">0.26150</td>
<td style="text-align: right;">-0.0615000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.283,0.326]</td>
<td style="text-align: left;">2013</td>
<td style="text-align: right;">0.1764706</td>
<td style="text-align: right;">17</td>
<td style="text-align: right;">-0.4088235</td>
<td style="text-align: right;">0.30450</td>
<td style="text-align: right;">-0.1280294</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.283,0.326]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">0.2745098</td>
<td style="text-align: right;">51</td>
<td style="text-align: right;">-0.1156863</td>
<td style="text-align: right;">0.30450</td>
<td style="text-align: right;">-0.0299902</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.283,0.326]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.3448276</td>
<td style="text-align: right;">58</td>
<td style="text-align: right;">0.1263793</td>
<td style="text-align: right;">0.30450</td>
<td style="text-align: right;">0.0403276</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.283,0.326]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">0.3043478</td>
<td style="text-align: right;">69</td>
<td style="text-align: right;">-0.0256522</td>
<td style="text-align: right;">0.30450</td>
<td style="text-align: right;">-0.0001522</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.283,0.326]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">0.2727273</td>
<td style="text-align: right;">33</td>
<td style="text-align: right;">-0.1075758</td>
<td style="text-align: right;">0.30450</td>
<td style="text-align: right;">-0.0317727</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.283,0.326]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">0.1627907</td>
<td style="text-align: right;">43</td>
<td style="text-align: right;">-0.4579070</td>
<td style="text-align: right;">0.30450</td>
<td style="text-align: right;">-0.1417093</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.283,0.326]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.3750000</td>
<td style="text-align: right;">40</td>
<td style="text-align: right;">0.2240000</td>
<td style="text-align: right;">0.30450</td>
<td style="text-align: right;">0.0705000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.283,0.326]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.2857143</td>
<td style="text-align: right;">63</td>
<td style="text-align: right;">-0.0673016</td>
<td style="text-align: right;">0.30450</td>
<td style="text-align: right;">-0.0187857</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.283,0.326]</td>
<td style="text-align: left;">2021</td>
<td style="text-align: right;">0.6666667</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">1.1216667</td>
<td style="text-align: right;">0.30450</td>
<td style="text-align: right;">0.3621667</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.326,0.369]</td>
<td style="text-align: left;">2013</td>
<td style="text-align: right;">0.3333333</td>
<td style="text-align: right;">15</td>
<td style="text-align: right;">-0.0546667</td>
<td style="text-align: right;">0.34750</td>
<td style="text-align: right;">-0.0141667</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.326,0.369]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">0.4255319</td>
<td style="text-align: right;">47</td>
<td style="text-align: right;">0.2155319</td>
<td style="text-align: right;">0.34750</td>
<td style="text-align: right;">0.0780319</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.326,0.369]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.3970588</td>
<td style="text-align: right;">68</td>
<td style="text-align: right;">0.1205882</td>
<td style="text-align: right;">0.34750</td>
<td style="text-align: right;">0.0495588</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.326,0.369]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">0.2500000</td>
<td style="text-align: right;">56</td>
<td style="text-align: right;">-0.2896429</td>
<td style="text-align: right;">0.34750</td>
<td style="text-align: right;">-0.0975000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.326,0.369]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">0.4523810</td>
<td style="text-align: right;">42</td>
<td style="text-align: right;">0.2807143</td>
<td style="text-align: right;">0.34750</td>
<td style="text-align: right;">0.1048810</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.326,0.369]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">0.3600000</td>
<td style="text-align: right;">50</td>
<td style="text-align: right;">0.0230000</td>
<td style="text-align: right;">0.34750</td>
<td style="text-align: right;">0.0125000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.326,0.369]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.3061224</td>
<td style="text-align: right;">49</td>
<td style="text-align: right;">-0.1281633</td>
<td style="text-align: right;">0.34750</td>
<td style="text-align: right;">-0.0413776</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.326,0.369]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.3508772</td>
<td style="text-align: right;">57</td>
<td style="text-align: right;">-0.0136842</td>
<td style="text-align: right;">0.34750</td>
<td style="text-align: right;">0.0033772</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.326,0.369]</td>
<td style="text-align: left;">2021</td>
<td style="text-align: right;">0.3333333</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">-0.0133333</td>
<td style="text-align: right;">0.34750</td>
<td style="text-align: right;">-0.0141667</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.369,0.413]</td>
<td style="text-align: left;">2013</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">18</td>
<td style="text-align: right;">0.2916667</td>
<td style="text-align: right;">0.39100</td>
<td style="text-align: right;">0.1090000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.369,0.413]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">0.3953488</td>
<td style="text-align: right;">43</td>
<td style="text-align: right;">0.0104651</td>
<td style="text-align: right;">0.39100</td>
<td style="text-align: right;">0.0043488</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.369,0.413]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.5454545</td>
<td style="text-align: right;">66</td>
<td style="text-align: right;">0.3907576</td>
<td style="text-align: right;">0.39100</td>
<td style="text-align: right;">0.1544545</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.369,0.413]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">0.5208333</td>
<td style="text-align: right;">96</td>
<td style="text-align: right;">0.3155208</td>
<td style="text-align: right;">0.39100</td>
<td style="text-align: right;">0.1298333</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.369,0.413]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">0.3442623</td>
<td style="text-align: right;">61</td>
<td style="text-align: right;">-0.1122951</td>
<td style="text-align: right;">0.39100</td>
<td style="text-align: right;">-0.0467377</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.369,0.413]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">84</td>
<td style="text-align: right;">0.2789286</td>
<td style="text-align: right;">0.39100</td>
<td style="text-align: right;">0.1090000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.369,0.413]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.4931507</td>
<td style="text-align: right;">73</td>
<td style="text-align: right;">0.2667123</td>
<td style="text-align: right;">0.39100</td>
<td style="text-align: right;">0.1021507</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.369,0.413]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.3684211</td>
<td style="text-align: right;">57</td>
<td style="text-align: right;">-0.0591228</td>
<td style="text-align: right;">0.39100</td>
<td style="text-align: right;">-0.0225789</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.369,0.413]</td>
<td style="text-align: left;">2021</td>
<td style="text-align: right;">0.1666667</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">-0.5983333</td>
<td style="text-align: right;">0.39100</td>
<td style="text-align: right;">-0.2243333</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.413,0.456]</td>
<td style="text-align: left;">2013</td>
<td style="text-align: right;">0.5555556</td>
<td style="text-align: right;">9</td>
<td style="text-align: right;">0.3000000</td>
<td style="text-align: right;">0.43450</td>
<td style="text-align: right;">0.1210556</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.413,0.456]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">0.5675676</td>
<td style="text-align: right;">37</td>
<td style="text-align: right;">0.3216216</td>
<td style="text-align: right;">0.43450</td>
<td style="text-align: right;">0.1330676</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.413,0.456]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.5151515</td>
<td style="text-align: right;">66</td>
<td style="text-align: right;">0.1771212</td>
<td style="text-align: right;">0.43450</td>
<td style="text-align: right;">0.0806515</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.413,0.456]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">0.5409836</td>
<td style="text-align: right;">61</td>
<td style="text-align: right;">0.2350820</td>
<td style="text-align: right;">0.43450</td>
<td style="text-align: right;">0.1064836</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.413,0.456]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">0.4084507</td>
<td style="text-align: right;">71</td>
<td style="text-align: right;">-0.0650704</td>
<td style="text-align: right;">0.43450</td>
<td style="text-align: right;">-0.0260493</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.413,0.456]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">0.4000000</td>
<td style="text-align: right;">55</td>
<td style="text-align: right;">-0.0750909</td>
<td style="text-align: right;">0.43450</td>
<td style="text-align: right;">-0.0345000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.413,0.456]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.3974359</td>
<td style="text-align: right;">78</td>
<td style="text-align: right;">-0.0793590</td>
<td style="text-align: right;">0.43450</td>
<td style="text-align: right;">-0.0370641</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.413,0.456]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.4520548</td>
<td style="text-align: right;">73</td>
<td style="text-align: right;">0.0404110</td>
<td style="text-align: right;">0.43450</td>
<td style="text-align: right;">0.0175548</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.413,0.456]</td>
<td style="text-align: left;">2021</td>
<td style="text-align: right;">0.5714286</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">0.3157143</td>
<td style="text-align: right;">0.43450</td>
<td style="text-align: right;">0.1369286</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.456,0.499]</td>
<td style="text-align: left;">2013</td>
<td style="text-align: right;">0.4000000</td>
<td style="text-align: right;">10</td>
<td style="text-align: right;">-0.1610000</td>
<td style="text-align: right;">0.47750</td>
<td style="text-align: right;">-0.0775000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.456,0.499]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">0.3913043</td>
<td style="text-align: right;">23</td>
<td style="text-align: right;">-0.1865217</td>
<td style="text-align: right;">0.47750</td>
<td style="text-align: right;">-0.0861957</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.456,0.499]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.5208333</td>
<td style="text-align: right;">48</td>
<td style="text-align: right;">0.0939583</td>
<td style="text-align: right;">0.47750</td>
<td style="text-align: right;">0.0433333</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.456,0.499]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">0.4222222</td>
<td style="text-align: right;">90</td>
<td style="text-align: right;">-0.1254444</td>
<td style="text-align: right;">0.47750</td>
<td style="text-align: right;">-0.0552778</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.456,0.499]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">0.4130435</td>
<td style="text-align: right;">46</td>
<td style="text-align: right;">-0.1436957</td>
<td style="text-align: right;">0.47750</td>
<td style="text-align: right;">-0.0644565</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.456,0.499]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">0.6140351</td>
<td style="text-align: right;">57</td>
<td style="text-align: right;">0.3015789</td>
<td style="text-align: right;">0.47750</td>
<td style="text-align: right;">0.1365351</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.456,0.499]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.5616438</td>
<td style="text-align: right;">73</td>
<td style="text-align: right;">0.1806849</td>
<td style="text-align: right;">0.47750</td>
<td style="text-align: right;">0.0841438</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.456,0.499]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.4285714</td>
<td style="text-align: right;">56</td>
<td style="text-align: right;">-0.1198214</td>
<td style="text-align: right;">0.47750</td>
<td style="text-align: right;">-0.0489286</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.456,0.499]</td>
<td style="text-align: left;">2021</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">2</td>
<td style="text-align: right;">0.0200000</td>
<td style="text-align: right;">0.47750</td>
<td style="text-align: right;">0.0225000</td>
<td style="text-align: left;">FALSE</td>
</tr>
</tbody>
</table>

Does the method of victory affect the relationship between odds and
outcome? Reduce number of bins (compared to Year comparison above) to
stabilize estimates. Graphs do not tell whole story due to number of
data points available across bins.

    odds_perf_by_method = gauge_over_performance(num_bin = 5, min_bin_size = 30, variable = "Method")

![](/AttM/rmd_images/2021-02-12-fight_odds_analysis/unnamed-chunk-26-1.png)![](/AttM/rmd_images/2021-02-12-fight_odds_analysis/unnamed-chunk-26-2.png)![](/AttM/rmd_images/2021-02-12-fight_odds_analysis/unnamed-chunk-26-3.png)![](/AttM/rmd_images/2021-02-12-fight_odds_analysis/unnamed-chunk-26-4.png)

    kable(odds_perf_by_method)

<table>
<colgroup>
<col style="width: 17%" />
<col style="width: 7%" />
<col style="width: 17%" />
<col style="width: 12%" />
<col style="width: 11%" />
<col style="width: 8%" />
<col style="width: 18%" />
<col style="width: 7%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Probability_Bin</th>
<th style="text-align: left;">Dummy</th>
<th style="text-align: right;">Prop_of_Victory</th>
<th style="text-align: right;">Size_of_Bin</th>
<th style="text-align: right;">ROI</th>
<th style="text-align: right;">Mid_Bin</th>
<th style="text-align: right;">Over_Performance</th>
<th style="text-align: left;">Is_Fav</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">(0.501,0.587]</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">0.5240000</td>
<td style="text-align: right;">250</td>
<td style="text-align: right;">-0.0403200</td>
<td style="text-align: right;">0.54400</td>
<td style="text-align: right;">-0.0200000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.501,0.587]</td>
<td style="text-align: left;">M-DEC</td>
<td style="text-align: right;">0.6666667</td>
<td style="text-align: right;">9</td>
<td style="text-align: right;">0.1844444</td>
<td style="text-align: right;">0.54400</td>
<td style="text-align: right;">0.1226667</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.501,0.587]</td>
<td style="text-align: left;">S-DEC</td>
<td style="text-align: right;">0.4385965</td>
<td style="text-align: right;">114</td>
<td style="text-align: right;">-0.2028947</td>
<td style="text-align: right;">0.54400</td>
<td style="text-align: right;">-0.1054035</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.501,0.587]</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">0.5548387</td>
<td style="text-align: right;">155</td>
<td style="text-align: right;">0.0037419</td>
<td style="text-align: right;">0.54400</td>
<td style="text-align: right;">0.0108387</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.501,0.587]</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">0.5419162</td>
<td style="text-align: right;">334</td>
<td style="text-align: right;">-0.0062874</td>
<td style="text-align: right;">0.54400</td>
<td style="text-align: right;">-0.0020838</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.587,0.674]</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">0.6028881</td>
<td style="text-align: right;">277</td>
<td style="text-align: right;">-0.0437906</td>
<td style="text-align: right;">0.63050</td>
<td style="text-align: right;">-0.0276119</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.587,0.674]</td>
<td style="text-align: left;">M-DEC</td>
<td style="text-align: right;">0.6666667</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">0.0666667</td>
<td style="text-align: right;">0.63050</td>
<td style="text-align: right;">0.0361667</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.587,0.674]</td>
<td style="text-align: left;">S-DEC</td>
<td style="text-align: right;">0.4107143</td>
<td style="text-align: right;">112</td>
<td style="text-align: right;">-0.3425893</td>
<td style="text-align: right;">0.63050</td>
<td style="text-align: right;">-0.2197857</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.587,0.674]</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">0.5144928</td>
<td style="text-align: right;">138</td>
<td style="text-align: right;">-0.1839130</td>
<td style="text-align: right;">0.63050</td>
<td style="text-align: right;">-0.1160072</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.587,0.674]</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">0.6454294</td>
<td style="text-align: right;">361</td>
<td style="text-align: right;">0.0236842</td>
<td style="text-align: right;">0.63050</td>
<td style="text-align: right;">0.0149294</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.674,0.76]</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">0.7268722</td>
<td style="text-align: right;">227</td>
<td style="text-align: right;">0.0123789</td>
<td style="text-align: right;">0.71700</td>
<td style="text-align: right;">0.0098722</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.674,0.76]</td>
<td style="text-align: left;">M-DEC</td>
<td style="text-align: right;">0.0000000</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-1.0000000</td>
<td style="text-align: right;">0.71700</td>
<td style="text-align: right;">-0.7170000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.674,0.76]</td>
<td style="text-align: left;">S-DEC</td>
<td style="text-align: right;">0.5714286</td>
<td style="text-align: right;">63</td>
<td style="text-align: right;">-0.1866667</td>
<td style="text-align: right;">0.71700</td>
<td style="text-align: right;">-0.1455714</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.674,0.76]</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">0.7304348</td>
<td style="text-align: right;">115</td>
<td style="text-align: right;">0.0180000</td>
<td style="text-align: right;">0.71700</td>
<td style="text-align: right;">0.0134348</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.674,0.76]</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">0.7722420</td>
<td style="text-align: right;">281</td>
<td style="text-align: right;">0.0755516</td>
<td style="text-align: right;">0.71700</td>
<td style="text-align: right;">0.0552420</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.76,0.846]</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">0.8014184</td>
<td style="text-align: right;">141</td>
<td style="text-align: right;">-0.0039716</td>
<td style="text-align: right;">0.80300</td>
<td style="text-align: right;">-0.0015816</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.76,0.846]</td>
<td style="text-align: left;">M-DEC</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">0.2600000</td>
<td style="text-align: right;">0.80300</td>
<td style="text-align: right;">0.1970000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.76,0.846]</td>
<td style="text-align: left;">S-DEC</td>
<td style="text-align: right;">0.4500000</td>
<td style="text-align: right;">20</td>
<td style="text-align: right;">-0.4270000</td>
<td style="text-align: right;">0.80300</td>
<td style="text-align: right;">-0.3530000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.76,0.846]</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">0.8426966</td>
<td style="text-align: right;">89</td>
<td style="text-align: right;">0.0495506</td>
<td style="text-align: right;">0.80300</td>
<td style="text-align: right;">0.0396966</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.76,0.846]</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">0.9142857</td>
<td style="text-align: right;">140</td>
<td style="text-align: right;">0.1424286</td>
<td style="text-align: right;">0.80300</td>
<td style="text-align: right;">0.1112857</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.846,0.933]</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">0.8510638</td>
<td style="text-align: right;">47</td>
<td style="text-align: right;">-0.0374468</td>
<td style="text-align: right;">0.88950</td>
<td style="text-align: right;">-0.0384362</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.846,0.933]</td>
<td style="text-align: left;">S-DEC</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">3</td>
<td style="text-align: right;">0.1533333</td>
<td style="text-align: right;">0.88950</td>
<td style="text-align: right;">0.1105000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.846,0.933]</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">0.9583333</td>
<td style="text-align: right;">24</td>
<td style="text-align: right;">0.0820833</td>
<td style="text-align: right;">0.88950</td>
<td style="text-align: right;">0.0688333</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.846,0.933]</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">0.9393939</td>
<td style="text-align: right;">33</td>
<td style="text-align: right;">0.0772727</td>
<td style="text-align: right;">0.88950</td>
<td style="text-align: right;">0.0498939</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.0669,0.154]</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">0.1489362</td>
<td style="text-align: right;">47</td>
<td style="text-align: right;">0.3393617</td>
<td style="text-align: right;">0.11045</td>
<td style="text-align: right;">0.0384862</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.0669,0.154]</td>
<td style="text-align: left;">S-DEC</td>
<td style="text-align: right;">0.0000000</td>
<td style="text-align: right;">3</td>
<td style="text-align: right;">-1.0000000</td>
<td style="text-align: right;">0.11045</td>
<td style="text-align: right;">-0.1104500</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.0669,0.154]</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">0.0416667</td>
<td style="text-align: right;">24</td>
<td style="text-align: right;">-0.7025000</td>
<td style="text-align: right;">0.11045</td>
<td style="text-align: right;">-0.0687833</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.0669,0.154]</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">0.0606061</td>
<td style="text-align: right;">33</td>
<td style="text-align: right;">-0.5239394</td>
<td style="text-align: right;">0.11045</td>
<td style="text-align: right;">-0.0498439</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.154,0.24]</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">0.1985816</td>
<td style="text-align: right;">141</td>
<td style="text-align: right;">-0.0098582</td>
<td style="text-align: right;">0.19700</td>
<td style="text-align: right;">0.0015816</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.154,0.24]</td>
<td style="text-align: left;">M-DEC</td>
<td style="text-align: right;">0.0000000</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-1.0000000</td>
<td style="text-align: right;">0.19700</td>
<td style="text-align: right;">-0.1970000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.154,0.24]</td>
<td style="text-align: left;">S-DEC</td>
<td style="text-align: right;">0.5500000</td>
<td style="text-align: right;">20</td>
<td style="text-align: right;">1.6125000</td>
<td style="text-align: right;">0.19700</td>
<td style="text-align: right;">0.3530000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.154,0.24]</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">0.1573034</td>
<td style="text-align: right;">89</td>
<td style="text-align: right;">-0.2049438</td>
<td style="text-align: right;">0.19700</td>
<td style="text-align: right;">-0.0396966</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.154,0.24]</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">0.0857143</td>
<td style="text-align: right;">140</td>
<td style="text-align: right;">-0.5875714</td>
<td style="text-align: right;">0.19700</td>
<td style="text-align: right;">-0.1112857</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.24,0.326]</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">0.2731278</td>
<td style="text-align: right;">227</td>
<td style="text-align: right;">-0.0531718</td>
<td style="text-align: right;">0.28300</td>
<td style="text-align: right;">-0.0098722</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.24,0.326]</td>
<td style="text-align: left;">M-DEC</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">2.0300000</td>
<td style="text-align: right;">0.28300</td>
<td style="text-align: right;">0.7170000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.24,0.326]</td>
<td style="text-align: left;">S-DEC</td>
<td style="text-align: right;">0.4285714</td>
<td style="text-align: right;">63</td>
<td style="text-align: right;">0.5015873</td>
<td style="text-align: right;">0.28300</td>
<td style="text-align: right;">0.1455714</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.24,0.326]</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">0.2695652</td>
<td style="text-align: right;">115</td>
<td style="text-align: right;">-0.0703478</td>
<td style="text-align: right;">0.28300</td>
<td style="text-align: right;">-0.0134348</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.24,0.326]</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">0.2277580</td>
<td style="text-align: right;">281</td>
<td style="text-align: right;">-0.2165836</td>
<td style="text-align: right;">0.28300</td>
<td style="text-align: right;">-0.0552420</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.326,0.413]</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">0.3971119</td>
<td style="text-align: right;">277</td>
<td style="text-align: right;">0.0597473</td>
<td style="text-align: right;">0.36950</td>
<td style="text-align: right;">0.0276119</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.326,0.413]</td>
<td style="text-align: left;">M-DEC</td>
<td style="text-align: right;">0.3333333</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">-0.0916667</td>
<td style="text-align: right;">0.36950</td>
<td style="text-align: right;">-0.0361667</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.326,0.413]</td>
<td style="text-align: left;">S-DEC</td>
<td style="text-align: right;">0.5892857</td>
<td style="text-align: right;">112</td>
<td style="text-align: right;">0.5446429</td>
<td style="text-align: right;">0.36950</td>
<td style="text-align: right;">0.2197857</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.326,0.413]</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">0.4855072</td>
<td style="text-align: right;">138</td>
<td style="text-align: right;">0.2974638</td>
<td style="text-align: right;">0.36950</td>
<td style="text-align: right;">0.1160072</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.326,0.413]</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">0.3545706</td>
<td style="text-align: right;">361</td>
<td style="text-align: right;">-0.0556510</td>
<td style="text-align: right;">0.36950</td>
<td style="text-align: right;">-0.0149294</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.413,0.499]</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">0.4760000</td>
<td style="text-align: right;">250</td>
<td style="text-align: right;">0.0419600</td>
<td style="text-align: right;">0.45600</td>
<td style="text-align: right;">0.0200000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.413,0.499]</td>
<td style="text-align: left;">M-DEC</td>
<td style="text-align: right;">0.3333333</td>
<td style="text-align: right;">9</td>
<td style="text-align: right;">-0.2344444</td>
<td style="text-align: right;">0.45600</td>
<td style="text-align: right;">-0.1226667</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.413,0.499]</td>
<td style="text-align: left;">S-DEC</td>
<td style="text-align: right;">0.5614035</td>
<td style="text-align: right;">114</td>
<td style="text-align: right;">0.2307018</td>
<td style="text-align: right;">0.45600</td>
<td style="text-align: right;">0.1054035</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.413,0.499]</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">0.4451613</td>
<td style="text-align: right;">155</td>
<td style="text-align: right;">-0.0121935</td>
<td style="text-align: right;">0.45600</td>
<td style="text-align: right;">-0.0108387</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.413,0.499]</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">0.4580838</td>
<td style="text-align: right;">334</td>
<td style="text-align: right;">0.0074251</td>
<td style="text-align: right;">0.45600</td>
<td style="text-align: right;">0.0020838</td>
<td style="text-align: left;">FALSE</td>
</tr>
</tbody>
</table>

How does fight finishing method vary with implied probability of vegas
odds?

    odds_perf_by_method %>%
      dplyr::filter(Is_Fav == T) %>%
      ggplot(aes(x=Mid_Bin, y=Size_of_Bin, group = Dummy, color = Dummy))+
      geom_point()+
      geom_smooth(se=F)+
      ylab("Count")+
      xlab("Adjusted Implied Probability (%)")+
      ggtitle("Favorites")+
      labs(color="Method")

![](/AttM/rmd_images/2021-02-12-fight_odds_analysis/unnamed-chunk-27-1.png)

    odds_perf_by_method %>%
      dplyr::filter(Is_Fav == F) %>%
      ggplot(aes(x=Mid_Bin, y=Size_of_Bin, group = Dummy, color = Dummy))+
      geom_point()+
      geom_smooth(se=F)+
      ylab("Count")+
      xlab("Adjusted Implied Probability (%)")+
      ggtitle("Underdogs")+
      labs(color="Method")

![](/AttM/rmd_images/2021-02-12-fight_odds_analysis/unnamed-chunk-27-2.png)

Calculate the proportion of fights that end by various methods as a
function of implied probability of fight odds.

    odds_perf_by_method %>%
      group_by(Is_Fav, Mid_Bin) %>%
      summarise(Total_Count = sum(Size_of_Bin)) -> total_count

    odds_perf_by_method %>%
      group_by(Is_Fav, Mid_Bin, Dummy) %>%
      summarise(Count= Size_of_Bin) -> single_count

    method_count_by_odds = merge(single_count, total_count)
    method_count_by_odds %>%
      dplyr::mutate(Method_Prop = Count / Total_Count ) -> method_count_by_odds

    method_count_by_odds %>%
      dplyr::filter(Is_Fav == T) %>%
      ggplot(aes(x=Mid_Bin*100, y=Method_Prop*100, group = Dummy, color=Dummy))+
      geom_point()+
      geom_smooth(se=F)+
      ylab("Probability of Method (%)")+
      xlab("Adjusted Implied Probability (%)")+
      ggtitle("Favorites")+
      labs(color="Method")

![](/AttM/rmd_images/2021-02-12-fight_odds_analysis/unnamed-chunk-28-1.png)

    method_count_by_odds %>%
      dplyr::filter(Is_Fav == F) %>%
      ggplot(aes(x=Mid_Bin*100, y=Method_Prop*100, group = Dummy, color=Dummy))+
      geom_point()+
      geom_smooth(se=F)+
      ylab("Probability of Method (%)")+
      xlab("Adjusted Implied Probability (%)")+
      ggtitle("Underdogs")+
      labs(color="Method")

![](/AttM/rmd_images/2021-02-12-fight_odds_analysis/unnamed-chunk-28-2.png)

<br>

#### Fighter Odds

Convert short back to long format.

    df_odds_short %>%
      gather(key = "Result", value = "NAME", Loser:Winner) -> df_odds_long

Identify if fighter was favortie to assign proper Implied Probability.

    df_odds_long %>%
      dplyr::mutate(
      Was_Favorite = ifelse(
        (Favorite_was_Winner & (Result == "Winner")) | (!Favorite_was_Winner & (Result == "Loser"))
        , T
        , F
      )
    ) -> df_odds_long

    summary(df_odds_long[, "Was_Favorite"])

    ##    Mode   FALSE    TRUE 
    ## logical    2941    2941

Identify Implied Probability of each fighter.

    df_odds_long %>%
      dplyr::mutate(
        Implied_Probability = ifelse(
          Was_Favorite
          , Favorite_Probability
          , Underdog_Probability
        )
        , Adjusted_Implied_Probability = ifelse(
          Was_Favorite
          , Adjusted_Favorite_Probability
          , Adjusted_Underdog_Probability
        )
      ) -> df_odds_long

    summary(df_odds_long[,c("Implied_Probability", "Adjusted_Implied_Probability")])

    ##  Implied_Probability Adjusted_Implied_Probability
    ##  Min.   :0.07117     Min.   :0.0673              
    ##  1st Qu.:0.35971     1st Qu.:0.3593              
    ##  Median :0.50000     Median :0.5000              
    ##  Mean   :0.50223     Mean   :0.5000              
    ##  3rd Qu.:0.64103     3rd Qu.:0.6407              
    ##  Max.   :0.94340     Max.   :0.9327

Get rid of useless columns.

    df_odds_long %>% dplyr::select(
      c(
        NAME
        , Event
        , Date
        , Result
        , Implied_Probability
        , Adjusted_Implied_Probability
      )
    ) -> df_odds_long

Summarize data.

    summary(df_odds_long)

    ##      NAME                                            Event     
    ##  Length:5882        UFC Fight Night: Chiesa vs. Magny   :  28  
    ##  Class :character   UFC Fight Night: Poirier vs. Gaethje:  28  
    ##  Mode  :character   UFC Fight Night: Whittaker vs. Till :  28  
    ##                     UFC 190: Rousey vs Correia          :  26  
    ##                     UFC 193: Rousey vs Holm             :  26  
    ##                     UFC 210: Cormier vs. Johnson 2      :  26  
    ##                     (Other)                             :5720  
    ##       Date               Result          Implied_Probability
    ##  Min.   :2013-04-27   Length:5882        Min.   :0.07117    
    ##  1st Qu.:2015-08-23   Class :character   1st Qu.:0.35971    
    ##  Median :2017-05-13   Mode  :character   Median :0.50000    
    ##  Mean   :2017-06-17                      Mean   :0.50223    
    ##  3rd Qu.:2019-04-20                      3rd Qu.:0.64103    
    ##  Max.   :2021-02-06                      Max.   :0.94340    
    ##                                                             
    ##  Adjusted_Implied_Probability
    ##  Min.   :0.0673              
    ##  1st Qu.:0.3593              
    ##  Median :0.5000              
    ##  Mean   :0.5000              
    ##  3rd Qu.:0.6407              
    ##  Max.   :0.9327              
    ## 

Add Win and Log Odds columns.

    df_odds_long %>%
      dplyr::mutate(
        Won = ifelse(Result == "Winner", T, F)
        , Logit_Prob = qlogis(Implied_Probability)
        , Adjusted_Logit_Prob = qlogis(Adjusted_Implied_Probability)
      ) -> df_odds_long

    summary(df_odds_long[, c("Won", "Logit_Prob", "Adjusted_Logit_Prob")])

    ##     Won            Logit_Prob       Adjusted_Logit_Prob
    ##  Mode :logical   Min.   :-2.56879   Min.   :-2.6289    
    ##  FALSE:2941      1st Qu.:-0.57661   1st Qu.:-0.5786    
    ##  TRUE :2941      Median : 0.00000   Median : 0.0000    
    ##                  Mean   : 0.01186   Mean   : 0.0000    
    ##                  3rd Qu.: 0.57982   3rd Qu.: 0.5786    
    ##                  Max.   : 2.81341   Max.   : 2.6289

Get performance and odds for each fighter using Adjusted Implied
Probability.

    df_odds_long %>%
      dplyr::group_by(NAME) %>%
      dplyr::summarise(
        Exp_Prop = mean(Adjusted_Implied_Probability)
        , Logit_Exp_Prop = mean(Adjusted_Logit_Prob)
        , Win_Prop = mean(Won)
        , N_Fights = length(Won)
        , Over_Performance = Win_Prop - Exp_Prop
        , Logit_Over = qlogis(Win_Prop) - Logit_Exp_Prop
        , Back_Trans_Exp = plogis(Logit_Exp_Prop)
      ) -> df_odds_long_fighters

Look at which fights were included in the dataset for a specific
fighter.

    df_odds_long %>%
      dplyr::filter(NAME == "Roxanne Modafferi") -> df_roxy

    kable(df_roxy)

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 31%" />
<col style="width: 6%" />
<col style="width: 3%" />
<col style="width: 11%" />
<col style="width: 16%" />
<col style="width: 3%" />
<col style="width: 6%" />
<col style="width: 11%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">NAME</th>
<th style="text-align: left;">Event</th>
<th style="text-align: left;">Date</th>
<th style="text-align: left;">Result</th>
<th style="text-align: right;">Implied_Probability</th>
<th style="text-align: right;">Adjusted_Implied_Probability</th>
<th style="text-align: left;">Won</th>
<th style="text-align: right;">Logit_Prob</th>
<th style="text-align: right;">Adjusted_Logit_Prob</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Roxanne Modafferi</td>
<td style="text-align: left;">UFC Fight Night: Dos Anjos vs. Edwards</td>
<td style="text-align: left;">2019-07-20</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">0.4385965</td>
<td style="text-align: right;">0.4399686</td>
<td style="text-align: left;">FALSE</td>
<td style="text-align: right;">-0.2468601</td>
<td style="text-align: right;">-0.2412893</td>
</tr>
<tr class="even">
<td style="text-align: left;">Roxanne Modafferi</td>
<td style="text-align: left;">UFC Fight Night: Blaydes vs. Volkov</td>
<td style="text-align: left;">2020-06-20</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">0.4651163</td>
<td style="text-align: right;">0.4694002</td>
<td style="text-align: left;">FALSE</td>
<td style="text-align: right;">-0.1397619</td>
<td style="text-align: right;">-0.1225522</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Roxanne Modafferi</td>
<td style="text-align: left;">The Ultimate Fighter: Team Rousey vs. Team Tate Finale</td>
<td style="text-align: left;">2013-11-30</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">0.1937984</td>
<td style="text-align: right;">0.2000738</td>
<td style="text-align: left;">FALSE</td>
<td style="text-align: right;">-1.4255151</td>
<td style="text-align: right;">-1.3858330</td>
</tr>
<tr class="even">
<td style="text-align: left;">Roxanne Modafferi</td>
<td style="text-align: left;">UFC Fight Night: Chiesa vs. Magny</td>
<td style="text-align: left;">2021-01-20</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">0.2777778</td>
<td style="text-align: right;">0.2657546</td>
<td style="text-align: left;">FALSE</td>
<td style="text-align: right;">-0.9555114</td>
<td style="text-align: right;">-1.0162702</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Roxanne Modafferi</td>
<td style="text-align: left;">UFC 230: Cormier vs. Lewis</td>
<td style="text-align: left;">2018-11-03</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">0.1724138</td>
<td style="text-align: right;">0.1695402</td>
<td style="text-align: left;">FALSE</td>
<td style="text-align: right;">-1.5686159</td>
<td style="text-align: right;">-1.5888892</td>
</tr>
<tr class="even">
<td style="text-align: left;">Roxanne Modafferi</td>
<td style="text-align: left;">UFC Fight Night: Waterson vs. Hill</td>
<td style="text-align: left;">2020-09-12</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">0.2777778</td>
<td style="text-align: right;">0.2657546</td>
<td style="text-align: left;">TRUE</td>
<td style="text-align: right;">-0.9555114</td>
<td style="text-align: right;">-1.0162702</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Roxanne Modafferi</td>
<td style="text-align: left;">UFC Fight Night: Overeem vs. Oleinik</td>
<td style="text-align: left;">2019-04-20</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">0.2666667</td>
<td style="text-align: right;">0.2683698</td>
<td style="text-align: left;">TRUE</td>
<td style="text-align: right;">-1.0116009</td>
<td style="text-align: right;">-1.0029092</td>
</tr>
<tr class="even">
<td style="text-align: left;">Roxanne Modafferi</td>
<td style="text-align: left;">UFC 246: McGregor vs. Cowboy</td>
<td style="text-align: left;">2020-01-18</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">0.1246883</td>
<td style="text-align: right;">0.1159156</td>
<td style="text-align: left;">TRUE</td>
<td style="text-align: right;">-1.9487632</td>
<td style="text-align: right;">-2.0316905</td>
</tr>
</tbody>
</table>

Top 10 over-performers with at least 5 fights where number of fights is
simply number available in the dataset (see above).

    df_odds_long_fighters %>%
      dplyr::filter(N_Fights >= 5) %>%
      dplyr::arrange(desc(Over_Performance)) %>%
      head(10) -> df_top_over_perform
    # now with logit
    df_odds_long_fighters %>%
      dplyr::filter(N_Fights >= 5) %>%
      dplyr::arrange(desc(Logit_Over)) %>%
      head(10) -> df_top_over_perform_logit

    kable(df_top_over_perform, caption = "Top 10 Over Performers with at least 5 Fights")  

<table>
<caption>Top 10 Over Performers with at least 5 Fights</caption>
<colgroup>
<col style="width: 20%" />
<col style="width: 9%" />
<col style="width: 13%" />
<col style="width: 9%" />
<col style="width: 8%" />
<col style="width: 15%" />
<col style="width: 10%" />
<col style="width: 13%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">NAME</th>
<th style="text-align: right;">Exp_Prop</th>
<th style="text-align: right;">Logit_Exp_Prop</th>
<th style="text-align: right;">Win_Prop</th>
<th style="text-align: right;">N_Fights</th>
<th style="text-align: right;">Over_Performance</th>
<th style="text-align: right;">Logit_Over</th>
<th style="text-align: right;">Back_Trans_Exp</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Leonardo Santos</td>
<td style="text-align: right;">0.4454486</td>
<td style="text-align: right;">-0.2777403</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.5545514</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.4310079</td>
</tr>
<tr class="even">
<td style="text-align: left;">Robert Whittaker</td>
<td style="text-align: right;">0.4996490</td>
<td style="text-align: right;">0.0065223</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">10</td>
<td style="text-align: right;">0.5003510</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.5016306</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Brandon Moreno</td>
<td style="text-align: right;">0.4399010</td>
<td style="text-align: right;">-0.2686787</td>
<td style="text-align: right;">0.8571429</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">0.4172418</td>
<td style="text-align: right;">2.060438</td>
<td style="text-align: right;">0.4332315</td>
</tr>
<tr class="even">
<td style="text-align: left;">Arnold Allen</td>
<td style="text-align: right;">0.5867006</td>
<td style="text-align: right;">0.3757653</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">0.4132994</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.5928513</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Brian Ortega</td>
<td style="text-align: right;">0.4823820</td>
<td style="text-align: right;">-0.0684020</td>
<td style="text-align: right;">0.8750000</td>
<td style="text-align: right;">8</td>
<td style="text-align: right;">0.3926180</td>
<td style="text-align: right;">2.014312</td>
<td style="text-align: right;">0.4829062</td>
</tr>
<tr class="even">
<td style="text-align: left;">Alexander Volkanovski</td>
<td style="text-align: right;">0.6101305</td>
<td style="text-align: right;">0.5177296</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">8</td>
<td style="text-align: right;">0.3898695</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.6266167</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Bryan Caraway</td>
<td style="text-align: right;">0.4194964</td>
<td style="text-align: right;">-0.3415057</td>
<td style="text-align: right;">0.8000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.3805036</td>
<td style="text-align: right;">1.727800</td>
<td style="text-align: right;">0.4154438</td>
</tr>
<tr class="even">
<td style="text-align: left;">Yan Xiaonan</td>
<td style="text-align: right;">0.6240270</td>
<td style="text-align: right;">0.5391744</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.3759730</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.6316203</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Amanda Nunes</td>
<td style="text-align: right;">0.5507052</td>
<td style="text-align: right;">0.2811614</td>
<td style="text-align: right;">0.9166667</td>
<td style="text-align: right;">12</td>
<td style="text-align: right;">0.3659615</td>
<td style="text-align: right;">2.116734</td>
<td style="text-align: right;">0.5698309</td>
</tr>
<tr class="even">
<td style="text-align: left;">Joaquim Silva</td>
<td style="text-align: right;">0.4575904</td>
<td style="text-align: right;">-0.1889315</td>
<td style="text-align: right;">0.8000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.3424096</td>
<td style="text-align: right;">1.575226</td>
<td style="text-align: right;">0.4529071</td>
</tr>
</tbody>
</table>

    kable(df_top_over_perform_logit, caption = "Logit Scale: Top 10 Over Performers with at least 5 Fights")

<table>
<caption>Logit Scale: Top 10 Over Performers with at least 5 Fights</caption>
<colgroup>
<col style="width: 20%" />
<col style="width: 9%" />
<col style="width: 13%" />
<col style="width: 8%" />
<col style="width: 8%" />
<col style="width: 15%" />
<col style="width: 10%" />
<col style="width: 13%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">NAME</th>
<th style="text-align: right;">Exp_Prop</th>
<th style="text-align: right;">Logit_Exp_Prop</th>
<th style="text-align: right;">Win_Prop</th>
<th style="text-align: right;">N_Fights</th>
<th style="text-align: right;">Over_Performance</th>
<th style="text-align: right;">Logit_Over</th>
<th style="text-align: right;">Back_Trans_Exp</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Alexander Volkanovski</td>
<td style="text-align: right;">0.6101305</td>
<td style="text-align: right;">0.5177296</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">8</td>
<td style="text-align: right;">0.3898695</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.6266167</td>
</tr>
<tr class="even">
<td style="text-align: left;">Arnold Allen</td>
<td style="text-align: right;">0.5867006</td>
<td style="text-align: right;">0.3757653</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">0.4132994</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.5928513</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Demetrious Johnson</td>
<td style="text-align: right;">0.8609483</td>
<td style="text-align: right;">1.8803058</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">9</td>
<td style="text-align: right;">0.1390517</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.8676462</td>
</tr>
<tr class="even">
<td style="text-align: left;">Israel Adesanya</td>
<td style="text-align: right;">0.7002859</td>
<td style="text-align: right;">0.8678323</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">0.2997141</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.7042944</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Jon Jones</td>
<td style="text-align: right;">0.7892464</td>
<td style="text-align: right;">1.3952860</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">0.2107536</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.8014348</td>
</tr>
<tr class="even">
<td style="text-align: left;">Kamaru Usman</td>
<td style="text-align: right;">0.6925314</td>
<td style="text-align: right;">0.8901129</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">10</td>
<td style="text-align: right;">0.3074686</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.7089135</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Khabib Nurmagomedov</td>
<td style="text-align: right;">0.7598282</td>
<td style="text-align: right;">1.2002959</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">9</td>
<td style="text-align: right;">0.2401718</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.7685774</td>
</tr>
<tr class="even">
<td style="text-align: left;">Kyung Ho Kang</td>
<td style="text-align: right;">0.6633446</td>
<td style="text-align: right;">0.7104716</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">0.3366554</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.6705054</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Leonardo Santos</td>
<td style="text-align: right;">0.4454486</td>
<td style="text-align: right;">-0.2777403</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.5545514</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.4310079</td>
</tr>
<tr class="even">
<td style="text-align: left;">Petr Yan</td>
<td style="text-align: right;">0.8144451</td>
<td style="text-align: right;">1.5256823</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.1855549</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.8213737</td>
</tr>
</tbody>
</table>

Top 10 under performers with at least 5 fights.

    df_odds_long_fighters %>%
      dplyr::filter(N_Fights >= 5) %>%
      dplyr::arrange(Over_Performance) %>%
      head(10) -> df_top_under_perform
    # with logit
    df_odds_long_fighters %>%
      dplyr::filter(N_Fights >= 5) %>%
      dplyr::arrange(Logit_Over) %>%
      head(10) -> df_top_under_perform_logit

    kable(df_top_under_perform, caption = "Top 10 Under Performers with at least 5 Fights")

<table>
<caption>Top 10 Under Performers with at least 5 Fights</caption>
<colgroup>
<col style="width: 19%" />
<col style="width: 9%" />
<col style="width: 13%" />
<col style="width: 9%" />
<col style="width: 8%" />
<col style="width: 15%" />
<col style="width: 10%" />
<col style="width: 13%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">NAME</th>
<th style="text-align: right;">Exp_Prop</th>
<th style="text-align: right;">Logit_Exp_Prop</th>
<th style="text-align: right;">Win_Prop</th>
<th style="text-align: right;">N_Fights</th>
<th style="text-align: right;">Over_Performance</th>
<th style="text-align: right;">Logit_Over</th>
<th style="text-align: right;">Back_Trans_Exp</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Kailin Curran</td>
<td style="text-align: right;">0.5404624</td>
<td style="text-align: right;">0.1811195</td>
<td style="text-align: right;">0.1428571</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">-0.3976052</td>
<td style="text-align: right;">-1.972879</td>
<td style="text-align: right;">0.5451565</td>
</tr>
<tr class="even">
<td style="text-align: left;">Joshua Burkman</td>
<td style="text-align: right;">0.3760531</td>
<td style="text-align: right;">-0.5400292</td>
<td style="text-align: right;">0.0000000</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">-0.3760531</td>
<td style="text-align: right;">-Inf</td>
<td style="text-align: right;">0.3681808</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Hyun Gyu Lim</td>
<td style="text-align: right;">0.5720479</td>
<td style="text-align: right;">0.3587458</td>
<td style="text-align: right;">0.2000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-0.3720479</td>
<td style="text-align: right;">-1.745040</td>
<td style="text-align: right;">0.5887368</td>
</tr>
<tr class="even">
<td style="text-align: left;">Alexander Gustafsson</td>
<td style="text-align: right;">0.6271431</td>
<td style="text-align: right;">0.5898086</td>
<td style="text-align: right;">0.2857143</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">-0.3414288</td>
<td style="text-align: right;">-1.506099</td>
<td style="text-align: right;">0.6433212</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Gray Maynard</td>
<td style="text-align: right;">0.5072171</td>
<td style="text-align: right;">0.0245074</td>
<td style="text-align: right;">0.1666667</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">-0.3405504</td>
<td style="text-align: right;">-1.633945</td>
<td style="text-align: right;">0.5061265</td>
</tr>
<tr class="even">
<td style="text-align: left;">Junior Albini</td>
<td style="text-align: right;">0.5325358</td>
<td style="text-align: right;">0.1453508</td>
<td style="text-align: right;">0.2000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-0.3325358</td>
<td style="text-align: right;">-1.531645</td>
<td style="text-align: right;">0.5362739</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Rashad Evans</td>
<td style="text-align: right;">0.5236378</td>
<td style="text-align: right;">0.1041933</td>
<td style="text-align: right;">0.2000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-0.3236378</td>
<td style="text-align: right;">-1.490488</td>
<td style="text-align: right;">0.5260248</td>
</tr>
<tr class="even">
<td style="text-align: left;">Andrea Lee</td>
<td style="text-align: right;">0.7055647</td>
<td style="text-align: right;">0.8841184</td>
<td style="text-align: right;">0.4000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-0.3055647</td>
<td style="text-align: right;">-1.289583</td>
<td style="text-align: right;">0.7076749</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Johny Hendricks</td>
<td style="text-align: right;">0.5509110</td>
<td style="text-align: right;">0.2250002</td>
<td style="text-align: right;">0.2500000</td>
<td style="text-align: right;">8</td>
<td style="text-align: right;">-0.3009110</td>
<td style="text-align: right;">-1.323613</td>
<td style="text-align: right;">0.5560140</td>
</tr>
<tr class="even">
<td style="text-align: left;">Anderson Silva</td>
<td style="text-align: right;">0.4249640</td>
<td style="text-align: right;">-0.3485824</td>
<td style="text-align: right;">0.1428571</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">-0.2821068</td>
<td style="text-align: right;">-1.443177</td>
<td style="text-align: right;">0.4137262</td>
</tr>
</tbody>
</table>

    kable(df_top_under_perform_logit, caption ="Logit Scale: Top 10 Under Performers with at least 5 Fights" )

<table>
<caption>Logit Scale: Top 10 Under Performers with at least 5 Fights</caption>
<colgroup>
<col style="width: 19%" />
<col style="width: 9%" />
<col style="width: 13%" />
<col style="width: 9%" />
<col style="width: 8%" />
<col style="width: 15%" />
<col style="width: 10%" />
<col style="width: 13%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">NAME</th>
<th style="text-align: right;">Exp_Prop</th>
<th style="text-align: right;">Logit_Exp_Prop</th>
<th style="text-align: right;">Win_Prop</th>
<th style="text-align: right;">N_Fights</th>
<th style="text-align: right;">Over_Performance</th>
<th style="text-align: right;">Logit_Over</th>
<th style="text-align: right;">Back_Trans_Exp</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Joshua Burkman</td>
<td style="text-align: right;">0.3760531</td>
<td style="text-align: right;">-0.5400292</td>
<td style="text-align: right;">0.0000000</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">-0.3760531</td>
<td style="text-align: right;">-Inf</td>
<td style="text-align: right;">0.3681808</td>
</tr>
<tr class="even">
<td style="text-align: left;">Kailin Curran</td>
<td style="text-align: right;">0.5404624</td>
<td style="text-align: right;">0.1811195</td>
<td style="text-align: right;">0.1428571</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">-0.3976052</td>
<td style="text-align: right;">-1.972879</td>
<td style="text-align: right;">0.5451565</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Hyun Gyu Lim</td>
<td style="text-align: right;">0.5720479</td>
<td style="text-align: right;">0.3587458</td>
<td style="text-align: right;">0.2000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-0.3720479</td>
<td style="text-align: right;">-1.745040</td>
<td style="text-align: right;">0.5887368</td>
</tr>
<tr class="even">
<td style="text-align: left;">Gray Maynard</td>
<td style="text-align: right;">0.5072171</td>
<td style="text-align: right;">0.0245074</td>
<td style="text-align: right;">0.1666667</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">-0.3405504</td>
<td style="text-align: right;">-1.633945</td>
<td style="text-align: right;">0.5061265</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Junior Albini</td>
<td style="text-align: right;">0.5325358</td>
<td style="text-align: right;">0.1453508</td>
<td style="text-align: right;">0.2000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-0.3325358</td>
<td style="text-align: right;">-1.531645</td>
<td style="text-align: right;">0.5362739</td>
</tr>
<tr class="even">
<td style="text-align: left;">Alexander Gustafsson</td>
<td style="text-align: right;">0.6271431</td>
<td style="text-align: right;">0.5898086</td>
<td style="text-align: right;">0.2857143</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">-0.3414288</td>
<td style="text-align: right;">-1.506099</td>
<td style="text-align: right;">0.6433212</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Rashad Evans</td>
<td style="text-align: right;">0.5236378</td>
<td style="text-align: right;">0.1041933</td>
<td style="text-align: right;">0.2000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-0.3236378</td>
<td style="text-align: right;">-1.490488</td>
<td style="text-align: right;">0.5260248</td>
</tr>
<tr class="even">
<td style="text-align: left;">Anderson Silva</td>
<td style="text-align: right;">0.4249640</td>
<td style="text-align: right;">-0.3485824</td>
<td style="text-align: right;">0.1428571</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">-0.2821068</td>
<td style="text-align: right;">-1.443177</td>
<td style="text-align: right;">0.4137262</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Ronda Rousey</td>
<td style="text-align: right;">0.8322407</td>
<td style="text-align: right;">1.8077087</td>
<td style="text-align: right;">0.6000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-0.2322407</td>
<td style="text-align: right;">-1.402244</td>
<td style="text-align: right;">0.8590847</td>
</tr>
<tr class="even">
<td style="text-align: left;">Brad Pickett</td>
<td style="text-align: right;">0.3826965</td>
<td style="text-align: right;">-0.5461462</td>
<td style="text-align: right;">0.1250000</td>
<td style="text-align: right;">8</td>
<td style="text-align: right;">-0.2576965</td>
<td style="text-align: right;">-1.399764</td>
<td style="text-align: right;">0.3667590</td>
</tr>
</tbody>
</table>

Most favored fighters with at least 5 fights

    df_odds_long_fighters %>%
      dplyr::filter(N_Fights >= 5) %>%
      dplyr::arrange(desc(Exp_Prop)) %>%
      head(10) -> df_most_fav
    # with logit
    df_odds_long_fighters %>%
      dplyr::filter(N_Fights >= 5) %>%
      dplyr::arrange(desc(Logit_Exp_Prop)) %>%
      head(10) -> df_most_fav_logit

    kable(df_most_fav)

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 9%" />
<col style="width: 13%" />
<col style="width: 9%" />
<col style="width: 8%" />
<col style="width: 15%" />
<col style="width: 10%" />
<col style="width: 13%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">NAME</th>
<th style="text-align: right;">Exp_Prop</th>
<th style="text-align: right;">Logit_Exp_Prop</th>
<th style="text-align: right;">Win_Prop</th>
<th style="text-align: right;">N_Fights</th>
<th style="text-align: right;">Over_Performance</th>
<th style="text-align: right;">Logit_Over</th>
<th style="text-align: right;">Back_Trans_Exp</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Demetrious Johnson</td>
<td style="text-align: right;">0.8609483</td>
<td style="text-align: right;">1.880306</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">9</td>
<td style="text-align: right;">0.1390517</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.8676462</td>
</tr>
<tr class="even">
<td style="text-align: left;">Ronda Rousey</td>
<td style="text-align: right;">0.8322407</td>
<td style="text-align: right;">1.807709</td>
<td style="text-align: right;">0.6000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-0.2322407</td>
<td style="text-align: right;">-1.4022436</td>
<td style="text-align: right;">0.8590847</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Cristiane Justino</td>
<td style="text-align: right;">0.8252814</td>
<td style="text-align: right;">1.703941</td>
<td style="text-align: right;">0.8571429</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">0.0318615</td>
<td style="text-align: right;">0.0878185</td>
<td style="text-align: right;">0.8460487</td>
</tr>
<tr class="even">
<td style="text-align: left;">Petr Yan</td>
<td style="text-align: right;">0.8144451</td>
<td style="text-align: right;">1.525682</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.1855549</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.8213737</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Zabit Magomedsharipov</td>
<td style="text-align: right;">0.8050291</td>
<td style="text-align: right;">1.485833</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">0.1949709</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.8154520</td>
</tr>
<tr class="even">
<td style="text-align: left;">Tatiana Suarez</td>
<td style="text-align: right;">0.7972730</td>
<td style="text-align: right;">1.391506</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.2027270</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.8008325</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Jon Jones</td>
<td style="text-align: right;">0.7892464</td>
<td style="text-align: right;">1.395286</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">0.2107536</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.8014348</td>
</tr>
<tr class="even">
<td style="text-align: left;">Magomed Ankalaev</td>
<td style="text-align: right;">0.7647264</td>
<td style="text-align: right;">1.211622</td>
<td style="text-align: right;">0.8000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.0352736</td>
<td style="text-align: right;">0.1746719</td>
<td style="text-align: right;">0.7705859</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Khabib Nurmagomedov</td>
<td style="text-align: right;">0.7598282</td>
<td style="text-align: right;">1.200296</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">9</td>
<td style="text-align: right;">0.2401718</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.7685774</td>
</tr>
<tr class="even">
<td style="text-align: left;">Mairbek Taisumov</td>
<td style="text-align: right;">0.7342042</td>
<td style="text-align: right;">1.072182</td>
<td style="text-align: right;">0.7777778</td>
<td style="text-align: right;">9</td>
<td style="text-align: right;">0.0435736</td>
<td style="text-align: right;">0.1805805</td>
<td style="text-align: right;">0.7450117</td>
</tr>
</tbody>
</table>

    kable(df_most_fav_logit)

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 9%" />
<col style="width: 13%" />
<col style="width: 9%" />
<col style="width: 8%" />
<col style="width: 15%" />
<col style="width: 10%" />
<col style="width: 13%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">NAME</th>
<th style="text-align: right;">Exp_Prop</th>
<th style="text-align: right;">Logit_Exp_Prop</th>
<th style="text-align: right;">Win_Prop</th>
<th style="text-align: right;">N_Fights</th>
<th style="text-align: right;">Over_Performance</th>
<th style="text-align: right;">Logit_Over</th>
<th style="text-align: right;">Back_Trans_Exp</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Demetrious Johnson</td>
<td style="text-align: right;">0.8609483</td>
<td style="text-align: right;">1.880306</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">9</td>
<td style="text-align: right;">0.1390517</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.8676462</td>
</tr>
<tr class="even">
<td style="text-align: left;">Ronda Rousey</td>
<td style="text-align: right;">0.8322407</td>
<td style="text-align: right;">1.807709</td>
<td style="text-align: right;">0.6000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-0.2322407</td>
<td style="text-align: right;">-1.4022436</td>
<td style="text-align: right;">0.8590847</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Cristiane Justino</td>
<td style="text-align: right;">0.8252814</td>
<td style="text-align: right;">1.703941</td>
<td style="text-align: right;">0.8571429</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">0.0318615</td>
<td style="text-align: right;">0.0878185</td>
<td style="text-align: right;">0.8460487</td>
</tr>
<tr class="even">
<td style="text-align: left;">Petr Yan</td>
<td style="text-align: right;">0.8144451</td>
<td style="text-align: right;">1.525682</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.1855549</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.8213737</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Zabit Magomedsharipov</td>
<td style="text-align: right;">0.8050291</td>
<td style="text-align: right;">1.485833</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">0.1949709</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.8154520</td>
</tr>
<tr class="even">
<td style="text-align: left;">Jon Jones</td>
<td style="text-align: right;">0.7892464</td>
<td style="text-align: right;">1.395286</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">0.2107536</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.8014348</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Tatiana Suarez</td>
<td style="text-align: right;">0.7972730</td>
<td style="text-align: right;">1.391506</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.2027270</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.8008325</td>
</tr>
<tr class="even">
<td style="text-align: left;">Magomed Ankalaev</td>
<td style="text-align: right;">0.7647264</td>
<td style="text-align: right;">1.211622</td>
<td style="text-align: right;">0.8000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.0352736</td>
<td style="text-align: right;">0.1746719</td>
<td style="text-align: right;">0.7705859</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Khabib Nurmagomedov</td>
<td style="text-align: right;">0.7598282</td>
<td style="text-align: right;">1.200296</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">9</td>
<td style="text-align: right;">0.2401718</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.7685774</td>
</tr>
<tr class="even">
<td style="text-align: left;">Mairbek Taisumov</td>
<td style="text-align: right;">0.7342042</td>
<td style="text-align: right;">1.072182</td>
<td style="text-align: right;">0.7777778</td>
<td style="text-align: right;">9</td>
<td style="text-align: right;">0.0435736</td>
<td style="text-align: right;">0.1805805</td>
<td style="text-align: right;">0.7450117</td>
</tr>
</tbody>
</table>

Least favored fighters with at least 5 fights.

    df_odds_long_fighters %>%
      dplyr::filter(N_Fights >= 5) %>%
      dplyr::arrange(Exp_Prop) %>%
      head(10) -> df_least_fav
    # with logit
    df_odds_long_fighters %>%
      dplyr::filter(N_Fights >= 5) %>%
      dplyr::arrange(Logit_Exp_Prop) %>%
      head(10) -> df_least_fav_logit

    kable(df_least_fav, caption = "Top 10 Least Favored Fighters with at least 5 Fights")

<table>
<caption>Top 10 Least Favored Fighters with at least 5 Fights</caption>
<colgroup>
<col style="width: 17%" />
<col style="width: 9%" />
<col style="width: 14%" />
<col style="width: 9%" />
<col style="width: 8%" />
<col style="width: 16%" />
<col style="width: 10%" />
<col style="width: 14%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">NAME</th>
<th style="text-align: right;">Exp_Prop</th>
<th style="text-align: right;">Logit_Exp_Prop</th>
<th style="text-align: right;">Win_Prop</th>
<th style="text-align: right;">N_Fights</th>
<th style="text-align: right;">Over_Performance</th>
<th style="text-align: right;">Logit_Over</th>
<th style="text-align: right;">Back_Trans_Exp</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Roxanne Modafferi</td>
<td style="text-align: right;">0.2743472</td>
<td style="text-align: right;">-1.0507130</td>
<td style="text-align: right;">0.3750000</td>
<td style="text-align: right;">8</td>
<td style="text-align: right;">0.1006528</td>
<td style="text-align: right;">0.5398874</td>
<td style="text-align: right;">0.2590882</td>
</tr>
<tr class="even">
<td style="text-align: left;">Daniel Kelly</td>
<td style="text-align: right;">0.2769185</td>
<td style="text-align: right;">-0.9737988</td>
<td style="text-align: right;">0.6000000</td>
<td style="text-align: right;">10</td>
<td style="text-align: right;">0.3230815</td>
<td style="text-align: right;">1.3792639</td>
<td style="text-align: right;">0.2741240</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Jessica Aguilar</td>
<td style="text-align: right;">0.2859562</td>
<td style="text-align: right;">-0.9707245</td>
<td style="text-align: right;">0.2000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-0.0859562</td>
<td style="text-align: right;">-0.4155698</td>
<td style="text-align: right;">0.2747361</td>
</tr>
<tr class="even">
<td style="text-align: left;">Dan Henderson</td>
<td style="text-align: right;">0.2887631</td>
<td style="text-align: right;">-0.9309147</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">0.2112369</td>
<td style="text-align: right;">0.9309147</td>
<td style="text-align: right;">0.2827392</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Thibault Gouti</td>
<td style="text-align: right;">0.2982523</td>
<td style="text-align: right;">-0.9293738</td>
<td style="text-align: right;">0.1666667</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">-0.1315857</td>
<td style="text-align: right;">-0.6800641</td>
<td style="text-align: right;">0.2830518</td>
</tr>
<tr class="even">
<td style="text-align: left;">Anthony Perosh</td>
<td style="text-align: right;">0.2985353</td>
<td style="text-align: right;">-0.9384366</td>
<td style="text-align: right;">0.4000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.1014647</td>
<td style="text-align: right;">0.5329715</td>
<td style="text-align: right;">0.2812162</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Leslie Smith</td>
<td style="text-align: right;">0.3018944</td>
<td style="text-align: right;">-0.9783537</td>
<td style="text-align: right;">0.4000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.0981056</td>
<td style="text-align: right;">0.5728886</td>
<td style="text-align: right;">0.2732186</td>
</tr>
<tr class="even">
<td style="text-align: left;">Garreth McLellan</td>
<td style="text-align: right;">0.3067211</td>
<td style="text-align: right;">-0.8343938</td>
<td style="text-align: right;">0.2000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-0.1067211</td>
<td style="text-align: right;">-0.5519005</td>
<td style="text-align: right;">0.3027168</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Yaotzin Meza</td>
<td style="text-align: right;">0.3076578</td>
<td style="text-align: right;">-0.8634526</td>
<td style="text-align: right;">0.4000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.0923422</td>
<td style="text-align: right;">0.4579875</td>
<td style="text-align: right;">0.2966185</td>
</tr>
<tr class="even">
<td style="text-align: left;">Takanori Gomi</td>
<td style="text-align: right;">0.3093210</td>
<td style="text-align: right;">-0.8732262</td>
<td style="text-align: right;">0.2000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-0.1093210</td>
<td style="text-align: right;">-0.5130682</td>
<td style="text-align: right;">0.2945834</td>
</tr>
</tbody>
</table>

    kable(df_least_fav_logit, caption = "Logit Scale: Top 10 Least Favored Fighters with at least 5 Fights")

<table>
<caption>Logit Scale: Top 10 Least Favored Fighters with at least 5 Fights</caption>
<colgroup>
<col style="width: 17%" />
<col style="width: 9%" />
<col style="width: 14%" />
<col style="width: 9%" />
<col style="width: 8%" />
<col style="width: 16%" />
<col style="width: 10%" />
<col style="width: 14%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">NAME</th>
<th style="text-align: right;">Exp_Prop</th>
<th style="text-align: right;">Logit_Exp_Prop</th>
<th style="text-align: right;">Win_Prop</th>
<th style="text-align: right;">N_Fights</th>
<th style="text-align: right;">Over_Performance</th>
<th style="text-align: right;">Logit_Over</th>
<th style="text-align: right;">Back_Trans_Exp</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Roxanne Modafferi</td>
<td style="text-align: right;">0.2743472</td>
<td style="text-align: right;">-1.0507130</td>
<td style="text-align: right;">0.3750000</td>
<td style="text-align: right;">8</td>
<td style="text-align: right;">0.1006528</td>
<td style="text-align: right;">0.5398874</td>
<td style="text-align: right;">0.2590882</td>
</tr>
<tr class="even">
<td style="text-align: left;">Leslie Smith</td>
<td style="text-align: right;">0.3018944</td>
<td style="text-align: right;">-0.9783537</td>
<td style="text-align: right;">0.4000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.0981056</td>
<td style="text-align: right;">0.5728886</td>
<td style="text-align: right;">0.2732186</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Daniel Kelly</td>
<td style="text-align: right;">0.2769185</td>
<td style="text-align: right;">-0.9737988</td>
<td style="text-align: right;">0.6000000</td>
<td style="text-align: right;">10</td>
<td style="text-align: right;">0.3230815</td>
<td style="text-align: right;">1.3792639</td>
<td style="text-align: right;">0.2741240</td>
</tr>
<tr class="even">
<td style="text-align: left;">Jessica Aguilar</td>
<td style="text-align: right;">0.2859562</td>
<td style="text-align: right;">-0.9707245</td>
<td style="text-align: right;">0.2000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-0.0859562</td>
<td style="text-align: right;">-0.4155698</td>
<td style="text-align: right;">0.2747361</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Anthony Perosh</td>
<td style="text-align: right;">0.2985353</td>
<td style="text-align: right;">-0.9384366</td>
<td style="text-align: right;">0.4000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.1014647</td>
<td style="text-align: right;">0.5329715</td>
<td style="text-align: right;">0.2812162</td>
</tr>
<tr class="even">
<td style="text-align: left;">Dan Henderson</td>
<td style="text-align: right;">0.2887631</td>
<td style="text-align: right;">-0.9309147</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">0.2112369</td>
<td style="text-align: right;">0.9309147</td>
<td style="text-align: right;">0.2827392</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Thibault Gouti</td>
<td style="text-align: right;">0.2982523</td>
<td style="text-align: right;">-0.9293738</td>
<td style="text-align: right;">0.1666667</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">-0.1315857</td>
<td style="text-align: right;">-0.6800641</td>
<td style="text-align: right;">0.2830518</td>
</tr>
<tr class="even">
<td style="text-align: left;">Takanori Gomi</td>
<td style="text-align: right;">0.3093210</td>
<td style="text-align: right;">-0.8732262</td>
<td style="text-align: right;">0.2000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-0.1093210</td>
<td style="text-align: right;">-0.5130682</td>
<td style="text-align: right;">0.2945834</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Yaotzin Meza</td>
<td style="text-align: right;">0.3076578</td>
<td style="text-align: right;">-0.8634526</td>
<td style="text-align: right;">0.4000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.0923422</td>
<td style="text-align: right;">0.4579875</td>
<td style="text-align: right;">0.2966185</td>
</tr>
<tr class="even">
<td style="text-align: left;">Julian Erosa</td>
<td style="text-align: right;">0.3202609</td>
<td style="text-align: right;">-0.8581763</td>
<td style="text-align: right;">0.2000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-0.1202609</td>
<td style="text-align: right;">-0.5281181</td>
<td style="text-align: right;">0.2977205</td>
</tr>
</tbody>
</table>

Examine odds for specific fighters.

    # Israel Adesanya
    df_odds_long_fighters %>% dplyr::filter(NAME == "Israel Adesanya") -> df_Izzy
    kable(df_Izzy)

<table>
<colgroup>
<col style="width: 15%" />
<col style="width: 9%" />
<col style="width: 14%" />
<col style="width: 8%" />
<col style="width: 8%" />
<col style="width: 16%" />
<col style="width: 10%" />
<col style="width: 14%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">NAME</th>
<th style="text-align: right;">Exp_Prop</th>
<th style="text-align: right;">Logit_Exp_Prop</th>
<th style="text-align: right;">Win_Prop</th>
<th style="text-align: right;">N_Fights</th>
<th style="text-align: right;">Over_Performance</th>
<th style="text-align: right;">Logit_Over</th>
<th style="text-align: right;">Back_Trans_Exp</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Israel Adesanya</td>
<td style="text-align: right;">0.7002859</td>
<td style="text-align: right;">0.8678323</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">0.2997141</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.7042944</td>
</tr>
</tbody>
</table>

    # Anthony Smith
    df_odds_long_fighters %>% dplyr::filter(NAME == "Anthony Smith") -> df_Smith
    kable(df_Smith)

<table>
<colgroup>
<col style="width: 13%" />
<col style="width: 9%" />
<col style="width: 14%" />
<col style="width: 9%" />
<col style="width: 8%" />
<col style="width: 16%" />
<col style="width: 10%" />
<col style="width: 14%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">NAME</th>
<th style="text-align: right;">Exp_Prop</th>
<th style="text-align: right;">Logit_Exp_Prop</th>
<th style="text-align: right;">Win_Prop</th>
<th style="text-align: right;">N_Fights</th>
<th style="text-align: right;">Over_Performance</th>
<th style="text-align: right;">Logit_Over</th>
<th style="text-align: right;">Back_Trans_Exp</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Anthony Smith</td>
<td style="text-align: right;">0.4539811</td>
<td style="text-align: right;">-0.2286408</td>
<td style="text-align: right;">0.6428571</td>
<td style="text-align: right;">14</td>
<td style="text-align: right;">0.1888761</td>
<td style="text-align: right;">0.8164275</td>
<td style="text-align: right;">0.4430875</td>
</tr>
</tbody>
</table>
