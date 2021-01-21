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
    ##  Length:5962        Length:5962        Length:5962        Length:5962       
    ##  Class :character   Class :character   Class :character   Class :character  
    ##  Mode  :character   Mode  :character   Mode  :character   Mode  :character  
    ##                                                                             
    ##                                                                             
    ##                                                                             
    ##                                                                             
    ##     State             Country          FightWeightClass       Round     
    ##  Length:5962        Length:5962        Length:5962        Min.   :1.00  
    ##  Class :character   Class :character   Class :character   1st Qu.:1.00  
    ##  Mode  :character   Mode  :character   Mode  :character   Median :3.00  
    ##                                                           Mean   :2.43  
    ##                                                           3rd Qu.:3.00  
    ##                                                           Max.   :5.00  
    ##                                                                         
    ##     Method          Winner_Odds         Loser_Odds            Sex           
    ##  Length:5962        Length:5962        Length:5962        Length:5962       
    ##  Class :character   Class :character   Class :character   Class :character  
    ##  Mode  :character   Mode  :character   Mode  :character   Mode  :character  
    ##                                                                             
    ##                                                                             
    ##                                                                             
    ##                                                                             
    ##     fight_id       Result          FighterWeight   FighterWeightClass
    ##  Min.   :   1   Length:5962        Min.   :115.0   Length:5962       
    ##  1st Qu.: 746   Class :character   1st Qu.:135.0   Class :character  
    ##  Median :1491   Mode  :character   Median :155.0   Mode  :character  
    ##  Mean   :1491                      Mean   :163.9                     
    ##  3rd Qu.:2236                      3rd Qu.:185.0                     
    ##  Max.   :2981                      Max.   :265.0                     
    ##                                                                      
    ##      REACH            SLPM            SAPM             STRA       
    ##  Min.   :58.00   Min.   : 0.00   Min.   : 0.000   Min.   :0.0000  
    ##  1st Qu.:69.00   1st Qu.: 2.68   1st Qu.: 2.630   1st Qu.:0.3900  
    ##  Median :72.00   Median : 3.44   Median : 3.220   Median :0.4400  
    ##  Mean   :71.77   Mean   : 3.53   Mean   : 3.435   Mean   :0.4411  
    ##  3rd Qu.:75.00   3rd Qu.: 4.25   3rd Qu.: 4.030   3rd Qu.:0.4900  
    ##  Max.   :84.00   Max.   :11.14   Max.   :23.330   Max.   :0.8000  
    ##  NA's   :215                                                      
    ##       STRD             TD              TDA              TDD       
    ##  Min.   :0.000   Min.   : 0.000   Min.   :0.0000   Min.   :0.000  
    ##  1st Qu.:0.510   1st Qu.: 0.560   1st Qu.:0.2600   1st Qu.:0.510  
    ##  Median :0.560   Median : 1.210   Median :0.3700   Median :0.640  
    ##  Mean   :0.552   Mean   : 1.516   Mean   :0.3735   Mean   :0.616  
    ##  3rd Qu.:0.600   3rd Qu.: 2.160   3rd Qu.:0.5000   3rd Qu.:0.760  
    ##  Max.   :0.920   Max.   :14.190   Max.   :1.0000   Max.   :1.000  
    ##                                                                   
    ##       SUBA        
    ##  Min.   : 0.0000  
    ##  1st Qu.: 0.1000  
    ##  Median : 0.4000  
    ##  Mean   : 0.5528  
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
    ##  Jim Miller        :  19   Median :2017-05-13  
    ##  Neil Magny        :  19   Mean   :2017-06-14  
    ##  Derrick Lewis     :  18   3rd Qu.:2019-04-13  
    ##  Tim Means         :  18   Max.   :2021-01-20  
    ##  (Other)           :5843                       
    ##                                   Event                  City     
    ##  UFC Fight Night: Chiesa vs. Magny   :  28   Las Vegas     :1222  
    ##  UFC Fight Night: Poirier vs. Gaethje:  28   Abu Dhabi     : 258  
    ##  UFC Fight Night: Whittaker vs. Till :  28   Boston        : 124  
    ##  UFC 190: Rousey vs Correia          :  26   Rio de Janeiro: 124  
    ##  UFC 193: Rousey vs Holm             :  26   Chicago       : 118  
    ##  UFC 210: Cormier vs. Johnson 2      :  26   Newark        : 114  
    ##  (Other)                             :5800   (Other)       :4002  
    ##         State                      Country          FightWeightClass
    ##  Nevada    :1222   USA                 :3440   Welterweight : 986   
    ##  Abu Dhabi : 258   Brazil              : 532   Lightweight  : 980   
    ##  Texas     : 256   Canada              : 378   Bantamweight : 848   
    ##  New York  : 252   United Arab Emirates: 258   Featherweight: 718   
    ##  California: 250   Australia           : 236   Middleweight : 654   
    ##  Florida   : 176   United Kingdom      : 184   Flyweight    : 494   
    ##  (Other)   :3548   (Other)             : 934   (Other)      :1282   
    ##      Round             Method      Winner_Odds     Loser_Odds       Sex      
    ##  Min.   :1.00   DQ        :  14   Min.   :1.06   Min.   :1.07   Female: 762  
    ##  1st Qu.:1.00   KO/TKO    :1902   1st Qu.:1.42   1st Qu.:1.77   Male  :5200  
    ##  Median :3.00   M-DEC     :  34   Median :1.71   Median :2.38                
    ##  Mean   :2.43   Overturned:  20   Mean   : Inf   Mean   : Inf                
    ##  3rd Qu.:3.00   S-DEC     : 626   3rd Qu.:2.33   3rd Qu.:3.36                
    ##  Max.   :5.00   SUB       :1058   Max.   : Inf   Max.   : Inf                
    ##                 U-DEC     :2308                                              
    ##     fight_id       Result     FighterWeight       FighterWeightClass
    ##  1      :   2   Loser :2981   Min.   :115.0   Welterweight :1007    
    ##  2      :   2   Winner:2981   1st Qu.:135.0   Lightweight  : 974    
    ##  3      :   2                 Median :155.0   Bantamweight : 792    
    ##  4      :   2                 Mean   :163.9   Featherweight: 729    
    ##  5      :   2                 3rd Qu.:185.0   Middleweight : 659    
    ##  6      :   2                 Max.   :265.0   Flyweight    : 550    
    ##  (Other):5950                                 (Other)      :1251    
    ##      REACH            SLPM            SAPM             STRA       
    ##  Min.   :58.00   Min.   : 0.00   Min.   : 0.000   Min.   :0.0000  
    ##  1st Qu.:69.00   1st Qu.: 2.68   1st Qu.: 2.630   1st Qu.:0.3900  
    ##  Median :72.00   Median : 3.44   Median : 3.220   Median :0.4400  
    ##  Mean   :71.77   Mean   : 3.53   Mean   : 3.435   Mean   :0.4411  
    ##  3rd Qu.:75.00   3rd Qu.: 4.25   3rd Qu.: 4.030   3rd Qu.:0.4900  
    ##  Max.   :84.00   Max.   :11.14   Max.   :23.330   Max.   :0.8000  
    ##  NA's   :215                                                      
    ##       STRD             TD              TDA              TDD       
    ##  Min.   :0.000   Min.   : 0.000   Min.   :0.0000   Min.   :0.000  
    ##  1st Qu.:0.510   1st Qu.: 0.560   1st Qu.:0.2600   1st Qu.:0.510  
    ##  Median :0.560   Median : 1.210   Median :0.3700   Median :0.640  
    ##  Mean   :0.552   Mean   : 1.516   Mean   :0.3735   Mean   :0.616  
    ##  3rd Qu.:0.600   3rd Qu.: 2.160   3rd Qu.:0.5000   3rd Qu.:0.760  
    ##  Max.   :0.920   Max.   :14.190   Max.   :1.0000   Max.   :1.000  
    ##                                                                   
    ##       SUBA        
    ##  Min.   : 0.0000  
    ##  1st Qu.: 0.1000  
    ##  Median : 0.4000  
    ##  Mean   : 0.5528  
    ##  3rd Qu.: 0.8000  
    ##  Max.   :12.1000  
    ## 

How many events does the dataset include?

    length(unique(df_master$Event))

    ## [1] 260

How many fights?

    length(unique(df_master$fight_id))

    ## [1] 2981

Over what time frame?

    range(sort(unique(df_master$Date)))

    ## [1] "2013-04-27" "2021-01-20"

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

    ## [1] 0.005432937

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

    ## [1] -0.02257084

What was the mean unit profit if one bet solely on the Underdog?

    mean(df_odds_short$Underdog_Unit_Profit)

    ## [1] -0.002553773

What proportion of the time does the Favorite win?

    mean(df_odds_short$Favorite_was_Winner)

    ## [1] 0.6462957

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

    ## [1] 0.004413998

    mean(df_odds_short$Total_Probability)

    ## [1] 1.004414

<br>

#### Odds performance

Add year as variable.

    df_odds_short %>%
      dplyr::mutate(
        Year = format(Date,"%Y")
      ) -> df_odds_short

Create function to graphically assess over performance as a function of
several variables. These are not inferential analyses but are instead
meant to visualize the data to observe trends for further analysis.

    gauge_over_performance = function(num_bin = 10, min_bin_size = 30, variable = NULL) {

      # get bins for Favorite
      df_odds_short$Favorite_Probability_Bin = cut(df_odds_short$Favorite_Probability, num_bin)
      # get bins for Underdog
      df_odds_short$Underdog_Probability_Bin = cut(df_odds_short$Underdog_Probability, num_bin)

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
          xlab("Expected Probability (%)")+
          ggtitle("Favorites")->gg
        print(gg)

        # plot over/under performance
        fav_perf %>%
          dplyr::filter(Size_of_Bin >= min_bin_size) %>%
          ggplot(aes(x=Mid_Bin * 100, y=Prop_of_Victory*100))+
          geom_point()+
          geom_smooth(se=F)+
          ylab("Probability of Victory (%)")+
          xlab("Expected Probability (%)")+
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
          xlab("Expected Probability (%)")+
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
          xlab("Expected Probability (%)")+
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
          xlab("Expected Probability (%)")+
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
          xlab("Expected Probability (%)")+
          ggtitle("Underdogs")->gg
        print(gg)

        # plot over/under performance
        under_perf %>%
          dplyr::filter(Size_of_Bin >= min_bin_size) %>%
          ggplot(aes(x=Mid_Bin * 100, y=Prop_of_Victory*100))+
          geom_point()+
          geom_smooth(se=F)+
          ylab("Probability of Victory (%)")+
          xlab("Expected Probability (%)")+
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
          xlab("Expected Probability (%)")+
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
          xlab("Expected Probability (%)")+
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
          xlab("Expected Probability (%)")+
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

![](/AttM/rmd_images/2021-01-21-fight_odds_analysis/unnamed-chunk-22-1.png)![](/AttM/rmd_images/2021-01-21-fight_odds_analysis/unnamed-chunk-22-2.png)![](/AttM/rmd_images/2021-01-21-fight_odds_analysis/unnamed-chunk-22-3.png)![](/AttM/rmd_images/2021-01-21-fight_odds_analysis/unnamed-chunk-22-4.png)![](/AttM/rmd_images/2021-01-21-fight_odds_analysis/unnamed-chunk-22-5.png)![](/AttM/rmd_images/2021-01-21-fight_odds_analysis/unnamed-chunk-22-6.png)

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
<td style="text-align: left;">(0.399,0.454]</td>
<td style="text-align: right;">0.0000000</td>
<td style="text-align: right;">2</td>
<td style="text-align: right;">-1.0000000</td>
<td style="text-align: right;">0.42650</td>
<td style="text-align: right;">-0.4265000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.454,0.509]</td>
<td style="text-align: right;">0.5909091</td>
<td style="text-align: right;">44</td>
<td style="text-align: right;">0.1890909</td>
<td style="text-align: right;">0.48150</td>
<td style="text-align: right;">0.1094091</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.509,0.563]</td>
<td style="text-align: right;">0.5067961</td>
<td style="text-align: right;">515</td>
<td style="text-align: right;">-0.0522913</td>
<td style="text-align: right;">0.53600</td>
<td style="text-align: right;">-0.0292039</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.563,0.617]</td>
<td style="text-align: right;">0.5442279</td>
<td style="text-align: right;">667</td>
<td style="text-align: right;">-0.0793703</td>
<td style="text-align: right;">0.59000</td>
<td style="text-align: right;">-0.0457721</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.617,0.672]</td>
<td style="text-align: right;">0.6161417</td>
<td style="text-align: right;">508</td>
<td style="text-align: right;">-0.0469488</td>
<td style="text-align: right;">0.64450</td>
<td style="text-align: right;">-0.0283583</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.672,0.726]</td>
<td style="text-align: right;">0.7114094</td>
<td style="text-align: right;">447</td>
<td style="text-align: right;">0.0165548</td>
<td style="text-align: right;">0.69900</td>
<td style="text-align: right;">0.0124094</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.726,0.78]</td>
<td style="text-align: right;">0.7794118</td>
<td style="text-align: right;">340</td>
<td style="text-align: right;">0.0352647</td>
<td style="text-align: right;">0.75300</td>
<td style="text-align: right;">0.0264118</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.78,0.835]</td>
<td style="text-align: right;">0.8333333</td>
<td style="text-align: right;">258</td>
<td style="text-align: right;">0.0327132</td>
<td style="text-align: right;">0.80750</td>
<td style="text-align: right;">0.0258333</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.835,0.889]</td>
<td style="text-align: right;">0.8918919</td>
<td style="text-align: right;">111</td>
<td style="text-align: right;">0.0374775</td>
<td style="text-align: right;">0.86200</td>
<td style="text-align: right;">0.0298919</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.889,0.944]</td>
<td style="text-align: right;">0.8918919</td>
<td style="text-align: right;">37</td>
<td style="text-align: right;">-0.0189189</td>
<td style="text-align: right;">0.91650</td>
<td style="text-align: right;">-0.0246081</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.0707,0.116]</td>
<td style="text-align: right;">0.0833333</td>
<td style="text-align: right;">36</td>
<td style="text-align: right;">-0.0986111</td>
<td style="text-align: right;">0.09335</td>
<td style="text-align: right;">-0.0100167</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.116,0.162]</td>
<td style="text-align: right;">0.1250000</td>
<td style="text-align: right;">80</td>
<td style="text-align: right;">-0.0855000</td>
<td style="text-align: right;">0.13900</td>
<td style="text-align: right;">-0.0140000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.162,0.207]</td>
<td style="text-align: right;">0.1620112</td>
<td style="text-align: right;">179</td>
<td style="text-align: right;">-0.1437989</td>
<td style="text-align: right;">0.18450</td>
<td style="text-align: right;">-0.0224888</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.207,0.252]</td>
<td style="text-align: right;">0.1849057</td>
<td style="text-align: right;">265</td>
<td style="text-align: right;">-0.1967547</td>
<td style="text-align: right;">0.22950</td>
<td style="text-align: right;">-0.0445943</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.252,0.297]</td>
<td style="text-align: right;">0.2447130</td>
<td style="text-align: right;">331</td>
<td style="text-align: right;">-0.1094260</td>
<td style="text-align: right;">0.27450</td>
<td style="text-align: right;">-0.0297870</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.297,0.343]</td>
<td style="text-align: right;">0.2972292</td>
<td style="text-align: right;">397</td>
<td style="text-align: right;">-0.0685139</td>
<td style="text-align: right;">0.32000</td>
<td style="text-align: right;">-0.0227708</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.343,0.388]</td>
<td style="text-align: right;">0.4159836</td>
<td style="text-align: right;">488</td>
<td style="text-align: right;">0.1331352</td>
<td style="text-align: right;">0.36550</td>
<td style="text-align: right;">0.0504836</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.388,0.433]</td>
<td style="text-align: right;">0.4527559</td>
<td style="text-align: right;">508</td>
<td style="text-align: right;">0.1052165</td>
<td style="text-align: right;">0.41050</td>
<td style="text-align: right;">0.0422559</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.433,0.478]</td>
<td style="text-align: right;">0.4818182</td>
<td style="text-align: right;">440</td>
<td style="text-align: right;">0.0581364</td>
<td style="text-align: right;">0.45550</td>
<td style="text-align: right;">0.0263182</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.478,0.524]</td>
<td style="text-align: right;">0.4926829</td>
<td style="text-align: right;">205</td>
<td style="text-align: right;">0.0010244</td>
<td style="text-align: right;">0.50100</td>
<td style="text-align: right;">-0.0083171</td>
<td style="text-align: left;">FALSE</td>
</tr>
</tbody>
</table>

Is there any stability across years? Need to reduce minimum bin size to
get estimates. As a result, estimates will be more noisy.

    odds_perf_by_year = gauge_over_performance(num_bin = 10, min_bin_size = 30, variable = "Year")

![](/AttM/rmd_images/2021-01-21-fight_odds_analysis/unnamed-chunk-23-1.png)![](/AttM/rmd_images/2021-01-21-fight_odds_analysis/unnamed-chunk-23-2.png)![](/AttM/rmd_images/2021-01-21-fight_odds_analysis/unnamed-chunk-23-3.png)![](/AttM/rmd_images/2021-01-21-fight_odds_analysis/unnamed-chunk-23-4.png)

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
<td style="text-align: left;">(0.399,0.454]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">0.0000000</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-1.0000000</td>
<td style="text-align: right;">0.42650</td>
<td style="text-align: right;">-0.4265000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.399,0.454]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.0000000</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-1.0000000</td>
<td style="text-align: right;">0.42650</td>
<td style="text-align: right;">-0.4265000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.454,0.509]</td>
<td style="text-align: left;">2013</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">0.9900000</td>
<td style="text-align: right;">0.48150</td>
<td style="text-align: right;">0.5185000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.454,0.509]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">0.6000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.2160000</td>
<td style="text-align: right;">0.48150</td>
<td style="text-align: right;">0.1185000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.454,0.509]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.3333333</td>
<td style="text-align: right;">3</td>
<td style="text-align: right;">-0.3066667</td>
<td style="text-align: right;">0.48150</td>
<td style="text-align: right;">-0.1481667</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.454,0.509]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">0.6666667</td>
<td style="text-align: right;">3</td>
<td style="text-align: right;">0.3500000</td>
<td style="text-align: right;">0.48150</td>
<td style="text-align: right;">0.1851667</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.454,0.509]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">2</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">0.48150</td>
<td style="text-align: right;">0.5185000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.454,0.509]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">0.4545455</td>
<td style="text-align: right;">11</td>
<td style="text-align: right;">-0.0790909</td>
<td style="text-align: right;">0.48150</td>
<td style="text-align: right;">-0.0269545</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.454,0.509]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.5384615</td>
<td style="text-align: right;">13</td>
<td style="text-align: right;">0.0769231</td>
<td style="text-align: right;">0.48150</td>
<td style="text-align: right;">0.0569615</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.454,0.509]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.8333333</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">0.6650000</td>
<td style="text-align: right;">0.48150</td>
<td style="text-align: right;">0.3518333</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.509,0.563]</td>
<td style="text-align: left;">2013</td>
<td style="text-align: right;">0.6153846</td>
<td style="text-align: right;">13</td>
<td style="text-align: right;">0.1615385</td>
<td style="text-align: right;">0.53600</td>
<td style="text-align: right;">0.0793846</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.509,0.563]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">0.4827586</td>
<td style="text-align: right;">29</td>
<td style="text-align: right;">-0.0865517</td>
<td style="text-align: right;">0.53600</td>
<td style="text-align: right;">-0.0532414</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.509,0.563]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.4788732</td>
<td style="text-align: right;">71</td>
<td style="text-align: right;">-0.1102817</td>
<td style="text-align: right;">0.53600</td>
<td style="text-align: right;">-0.0571268</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.509,0.563]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">0.5576923</td>
<td style="text-align: right;">104</td>
<td style="text-align: right;">0.0463462</td>
<td style="text-align: right;">0.53600</td>
<td style="text-align: right;">0.0216923</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.509,0.563]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">0.5692308</td>
<td style="text-align: right;">65</td>
<td style="text-align: right;">0.0593846</td>
<td style="text-align: right;">0.53600</td>
<td style="text-align: right;">0.0332308</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.509,0.563]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">0.4411765</td>
<td style="text-align: right;">68</td>
<td style="text-align: right;">-0.1735294</td>
<td style="text-align: right;">0.53600</td>
<td style="text-align: right;">-0.0948235</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.509,0.563]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.4382022</td>
<td style="text-align: right;">89</td>
<td style="text-align: right;">-0.1792135</td>
<td style="text-align: right;">0.53600</td>
<td style="text-align: right;">-0.0977978</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.509,0.563]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.5405405</td>
<td style="text-align: right;">74</td>
<td style="text-align: right;">0.0058108</td>
<td style="text-align: right;">0.53600</td>
<td style="text-align: right;">0.0045405</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.509,0.563]</td>
<td style="text-align: left;">2021</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">2</td>
<td style="text-align: right;">-0.0250000</td>
<td style="text-align: right;">0.53600</td>
<td style="text-align: right;">-0.0360000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.563,0.617]</td>
<td style="text-align: left;">2013</td>
<td style="text-align: right;">0.4210526</td>
<td style="text-align: right;">19</td>
<td style="text-align: right;">-0.2952632</td>
<td style="text-align: right;">0.59000</td>
<td style="text-align: right;">-0.1689474</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.563,0.617]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">0.5937500</td>
<td style="text-align: right;">64</td>
<td style="text-align: right;">-0.0004688</td>
<td style="text-align: right;">0.59000</td>
<td style="text-align: right;">0.0037500</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.563,0.617]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.4819277</td>
<td style="text-align: right;">83</td>
<td style="text-align: right;">-0.1860241</td>
<td style="text-align: right;">0.59000</td>
<td style="text-align: right;">-0.1080723</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.563,0.617]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">0.4128440</td>
<td style="text-align: right;">109</td>
<td style="text-align: right;">-0.3022936</td>
<td style="text-align: right;">0.59000</td>
<td style="text-align: right;">-0.1771560</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.563,0.617]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">0.6373626</td>
<td style="text-align: right;">91</td>
<td style="text-align: right;">0.0794505</td>
<td style="text-align: right;">0.59000</td>
<td style="text-align: right;">0.0473626</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.563,0.617]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">0.5510204</td>
<td style="text-align: right;">98</td>
<td style="text-align: right;">-0.0691837</td>
<td style="text-align: right;">0.59000</td>
<td style="text-align: right;">-0.0389796</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.563,0.617]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.5754717</td>
<td style="text-align: right;">106</td>
<td style="text-align: right;">-0.0234906</td>
<td style="text-align: right;">0.59000</td>
<td style="text-align: right;">-0.0145283</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.563,0.617]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.6067416</td>
<td style="text-align: right;">89</td>
<td style="text-align: right;">0.0294382</td>
<td style="text-align: right;">0.59000</td>
<td style="text-align: right;">0.0167416</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.563,0.617]</td>
<td style="text-align: left;">2021</td>
<td style="text-align: right;">0.6250000</td>
<td style="text-align: right;">8</td>
<td style="text-align: right;">0.0637500</td>
<td style="text-align: right;">0.59000</td>
<td style="text-align: right;">0.0350000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.617,0.672]</td>
<td style="text-align: left;">2013</td>
<td style="text-align: right;">0.6956522</td>
<td style="text-align: right;">23</td>
<td style="text-align: right;">0.0760870</td>
<td style="text-align: right;">0.64450</td>
<td style="text-align: right;">0.0511522</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.617,0.672]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">0.4897959</td>
<td style="text-align: right;">49</td>
<td style="text-align: right;">-0.2428571</td>
<td style="text-align: right;">0.64450</td>
<td style="text-align: right;">-0.1547041</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.617,0.672]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.5697674</td>
<td style="text-align: right;">86</td>
<td style="text-align: right;">-0.1186047</td>
<td style="text-align: right;">0.64450</td>
<td style="text-align: right;">-0.0747326</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.617,0.672]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">0.7468354</td>
<td style="text-align: right;">79</td>
<td style="text-align: right;">0.1559494</td>
<td style="text-align: right;">0.64450</td>
<td style="text-align: right;">0.1023354</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.617,0.672]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">0.5322581</td>
<td style="text-align: right;">62</td>
<td style="text-align: right;">-0.1743548</td>
<td style="text-align: right;">0.64450</td>
<td style="text-align: right;">-0.1122419</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.617,0.672]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">0.6081081</td>
<td style="text-align: right;">74</td>
<td style="text-align: right;">-0.0651351</td>
<td style="text-align: right;">0.64450</td>
<td style="text-align: right;">-0.0363919</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.617,0.672]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.6774194</td>
<td style="text-align: right;">62</td>
<td style="text-align: right;">0.0474194</td>
<td style="text-align: right;">0.64450</td>
<td style="text-align: right;">0.0329194</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.617,0.672]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.5942029</td>
<td style="text-align: right;">69</td>
<td style="text-align: right;">-0.0768116</td>
<td style="text-align: right;">0.64450</td>
<td style="text-align: right;">-0.0502971</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.617,0.672]</td>
<td style="text-align: left;">2021</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">4</td>
<td style="text-align: right;">0.5425000</td>
<td style="text-align: right;">0.64450</td>
<td style="text-align: right;">0.3555000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.672,0.726]</td>
<td style="text-align: left;">2013</td>
<td style="text-align: right;">0.8421053</td>
<td style="text-align: right;">19</td>
<td style="text-align: right;">0.1984211</td>
<td style="text-align: right;">0.69900</td>
<td style="text-align: right;">0.1431053</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.672,0.726]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">0.7741935</td>
<td style="text-align: right;">62</td>
<td style="text-align: right;">0.1109677</td>
<td style="text-align: right;">0.69900</td>
<td style="text-align: right;">0.0751935</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.672,0.726]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.6417910</td>
<td style="text-align: right;">67</td>
<td style="text-align: right;">-0.0800000</td>
<td style="text-align: right;">0.69900</td>
<td style="text-align: right;">-0.0572090</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.672,0.726]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">0.6707317</td>
<td style="text-align: right;">82</td>
<td style="text-align: right;">-0.0425610</td>
<td style="text-align: right;">0.69900</td>
<td style="text-align: right;">-0.0282683</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.672,0.726]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">0.7441860</td>
<td style="text-align: right;">43</td>
<td style="text-align: right;">0.0553488</td>
<td style="text-align: right;">0.69900</td>
<td style="text-align: right;">0.0451860</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.672,0.726]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">0.8085106</td>
<td style="text-align: right;">47</td>
<td style="text-align: right;">0.1534043</td>
<td style="text-align: right;">0.69900</td>
<td style="text-align: right;">0.1095106</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.672,0.726]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.6122449</td>
<td style="text-align: right;">49</td>
<td style="text-align: right;">-0.1232653</td>
<td style="text-align: right;">0.69900</td>
<td style="text-align: right;">-0.0867551</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.672,0.726]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.7432432</td>
<td style="text-align: right;">74</td>
<td style="text-align: right;">0.0627027</td>
<td style="text-align: right;">0.69900</td>
<td style="text-align: right;">0.0442432</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.672,0.726]</td>
<td style="text-align: left;">2021</td>
<td style="text-align: right;">0.2500000</td>
<td style="text-align: right;">4</td>
<td style="text-align: right;">-0.6475000</td>
<td style="text-align: right;">0.69900</td>
<td style="text-align: right;">-0.4490000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.726,0.78]</td>
<td style="text-align: left;">2013</td>
<td style="text-align: right;">0.9333333</td>
<td style="text-align: right;">15</td>
<td style="text-align: right;">0.2420000</td>
<td style="text-align: right;">0.75300</td>
<td style="text-align: right;">0.1803333</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.726,0.78]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">0.7804878</td>
<td style="text-align: right;">41</td>
<td style="text-align: right;">0.0360976</td>
<td style="text-align: right;">0.75300</td>
<td style="text-align: right;">0.0274878</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.726,0.78]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.7777778</td>
<td style="text-align: right;">36</td>
<td style="text-align: right;">0.0286111</td>
<td style="text-align: right;">0.75300</td>
<td style="text-align: right;">0.0247778</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.726,0.78]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">0.8392857</td>
<td style="text-align: right;">56</td>
<td style="text-align: right;">0.1148214</td>
<td style="text-align: right;">0.75300</td>
<td style="text-align: right;">0.0862857</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.726,0.78]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">0.8000000</td>
<td style="text-align: right;">55</td>
<td style="text-align: right;">0.0647273</td>
<td style="text-align: right;">0.75300</td>
<td style="text-align: right;">0.0470000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.726,0.78]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">0.7659574</td>
<td style="text-align: right;">47</td>
<td style="text-align: right;">0.0165957</td>
<td style="text-align: right;">0.75300</td>
<td style="text-align: right;">0.0129574</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.726,0.78]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.7750000</td>
<td style="text-align: right;">40</td>
<td style="text-align: right;">0.0275000</td>
<td style="text-align: right;">0.75300</td>
<td style="text-align: right;">0.0220000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.726,0.78]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.6595745</td>
<td style="text-align: right;">47</td>
<td style="text-align: right;">-0.1210638</td>
<td style="text-align: right;">0.75300</td>
<td style="text-align: right;">-0.0934255</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.726,0.78]</td>
<td style="text-align: left;">2021</td>
<td style="text-align: right;">0.6666667</td>
<td style="text-align: right;">3</td>
<td style="text-align: right;">-0.1100000</td>
<td style="text-align: right;">0.75300</td>
<td style="text-align: right;">-0.0863333</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.78,0.835]</td>
<td style="text-align: left;">2013</td>
<td style="text-align: right;">0.8000000</td>
<td style="text-align: right;">15</td>
<td style="text-align: right;">-0.0106667</td>
<td style="text-align: right;">0.80750</td>
<td style="text-align: right;">-0.0075000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.78,0.835]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">0.8333333</td>
<td style="text-align: right;">30</td>
<td style="text-align: right;">0.0333333</td>
<td style="text-align: right;">0.80750</td>
<td style="text-align: right;">0.0258333</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.78,0.835]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.7333333</td>
<td style="text-align: right;">60</td>
<td style="text-align: right;">-0.0905000</td>
<td style="text-align: right;">0.80750</td>
<td style="text-align: right;">-0.0741667</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.78,0.835]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">0.8484848</td>
<td style="text-align: right;">33</td>
<td style="text-align: right;">0.0536364</td>
<td style="text-align: right;">0.80750</td>
<td style="text-align: right;">0.0409848</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.78,0.835]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">0.8437500</td>
<td style="text-align: right;">32</td>
<td style="text-align: right;">0.0496875</td>
<td style="text-align: right;">0.80750</td>
<td style="text-align: right;">0.0362500</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.78,0.835]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">0.8518519</td>
<td style="text-align: right;">27</td>
<td style="text-align: right;">0.0448148</td>
<td style="text-align: right;">0.80750</td>
<td style="text-align: right;">0.0443519</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.78,0.835]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.8846154</td>
<td style="text-align: right;">26</td>
<td style="text-align: right;">0.0961538</td>
<td style="text-align: right;">0.80750</td>
<td style="text-align: right;">0.0771154</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.78,0.835]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.9375000</td>
<td style="text-align: right;">32</td>
<td style="text-align: right;">0.1656250</td>
<td style="text-align: right;">0.80750</td>
<td style="text-align: right;">0.1300000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.78,0.835]</td>
<td style="text-align: left;">2021</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">3</td>
<td style="text-align: right;">0.2200000</td>
<td style="text-align: right;">0.80750</td>
<td style="text-align: right;">0.1925000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.835,0.889]</td>
<td style="text-align: left;">2013</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">8</td>
<td style="text-align: right;">0.1562500</td>
<td style="text-align: right;">0.86200</td>
<td style="text-align: right;">0.1380000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.835,0.889]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">0.8095238</td>
<td style="text-align: right;">21</td>
<td style="text-align: right;">-0.0552381</td>
<td style="text-align: right;">0.86200</td>
<td style="text-align: right;">-0.0524762</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.835,0.889]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.8888889</td>
<td style="text-align: right;">27</td>
<td style="text-align: right;">0.0333333</td>
<td style="text-align: right;">0.86200</td>
<td style="text-align: right;">0.0268889</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.835,0.889]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">0.7777778</td>
<td style="text-align: right;">9</td>
<td style="text-align: right;">-0.0977778</td>
<td style="text-align: right;">0.86200</td>
<td style="text-align: right;">-0.0842222</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.835,0.889]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">0.8571429</td>
<td style="text-align: right;">14</td>
<td style="text-align: right;">0.0014286</td>
<td style="text-align: right;">0.86200</td>
<td style="text-align: right;">-0.0048571</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.835,0.889]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">0.9411765</td>
<td style="text-align: right;">17</td>
<td style="text-align: right;">0.0970588</td>
<td style="text-align: right;">0.86200</td>
<td style="text-align: right;">0.0791765</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.835,0.889]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">8</td>
<td style="text-align: right;">0.1612500</td>
<td style="text-align: right;">0.86200</td>
<td style="text-align: right;">0.1380000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.835,0.889]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">0.1557143</td>
<td style="text-align: right;">0.86200</td>
<td style="text-align: right;">0.1380000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.889,0.944]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">4</td>
<td style="text-align: right;">0.0900000</td>
<td style="text-align: right;">0.91650</td>
<td style="text-align: right;">0.0835000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.889,0.944]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.9000000</td>
<td style="text-align: right;">10</td>
<td style="text-align: right;">-0.0160000</td>
<td style="text-align: right;">0.91650</td>
<td style="text-align: right;">-0.0165000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.889,0.944]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">4</td>
<td style="text-align: right;">0.1000000</td>
<td style="text-align: right;">0.91650</td>
<td style="text-align: right;">0.0835000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.889,0.944]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">3</td>
<td style="text-align: right;">0.1100000</td>
<td style="text-align: right;">0.91650</td>
<td style="text-align: right;">0.0835000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.889,0.944]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">0.1100000</td>
<td style="text-align: right;">0.91650</td>
<td style="text-align: right;">0.0835000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.889,0.944]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.8000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-0.1160000</td>
<td style="text-align: right;">0.91650</td>
<td style="text-align: right;">-0.1165000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.889,0.944]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.6000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-0.3420000</td>
<td style="text-align: right;">0.91650</td>
<td style="text-align: right;">-0.3165000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.0707,0.116]</td>
<td style="text-align: left;">2013</td>
<td style="text-align: right;">0.0000000</td>
<td style="text-align: right;">2</td>
<td style="text-align: right;">-1.0000000</td>
<td style="text-align: right;">0.09335</td>
<td style="text-align: right;">-0.0933500</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.0707,0.116]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">0.0000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-1.0000000</td>
<td style="text-align: right;">0.09335</td>
<td style="text-align: right;">-0.0933500</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.0707,0.116]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.1428571</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">0.8557143</td>
<td style="text-align: right;">0.09335</td>
<td style="text-align: right;">0.0495071</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.0707,0.116]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">0.0000000</td>
<td style="text-align: right;">4</td>
<td style="text-align: right;">-1.0000000</td>
<td style="text-align: right;">0.09335</td>
<td style="text-align: right;">-0.0933500</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.0707,0.116]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">0.0000000</td>
<td style="text-align: right;">4</td>
<td style="text-align: right;">-1.0000000</td>
<td style="text-align: right;">0.09335</td>
<td style="text-align: right;">-0.0933500</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.0707,0.116]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">0.0000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-1.0000000</td>
<td style="text-align: right;">0.09335</td>
<td style="text-align: right;">-0.0933500</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.0707,0.116]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.2000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.7500000</td>
<td style="text-align: right;">0.09335</td>
<td style="text-align: right;">0.1066500</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.0707,0.116]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.2500000</td>
<td style="text-align: right;">4</td>
<td style="text-align: right;">1.6775000</td>
<td style="text-align: right;">0.09335</td>
<td style="text-align: right;">0.1566500</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.116,0.162]</td>
<td style="text-align: left;">2013</td>
<td style="text-align: right;">0.0000000</td>
<td style="text-align: right;">4</td>
<td style="text-align: right;">-1.0000000</td>
<td style="text-align: right;">0.13900</td>
<td style="text-align: right;">-0.1390000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.116,0.162]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">0.2000000</td>
<td style="text-align: right;">15</td>
<td style="text-align: right;">0.5980000</td>
<td style="text-align: right;">0.13900</td>
<td style="text-align: right;">0.0610000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.116,0.162]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.1363636</td>
<td style="text-align: right;">22</td>
<td style="text-align: right;">-0.0345455</td>
<td style="text-align: right;">0.13900</td>
<td style="text-align: right;">-0.0026364</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.116,0.162]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">0.1666667</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">0.0666667</td>
<td style="text-align: right;">0.13900</td>
<td style="text-align: right;">0.0276667</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.116,0.162]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">0.2500000</td>
<td style="text-align: right;">8</td>
<td style="text-align: right;">0.6912500</td>
<td style="text-align: right;">0.13900</td>
<td style="text-align: right;">0.1110000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.116,0.162]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">0.0000000</td>
<td style="text-align: right;">10</td>
<td style="text-align: right;">-1.0000000</td>
<td style="text-align: right;">0.13900</td>
<td style="text-align: right;">-0.1390000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.116,0.162]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.0000000</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">-1.0000000</td>
<td style="text-align: right;">0.13900</td>
<td style="text-align: right;">-0.1390000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.116,0.162]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.1250000</td>
<td style="text-align: right;">8</td>
<td style="text-align: right;">0.0025000</td>
<td style="text-align: right;">0.13900</td>
<td style="text-align: right;">-0.0140000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.162,0.207]</td>
<td style="text-align: left;">2013</td>
<td style="text-align: right;">0.1818182</td>
<td style="text-align: right;">11</td>
<td style="text-align: right;">-0.0409091</td>
<td style="text-align: right;">0.18450</td>
<td style="text-align: right;">-0.0026818</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.162,0.207]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">0.1304348</td>
<td style="text-align: right;">23</td>
<td style="text-align: right;">-0.3086957</td>
<td style="text-align: right;">0.18450</td>
<td style="text-align: right;">-0.0540652</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.162,0.207]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.1842105</td>
<td style="text-align: right;">38</td>
<td style="text-align: right;">-0.0313158</td>
<td style="text-align: right;">0.18450</td>
<td style="text-align: right;">-0.0002895</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.162,0.207]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">0.2400000</td>
<td style="text-align: right;">25</td>
<td style="text-align: right;">0.2700000</td>
<td style="text-align: right;">0.18450</td>
<td style="text-align: right;">0.0555000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.162,0.207]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">0.2380952</td>
<td style="text-align: right;">21</td>
<td style="text-align: right;">0.2714286</td>
<td style="text-align: right;">0.18450</td>
<td style="text-align: right;">0.0535952</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.162,0.207]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">0.1071429</td>
<td style="text-align: right;">28</td>
<td style="text-align: right;">-0.4175000</td>
<td style="text-align: right;">0.18450</td>
<td style="text-align: right;">-0.0773571</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.162,0.207]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.1176471</td>
<td style="text-align: right;">17</td>
<td style="text-align: right;">-0.4182353</td>
<td style="text-align: right;">0.18450</td>
<td style="text-align: right;">-0.0668529</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.162,0.207]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.0769231</td>
<td style="text-align: right;">13</td>
<td style="text-align: right;">-0.5884615</td>
<td style="text-align: right;">0.18450</td>
<td style="text-align: right;">-0.1075769</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.162,0.207]</td>
<td style="text-align: left;">2021</td>
<td style="text-align: right;">0.0000000</td>
<td style="text-align: right;">3</td>
<td style="text-align: right;">-1.0000000</td>
<td style="text-align: right;">0.18450</td>
<td style="text-align: right;">-0.1845000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.207,0.252]</td>
<td style="text-align: left;">2013</td>
<td style="text-align: right;">0.0666667</td>
<td style="text-align: right;">15</td>
<td style="text-align: right;">-0.6900000</td>
<td style="text-align: right;">0.22950</td>
<td style="text-align: right;">-0.1628333</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.207,0.252]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">0.2800000</td>
<td style="text-align: right;">25</td>
<td style="text-align: right;">0.2428000</td>
<td style="text-align: right;">0.22950</td>
<td style="text-align: right;">0.0505000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.207,0.252]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.2340426</td>
<td style="text-align: right;">47</td>
<td style="text-align: right;">0.0348936</td>
<td style="text-align: right;">0.22950</td>
<td style="text-align: right;">0.0045426</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.207,0.252]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">0.1081081</td>
<td style="text-align: right;">37</td>
<td style="text-align: right;">-0.5594595</td>
<td style="text-align: right;">0.22950</td>
<td style="text-align: right;">-0.1213919</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.207,0.252]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">0.1282051</td>
<td style="text-align: right;">39</td>
<td style="text-align: right;">-0.4533333</td>
<td style="text-align: right;">0.22950</td>
<td style="text-align: right;">-0.1012949</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.207,0.252]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">0.2941176</td>
<td style="text-align: right;">34</td>
<td style="text-align: right;">0.2764706</td>
<td style="text-align: right;">0.22950</td>
<td style="text-align: right;">0.0646176</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.207,0.252]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.1875000</td>
<td style="text-align: right;">32</td>
<td style="text-align: right;">-0.1734375</td>
<td style="text-align: right;">0.22950</td>
<td style="text-align: right;">-0.0420000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.207,0.252]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.1388889</td>
<td style="text-align: right;">36</td>
<td style="text-align: right;">-0.4158333</td>
<td style="text-align: right;">0.22950</td>
<td style="text-align: right;">-0.0906111</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.252,0.297]</td>
<td style="text-align: left;">2013</td>
<td style="text-align: right;">0.1111111</td>
<td style="text-align: right;">18</td>
<td style="text-align: right;">-0.5966667</td>
<td style="text-align: right;">0.27450</td>
<td style="text-align: right;">-0.1633889</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.252,0.297]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">0.1632653</td>
<td style="text-align: right;">49</td>
<td style="text-align: right;">-0.4000000</td>
<td style="text-align: right;">0.27450</td>
<td style="text-align: right;">-0.1112347</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.252,0.297]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.3823529</td>
<td style="text-align: right;">34</td>
<td style="text-align: right;">0.3729412</td>
<td style="text-align: right;">0.27450</td>
<td style="text-align: right;">0.1078529</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.252,0.297]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">0.2195122</td>
<td style="text-align: right;">41</td>
<td style="text-align: right;">-0.2090244</td>
<td style="text-align: right;">0.27450</td>
<td style="text-align: right;">-0.0549878</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.252,0.297]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">0.2456140</td>
<td style="text-align: right;">57</td>
<td style="text-align: right;">-0.1047368</td>
<td style="text-align: right;">0.27450</td>
<td style="text-align: right;">-0.0288860</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.252,0.297]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">0.1707317</td>
<td style="text-align: right;">41</td>
<td style="text-align: right;">-0.3646341</td>
<td style="text-align: right;">0.27450</td>
<td style="text-align: right;">-0.1037683</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.252,0.297]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.3142857</td>
<td style="text-align: right;">35</td>
<td style="text-align: right;">0.1240000</td>
<td style="text-align: right;">0.27450</td>
<td style="text-align: right;">0.0397857</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.252,0.297]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.3018868</td>
<td style="text-align: right;">53</td>
<td style="text-align: right;">0.1073585</td>
<td style="text-align: right;">0.27450</td>
<td style="text-align: right;">0.0273868</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.252,0.297]</td>
<td style="text-align: left;">2021</td>
<td style="text-align: right;">0.3333333</td>
<td style="text-align: right;">3</td>
<td style="text-align: right;">0.3000000</td>
<td style="text-align: right;">0.27450</td>
<td style="text-align: right;">0.0588333</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.297,0.343]</td>
<td style="text-align: left;">2013</td>
<td style="text-align: right;">0.1764706</td>
<td style="text-align: right;">17</td>
<td style="text-align: right;">-0.4482353</td>
<td style="text-align: right;">0.32000</td>
<td style="text-align: right;">-0.1435294</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.297,0.343]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">0.3157895</td>
<td style="text-align: right;">57</td>
<td style="text-align: right;">-0.0180702</td>
<td style="text-align: right;">0.32000</td>
<td style="text-align: right;">-0.0042105</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.297,0.343]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.3548387</td>
<td style="text-align: right;">62</td>
<td style="text-align: right;">0.1027419</td>
<td style="text-align: right;">0.32000</td>
<td style="text-align: right;">0.0348387</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.297,0.343]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">0.3013699</td>
<td style="text-align: right;">73</td>
<td style="text-align: right;">-0.0502740</td>
<td style="text-align: right;">0.32000</td>
<td style="text-align: right;">-0.0186301</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.297,0.343]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">0.3103448</td>
<td style="text-align: right;">29</td>
<td style="text-align: right;">-0.0465517</td>
<td style="text-align: right;">0.32000</td>
<td style="text-align: right;">-0.0096552</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.297,0.343]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">0.1764706</td>
<td style="text-align: right;">51</td>
<td style="text-align: right;">-0.4449020</td>
<td style="text-align: right;">0.32000</td>
<td style="text-align: right;">-0.1435294</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.297,0.343]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.3333333</td>
<td style="text-align: right;">45</td>
<td style="text-align: right;">0.0544444</td>
<td style="text-align: right;">0.32000</td>
<td style="text-align: right;">0.0133333</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.297,0.343]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.2881356</td>
<td style="text-align: right;">59</td>
<td style="text-align: right;">-0.0894915</td>
<td style="text-align: right;">0.32000</td>
<td style="text-align: right;">-0.0318644</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.297,0.343]</td>
<td style="text-align: left;">2021</td>
<td style="text-align: right;">0.7500000</td>
<td style="text-align: right;">4</td>
<td style="text-align: right;">1.4050000</td>
<td style="text-align: right;">0.32000</td>
<td style="text-align: right;">0.4300000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.343,0.388]</td>
<td style="text-align: left;">2013</td>
<td style="text-align: right;">0.4736842</td>
<td style="text-align: right;">19</td>
<td style="text-align: right;">0.2921053</td>
<td style="text-align: right;">0.36550</td>
<td style="text-align: right;">0.1081842</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.343,0.388]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">42</td>
<td style="text-align: right;">0.3676190</td>
<td style="text-align: right;">0.36550</td>
<td style="text-align: right;">0.1345000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.343,0.388]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.4415584</td>
<td style="text-align: right;">77</td>
<td style="text-align: right;">0.1953247</td>
<td style="text-align: right;">0.36550</td>
<td style="text-align: right;">0.0760584</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.343,0.388]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">0.3544304</td>
<td style="text-align: right;">79</td>
<td style="text-align: right;">-0.0413924</td>
<td style="text-align: right;">0.36550</td>
<td style="text-align: right;">-0.0110696</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.343,0.388]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">0.4590164</td>
<td style="text-align: right;">61</td>
<td style="text-align: right;">0.2490164</td>
<td style="text-align: right;">0.36550</td>
<td style="text-align: right;">0.0935164</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.343,0.388]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">0.4246575</td>
<td style="text-align: right;">73</td>
<td style="text-align: right;">0.1571233</td>
<td style="text-align: right;">0.36550</td>
<td style="text-align: right;">0.0591575</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.343,0.388]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.3714286</td>
<td style="text-align: right;">70</td>
<td style="text-align: right;">0.0131429</td>
<td style="text-align: right;">0.36550</td>
<td style="text-align: right;">0.0059286</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.343,0.388]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.4126984</td>
<td style="text-align: right;">63</td>
<td style="text-align: right;">0.1369841</td>
<td style="text-align: right;">0.36550</td>
<td style="text-align: right;">0.0471984</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.343,0.388]</td>
<td style="text-align: left;">2021</td>
<td style="text-align: right;">0.0000000</td>
<td style="text-align: right;">4</td>
<td style="text-align: right;">-1.0000000</td>
<td style="text-align: right;">0.36550</td>
<td style="text-align: right;">-0.3655000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.388,0.433]</td>
<td style="text-align: left;">2013</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">14</td>
<td style="text-align: right;">0.2214286</td>
<td style="text-align: right;">0.41050</td>
<td style="text-align: right;">0.0895000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.388,0.433]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">0.4375000</td>
<td style="text-align: right;">48</td>
<td style="text-align: right;">0.0658333</td>
<td style="text-align: right;">0.41050</td>
<td style="text-align: right;">0.0270000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.388,0.433]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.5285714</td>
<td style="text-align: right;">70</td>
<td style="text-align: right;">0.2848571</td>
<td style="text-align: right;">0.41050</td>
<td style="text-align: right;">0.1180714</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.388,0.433]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">0.5058824</td>
<td style="text-align: right;">85</td>
<td style="text-align: right;">0.2362353</td>
<td style="text-align: right;">0.41050</td>
<td style="text-align: right;">0.0953824</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.388,0.433]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">0.3148148</td>
<td style="text-align: right;">54</td>
<td style="text-align: right;">-0.2311111</td>
<td style="text-align: right;">0.41050</td>
<td style="text-align: right;">-0.0956852</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.388,0.433]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">0.4931507</td>
<td style="text-align: right;">73</td>
<td style="text-align: right;">0.2231507</td>
<td style="text-align: right;">0.41050</td>
<td style="text-align: right;">0.0826507</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.388,0.433]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.4534884</td>
<td style="text-align: right;">86</td>
<td style="text-align: right;">0.1020930</td>
<td style="text-align: right;">0.41050</td>
<td style="text-align: right;">0.0429884</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.388,0.433]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.3888889</td>
<td style="text-align: right;">72</td>
<td style="text-align: right;">-0.0576389</td>
<td style="text-align: right;">0.41050</td>
<td style="text-align: right;">-0.0216111</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.388,0.433]</td>
<td style="text-align: left;">2021</td>
<td style="text-align: right;">0.3333333</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">-0.2116667</td>
<td style="text-align: right;">0.41050</td>
<td style="text-align: right;">-0.0771667</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.433,0.478]</td>
<td style="text-align: left;">2013</td>
<td style="text-align: right;">0.5555556</td>
<td style="text-align: right;">9</td>
<td style="text-align: right;">0.2155556</td>
<td style="text-align: right;">0.45550</td>
<td style="text-align: right;">0.1000556</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.433,0.478]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">28</td>
<td style="text-align: right;">0.1157143</td>
<td style="text-align: right;">0.45550</td>
<td style="text-align: right;">0.0445000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.433,0.478]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.5084746</td>
<td style="text-align: right;">59</td>
<td style="text-align: right;">0.1169492</td>
<td style="text-align: right;">0.45550</td>
<td style="text-align: right;">0.0529746</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.433,0.478]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">0.4444444</td>
<td style="text-align: right;">81</td>
<td style="text-align: right;">-0.0193827</td>
<td style="text-align: right;">0.45550</td>
<td style="text-align: right;">-0.0110556</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.433,0.478]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">0.4202899</td>
<td style="text-align: right;">69</td>
<td style="text-align: right;">-0.0762319</td>
<td style="text-align: right;">0.45550</td>
<td style="text-align: right;">-0.0352101</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.433,0.478]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">0.5762712</td>
<td style="text-align: right;">59</td>
<td style="text-align: right;">0.2574576</td>
<td style="text-align: right;">0.45550</td>
<td style="text-align: right;">0.1207712</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.433,0.478]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.5362319</td>
<td style="text-align: right;">69</td>
<td style="text-align: right;">0.1652174</td>
<td style="text-align: right;">0.45550</td>
<td style="text-align: right;">0.0807319</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.433,0.478]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.3968254</td>
<td style="text-align: right;">63</td>
<td style="text-align: right;">-0.1228571</td>
<td style="text-align: right;">0.45550</td>
<td style="text-align: right;">-0.0586746</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.433,0.478]</td>
<td style="text-align: left;">2021</td>
<td style="text-align: right;">0.6666667</td>
<td style="text-align: right;">3</td>
<td style="text-align: right;">0.4933333</td>
<td style="text-align: right;">0.45550</td>
<td style="text-align: right;">0.2111667</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.478,0.524]</td>
<td style="text-align: left;">2013</td>
<td style="text-align: right;">0.2500000</td>
<td style="text-align: right;">4</td>
<td style="text-align: right;">-0.5000000</td>
<td style="text-align: right;">0.50100</td>
<td style="text-align: right;">-0.2510000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.478,0.524]</td>
<td style="text-align: left;">2014</td>
<td style="text-align: right;">0.3846154</td>
<td style="text-align: right;">13</td>
<td style="text-align: right;">-0.2246154</td>
<td style="text-align: right;">0.50100</td>
<td style="text-align: right;">-0.1163846</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.478,0.524]</td>
<td style="text-align: left;">2015</td>
<td style="text-align: right;">0.4814815</td>
<td style="text-align: right;">27</td>
<td style="text-align: right;">-0.0166667</td>
<td style="text-align: right;">0.50100</td>
<td style="text-align: right;">-0.0195185</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.478,0.524]</td>
<td style="text-align: left;">2016</td>
<td style="text-align: right;">0.5208333</td>
<td style="text-align: right;">48</td>
<td style="text-align: right;">0.0610417</td>
<td style="text-align: right;">0.50100</td>
<td style="text-align: right;">0.0198333</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.478,0.524]</td>
<td style="text-align: left;">2017</td>
<td style="text-align: right;">0.4000000</td>
<td style="text-align: right;">25</td>
<td style="text-align: right;">-0.1856000</td>
<td style="text-align: right;">0.50100</td>
<td style="text-align: right;">-0.1010000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.478,0.524]</td>
<td style="text-align: left;">2018</td>
<td style="text-align: right;">0.5909091</td>
<td style="text-align: right;">22</td>
<td style="text-align: right;">0.2040909</td>
<td style="text-align: right;">0.50100</td>
<td style="text-align: right;">0.0899091</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.478,0.524]</td>
<td style="text-align: left;">2019</td>
<td style="text-align: right;">0.5151515</td>
<td style="text-align: right;">33</td>
<td style="text-align: right;">0.0424242</td>
<td style="text-align: right;">0.50100</td>
<td style="text-align: right;">0.0141515</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.478,0.524]</td>
<td style="text-align: left;">2020</td>
<td style="text-align: right;">0.5312500</td>
<td style="text-align: right;">32</td>
<td style="text-align: right;">0.0750000</td>
<td style="text-align: right;">0.50100</td>
<td style="text-align: right;">0.0302500</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.478,0.524]</td>
<td style="text-align: left;">2021</td>
<td style="text-align: right;">0.0000000</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-1.0000000</td>
<td style="text-align: right;">0.50100</td>
<td style="text-align: right;">-0.5010000</td>
<td style="text-align: left;">FALSE</td>
</tr>
</tbody>
</table>

Does the method of victory affect the relationship between odds and
outcome? Reduce number of bins (compared to Year comparison above) to
stabilize estimates. Graphs do not tell whole story due to number of
data points available across bins.

    odds_perf_by_method = gauge_over_performance(num_bin = 5, min_bin_size = 30, variable = "Method")

![](/AttM/rmd_images/2021-01-21-fight_odds_analysis/unnamed-chunk-24-1.png)![](/AttM/rmd_images/2021-01-21-fight_odds_analysis/unnamed-chunk-24-2.png)![](/AttM/rmd_images/2021-01-21-fight_odds_analysis/unnamed-chunk-24-3.png)![](/AttM/rmd_images/2021-01-21-fight_odds_analysis/unnamed-chunk-24-4.png)

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
<td style="text-align: left;">(0.399,0.509]</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">14</td>
<td style="text-align: right;">0.0171429</td>
<td style="text-align: right;">0.45400</td>
<td style="text-align: right;">0.0460000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.399,0.509]</td>
<td style="text-align: left;">S-DEC</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">2</td>
<td style="text-align: right;">0.0000000</td>
<td style="text-align: right;">0.45400</td>
<td style="text-align: right;">0.0460000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.399,0.509]</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">0.7142857</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">0.4200000</td>
<td style="text-align: right;">0.45400</td>
<td style="text-align: right;">0.2602857</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.399,0.509]</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">0.5652174</td>
<td style="text-align: right;">23</td>
<td style="text-align: right;">0.1365217</td>
<td style="text-align: right;">0.45400</td>
<td style="text-align: right;">0.1112174</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.509,0.617]</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">0.5299145</td>
<td style="text-align: right;">351</td>
<td style="text-align: right;">-0.0627635</td>
<td style="text-align: right;">0.56300</td>
<td style="text-align: right;">-0.0330855</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.509,0.617]</td>
<td style="text-align: left;">M-DEC</td>
<td style="text-align: right;">0.6363636</td>
<td style="text-align: right;">11</td>
<td style="text-align: right;">0.1227273</td>
<td style="text-align: right;">0.56300</td>
<td style="text-align: right;">0.0733636</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.509,0.617]</td>
<td style="text-align: left;">S-DEC</td>
<td style="text-align: right;">0.4171779</td>
<td style="text-align: right;">163</td>
<td style="text-align: right;">-0.2595092</td>
<td style="text-align: right;">0.56300</td>
<td style="text-align: right;">-0.1458221</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.509,0.617]</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">0.5404040</td>
<td style="text-align: right;">198</td>
<td style="text-align: right;">-0.0480303</td>
<td style="text-align: right;">0.56300</td>
<td style="text-align: right;">-0.0225960</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.509,0.617]</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">0.5577342</td>
<td style="text-align: right;">459</td>
<td style="text-align: right;">-0.0160784</td>
<td style="text-align: right;">0.56300</td>
<td style="text-align: right;">-0.0052658</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.617,0.726]</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">0.6722408</td>
<td style="text-align: right;">299</td>
<td style="text-align: right;">-0.0012375</td>
<td style="text-align: right;">0.67150</td>
<td style="text-align: right;">0.0007408</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.617,0.726]</td>
<td style="text-align: left;">M-DEC</td>
<td style="text-align: right;">0.6000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-0.0580000</td>
<td style="text-align: right;">0.67150</td>
<td style="text-align: right;">-0.0715000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.617,0.726]</td>
<td style="text-align: left;">S-DEC</td>
<td style="text-align: right;">0.5514019</td>
<td style="text-align: right;">107</td>
<td style="text-align: right;">-0.1804673</td>
<td style="text-align: right;">0.67150</td>
<td style="text-align: right;">-0.1200981</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.617,0.726]</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">0.5962733</td>
<td style="text-align: right;">161</td>
<td style="text-align: right;">-0.1140994</td>
<td style="text-align: right;">0.67150</td>
<td style="text-align: right;">-0.0752267</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.617,0.726]</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">0.7101828</td>
<td style="text-align: right;">383</td>
<td style="text-align: right;">0.0571540</td>
<td style="text-align: right;">0.67150</td>
<td style="text-align: right;">0.0386828</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.726,0.835]</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">0.7809524</td>
<td style="text-align: right;">210</td>
<td style="text-align: right;">0.0050000</td>
<td style="text-align: right;">0.78050</td>
<td style="text-align: right;">0.0004524</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.726,0.835]</td>
<td style="text-align: left;">M-DEC</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">0.2600000</td>
<td style="text-align: right;">0.78050</td>
<td style="text-align: right;">0.2195000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.726,0.835]</td>
<td style="text-align: left;">S-DEC</td>
<td style="text-align: right;">0.3611111</td>
<td style="text-align: right;">36</td>
<td style="text-align: right;">-0.5330556</td>
<td style="text-align: right;">0.78050</td>
<td style="text-align: right;">-0.4193889</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.726,0.835]</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">0.8319328</td>
<td style="text-align: right;">119</td>
<td style="text-align: right;">0.0673950</td>
<td style="text-align: right;">0.78050</td>
<td style="text-align: right;">0.0514328</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.726,0.835]</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">0.8750000</td>
<td style="text-align: right;">232</td>
<td style="text-align: right;">0.1305603</td>
<td style="text-align: right;">0.78050</td>
<td style="text-align: right;">0.0945000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.835,0.944]</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">0.8437500</td>
<td style="text-align: right;">64</td>
<td style="text-align: right;">-0.0350000</td>
<td style="text-align: right;">0.88950</td>
<td style="text-align: right;">-0.0457500</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.835,0.944]</td>
<td style="text-align: left;">S-DEC</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">3</td>
<td style="text-align: right;">0.1533333</td>
<td style="text-align: right;">0.88950</td>
<td style="text-align: right;">0.1105000</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.835,0.944]</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">0.9142857</td>
<td style="text-align: right;">35</td>
<td style="text-align: right;">0.0448571</td>
<td style="text-align: right;">0.88950</td>
<td style="text-align: right;">0.0247857</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.835,0.944]</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">0.9347826</td>
<td style="text-align: right;">46</td>
<td style="text-align: right;">0.0797826</td>
<td style="text-align: right;">0.88950</td>
<td style="text-align: right;">0.0452826</td>
<td style="text-align: left;">TRUE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.0707,0.162]</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">0.2000000</td>
<td style="text-align: right;">50</td>
<td style="text-align: right;">0.6552000</td>
<td style="text-align: right;">0.11635</td>
<td style="text-align: right;">0.0836500</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.0707,0.162]</td>
<td style="text-align: left;">S-DEC</td>
<td style="text-align: right;">0.0000000</td>
<td style="text-align: right;">3</td>
<td style="text-align: right;">-1.0000000</td>
<td style="text-align: right;">0.11635</td>
<td style="text-align: right;">-0.1163500</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.0707,0.162]</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">0.0400000</td>
<td style="text-align: right;">25</td>
<td style="text-align: right;">-0.7144000</td>
<td style="text-align: right;">0.11635</td>
<td style="text-align: right;">-0.0763500</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.0707,0.162]</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">0.0526316</td>
<td style="text-align: right;">38</td>
<td style="text-align: right;">-0.5865789</td>
<td style="text-align: right;">0.11635</td>
<td style="text-align: right;">-0.0637184</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.162,0.252]</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">0.1962025</td>
<td style="text-align: right;">158</td>
<td style="text-align: right;">-0.0868987</td>
<td style="text-align: right;">0.20700</td>
<td style="text-align: right;">-0.0107975</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.162,0.252]</td>
<td style="text-align: left;">M-DEC</td>
<td style="text-align: right;">0.0000000</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-1.0000000</td>
<td style="text-align: right;">0.20700</td>
<td style="text-align: right;">-0.2070000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.162,0.252]</td>
<td style="text-align: left;">S-DEC</td>
<td style="text-align: right;">0.5600000</td>
<td style="text-align: right;">25</td>
<td style="text-align: right;">1.5880000</td>
<td style="text-align: right;">0.20700</td>
<td style="text-align: right;">0.3530000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.162,0.252]</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">0.1515152</td>
<td style="text-align: right;">99</td>
<td style="text-align: right;">-0.2433333</td>
<td style="text-align: right;">0.20700</td>
<td style="text-align: right;">-0.0554848</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.162,0.252]</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">0.1118012</td>
<td style="text-align: right;">161</td>
<td style="text-align: right;">-0.4891925</td>
<td style="text-align: right;">0.20700</td>
<td style="text-align: right;">-0.0951988</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.252,0.343]</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">0.2761506</td>
<td style="text-align: right;">239</td>
<td style="text-align: right;">-0.0758996</td>
<td style="text-align: right;">0.29750</td>
<td style="text-align: right;">-0.0213494</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.252,0.343]</td>
<td style="text-align: left;">M-DEC</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">2.0300000</td>
<td style="text-align: right;">0.29750</td>
<td style="text-align: right;">0.7025000</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.252,0.343]</td>
<td style="text-align: left;">S-DEC</td>
<td style="text-align: right;">0.4637681</td>
<td style="text-align: right;">69</td>
<td style="text-align: right;">0.5353623</td>
<td style="text-align: right;">0.29750</td>
<td style="text-align: right;">0.1662681</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.252,0.343]</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">0.2991453</td>
<td style="text-align: right;">117</td>
<td style="text-align: right;">0.0038462</td>
<td style="text-align: right;">0.29750</td>
<td style="text-align: right;">0.0016453</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.252,0.343]</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">0.2152318</td>
<td style="text-align: right;">302</td>
<td style="text-align: right;">-0.2804636</td>
<td style="text-align: right;">0.29750</td>
<td style="text-align: right;">-0.0822682</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.343,0.433]</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">0.4161074</td>
<td style="text-align: right;">298</td>
<td style="text-align: right;">0.0760403</td>
<td style="text-align: right;">0.38800</td>
<td style="text-align: right;">0.0281074</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.343,0.433]</td>
<td style="text-align: left;">M-DEC</td>
<td style="text-align: right;">0.4444444</td>
<td style="text-align: right;">9</td>
<td style="text-align: right;">0.1311111</td>
<td style="text-align: right;">0.38800</td>
<td style="text-align: right;">0.0564444</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.343,0.433]</td>
<td style="text-align: left;">S-DEC</td>
<td style="text-align: right;">0.5781250</td>
<td style="text-align: right;">128</td>
<td style="text-align: right;">0.4633594</td>
<td style="text-align: right;">0.38800</td>
<td style="text-align: right;">0.1901250</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.343,0.433]</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">0.4730539</td>
<td style="text-align: right;">167</td>
<td style="text-align: right;">0.2229940</td>
<td style="text-align: right;">0.38800</td>
<td style="text-align: right;">0.0850539</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.343,0.433]</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">0.3857868</td>
<td style="text-align: right;">394</td>
<td style="text-align: right;">-0.0050000</td>
<td style="text-align: right;">0.38800</td>
<td style="text-align: right;">-0.0022132</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.433,0.524]</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">0.4922280</td>
<td style="text-align: right;">193</td>
<td style="text-align: right;">0.0517098</td>
<td style="text-align: right;">0.47850</td>
<td style="text-align: right;">0.0137280</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.433,0.524]</td>
<td style="text-align: left;">M-DEC</td>
<td style="text-align: right;">0.1666667</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">-0.6400000</td>
<td style="text-align: right;">0.47850</td>
<td style="text-align: right;">-0.3118333</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.433,0.524]</td>
<td style="text-align: left;">S-DEC</td>
<td style="text-align: right;">0.5465116</td>
<td style="text-align: right;">86</td>
<td style="text-align: right;">0.1646512</td>
<td style="text-align: right;">0.47850</td>
<td style="text-align: right;">0.0680116</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="even">
<td style="text-align: left;">(0.433,0.524]</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">0.4553571</td>
<td style="text-align: right;">112</td>
<td style="text-align: right;">-0.0167857</td>
<td style="text-align: right;">0.47850</td>
<td style="text-align: right;">-0.0231429</td>
<td style="text-align: left;">FALSE</td>
</tr>
<tr class="odd">
<td style="text-align: left;">(0.433,0.524]</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">0.4798387</td>
<td style="text-align: right;">248</td>
<td style="text-align: right;">0.0297177</td>
<td style="text-align: right;">0.47850</td>
<td style="text-align: right;">0.0013387</td>
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
      xlab("Implied Probability (%)")+
      ggtitle("Favorites")+
      labs(color="Method")

![](/AttM/rmd_images/2021-01-21-fight_odds_analysis/unnamed-chunk-25-1.png)

    odds_perf_by_method %>%
      dplyr::filter(Is_Fav == F) %>%
      ggplot(aes(x=Mid_Bin, y=Size_of_Bin, group = Dummy, color = Dummy))+
      geom_point()+
      geom_smooth(se=F)+
      ylab("Count")+
      xlab("Implied Probability (%)")+
      ggtitle("Underdogs")+
      labs(color="Method")

![](/AttM/rmd_images/2021-01-21-fight_odds_analysis/unnamed-chunk-25-2.png)

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
      xlab("Implied Probability (%)")+
      ggtitle("Favorites")+
      labs(color="Method")

![](/AttM/rmd_images/2021-01-21-fight_odds_analysis/unnamed-chunk-26-1.png)

    method_count_by_odds %>%
      dplyr::filter(Is_Fav == F) %>%
      ggplot(aes(x=Mid_Bin*100, y=Method_Prop*100, group = Dummy, color=Dummy))+
      geom_point()+
      geom_smooth(se=F)+
      ylab("Probability of Method (%)")+
      xlab("Implied Probability (%)")+
      ggtitle("Underdogs")+
      labs(color="Method")

![](/AttM/rmd_images/2021-01-21-fight_odds_analysis/unnamed-chunk-26-2.png)

<br>

#### Fighter Odds

Get rid of useless columns.

    df_odds %>% dplyr::select(
      c(
        NAME
        , Event
        , Date
        , Result
        , Winner_Odds
        , Loser_Odds
      )
    ) -> df_odds_long

Summarize data.

    summary(df_odds_long)

    ##                  NAME                                       Event     
    ##  Donald Cerrone    :  24   UFC Fight Night: Chiesa vs. Magny   :  28  
    ##  Ovince Saint Preux:  21   UFC Fight Night: Poirier vs. Gaethje:  28  
    ##  Jim Miller        :  19   UFC Fight Night: Whittaker vs. Till :  28  
    ##  Neil Magny        :  19   UFC 190: Rousey vs Correia          :  26  
    ##  Derrick Lewis     :  18   UFC 193: Rousey vs Holm             :  26  
    ##  Tim Means         :  18   UFC 210: Cormier vs. Johnson 2      :  26  
    ##  (Other)           :5771   (Other)                             :5728  
    ##       Date               Result      Winner_Odds       Loser_Odds   
    ##  Min.   :2013-04-27   Loser :2945   Min.   : 1.060   Min.   : 1.07  
    ##  1st Qu.:2015-08-23   Winner:2945   1st Qu.: 1.420   1st Qu.: 1.77  
    ##  Median :2017-05-13                 Median : 1.710   Median : 2.38  
    ##  Mean   :2017-06-12                 Mean   : 1.975   Mean   : 2.81  
    ##  3rd Qu.:2019-04-13                 3rd Qu.: 2.300   3rd Qu.: 3.35  
    ##  Max.   :2021-01-20                 Max.   :12.990   Max.   :14.05  
    ## 

Add Fighter Odds column.

    df_odds_long %>%
      dplyr::mutate(
        Fighter_Odds = ifelse(Result == "Winner", Winner_Odds, Loser_Odds)
      ) -> df_odds_long

Add Implied Probability column.

    df_odds_long %>%
      dplyr::mutate(
        Implied_Probability = 1/Fighter_Odds
        , Won = ifelse(Result == "Winner", T, F)
        , Logit_Prob = qlogis(Implied_Probability)
      ) -> df_odds_long

Get performance and odds.

    df_odds_long %>%
      dplyr::group_by(NAME) %>%
      dplyr::summarise(
        Exp_Prop = mean(Implied_Probability)
        , Logit_Exp_Prop = mean(Logit_Prob)
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
<col style="width: 33%" />
<col style="width: 6%" />
<col style="width: 4%" />
<col style="width: 7%" />
<col style="width: 6%" />
<col style="width: 7%" />
<col style="width: 12%" />
<col style="width: 3%" />
<col style="width: 6%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">NAME</th>
<th style="text-align: left;">Event</th>
<th style="text-align: left;">Date</th>
<th style="text-align: left;">Result</th>
<th style="text-align: right;">Winner_Odds</th>
<th style="text-align: right;">Loser_Odds</th>
<th style="text-align: right;">Fighter_Odds</th>
<th style="text-align: right;">Implied_Probability</th>
<th style="text-align: left;">Won</th>
<th style="text-align: right;">Logit_Prob</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Roxanne Modafferi</td>
<td style="text-align: left;">UFC Fight Night: Dos Anjos vs. Edwards</td>
<td style="text-align: left;">2019-07-20</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">1.79</td>
<td style="text-align: right;">2.28</td>
<td style="text-align: right;">2.28</td>
<td style="text-align: right;">0.4385965</td>
<td style="text-align: left;">FALSE</td>
<td style="text-align: right;">-0.2468601</td>
</tr>
<tr class="even">
<td style="text-align: left;">Roxanne Modafferi</td>
<td style="text-align: left;">UFC Fight Night: Blaydes vs. Volkov</td>
<td style="text-align: left;">2020-06-20</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">1.90</td>
<td style="text-align: right;">2.15</td>
<td style="text-align: right;">2.15</td>
<td style="text-align: right;">0.4651163</td>
<td style="text-align: left;">FALSE</td>
<td style="text-align: right;">-0.1397619</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Roxanne Modafferi</td>
<td style="text-align: left;">UFC Fight Night: Waterson vs. Hill</td>
<td style="text-align: left;">2020-09-12</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">3.60</td>
<td style="text-align: right;">1.34</td>
<td style="text-align: right;">3.60</td>
<td style="text-align: right;">0.2777778</td>
<td style="text-align: left;">TRUE</td>
<td style="text-align: right;">-0.9555114</td>
</tr>
<tr class="even">
<td style="text-align: left;">Roxanne Modafferi</td>
<td style="text-align: left;">UFC Fight Night: Overeem vs. Oleinik</td>
<td style="text-align: left;">2019-04-20</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">3.75</td>
<td style="text-align: right;">1.37</td>
<td style="text-align: right;">3.75</td>
<td style="text-align: right;">0.2666667</td>
<td style="text-align: left;">TRUE</td>
<td style="text-align: right;">-1.0116009</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Roxanne Modafferi</td>
<td style="text-align: left;">UFC Fight Night: Chiesa vs. Magny</td>
<td style="text-align: left;">2021-01-20</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">1.34</td>
<td style="text-align: right;">3.60</td>
<td style="text-align: right;">3.60</td>
<td style="text-align: right;">0.2777778</td>
<td style="text-align: left;">FALSE</td>
<td style="text-align: right;">-0.9555114</td>
</tr>
<tr class="even">
<td style="text-align: left;">Roxanne Modafferi</td>
<td style="text-align: left;">The Ultimate Fighter: Team Rousey vs. Team Tate Finale</td>
<td style="text-align: left;">2013-11-30</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">1.26</td>
<td style="text-align: right;">5.16</td>
<td style="text-align: right;">5.16</td>
<td style="text-align: right;">0.1937984</td>
<td style="text-align: left;">FALSE</td>
<td style="text-align: right;">-1.4255151</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Roxanne Modafferi</td>
<td style="text-align: left;">UFC 246: McGregor vs. Cowboy</td>
<td style="text-align: left;">2020-01-18</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">8.02</td>
<td style="text-align: right;">1.12</td>
<td style="text-align: right;">8.02</td>
<td style="text-align: right;">0.1246883</td>
<td style="text-align: left;">TRUE</td>
<td style="text-align: right;">-1.9487632</td>
</tr>
<tr class="even">
<td style="text-align: left;">Roxanne Modafferi</td>
<td style="text-align: left;">UFC 230: Cormier vs. Lewis</td>
<td style="text-align: left;">2018-11-03</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">1.20</td>
<td style="text-align: right;">5.80</td>
<td style="text-align: right;">5.80</td>
<td style="text-align: right;">0.1724138</td>
<td style="text-align: left;">FALSE</td>
<td style="text-align: right;">-1.5686159</td>
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
<td style="text-align: right;">0.4443780</td>
<td style="text-align: right;">-0.2816010</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.5556220</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.4300613</td>
</tr>
<tr class="even">
<td style="text-align: left;">Robert Whittaker</td>
<td style="text-align: right;">0.5008462</td>
<td style="text-align: right;">0.0110577</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">10</td>
<td style="text-align: right;">0.4991538</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.5027644</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Brandon Moreno</td>
<td style="text-align: right;">0.4433253</td>
<td style="text-align: right;">-0.2519972</td>
<td style="text-align: right;">0.8571429</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">0.4138175</td>
<td style="text-align: right;">2.043757</td>
<td style="text-align: right;">0.4373320</td>
</tr>
<tr class="even">
<td style="text-align: left;">Arnold Allen</td>
<td style="text-align: right;">0.5943642</td>
<td style="text-align: right;">0.4091497</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">0.4056358</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.6008840</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Alexander Volkanovski</td>
<td style="text-align: right;">0.5982419</td>
<td style="text-align: right;">0.4724428</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">8</td>
<td style="text-align: right;">0.4017581</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.6159618</td>
</tr>
<tr class="even">
<td style="text-align: left;">Brian Ortega</td>
<td style="text-align: right;">0.4849879</td>
<td style="text-align: right;">-0.0566433</td>
<td style="text-align: right;">0.8750000</td>
<td style="text-align: right;">8</td>
<td style="text-align: right;">0.3900121</td>
<td style="text-align: right;">2.002553</td>
<td style="text-align: right;">0.4858430</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Bryan Caraway</td>
<td style="text-align: right;">0.4139121</td>
<td style="text-align: right;">-0.3645644</td>
<td style="text-align: right;">0.8000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.3860879</td>
<td style="text-align: right;">1.750859</td>
<td style="text-align: right;">0.4098551</td>
</tr>
<tr class="even">
<td style="text-align: left;">Yan Xiaonan</td>
<td style="text-align: right;">0.6190609</td>
<td style="text-align: right;">0.5138155</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.3809391</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.6257005</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Diego Ferreira</td>
<td style="text-align: right;">0.4952975</td>
<td style="text-align: right;">0.0012976</td>
<td style="text-align: right;">0.8750000</td>
<td style="text-align: right;">8</td>
<td style="text-align: right;">0.3797025</td>
<td style="text-align: right;">1.944613</td>
<td style="text-align: right;">0.5003244</td>
</tr>
<tr class="even">
<td style="text-align: left;">Amanda Nunes</td>
<td style="text-align: right;">0.5544114</td>
<td style="text-align: right;">0.3026989</td>
<td style="text-align: right;">0.9166667</td>
<td style="text-align: right;">12</td>
<td style="text-align: right;">0.3622553</td>
<td style="text-align: right;">2.095196</td>
<td style="text-align: right;">0.5751022</td>
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
<td style="text-align: right;">0.5982419</td>
<td style="text-align: right;">0.4724428</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">8</td>
<td style="text-align: right;">0.4017581</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.6159618</td>
</tr>
<tr class="even">
<td style="text-align: left;">Arnold Allen</td>
<td style="text-align: right;">0.5943642</td>
<td style="text-align: right;">0.4091497</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">0.4056358</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.6008840</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Demetrious Johnson</td>
<td style="text-align: right;">0.8655816</td>
<td style="text-align: right;">1.9313437</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">9</td>
<td style="text-align: right;">0.1344184</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.8733981</td>
</tr>
<tr class="even">
<td style="text-align: left;">Israel Adesanya</td>
<td style="text-align: right;">0.7047793</td>
<td style="text-align: right;">0.8905514</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">0.2952207</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.7090040</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Jon Jones</td>
<td style="text-align: right;">0.7929217</td>
<td style="text-align: right;">1.4212020</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">0.2070783</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.8055268</td>
</tr>
<tr class="even">
<td style="text-align: left;">Kamaru Usman</td>
<td style="text-align: right;">0.6905204</td>
<td style="text-align: right;">0.8920489</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">10</td>
<td style="text-align: right;">0.3094796</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.7093128</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Khabib Nurmagomedov</td>
<td style="text-align: right;">0.7586623</td>
<td style="text-align: right;">1.1982306</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">9</td>
<td style="text-align: right;">0.2413377</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.7682099</td>
</tr>
<tr class="even">
<td style="text-align: left;">Kyung Ho Kang</td>
<td style="text-align: right;">0.6666421</td>
<td style="text-align: right;">0.7263403</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">0.3333579</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.6740017</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Leonardo Santos</td>
<td style="text-align: right;">0.4443780</td>
<td style="text-align: right;">-0.2816010</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.5556220</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.4300613</td>
</tr>
<tr class="even">
<td style="text-align: left;">Petr Yan</td>
<td style="text-align: right;">0.8155106</td>
<td style="text-align: right;">1.5378261</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.1844894</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.8231485</td>
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
<td style="text-align: right;">0.5458797</td>
<td style="text-align: right;">0.2043752</td>
<td style="text-align: right;">0.1428571</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">-0.4030225</td>
<td style="text-align: right;">-1.996135</td>
<td style="text-align: right;">0.5509167</td>
</tr>
<tr class="even">
<td style="text-align: left;">Joshua Burkman</td>
<td style="text-align: right;">0.3796388</td>
<td style="text-align: right;">-0.5238111</td>
<td style="text-align: right;">0.0000000</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">-0.3796388</td>
<td style="text-align: right;">-Inf</td>
<td style="text-align: right;">0.3719615</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Hyun Gyu Lim</td>
<td style="text-align: right;">0.5769598</td>
<td style="text-align: right;">0.3820238</td>
<td style="text-align: right;">0.2000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-0.3769598</td>
<td style="text-align: right;">-1.768318</td>
<td style="text-align: right;">0.5943611</td>
</tr>
<tr class="even">
<td style="text-align: left;">Alexander Gustafsson</td>
<td style="text-align: right;">0.6307871</td>
<td style="text-align: right;">0.6119623</td>
<td style="text-align: right;">0.2857143</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">-0.3450728</td>
<td style="text-align: right;">-1.528253</td>
<td style="text-align: right;">0.6483883</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Gray Maynard</td>
<td style="text-align: right;">0.5082959</td>
<td style="text-align: right;">0.0289783</td>
<td style="text-align: right;">0.1666667</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">-0.3416293</td>
<td style="text-align: right;">-1.638416</td>
<td style="text-align: right;">0.5072441</td>
</tr>
<tr class="even">
<td style="text-align: left;">Junior Albini</td>
<td style="text-align: right;">0.5384896</td>
<td style="text-align: right;">0.1697904</td>
<td style="text-align: right;">0.2000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-0.3384896</td>
<td style="text-align: right;">-1.556085</td>
<td style="text-align: right;">0.5423459</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Andrea Lee</td>
<td style="text-align: right;">0.7122283</td>
<td style="text-align: right;">0.9185238</td>
<td style="text-align: right;">0.4000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-0.3122283</td>
<td style="text-align: right;">-1.323989</td>
<td style="text-align: right;">0.7147412</td>
</tr>
<tr class="even">
<td style="text-align: left;">Rashad Evans</td>
<td style="text-align: right;">0.5111291</td>
<td style="text-align: right;">0.0452450</td>
<td style="text-align: right;">0.2000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-0.3111291</td>
<td style="text-align: right;">-1.431539</td>
<td style="text-align: right;">0.5113093</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Johny Hendricks</td>
<td style="text-align: right;">0.5548586</td>
<td style="text-align: right;">0.2420306</td>
<td style="text-align: right;">0.2500000</td>
<td style="text-align: right;">8</td>
<td style="text-align: right;">-0.3048586</td>
<td style="text-align: right;">-1.340643</td>
<td style="text-align: right;">0.5602140</td>
</tr>
<tr class="even">
<td style="text-align: left;">Anderson Silva</td>
<td style="text-align: right;">0.4275559</td>
<td style="text-align: right;">-0.3389233</td>
<td style="text-align: right;">0.1428571</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">-0.2846987</td>
<td style="text-align: right;">-1.452836</td>
<td style="text-align: right;">0.4160710</td>
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
<td style="text-align: right;">0.3796388</td>
<td style="text-align: right;">-0.5238111</td>
<td style="text-align: right;">0.0000000</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">-0.3796388</td>
<td style="text-align: right;">-Inf</td>
<td style="text-align: right;">0.3719615</td>
</tr>
<tr class="even">
<td style="text-align: left;">Kailin Curran</td>
<td style="text-align: right;">0.5458797</td>
<td style="text-align: right;">0.2043752</td>
<td style="text-align: right;">0.1428571</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">-0.4030225</td>
<td style="text-align: right;">-1.996135</td>
<td style="text-align: right;">0.5509167</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Hyun Gyu Lim</td>
<td style="text-align: right;">0.5769598</td>
<td style="text-align: right;">0.3820238</td>
<td style="text-align: right;">0.2000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-0.3769598</td>
<td style="text-align: right;">-1.768318</td>
<td style="text-align: right;">0.5943611</td>
</tr>
<tr class="even">
<td style="text-align: left;">Gray Maynard</td>
<td style="text-align: right;">0.5082959</td>
<td style="text-align: right;">0.0289783</td>
<td style="text-align: right;">0.1666667</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">-0.3416293</td>
<td style="text-align: right;">-1.638416</td>
<td style="text-align: right;">0.5072441</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Junior Albini</td>
<td style="text-align: right;">0.5384896</td>
<td style="text-align: right;">0.1697904</td>
<td style="text-align: right;">0.2000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-0.3384896</td>
<td style="text-align: right;">-1.556085</td>
<td style="text-align: right;">0.5423459</td>
</tr>
<tr class="even">
<td style="text-align: left;">Alexander Gustafsson</td>
<td style="text-align: right;">0.6307871</td>
<td style="text-align: right;">0.6119623</td>
<td style="text-align: right;">0.2857143</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">-0.3450728</td>
<td style="text-align: right;">-1.528253</td>
<td style="text-align: right;">0.6483883</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Anderson Silva</td>
<td style="text-align: right;">0.4275559</td>
<td style="text-align: right;">-0.3389233</td>
<td style="text-align: right;">0.1428571</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">-0.2846987</td>
<td style="text-align: right;">-1.452836</td>
<td style="text-align: right;">0.4160710</td>
</tr>
<tr class="even">
<td style="text-align: left;">Ronda Rousey</td>
<td style="text-align: right;">0.8340240</td>
<td style="text-align: right;">1.8411506</td>
<td style="text-align: right;">0.6000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-0.2340240</td>
<td style="text-align: right;">-1.435685</td>
<td style="text-align: right;">0.8630847</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Rashad Evans</td>
<td style="text-align: right;">0.5111291</td>
<td style="text-align: right;">0.0452450</td>
<td style="text-align: right;">0.2000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-0.3111291</td>
<td style="text-align: right;">-1.431539</td>
<td style="text-align: right;">0.5113093</td>
</tr>
<tr class="even">
<td style="text-align: left;">Brad Pickett</td>
<td style="text-align: right;">0.3825716</td>
<td style="text-align: right;">-0.5428885</td>
<td style="text-align: right;">0.1250000</td>
<td style="text-align: right;">8</td>
<td style="text-align: right;">-0.2575716</td>
<td style="text-align: right;">-1.403022</td>
<td style="text-align: right;">0.3675159</td>
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
<td style="text-align: right;">0.8655816</td>
<td style="text-align: right;">1.931344</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">9</td>
<td style="text-align: right;">0.1344184</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.8733981</td>
</tr>
<tr class="even">
<td style="text-align: left;">Ronda Rousey</td>
<td style="text-align: right;">0.8340240</td>
<td style="text-align: right;">1.841151</td>
<td style="text-align: right;">0.6000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-0.2340240</td>
<td style="text-align: right;">-1.4356855</td>
<td style="text-align: right;">0.8630847</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Cristiane Justino</td>
<td style="text-align: right;">0.8223181</td>
<td style="text-align: right;">1.687443</td>
<td style="text-align: right;">0.8571429</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">0.0348247</td>
<td style="text-align: right;">0.1043161</td>
<td style="text-align: right;">0.8438876</td>
</tr>
<tr class="even">
<td style="text-align: left;">Petr Yan</td>
<td style="text-align: right;">0.8155106</td>
<td style="text-align: right;">1.537826</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.1844894</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.8231485</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Zabit Magomedsharipov</td>
<td style="text-align: right;">0.8098507</td>
<td style="text-align: right;">1.521697</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">0.1901493</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.8207883</td>
</tr>
<tr class="even">
<td style="text-align: left;">Tatiana Suarez</td>
<td style="text-align: right;">0.8048298</td>
<td style="text-align: right;">1.439167</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.1951702</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.8083257</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Jon Jones</td>
<td style="text-align: right;">0.7929217</td>
<td style="text-align: right;">1.421202</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">0.2070783</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.8055268</td>
</tr>
<tr class="even">
<td style="text-align: left;">Magomed Ankalaev</td>
<td style="text-align: right;">0.7692160</td>
<td style="text-align: right;">1.241505</td>
<td style="text-align: right;">0.8000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.0307840</td>
<td style="text-align: right;">0.1447892</td>
<td style="text-align: right;">0.7758259</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Khabib Nurmagomedov</td>
<td style="text-align: right;">0.7586623</td>
<td style="text-align: right;">1.198231</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">9</td>
<td style="text-align: right;">0.2413377</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.7682099</td>
</tr>
<tr class="even">
<td style="text-align: left;">Mairbek Taisumov</td>
<td style="text-align: right;">0.7372457</td>
<td style="text-align: right;">1.092292</td>
<td style="text-align: right;">0.7777778</td>
<td style="text-align: right;">9</td>
<td style="text-align: right;">0.0405321</td>
<td style="text-align: right;">0.1604711</td>
<td style="text-align: right;">0.7488130</td>
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
<td style="text-align: right;">0.8655816</td>
<td style="text-align: right;">1.931344</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">9</td>
<td style="text-align: right;">0.1344184</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.8733981</td>
</tr>
<tr class="even">
<td style="text-align: left;">Ronda Rousey</td>
<td style="text-align: right;">0.8340240</td>
<td style="text-align: right;">1.841151</td>
<td style="text-align: right;">0.6000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-0.2340240</td>
<td style="text-align: right;">-1.4356855</td>
<td style="text-align: right;">0.8630847</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Cristiane Justino</td>
<td style="text-align: right;">0.8223181</td>
<td style="text-align: right;">1.687443</td>
<td style="text-align: right;">0.8571429</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">0.0348247</td>
<td style="text-align: right;">0.1043161</td>
<td style="text-align: right;">0.8438876</td>
</tr>
<tr class="even">
<td style="text-align: left;">Petr Yan</td>
<td style="text-align: right;">0.8155106</td>
<td style="text-align: right;">1.537826</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.1844894</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.8231485</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Zabit Magomedsharipov</td>
<td style="text-align: right;">0.8098507</td>
<td style="text-align: right;">1.521697</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">0.1901493</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.8207883</td>
</tr>
<tr class="even">
<td style="text-align: left;">Tatiana Suarez</td>
<td style="text-align: right;">0.8048298</td>
<td style="text-align: right;">1.439167</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.1951702</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.8083257</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Jon Jones</td>
<td style="text-align: right;">0.7929217</td>
<td style="text-align: right;">1.421202</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">0.2070783</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.8055268</td>
</tr>
<tr class="even">
<td style="text-align: left;">Magomed Ankalaev</td>
<td style="text-align: right;">0.7692160</td>
<td style="text-align: right;">1.241505</td>
<td style="text-align: right;">0.8000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.0307840</td>
<td style="text-align: right;">0.1447892</td>
<td style="text-align: right;">0.7758259</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Khabib Nurmagomedov</td>
<td style="text-align: right;">0.7586623</td>
<td style="text-align: right;">1.198231</td>
<td style="text-align: right;">1.0000000</td>
<td style="text-align: right;">9</td>
<td style="text-align: right;">0.2413377</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.7682099</td>
</tr>
<tr class="even">
<td style="text-align: left;">Mairbek Taisumov</td>
<td style="text-align: right;">0.7372457</td>
<td style="text-align: right;">1.092292</td>
<td style="text-align: right;">0.7777778</td>
<td style="text-align: right;">9</td>
<td style="text-align: right;">0.0405321</td>
<td style="text-align: right;">0.1604711</td>
<td style="text-align: right;">0.7488130</td>
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
<td style="text-align: left;">Daniel Kelly</td>
<td style="text-align: right;">0.2746347</td>
<td style="text-align: right;">-0.9855774</td>
<td style="text-align: right;">0.6000000</td>
<td style="text-align: right;">10</td>
<td style="text-align: right;">0.3253653</td>
<td style="text-align: right;">1.3910425</td>
<td style="text-align: right;">0.2717865</td>
</tr>
<tr class="even">
<td style="text-align: left;">Roxanne Modafferi</td>
<td style="text-align: right;">0.2771044</td>
<td style="text-align: right;">-1.0315175</td>
<td style="text-align: right;">0.3750000</td>
<td style="text-align: right;">8</td>
<td style="text-align: right;">0.0978956</td>
<td style="text-align: right;">0.5206919</td>
<td style="text-align: right;">0.2627900</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Jessica Aguilar</td>
<td style="text-align: right;">0.2890830</td>
<td style="text-align: right;">-0.9508411</td>
<td style="text-align: right;">0.2000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-0.0890830</td>
<td style="text-align: right;">-0.4354533</td>
<td style="text-align: right;">0.2787157</td>
</tr>
<tr class="even">
<td style="text-align: left;">Dan Henderson</td>
<td style="text-align: right;">0.2919760</td>
<td style="text-align: right;">-0.9132753</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">0.2080240</td>
<td style="text-align: right;">0.9132753</td>
<td style="text-align: right;">0.2863301</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Thibault Gouti</td>
<td style="text-align: right;">0.2996752</td>
<td style="text-align: right;">-0.9188371</td>
<td style="text-align: right;">0.1666667</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">-0.1330085</td>
<td style="text-align: right;">-0.6906008</td>
<td style="text-align: right;">0.2851949</td>
</tr>
<tr class="even">
<td style="text-align: left;">Anthony Perosh</td>
<td style="text-align: right;">0.3020013</td>
<td style="text-align: right;">-0.9187685</td>
<td style="text-align: right;">0.4000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.0979987</td>
<td style="text-align: right;">0.5133034</td>
<td style="text-align: right;">0.2852089</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Leslie Smith</td>
<td style="text-align: right;">0.3045345</td>
<td style="text-align: right;">-0.9842242</td>
<td style="text-align: right;">0.4000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.0954655</td>
<td style="text-align: right;">0.5787591</td>
<td style="text-align: right;">0.2720544</td>
</tr>
<tr class="even">
<td style="text-align: left;">Yaotzin Meza</td>
<td style="text-align: right;">0.3083322</td>
<td style="text-align: right;">-0.8594931</td>
<td style="text-align: right;">0.4000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.0916678</td>
<td style="text-align: right;">0.4540280</td>
<td style="text-align: right;">0.2974453</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Garreth McLellan</td>
<td style="text-align: right;">0.3104941</td>
<td style="text-align: right;">-0.8174851</td>
<td style="text-align: right;">0.2000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-0.1104941</td>
<td style="text-align: right;">-0.5688092</td>
<td style="text-align: right;">0.3062978</td>
</tr>
<tr class="even">
<td style="text-align: left;">Takanori Gomi</td>
<td style="text-align: right;">0.3128814</td>
<td style="text-align: right;">-0.8519118</td>
<td style="text-align: right;">0.2000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-0.1128814</td>
<td style="text-align: right;">-0.5343826</td>
<td style="text-align: right;">0.2990320</td>
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
<td style="text-align: right;">0.2771044</td>
<td style="text-align: right;">-1.0315175</td>
<td style="text-align: right;">0.3750000</td>
<td style="text-align: right;">8</td>
<td style="text-align: right;">0.0978956</td>
<td style="text-align: right;">0.5206919</td>
<td style="text-align: right;">0.2627900</td>
</tr>
<tr class="even">
<td style="text-align: left;">Daniel Kelly</td>
<td style="text-align: right;">0.2746347</td>
<td style="text-align: right;">-0.9855774</td>
<td style="text-align: right;">0.6000000</td>
<td style="text-align: right;">10</td>
<td style="text-align: right;">0.3253653</td>
<td style="text-align: right;">1.3910425</td>
<td style="text-align: right;">0.2717865</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Leslie Smith</td>
<td style="text-align: right;">0.3045345</td>
<td style="text-align: right;">-0.9842242</td>
<td style="text-align: right;">0.4000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.0954655</td>
<td style="text-align: right;">0.5787591</td>
<td style="text-align: right;">0.2720544</td>
</tr>
<tr class="even">
<td style="text-align: left;">Jessica Aguilar</td>
<td style="text-align: right;">0.2890830</td>
<td style="text-align: right;">-0.9508411</td>
<td style="text-align: right;">0.2000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-0.0890830</td>
<td style="text-align: right;">-0.4354533</td>
<td style="text-align: right;">0.2787157</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Thibault Gouti</td>
<td style="text-align: right;">0.2996752</td>
<td style="text-align: right;">-0.9188371</td>
<td style="text-align: right;">0.1666667</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">-0.1330085</td>
<td style="text-align: right;">-0.6906008</td>
<td style="text-align: right;">0.2851949</td>
</tr>
<tr class="even">
<td style="text-align: left;">Anthony Perosh</td>
<td style="text-align: right;">0.3020013</td>
<td style="text-align: right;">-0.9187685</td>
<td style="text-align: right;">0.4000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.0979987</td>
<td style="text-align: right;">0.5133034</td>
<td style="text-align: right;">0.2852089</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Dan Henderson</td>
<td style="text-align: right;">0.2919760</td>
<td style="text-align: right;">-0.9132753</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">0.2080240</td>
<td style="text-align: right;">0.9132753</td>
<td style="text-align: right;">0.2863301</td>
</tr>
<tr class="even">
<td style="text-align: left;">Yaotzin Meza</td>
<td style="text-align: right;">0.3083322</td>
<td style="text-align: right;">-0.8594931</td>
<td style="text-align: right;">0.4000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.0916678</td>
<td style="text-align: right;">0.4540280</td>
<td style="text-align: right;">0.2974453</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Takanori Gomi</td>
<td style="text-align: right;">0.3128814</td>
<td style="text-align: right;">-0.8519118</td>
<td style="text-align: right;">0.2000000</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">-0.1128814</td>
<td style="text-align: right;">-0.5343826</td>
<td style="text-align: right;">0.2990320</td>
</tr>
<tr class="even">
<td style="text-align: left;">Diego Sanchez</td>
<td style="text-align: right;">0.3156820</td>
<td style="text-align: right;">-0.8267521</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">10</td>
<td style="text-align: right;">0.1843180</td>
<td style="text-align: right;">0.8267521</td>
<td style="text-align: right;">0.3043323</td>
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
<td style="text-align: right;">0.7047793</td>
<td style="text-align: right;">0.8905514</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">0.2952207</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">0.709004</td>
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
<td style="text-align: right;">0.4566026</td>
<td style="text-align: right;">-0.2132141</td>
<td style="text-align: right;">0.6428571</td>
<td style="text-align: right;">14</td>
<td style="text-align: right;">0.1862545</td>
<td style="text-align: right;">0.8010008</td>
<td style="text-align: right;">0.4468975</td>
</tr>
</tbody>
</table>
