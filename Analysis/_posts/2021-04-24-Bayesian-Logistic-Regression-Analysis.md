<br>

Description
-----------

This script uses inferential statistics to understand UFC fight odds
data.

<br>

### Libraries

    library(tidyverse)
    library(psych)
    library(corrplot)
    library(knitr)
    library(Amelia)
    library(rstanarm)

<br>

### Examine Data

Load data.

    load("./Datasets/df_master.RData")

Set the minimum number of fights required for a fighter to be included
in the analysis.

    fight_min = 1   

Summarize data.

    summary(df_master)

    ##      NAME               Date              Event               City          
    ##  Length:6088        Length:6088        Length:6088        Length:6088       
    ##  Class :character   Class :character   Class :character   Class :character  
    ##  Mode  :character   Mode  :character   Mode  :character   Mode  :character  
    ##                                                                             
    ##                                                                             
    ##                                                                             
    ##                                                                             
    ##     State             Country          FightWeightClass       Round      
    ##  Length:6088        Length:6088        Length:6088        Min.   :1.000  
    ##  Class :character   Class :character   Class :character   1st Qu.:1.000  
    ##  Mode  :character   Mode  :character   Mode  :character   Median :3.000  
    ##                                                           Mean   :2.431  
    ##                                                           3rd Qu.:3.000  
    ##                                                           Max.   :5.000  
    ##                                                                          
    ##     Method          Winner_Odds         Loser_Odds            Sex           
    ##  Length:6088        Length:6088        Length:6088        Length:6088       
    ##  Class :character   Class :character   Class :character   Class :character  
    ##  Mode  :character   Mode  :character   Mode  :character   Mode  :character  
    ##                                                                             
    ##                                                                             
    ##                                                                             
    ##                                                                             
    ##     fight_id         Result          FighterWeight   FighterWeightClass
    ##  Min.   :   1.0   Length:6088        Min.   :115.0   Length:6088       
    ##  1st Qu.: 761.8   Class :character   1st Qu.:135.0   Class :character  
    ##  Median :1522.5   Mode  :character   Median :155.0   Mode  :character  
    ##  Mean   :1522.5                      Mean   :163.9                     
    ##  3rd Qu.:2283.2                      3rd Qu.:185.0                     
    ##  Max.   :3044.0                      Max.   :265.0                     
    ##                                                                        
    ##      REACH            SLPM             SAPM             STRA       
    ##  Min.   :58.00   Min.   : 0.000   Min.   : 0.100   Min.   :0.0000  
    ##  1st Qu.:69.00   1st Qu.: 2.680   1st Qu.: 2.630   1st Qu.:0.3900  
    ##  Median :72.00   Median : 3.440   Median : 3.240   Median :0.4400  
    ##  Mean   :71.77   Mean   : 3.529   Mean   : 3.434   Mean   :0.4422  
    ##  3rd Qu.:75.00   3rd Qu.: 4.220   3rd Qu.: 4.020   3rd Qu.:0.4900  
    ##  Max.   :84.00   Max.   :19.910   Max.   :21.180   Max.   :0.8800  
    ##  NA's   :215                                                       
    ##       STRD              TD             TDA              TDD        
    ##  Min.   :0.0900   Min.   :0.000   Min.   :0.0000   Min.   :0.0000  
    ##  1st Qu.:0.5100   1st Qu.:0.560   1st Qu.:0.2600   1st Qu.:0.5100  
    ##  Median :0.5600   Median :1.210   Median :0.3700   Median :0.6400  
    ##  Mean   :0.5516   Mean   :1.520   Mean   :0.3752   Mean   :0.6158  
    ##  3rd Qu.:0.6000   3rd Qu.:2.183   3rd Qu.:0.5000   3rd Qu.:0.7600  
    ##  Max.   :0.9200   Max.   :8.930   Max.   :1.0000   Max.   :1.0000  
    ##                                                                    
    ##       SUBA        
    ##  Min.   : 0.0000  
    ##  1st Qu.: 0.1000  
    ##  Median : 0.4000  
    ##  Mean   : 0.5506  
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
    # will keep round as integer since represents time in match...
    # df_master$Round = as.factor(df_master$Round)  
    df_master$Method = as.factor(df_master$Method)
    df_master$Winner_Odds = as.numeric(df_master$Winner_Odds)
    df_master$Loser_Odds = as.numeric(df_master$Loser_Odds)
    df_master$fight_id = as.factor(df_master$fight_id)
    df_master$Sex = as.factor(df_master$Sex)
    df_master$Result = as.factor(df_master$Result)
    df_master$FighterWeightClass = as.factor(df_master$FighterWeightClass)

Summarize again. There are infinite odds and overturned / DQ fight
outcomes. These will have to be removed.

    summary(df_master)

    ##                  NAME           Date           
    ##  Donald Cerrone    :  24   Min.   :2013-04-27  
    ##  Ovince Saint Preux:  21   1st Qu.:2015-09-05  
    ##  Jim Miller        :  20   Median :2017-06-17  
    ##  Derrick Lewis     :  19   Mean   :2017-07-11  
    ##  Neil Magny        :  19   3rd Qu.:2019-05-18  
    ##  Andrei Arlovski   :  18   Max.   :2021-04-17  
    ##  (Other)           :5967                       
    ##                                   Event                  City     
    ##  UFC 259: Blachowicz vs. Adesanya    :  30   Las Vegas     :1346  
    ##  UFC Fight Night: Chiesa vs. Magny   :  28   Abu Dhabi     : 258  
    ##  UFC Fight Night: Poirier vs. Gaethje:  28   Boston        : 124  
    ##  UFC Fight Night: Whittaker vs. Till :  28   Rio de Janeiro: 124  
    ##  UFC 190: Rousey vs Correia          :  26   Chicago       : 118  
    ##  UFC 193: Rousey vs Holm             :  26   Newark        : 114  
    ##  (Other)                             :5922   (Other)       :4004  
    ##         State                      Country          FightWeightClass
    ##  Nevada    :1346   USA                 :3564   Lightweight  : 998   
    ##  Abu Dhabi : 258   Brazil              : 534   Welterweight : 992   
    ##  Texas     : 256   Canada              : 378   Bantamweight : 872   
    ##  New York  : 252   United Arab Emirates: 258   Featherweight: 736   
    ##  California: 250   Australia           : 236   Middleweight : 666   
    ##  Florida   : 176   United Kingdom      : 184   Flyweight    : 508   
    ##  (Other)   :3550   (Other)             : 934   (Other)      :1316   
    ##      Round              Method      Winner_Odds     Loser_Odds       Sex      
    ##  Min.   :1.000   DQ        :  16   Min.   :1.06   Min.   :1.07   Female: 780  
    ##  1st Qu.:1.000   KO/TKO    :1940   1st Qu.:1.42   1st Qu.:1.77   Male  :5308  
    ##  Median :3.000   M-DEC     :  36   Median :1.71   Median :2.38                
    ##  Mean   :2.431   Overturned:  20   Mean   : Inf   Mean   : Inf                
    ##  3rd Qu.:3.000   S-DEC     : 642   3rd Qu.:2.33   3rd Qu.:3.35                
    ##  Max.   :5.000   SUB       :1078   Max.   : Inf   Max.   : Inf                
    ##                  U-DEC     :2356                                              
    ##     fight_id       Result     FighterWeight       FighterWeightClass
    ##  1      :   2   Loser :3044   Min.   :115.0   Welterweight :1018    
    ##  2      :   2   Winner:3044   1st Qu.:135.0   Lightweight  : 992    
    ##  3      :   2                 Median :155.0   Bantamweight : 821    
    ##  4      :   2                 Mean   :163.9   Featherweight: 739    
    ##  5      :   2                 3rd Qu.:185.0   Middleweight : 667    
    ##  6      :   2                 Max.   :265.0   Flyweight    : 570    
    ##  (Other):6076                                 (Other)      :1281    
    ##      REACH            SLPM             SAPM             STRA       
    ##  Min.   :58.00   Min.   : 0.000   Min.   : 0.100   Min.   :0.0000  
    ##  1st Qu.:69.00   1st Qu.: 2.680   1st Qu.: 2.630   1st Qu.:0.3900  
    ##  Median :72.00   Median : 3.440   Median : 3.240   Median :0.4400  
    ##  Mean   :71.77   Mean   : 3.529   Mean   : 3.434   Mean   :0.4422  
    ##  3rd Qu.:75.00   3rd Qu.: 4.220   3rd Qu.: 4.020   3rd Qu.:0.4900  
    ##  Max.   :84.00   Max.   :19.910   Max.   :21.180   Max.   :0.8800  
    ##  NA's   :215                                                       
    ##       STRD              TD             TDA              TDD        
    ##  Min.   :0.0900   Min.   :0.000   Min.   :0.0000   Min.   :0.0000  
    ##  1st Qu.:0.5100   1st Qu.:0.560   1st Qu.:0.2600   1st Qu.:0.5100  
    ##  Median :0.5600   Median :1.210   Median :0.3700   Median :0.6400  
    ##  Mean   :0.5516   Mean   :1.520   Mean   :0.3752   Mean   :0.6158  
    ##  3rd Qu.:0.6000   3rd Qu.:2.183   3rd Qu.:0.5000   3rd Qu.:0.7600  
    ##  Max.   :0.9200   Max.   :8.930   Max.   :1.0000   Max.   :1.0000  
    ##                                                                    
    ##       SUBA        
    ##  Min.   : 0.0000  
    ##  1st Qu.: 0.1000  
    ##  Median : 0.4000  
    ##  Mean   : 0.5506  
    ##  3rd Qu.: 0.8000  
    ##  Max.   :12.1000  
    ## 

How many events are there in the dataset?

    length(unique(df_master$Event))

    ## [1] 265

How many fights?

    length(unique(df_master$fight_id))

    ## [1] 3044

Over what time frame did these occur?

    range(sort(unique(df_master$Date)))

    ## [1] "2013-04-27" "2021-04-17"

<br>

### Preprocess Data

Make copy of data frame.

    df_stats = df_master

Calculate number of fights in dataset for each fighter in dataset.

    df_stats %>%
      dplyr::group_by(NAME) %>%
      dplyr::summarise(
        Num_Fights = length(Round)
      ) -> df_fight_count

Append fight count to dataframe.

    df_stats = merge(df_stats, df_fight_count)

Which fights will we lose due to equal odds?

    df_stats %>%
      dplyr::filter(Winner_Odds == Loser_Odds) -> df_equal_odds

    kable(df_equal_odds)

<table style="width:100%;">
<colgroup>
<col style="width: 7%" />
<col style="width: 3%" />
<col style="width: 14%" />
<col style="width: 5%" />
<col style="width: 5%" />
<col style="width: 7%" />
<col style="width: 6%" />
<col style="width: 2%" />
<col style="width: 2%" />
<col style="width: 4%" />
<col style="width: 3%" />
<col style="width: 2%" />
<col style="width: 3%" />
<col style="width: 2%" />
<col style="width: 4%" />
<col style="width: 6%" />
<col style="width: 2%" />
<col style="width: 1%" />
<col style="width: 2%" />
<col style="width: 1%" />
<col style="width: 1%" />
<col style="width: 1%" />
<col style="width: 1%" />
<col style="width: 1%" />
<col style="width: 1%" />
<col style="width: 3%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">NAME</th>
<th style="text-align: left;">Date</th>
<th style="text-align: left;">Event</th>
<th style="text-align: left;">City</th>
<th style="text-align: left;">State</th>
<th style="text-align: left;">Country</th>
<th style="text-align: left;">FightWeightClass</th>
<th style="text-align: right;">Round</th>
<th style="text-align: left;">Method</th>
<th style="text-align: right;">Winner_Odds</th>
<th style="text-align: right;">Loser_Odds</th>
<th style="text-align: left;">Sex</th>
<th style="text-align: left;">fight_id</th>
<th style="text-align: left;">Result</th>
<th style="text-align: right;">FighterWeight</th>
<th style="text-align: left;">FighterWeightClass</th>
<th style="text-align: right;">REACH</th>
<th style="text-align: right;">SLPM</th>
<th style="text-align: right;">SAPM</th>
<th style="text-align: right;">STRA</th>
<th style="text-align: right;">STRD</th>
<th style="text-align: right;">TD</th>
<th style="text-align: right;">TDA</th>
<th style="text-align: right;">TDD</th>
<th style="text-align: right;">SUBA</th>
<th style="text-align: right;">Num_Fights</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Abdul Razak Alhassan</td>
<td style="text-align: left;">2021-04-17</td>
<td style="text-align: left;">UFC Fight Night: Whittaker vs. Gastelum</td>
<td style="text-align: left;">Las Vegas</td>
<td style="text-align: left;">Nevada</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Middleweight</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">1220</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">170</td>
<td style="text-align: left;">Welterweight</td>
<td style="text-align: right;">73</td>
<td style="text-align: right;">3.71</td>
<td style="text-align: right;">4.24</td>
<td style="text-align: right;">0.47</td>
<td style="text-align: right;">0.53</td>
<td style="text-align: right;">0.53</td>
<td style="text-align: right;">0.28</td>
<td style="text-align: right;">0.55</td>
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">7</td>
</tr>
<tr class="even">
<td style="text-align: left;">Aisling Daly</td>
<td style="text-align: left;">2015-10-24</td>
<td style="text-align: left;">UFC Fight Night: Holohan vs Smolka</td>
<td style="text-align: left;">Dublin</td>
<td style="text-align: left;">Leinster</td>
<td style="text-align: left;">Ireland</td>
<td style="text-align: left;">Strawweight</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">2.00</td>
<td style="text-align: right;">2.00</td>
<td style="text-align: left;">Female</td>
<td style="text-align: left;">18</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">115</td>
<td style="text-align: left;">Strawweight</td>
<td style="text-align: right;">64</td>
<td style="text-align: right;">2.92</td>
<td style="text-align: right;">1.40</td>
<td style="text-align: right;">0.52</td>
<td style="text-align: right;">0.55</td>
<td style="text-align: right;">2.15</td>
<td style="text-align: right;">0.41</td>
<td style="text-align: right;">0.33</td>
<td style="text-align: right;">0.9</td>
<td style="text-align: right;">3</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Aleksei Oleinik</td>
<td style="text-align: left;">2017-11-04</td>
<td style="text-align: left;">UFC 217: Bisping vs. St-Pierre</td>
<td style="text-align: left;">New York City</td>
<td style="text-align: left;">New York</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Heavyweight</td>
<td style="text-align: right;">2</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">617</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">240</td>
<td style="text-align: left;">Heavyweight</td>
<td style="text-align: right;">80</td>
<td style="text-align: right;">3.47</td>
<td style="text-align: right;">3.85</td>
<td style="text-align: right;">0.50</td>
<td style="text-align: right;">0.44</td>
<td style="text-align: right;">2.38</td>
<td style="text-align: right;">0.46</td>
<td style="text-align: right;">0.33</td>
<td style="text-align: right;">2.4</td>
<td style="text-align: right;">14</td>
</tr>
<tr class="even">
<td style="text-align: left;">Aleksei Oleinik</td>
<td style="text-align: left;">2017-07-08</td>
<td style="text-align: left;">UFC 213: Romero vs. Whittaker</td>
<td style="text-align: left;">Las Vegas</td>
<td style="text-align: left;">Nevada</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Heavyweight</td>
<td style="text-align: right;">2</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">62</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">240</td>
<td style="text-align: left;">Heavyweight</td>
<td style="text-align: right;">80</td>
<td style="text-align: right;">3.47</td>
<td style="text-align: right;">3.85</td>
<td style="text-align: right;">0.50</td>
<td style="text-align: right;">0.44</td>
<td style="text-align: right;">2.38</td>
<td style="text-align: right;">0.46</td>
<td style="text-align: right;">0.33</td>
<td style="text-align: right;">2.4</td>
<td style="text-align: right;">14</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Ali AlQaisi</td>
<td style="text-align: left;">2020-10-10</td>
<td style="text-align: left;">UFC Fight Night: Moraes vs. Sandhagen</td>
<td style="text-align: left;">Abu Dhabi</td>
<td style="text-align: left;">Abu Dhabi</td>
<td style="text-align: left;">United Arab Emirates</td>
<td style="text-align: left;">Bantamweight</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">2694</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">135</td>
<td style="text-align: left;">Bantamweight</td>
<td style="text-align: right;">68</td>
<td style="text-align: right;">2.43</td>
<td style="text-align: right;">1.97</td>
<td style="text-align: right;">0.42</td>
<td style="text-align: right;">0.56</td>
<td style="text-align: right;">3.50</td>
<td style="text-align: right;">0.29</td>
<td style="text-align: right;">0.60</td>
<td style="text-align: right;">1.0</td>
<td style="text-align: right;">2</td>
</tr>
<tr class="even">
<td style="text-align: left;">Alvaro Herrera Mendoza</td>
<td style="text-align: left;">2018-07-28</td>
<td style="text-align: left;">UFC Fight Night: Alvarez vs. Poirier 2</td>
<td style="text-align: left;">Calgary</td>
<td style="text-align: left;">Alberta</td>
<td style="text-align: left;">Canada</td>
<td style="text-align: left;">Lightweight</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">2.00</td>
<td style="text-align: right;">2.00</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">801</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">155</td>
<td style="text-align: left;">Lightweight</td>
<td style="text-align: right;">74</td>
<td style="text-align: right;">1.89</td>
<td style="text-align: right;">3.40</td>
<td style="text-align: right;">0.38</td>
<td style="text-align: right;">0.55</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.33</td>
<td style="text-align: right;">1.1</td>
<td style="text-align: right;">2</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Anthony Johnson</td>
<td style="text-align: left;">2015-05-23</td>
<td style="text-align: left;">UFC 187: Johnson vs Cormier</td>
<td style="text-align: left;">Las Vegas</td>
<td style="text-align: left;">Nevada</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Light Heavyweight</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">1.96</td>
<td style="text-align: right;">1.96</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">655</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">205</td>
<td style="text-align: left;">Light Heavyweight</td>
<td style="text-align: right;">78</td>
<td style="text-align: right;">3.25</td>
<td style="text-align: right;">1.83</td>
<td style="text-align: right;">0.47</td>
<td style="text-align: right;">0.60</td>
<td style="text-align: right;">2.43</td>
<td style="text-align: right;">0.57</td>
<td style="text-align: right;">0.77</td>
<td style="text-align: right;">0.6</td>
<td style="text-align: right;">8</td>
</tr>
<tr class="even">
<td style="text-align: left;">Antonio Carlos Junior</td>
<td style="text-align: left;">2017-10-28</td>
<td style="text-align: left;">UFC Fight Night: Brunson vs. Machida</td>
<td style="text-align: left;">Sao Paulo</td>
<td style="text-align: left;">Sao Paulo</td>
<td style="text-align: left;">Brazil</td>
<td style="text-align: left;">Middleweight</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">251</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">185</td>
<td style="text-align: left;">Middleweight</td>
<td style="text-align: right;">79</td>
<td style="text-align: right;">1.95</td>
<td style="text-align: right;">2.14</td>
<td style="text-align: right;">0.42</td>
<td style="text-align: right;">0.52</td>
<td style="text-align: right;">3.42</td>
<td style="text-align: right;">0.39</td>
<td style="text-align: right;">0.53</td>
<td style="text-align: right;">0.8</td>
<td style="text-align: right;">9</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Ariane Lipski</td>
<td style="text-align: left;">2019-11-16</td>
<td style="text-align: left;">UFC Fight Night: Blachowicz vs. Jacare</td>
<td style="text-align: left;">Sao Paulo</td>
<td style="text-align: left;">Sao Paulo</td>
<td style="text-align: left;">Brazil</td>
<td style="text-align: left;">Flyweight</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Female</td>
<td style="text-align: left;">254</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">125</td>
<td style="text-align: left;">Flyweight</td>
<td style="text-align: right;">67</td>
<td style="text-align: right;">3.03</td>
<td style="text-align: right;">4.45</td>
<td style="text-align: right;">0.32</td>
<td style="text-align: right;">0.48</td>
<td style="text-align: right;">0.27</td>
<td style="text-align: right;">0.25</td>
<td style="text-align: right;">0.45</td>
<td style="text-align: right;">0.5</td>
<td style="text-align: right;">4</td>
</tr>
<tr class="even">
<td style="text-align: left;">Bevon Lewis</td>
<td style="text-align: left;">2018-12-29</td>
<td style="text-align: left;">UFC 232: Jones vs. Gustafsson 2</td>
<td style="text-align: left;">Los Angeles</td>
<td style="text-align: left;">California</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Middleweight</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">2881</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">185</td>
<td style="text-align: left;">Middleweight</td>
<td style="text-align: right;">79</td>
<td style="text-align: right;">3.73</td>
<td style="text-align: right;">2.67</td>
<td style="text-align: right;">0.43</td>
<td style="text-align: right;">0.54</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.66</td>
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">3</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Brian Camozzi</td>
<td style="text-align: left;">2018-02-18</td>
<td style="text-align: left;">UFC Fight Night: Cerrone vs. Medeiros</td>
<td style="text-align: left;">Austin</td>
<td style="text-align: left;">Texas</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Welterweight</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">1041</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">170</td>
<td style="text-align: left;">Welterweight</td>
<td style="text-align: right;">78</td>
<td style="text-align: right;">3.15</td>
<td style="text-align: right;">6.39</td>
<td style="text-align: right;">0.26</td>
<td style="text-align: right;">0.54</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.7</td>
<td style="text-align: right;">3</td>
</tr>
<tr class="even">
<td style="text-align: left;">Carlos Condit</td>
<td style="text-align: left;">2016-01-02</td>
<td style="text-align: left;">UFC 195: Lawler vs Condit</td>
<td style="text-align: left;">Las Vegas</td>
<td style="text-align: left;">Nevada</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Welterweight</td>
<td style="text-align: right;">5</td>
<td style="text-align: left;">S-DEC</td>
<td style="text-align: right;">1.95</td>
<td style="text-align: right;">1.95</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">2336</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">170</td>
<td style="text-align: left;">Welterweight</td>
<td style="text-align: right;">75</td>
<td style="text-align: right;">3.63</td>
<td style="text-align: right;">2.49</td>
<td style="text-align: right;">0.39</td>
<td style="text-align: right;">0.56</td>
<td style="text-align: right;">0.62</td>
<td style="text-align: right;">0.54</td>
<td style="text-align: right;">0.39</td>
<td style="text-align: right;">1.0</td>
<td style="text-align: right;">8</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Carlton Minus</td>
<td style="text-align: left;">2020-08-22</td>
<td style="text-align: left;">UFC Fight Night: Munhoz vs. Edgar</td>
<td style="text-align: left;">Las Vegas</td>
<td style="text-align: left;">Nevada</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Welterweight</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">2887</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">170</td>
<td style="text-align: left;">Welterweight</td>
<td style="text-align: right;">75</td>
<td style="text-align: right;">3.50</td>
<td style="text-align: right;">4.97</td>
<td style="text-align: right;">0.40</td>
<td style="text-align: right;">0.50</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.58</td>
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">2</td>
</tr>
<tr class="even">
<td style="text-align: left;">Cezar Ferreira</td>
<td style="text-align: left;">2018-05-12</td>
<td style="text-align: left;">UFC 224: Nunes vs. Pennington</td>
<td style="text-align: left;">Rio de Janeiro</td>
<td style="text-align: left;">Rio de Janeiro</td>
<td style="text-align: left;">Brazil</td>
<td style="text-align: left;">Middleweight</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">1.95</td>
<td style="text-align: right;">1.95</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">453</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">185</td>
<td style="text-align: left;">Middleweight</td>
<td style="text-align: right;">78</td>
<td style="text-align: right;">1.90</td>
<td style="text-align: right;">2.44</td>
<td style="text-align: right;">0.42</td>
<td style="text-align: right;">0.53</td>
<td style="text-align: right;">2.69</td>
<td style="text-align: right;">0.53</td>
<td style="text-align: right;">0.84</td>
<td style="text-align: right;">0.5</td>
<td style="text-align: right;">13</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Curtis Blaydes</td>
<td style="text-align: left;">2017-11-04</td>
<td style="text-align: left;">UFC 217: Bisping vs. St-Pierre</td>
<td style="text-align: left;">New York City</td>
<td style="text-align: left;">New York</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Heavyweight</td>
<td style="text-align: right;">2</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">617</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">265</td>
<td style="text-align: left;">Heavyweight</td>
<td style="text-align: right;">80</td>
<td style="text-align: right;">3.59</td>
<td style="text-align: right;">1.70</td>
<td style="text-align: right;">0.53</td>
<td style="text-align: right;">0.57</td>
<td style="text-align: right;">6.64</td>
<td style="text-align: right;">0.54</td>
<td style="text-align: right;">0.33</td>
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">12</td>
</tr>
<tr class="even">
<td style="text-align: left;">Da-Un Jung</td>
<td style="text-align: left;">2021-04-10</td>
<td style="text-align: left;">UFC Fight Night: Vettori vs. Holland</td>
<td style="text-align: left;">Las Vegas</td>
<td style="text-align: left;">Nevada</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Light Heavyweight</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">3039</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">205</td>
<td style="text-align: left;">Light Heavyweight</td>
<td style="text-align: right;">78</td>
<td style="text-align: right;">3.95</td>
<td style="text-align: right;">3.90</td>
<td style="text-align: right;">0.45</td>
<td style="text-align: right;">0.54</td>
<td style="text-align: right;">2.79</td>
<td style="text-align: right;">0.61</td>
<td style="text-align: right;">0.88</td>
<td style="text-align: right;">0.3</td>
<td style="text-align: right;">3</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Daniel Cormier</td>
<td style="text-align: left;">2015-05-23</td>
<td style="text-align: left;">UFC 187: Johnson vs Cormier</td>
<td style="text-align: left;">Las Vegas</td>
<td style="text-align: left;">Nevada</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Light Heavyweight</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">1.96</td>
<td style="text-align: right;">1.96</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">655</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">235</td>
<td style="text-align: left;">Heavyweight</td>
<td style="text-align: right;">72</td>
<td style="text-align: right;">4.25</td>
<td style="text-align: right;">2.92</td>
<td style="text-align: right;">0.52</td>
<td style="text-align: right;">0.54</td>
<td style="text-align: right;">1.83</td>
<td style="text-align: right;">0.44</td>
<td style="text-align: right;">0.80</td>
<td style="text-align: right;">0.4</td>
<td style="text-align: right;">10</td>
</tr>
<tr class="even">
<td style="text-align: left;">Darrick Minner</td>
<td style="text-align: left;">2020-09-19</td>
<td style="text-align: left;">UFC Fight Night: Covington vs. Woodley</td>
<td style="text-align: left;">Las Vegas</td>
<td style="text-align: left;">Nevada</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Featherweight</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">715</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">145</td>
<td style="text-align: left;">Featherweight</td>
<td style="text-align: right;">69</td>
<td style="text-align: right;">3.24</td>
<td style="text-align: right;">1.40</td>
<td style="text-align: right;">0.70</td>
<td style="text-align: right;">0.43</td>
<td style="text-align: right;">3.00</td>
<td style="text-align: right;">0.62</td>
<td style="text-align: right;">0.60</td>
<td style="text-align: right;">3.6</td>
<td style="text-align: right;">3</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Deiveson Figueiredo</td>
<td style="text-align: left;">2018-02-03</td>
<td style="text-align: left;">UFC Fight Night: Machida vs. Anders</td>
<td style="text-align: left;">Belem</td>
<td style="text-align: left;">Para</td>
<td style="text-align: left;">Brazil</td>
<td style="text-align: left;">Flyweight</td>
<td style="text-align: right;">2</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">2.20</td>
<td style="text-align: right;">2.20</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">734</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">125</td>
<td style="text-align: left;">Flyweight</td>
<td style="text-align: right;">68</td>
<td style="text-align: right;">3.38</td>
<td style="text-align: right;">3.35</td>
<td style="text-align: right;">0.56</td>
<td style="text-align: right;">0.50</td>
<td style="text-align: right;">1.57</td>
<td style="text-align: right;">0.50</td>
<td style="text-align: right;">0.61</td>
<td style="text-align: right;">2.4</td>
<td style="text-align: right;">8</td>
</tr>
<tr class="even">
<td style="text-align: left;">Devin Powell</td>
<td style="text-align: left;">2018-07-28</td>
<td style="text-align: left;">UFC Fight Night: Alvarez vs. Poirier 2</td>
<td style="text-align: left;">Calgary</td>
<td style="text-align: left;">Alberta</td>
<td style="text-align: left;">Canada</td>
<td style="text-align: left;">Lightweight</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">2.00</td>
<td style="text-align: right;">2.00</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">801</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">155</td>
<td style="text-align: left;">Lightweight</td>
<td style="text-align: right;">73</td>
<td style="text-align: right;">2.88</td>
<td style="text-align: right;">3.67</td>
<td style="text-align: right;">0.41</td>
<td style="text-align: right;">0.51</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.6</td>
<td style="text-align: right;">4</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Devonte Smith</td>
<td style="text-align: left;">2019-02-09</td>
<td style="text-align: left;">UFC 234: Adesanya vs. Silva</td>
<td style="text-align: left;">Melbourne</td>
<td style="text-align: left;">Victoria</td>
<td style="text-align: left;">Australia</td>
<td style="text-align: left;">Lightweight</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">803</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">155</td>
<td style="text-align: left;">Lightweight</td>
<td style="text-align: right;">76</td>
<td style="text-align: right;">5.64</td>
<td style="text-align: right;">2.65</td>
<td style="text-align: right;">0.55</td>
<td style="text-align: right;">0.59</td>
<td style="text-align: right;">0.74</td>
<td style="text-align: right;">1.00</td>
<td style="text-align: right;">1.00</td>
<td style="text-align: right;">0.7</td>
<td style="text-align: right;">4</td>
</tr>
<tr class="even">
<td style="text-align: left;">Dong Hyun Ma</td>
<td style="text-align: left;">2019-02-09</td>
<td style="text-align: left;">UFC 234: Adesanya vs. Silva</td>
<td style="text-align: left;">Melbourne</td>
<td style="text-align: left;">Victoria</td>
<td style="text-align: left;">Australia</td>
<td style="text-align: left;">Lightweight</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">803</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">155</td>
<td style="text-align: left;">Lightweight</td>
<td style="text-align: right;">70</td>
<td style="text-align: right;">2.84</td>
<td style="text-align: right;">4.10</td>
<td style="text-align: right;">0.41</td>
<td style="text-align: right;">0.54</td>
<td style="text-align: right;">1.27</td>
<td style="text-align: right;">0.53</td>
<td style="text-align: right;">0.33</td>
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">8</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Dong Hyun Ma</td>
<td style="text-align: left;">2017-09-22</td>
<td style="text-align: left;">UFC Fight Night: Saint Preux vs. Okami</td>
<td style="text-align: left;">Saitama</td>
<td style="text-align: left;">Saitama</td>
<td style="text-align: left;">Japan</td>
<td style="text-align: left;">Lightweight</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">849</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">155</td>
<td style="text-align: left;">Lightweight</td>
<td style="text-align: right;">70</td>
<td style="text-align: right;">2.84</td>
<td style="text-align: right;">4.10</td>
<td style="text-align: right;">0.41</td>
<td style="text-align: right;">0.54</td>
<td style="text-align: right;">1.27</td>
<td style="text-align: right;">0.53</td>
<td style="text-align: right;">0.33</td>
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">8</td>
</tr>
<tr class="even">
<td style="text-align: left;">Ericka Almeida</td>
<td style="text-align: left;">2015-10-24</td>
<td style="text-align: left;">UFC Fight Night: Holohan vs Smolka</td>
<td style="text-align: left;">Dublin</td>
<td style="text-align: left;">Leinster</td>
<td style="text-align: left;">Ireland</td>
<td style="text-align: left;">Strawweight</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">2.00</td>
<td style="text-align: right;">2.00</td>
<td style="text-align: left;">Female</td>
<td style="text-align: left;">18</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">115</td>
<td style="text-align: left;">Strawweight</td>
<td style="text-align: right;">NA</td>
<td style="text-align: right;">1.07</td>
<td style="text-align: right;">3.33</td>
<td style="text-align: right;">0.39</td>
<td style="text-align: right;">0.43</td>
<td style="text-align: right;">0.50</td>
<td style="text-align: right;">0.33</td>
<td style="text-align: right;">0.37</td>
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">2</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Felicia Spencer</td>
<td style="text-align: left;">2020-02-29</td>
<td style="text-align: left;">UFC Fight Night: Benavidez vs. Figueiredo</td>
<td style="text-align: left;">Norfolk</td>
<td style="text-align: left;">Virginia</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Featherweight</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Female</td>
<td style="text-align: left;">974</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">145</td>
<td style="text-align: left;">Featherweight</td>
<td style="text-align: right;">68</td>
<td style="text-align: right;">3.02</td>
<td style="text-align: right;">5.57</td>
<td style="text-align: right;">0.45</td>
<td style="text-align: right;">0.43</td>
<td style="text-align: right;">0.64</td>
<td style="text-align: right;">0.10</td>
<td style="text-align: right;">0.14</td>
<td style="text-align: right;">0.3</td>
<td style="text-align: right;">4</td>
</tr>
<tr class="even">
<td style="text-align: left;">Felipe Colares</td>
<td style="text-align: left;">2019-02-02</td>
<td style="text-align: left;">UFC Fight Night: Assuncao vs. Moraes 2</td>
<td style="text-align: left;">Fortaleza</td>
<td style="text-align: left;">Ceara</td>
<td style="text-align: left;">Brazil</td>
<td style="text-align: left;">Featherweight</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">2915</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">135</td>
<td style="text-align: left;">Bantamweight</td>
<td style="text-align: right;">69</td>
<td style="text-align: right;">1.13</td>
<td style="text-align: right;">3.00</td>
<td style="text-align: right;">0.42</td>
<td style="text-align: right;">0.32</td>
<td style="text-align: right;">2.00</td>
<td style="text-align: right;">0.25</td>
<td style="text-align: right;">0.34</td>
<td style="text-align: right;">1.0</td>
<td style="text-align: right;">3</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Frankie Perez</td>
<td style="text-align: left;">2015-01-18</td>
<td style="text-align: left;">UFC Fight Night: McGregor vs Siver</td>
<td style="text-align: left;">Boston</td>
<td style="text-align: left;">Massachusetts</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Lightweight</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">1432</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">155</td>
<td style="text-align: left;">Lightweight</td>
<td style="text-align: right;">73</td>
<td style="text-align: right;">1.64</td>
<td style="text-align: right;">2.17</td>
<td style="text-align: right;">0.41</td>
<td style="text-align: right;">0.54</td>
<td style="text-align: right;">1.75</td>
<td style="text-align: right;">0.41</td>
<td style="text-align: right;">0.50</td>
<td style="text-align: right;">0.3</td>
<td style="text-align: right;">4</td>
</tr>
<tr class="even">
<td style="text-align: left;">Frankie Saenz</td>
<td style="text-align: left;">2018-05-19</td>
<td style="text-align: left;">UFC Fight Night: Maia vs. Usman</td>
<td style="text-align: left;">Santiago</td>
<td style="text-align: left;">Chile</td>
<td style="text-align: left;">Chile</td>
<td style="text-align: left;">Bantamweight</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">1021</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">135</td>
<td style="text-align: left;">Bantamweight</td>
<td style="text-align: right;">66</td>
<td style="text-align: right;">3.94</td>
<td style="text-align: right;">3.50</td>
<td style="text-align: right;">0.47</td>
<td style="text-align: right;">0.52</td>
<td style="text-align: right;">1.74</td>
<td style="text-align: right;">0.31</td>
<td style="text-align: right;">0.61</td>
<td style="text-align: right;">0.1</td>
<td style="text-align: right;">9</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Geoff Neal</td>
<td style="text-align: left;">2018-02-18</td>
<td style="text-align: left;">UFC Fight Night: Cerrone vs. Medeiros</td>
<td style="text-align: left;">Austin</td>
<td style="text-align: left;">Texas</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Welterweight</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">1041</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">170</td>
<td style="text-align: left;">Welterweight</td>
<td style="text-align: right;">75</td>
<td style="text-align: right;">4.94</td>
<td style="text-align: right;">4.93</td>
<td style="text-align: right;">0.49</td>
<td style="text-align: right;">0.61</td>
<td style="text-align: right;">0.50</td>
<td style="text-align: right;">0.50</td>
<td style="text-align: right;">0.92</td>
<td style="text-align: right;">0.2</td>
<td style="text-align: right;">5</td>
</tr>
<tr class="even">
<td style="text-align: left;">Geraldo de Freitas</td>
<td style="text-align: left;">2019-02-02</td>
<td style="text-align: left;">UFC Fight Night: Assuncao vs. Moraes 2</td>
<td style="text-align: left;">Fortaleza</td>
<td style="text-align: left;">Ceara</td>
<td style="text-align: left;">Brazil</td>
<td style="text-align: left;">Featherweight</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">2915</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">135</td>
<td style="text-align: left;">Bantamweight</td>
<td style="text-align: right;">72</td>
<td style="text-align: right;">3.67</td>
<td style="text-align: right;">2.62</td>
<td style="text-align: right;">0.52</td>
<td style="text-align: right;">0.50</td>
<td style="text-align: right;">3.00</td>
<td style="text-align: right;">0.45</td>
<td style="text-align: right;">0.59</td>
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">3</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Gina Mazany</td>
<td style="text-align: left;">2017-11-25</td>
<td style="text-align: left;">UFC Fight Night: Bisping vs. Gastelum</td>
<td style="text-align: left;">Shanghai</td>
<td style="text-align: left;">Hebei</td>
<td style="text-align: left;">China</td>
<td style="text-align: left;">Bantamweight</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">2.25</td>
<td style="text-align: right;">2.25</td>
<td style="text-align: left;">Female</td>
<td style="text-align: left;">1087</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">125</td>
<td style="text-align: left;">Flyweight</td>
<td style="text-align: right;">68</td>
<td style="text-align: right;">3.45</td>
<td style="text-align: right;">3.07</td>
<td style="text-align: right;">0.47</td>
<td style="text-align: right;">0.51</td>
<td style="text-align: right;">4.41</td>
<td style="text-align: right;">0.63</td>
<td style="text-align: right;">0.33</td>
<td style="text-align: right;">0.3</td>
<td style="text-align: right;">6</td>
</tr>
<tr class="even">
<td style="text-align: left;">Glover Teixeira</td>
<td style="text-align: left;">2015-08-08</td>
<td style="text-align: left;">UFC Fight Night: Teixeira vs Saint Preux</td>
<td style="text-align: left;">Nashville</td>
<td style="text-align: left;">Tennessee</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Light Heavyweight</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">1.95</td>
<td style="text-align: right;">1.95</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">1093</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">205</td>
<td style="text-align: left;">Light Heavyweight</td>
<td style="text-align: right;">76</td>
<td style="text-align: right;">3.75</td>
<td style="text-align: right;">3.84</td>
<td style="text-align: right;">0.47</td>
<td style="text-align: right;">0.54</td>
<td style="text-align: right;">2.04</td>
<td style="text-align: right;">0.40</td>
<td style="text-align: right;">0.60</td>
<td style="text-align: right;">1.0</td>
<td style="text-align: right;">12</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Henry Briones</td>
<td style="text-align: left;">2018-05-19</td>
<td style="text-align: left;">UFC Fight Night: Maia vs. Usman</td>
<td style="text-align: left;">Santiago</td>
<td style="text-align: left;">Chile</td>
<td style="text-align: left;">Chile</td>
<td style="text-align: left;">Bantamweight</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">1021</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">135</td>
<td style="text-align: left;">Bantamweight</td>
<td style="text-align: right;">69</td>
<td style="text-align: right;">3.47</td>
<td style="text-align: right;">4.68</td>
<td style="text-align: right;">0.42</td>
<td style="text-align: right;">0.53</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.52</td>
<td style="text-align: right;">0.6</td>
<td style="text-align: right;">4</td>
</tr>
<tr class="even">
<td style="text-align: left;">Ildemar Alcantara</td>
<td style="text-align: left;">2015-07-15</td>
<td style="text-align: left;">UFC Fight Night: Mir vs Duffee</td>
<td style="text-align: left;">San Diego</td>
<td style="text-align: left;">California</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Middleweight</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">1.95</td>
<td style="text-align: right;">1.95</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">1624</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">185</td>
<td style="text-align: left;">Middleweight</td>
<td style="text-align: right;">78</td>
<td style="text-align: right;">1.93</td>
<td style="text-align: right;">2.63</td>
<td style="text-align: right;">0.38</td>
<td style="text-align: right;">0.50</td>
<td style="text-align: right;">2.00</td>
<td style="text-align: right;">0.68</td>
<td style="text-align: right;">0.81</td>
<td style="text-align: right;">0.9</td>
<td style="text-align: right;">3</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Isabela de Padua</td>
<td style="text-align: left;">2019-11-16</td>
<td style="text-align: left;">UFC Fight Night: Blachowicz vs. Jacare</td>
<td style="text-align: left;">Sao Paulo</td>
<td style="text-align: left;">Sao Paulo</td>
<td style="text-align: left;">Brazil</td>
<td style="text-align: left;">Flyweight</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Female</td>
<td style="text-align: left;">254</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">125</td>
<td style="text-align: left;">Flyweight</td>
<td style="text-align: right;">64</td>
<td style="text-align: right;">1.00</td>
<td style="text-align: right;">2.07</td>
<td style="text-align: right;">0.35</td>
<td style="text-align: right;">0.50</td>
<td style="text-align: right;">2.00</td>
<td style="text-align: right;">0.66</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">1.0</td>
<td style="text-align: right;">1</td>
</tr>
<tr class="even">
<td style="text-align: left;">Iuri Alcantara</td>
<td style="text-align: left;">2018-02-03</td>
<td style="text-align: left;">UFC Fight Night: Machida vs. Anders</td>
<td style="text-align: left;">Belem</td>
<td style="text-align: left;">Para</td>
<td style="text-align: left;">Brazil</td>
<td style="text-align: left;">Bantamweight</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">2.00</td>
<td style="text-align: right;">2.00</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">2949</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">135</td>
<td style="text-align: left;">Bantamweight</td>
<td style="text-align: right;">71</td>
<td style="text-align: right;">2.72</td>
<td style="text-align: right;">2.79</td>
<td style="text-align: right;">0.45</td>
<td style="text-align: right;">0.49</td>
<td style="text-align: right;">1.44</td>
<td style="text-align: right;">0.62</td>
<td style="text-align: right;">0.60</td>
<td style="text-align: right;">0.8</td>
<td style="text-align: right;">12</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Jack Marshman</td>
<td style="text-align: left;">2017-10-28</td>
<td style="text-align: left;">UFC Fight Night: Brunson vs. Machida</td>
<td style="text-align: left;">Sao Paulo</td>
<td style="text-align: left;">Sao Paulo</td>
<td style="text-align: left;">Brazil</td>
<td style="text-align: left;">Middleweight</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">251</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">185</td>
<td style="text-align: left;">Middleweight</td>
<td style="text-align: right;">73</td>
<td style="text-align: right;">2.74</td>
<td style="text-align: right;">4.19</td>
<td style="text-align: right;">0.25</td>
<td style="text-align: right;">0.56</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.20</td>
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">6</td>
</tr>
<tr class="even">
<td style="text-align: left;">Jacob Malkoun</td>
<td style="text-align: left;">2021-04-17</td>
<td style="text-align: left;">UFC Fight Night: Whittaker vs. Gastelum</td>
<td style="text-align: left;">Las Vegas</td>
<td style="text-align: left;">Nevada</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Middleweight</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">1220</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">185</td>
<td style="text-align: left;">Middleweight</td>
<td style="text-align: right;">73</td>
<td style="text-align: right;">1.76</td>
<td style="text-align: right;">1.83</td>
<td style="text-align: right;">0.47</td>
<td style="text-align: right;">0.51</td>
<td style="text-align: right;">7.84</td>
<td style="text-align: right;">0.33</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">2.0</td>
<td style="text-align: right;">2</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Jarjis Danho</td>
<td style="text-align: left;">2021-04-10</td>
<td style="text-align: left;">UFC Fight Night: Vettori vs. Holland</td>
<td style="text-align: left;">Las Vegas</td>
<td style="text-align: left;">Nevada</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Heavyweight</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">1288</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">265</td>
<td style="text-align: left;">Heavyweight</td>
<td style="text-align: right;">74</td>
<td style="text-align: right;">3.38</td>
<td style="text-align: right;">5.25</td>
<td style="text-align: right;">0.50</td>
<td style="text-align: right;">0.49</td>
<td style="text-align: right;">0.51</td>
<td style="text-align: right;">0.16</td>
<td style="text-align: right;">1.00</td>
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">2</td>
</tr>
<tr class="even">
<td style="text-align: left;">Joanne Calderwood</td>
<td style="text-align: left;">2019-06-08</td>
<td style="text-align: left;">UFC 238: Cejudo vs. Moraes</td>
<td style="text-align: left;">Chicago</td>
<td style="text-align: left;">Illinois</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Flyweight</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">1.98</td>
<td style="text-align: right;">1.98</td>
<td style="text-align: left;">Female</td>
<td style="text-align: left;">1596</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">125</td>
<td style="text-align: left;">Flyweight</td>
<td style="text-align: right;">65</td>
<td style="text-align: right;">6.59</td>
<td style="text-align: right;">4.40</td>
<td style="text-align: right;">0.49</td>
<td style="text-align: right;">0.53</td>
<td style="text-align: right;">1.80</td>
<td style="text-align: right;">0.55</td>
<td style="text-align: right;">0.58</td>
<td style="text-align: right;">0.5</td>
<td style="text-align: right;">9</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Joe Soto</td>
<td style="text-align: left;">2018-02-03</td>
<td style="text-align: left;">UFC Fight Night: Machida vs. Anders</td>
<td style="text-align: left;">Belem</td>
<td style="text-align: left;">Para</td>
<td style="text-align: left;">Brazil</td>
<td style="text-align: left;">Bantamweight</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">2.00</td>
<td style="text-align: right;">2.00</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">2949</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">135</td>
<td style="text-align: left;">Bantamweight</td>
<td style="text-align: right;">65</td>
<td style="text-align: right;">3.36</td>
<td style="text-align: right;">5.37</td>
<td style="text-align: right;">0.41</td>
<td style="text-align: right;">0.67</td>
<td style="text-align: right;">0.85</td>
<td style="text-align: right;">0.21</td>
<td style="text-align: right;">0.70</td>
<td style="text-align: right;">1.9</td>
<td style="text-align: right;">7</td>
</tr>
<tr class="even">
<td style="text-align: left;">Johnny Case</td>
<td style="text-align: left;">2015-01-18</td>
<td style="text-align: left;">UFC Fight Night: McGregor vs Siver</td>
<td style="text-align: left;">Boston</td>
<td style="text-align: left;">Massachusetts</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Lightweight</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">1432</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">155</td>
<td style="text-align: left;">Lightweight</td>
<td style="text-align: right;">72</td>
<td style="text-align: right;">3.95</td>
<td style="text-align: right;">2.66</td>
<td style="text-align: right;">0.38</td>
<td style="text-align: right;">0.61</td>
<td style="text-align: right;">1.70</td>
<td style="text-align: right;">0.45</td>
<td style="text-align: right;">0.72</td>
<td style="text-align: right;">0.2</td>
<td style="text-align: right;">6</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Johny Hendricks</td>
<td style="text-align: left;">2017-11-04</td>
<td style="text-align: left;">UFC 217: Bisping vs. St-Pierre</td>
<td style="text-align: left;">New York City</td>
<td style="text-align: left;">New York</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Middleweight</td>
<td style="text-align: right;">2</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">2198</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">185</td>
<td style="text-align: left;">Middleweight</td>
<td style="text-align: right;">69</td>
<td style="text-align: right;">3.49</td>
<td style="text-align: right;">3.99</td>
<td style="text-align: right;">0.45</td>
<td style="text-align: right;">0.53</td>
<td style="text-align: right;">3.83</td>
<td style="text-align: right;">0.46</td>
<td style="text-align: right;">0.63</td>
<td style="text-align: right;">0.3</td>
<td style="text-align: right;">9</td>
</tr>
<tr class="even">
<td style="text-align: left;">Jorge Masvidal</td>
<td style="text-align: left;">2016-05-29</td>
<td style="text-align: left;">UFC Fight Night: Almeida vs Garbrandt</td>
<td style="text-align: left;">Las Vegas</td>
<td style="text-align: left;">Nevada</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Welterweight</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">S-DEC</td>
<td style="text-align: right;">2.00</td>
<td style="text-align: right;">2.00</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">1750</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">170</td>
<td style="text-align: left;">Welterweight</td>
<td style="text-align: right;">74</td>
<td style="text-align: right;">4.20</td>
<td style="text-align: right;">3.00</td>
<td style="text-align: right;">0.47</td>
<td style="text-align: right;">0.65</td>
<td style="text-align: right;">1.57</td>
<td style="text-align: right;">0.59</td>
<td style="text-align: right;">0.77</td>
<td style="text-align: right;">0.4</td>
<td style="text-align: right;">15</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Joseph Morales</td>
<td style="text-align: left;">2018-02-03</td>
<td style="text-align: left;">UFC Fight Night: Machida vs. Anders</td>
<td style="text-align: left;">Belem</td>
<td style="text-align: left;">Para</td>
<td style="text-align: left;">Brazil</td>
<td style="text-align: left;">Flyweight</td>
<td style="text-align: right;">2</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">2.20</td>
<td style="text-align: right;">2.20</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">734</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">125</td>
<td style="text-align: left;">Flyweight</td>
<td style="text-align: right;">69</td>
<td style="text-align: right;">1.58</td>
<td style="text-align: right;">1.72</td>
<td style="text-align: right;">0.37</td>
<td style="text-align: right;">0.60</td>
<td style="text-align: right;">0.53</td>
<td style="text-align: right;">0.50</td>
<td style="text-align: right;">0.23</td>
<td style="text-align: right;">2.6</td>
<td style="text-align: right;">2</td>
</tr>
<tr class="even">
<td style="text-align: left;">Karl Roberson</td>
<td style="text-align: left;">2018-05-12</td>
<td style="text-align: left;">UFC 224: Nunes vs. Pennington</td>
<td style="text-align: left;">Rio de Janeiro</td>
<td style="text-align: left;">Rio de Janeiro</td>
<td style="text-align: left;">Brazil</td>
<td style="text-align: left;">Middleweight</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">1.95</td>
<td style="text-align: right;">1.95</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">453</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">185</td>
<td style="text-align: left;">Middleweight</td>
<td style="text-align: right;">74</td>
<td style="text-align: right;">3.00</td>
<td style="text-align: right;">2.42</td>
<td style="text-align: right;">0.51</td>
<td style="text-align: right;">0.57</td>
<td style="text-align: right;">0.99</td>
<td style="text-align: right;">0.57</td>
<td style="text-align: right;">0.50</td>
<td style="text-align: right;">0.8</td>
<td style="text-align: right;">6</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Katlyn Chookagian</td>
<td style="text-align: left;">2019-06-08</td>
<td style="text-align: left;">UFC 238: Cejudo vs. Moraes</td>
<td style="text-align: left;">Chicago</td>
<td style="text-align: left;">Illinois</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Flyweight</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">1.98</td>
<td style="text-align: right;">1.98</td>
<td style="text-align: left;">Female</td>
<td style="text-align: left;">1596</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">125</td>
<td style="text-align: left;">Flyweight</td>
<td style="text-align: right;">68</td>
<td style="text-align: right;">4.22</td>
<td style="text-align: right;">4.23</td>
<td style="text-align: right;">0.34</td>
<td style="text-align: right;">0.63</td>
<td style="text-align: right;">0.27</td>
<td style="text-align: right;">0.15</td>
<td style="text-align: right;">0.51</td>
<td style="text-align: right;">0.5</td>
<td style="text-align: right;">11</td>
</tr>
<tr class="even">
<td style="text-align: left;">KB Bhullar</td>
<td style="text-align: left;">2020-10-10</td>
<td style="text-align: left;">UFC Fight Night: Moraes vs. Sandhagen</td>
<td style="text-align: left;">Abu Dhabi</td>
<td style="text-align: left;">Abu Dhabi</td>
<td style="text-align: left;">United Arab Emirates</td>
<td style="text-align: left;">Middleweight</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">2678</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">185</td>
<td style="text-align: left;">Middleweight</td>
<td style="text-align: right;">78</td>
<td style="text-align: right;">1.18</td>
<td style="text-align: right;">10.00</td>
<td style="text-align: right;">0.13</td>
<td style="text-align: right;">0.37</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">1</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Kevin Casey</td>
<td style="text-align: left;">2015-07-15</td>
<td style="text-align: left;">UFC Fight Night: Mir vs Duffee</td>
<td style="text-align: left;">San Diego</td>
<td style="text-align: left;">California</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Middleweight</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">1.95</td>
<td style="text-align: right;">1.95</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">1624</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">185</td>
<td style="text-align: left;">Middleweight</td>
<td style="text-align: right;">77</td>
<td style="text-align: right;">2.27</td>
<td style="text-align: right;">3.76</td>
<td style="text-align: right;">0.53</td>
<td style="text-align: right;">0.46</td>
<td style="text-align: right;">0.79</td>
<td style="text-align: right;">0.22</td>
<td style="text-align: right;">0.27</td>
<td style="text-align: right;">0.4</td>
<td style="text-align: right;">3</td>
</tr>
<tr class="even">
<td style="text-align: left;">Kyle Bochniak</td>
<td style="text-align: left;">2019-10-18</td>
<td style="text-align: left;">UFC Fight Night: Reyes vs. Weidman</td>
<td style="text-align: left;">Boston</td>
<td style="text-align: left;">Massachusetts</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Featherweight</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">2.00</td>
<td style="text-align: right;">2.00</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">2486</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">145</td>
<td style="text-align: left;">Featherweight</td>
<td style="text-align: right;">70</td>
<td style="text-align: right;">2.63</td>
<td style="text-align: right;">5.11</td>
<td style="text-align: right;">0.31</td>
<td style="text-align: right;">0.58</td>
<td style="text-align: right;">1.14</td>
<td style="text-align: right;">0.15</td>
<td style="text-align: right;">0.62</td>
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">7</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Lorenz Larkin</td>
<td style="text-align: left;">2016-05-29</td>
<td style="text-align: left;">UFC Fight Night: Almeida vs Garbrandt</td>
<td style="text-align: left;">Las Vegas</td>
<td style="text-align: left;">Nevada</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Welterweight</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">S-DEC</td>
<td style="text-align: right;">2.00</td>
<td style="text-align: right;">2.00</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">1750</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">170</td>
<td style="text-align: left;">Welterweight</td>
<td style="text-align: right;">72</td>
<td style="text-align: right;">3.53</td>
<td style="text-align: right;">2.74</td>
<td style="text-align: right;">0.46</td>
<td style="text-align: right;">0.63</td>
<td style="text-align: right;">0.27</td>
<td style="text-align: right;">0.42</td>
<td style="text-align: right;">0.79</td>
<td style="text-align: right;">0.1</td>
<td style="text-align: right;">7</td>
</tr>
<tr class="even">
<td style="text-align: left;">Luis Pena</td>
<td style="text-align: left;">2020-02-29</td>
<td style="text-align: left;">UFC Fight Night: Benavidez vs. Figueiredo</td>
<td style="text-align: left;">Norfolk</td>
<td style="text-align: left;">Virginia</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Lightweight</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">1770</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">155</td>
<td style="text-align: left;">Lightweight</td>
<td style="text-align: right;">75</td>
<td style="text-align: right;">3.66</td>
<td style="text-align: right;">3.12</td>
<td style="text-align: right;">0.46</td>
<td style="text-align: right;">0.51</td>
<td style="text-align: right;">1.17</td>
<td style="text-align: right;">0.33</td>
<td style="text-align: right;">0.48</td>
<td style="text-align: right;">1.2</td>
<td style="text-align: right;">6</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Luke Sanders</td>
<td style="text-align: left;">2018-08-25</td>
<td style="text-align: left;">UFC Fight Night: Gaethje vs. Vick</td>
<td style="text-align: left;">Lincoln</td>
<td style="text-align: left;">Nebraska</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Bantamweight</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">2.00</td>
<td style="text-align: right;">2.00</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">2261</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">135</td>
<td style="text-align: left;">Bantamweight</td>
<td style="text-align: right;">67</td>
<td style="text-align: right;">6.21</td>
<td style="text-align: right;">4.11</td>
<td style="text-align: right;">0.51</td>
<td style="text-align: right;">0.53</td>
<td style="text-align: right;">0.31</td>
<td style="text-align: right;">0.20</td>
<td style="text-align: right;">0.66</td>
<td style="text-align: right;">0.3</td>
<td style="text-align: right;">6</td>
</tr>
<tr class="even">
<td style="text-align: left;">Magomed Mustafaev</td>
<td style="text-align: left;">2019-04-20</td>
<td style="text-align: left;">UFC Fight Night: Overeem vs. Oleinik</td>
<td style="text-align: left;">Saint Petersburg</td>
<td style="text-align: left;">Saint Petersburg</td>
<td style="text-align: left;">Russia</td>
<td style="text-align: left;">Lightweight</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">2.25</td>
<td style="text-align: right;">2.25</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">1806</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">155</td>
<td style="text-align: left;">Lightweight</td>
<td style="text-align: right;">71</td>
<td style="text-align: right;">2.59</td>
<td style="text-align: right;">2.68</td>
<td style="text-align: right;">0.58</td>
<td style="text-align: right;">0.41</td>
<td style="text-align: right;">3.31</td>
<td style="text-align: right;">0.50</td>
<td style="text-align: right;">0.23</td>
<td style="text-align: right;">0.4</td>
<td style="text-align: right;">5</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Matthew Semelsberger</td>
<td style="text-align: left;">2020-08-22</td>
<td style="text-align: left;">UFC Fight Night: Munhoz vs. Edgar</td>
<td style="text-align: left;">Las Vegas</td>
<td style="text-align: left;">Nevada</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Welterweight</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">2887</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">170</td>
<td style="text-align: left;">Welterweight</td>
<td style="text-align: right;">75</td>
<td style="text-align: right;">7.93</td>
<td style="text-align: right;">5.31</td>
<td style="text-align: right;">0.50</td>
<td style="text-align: right;">0.56</td>
<td style="text-align: right;">1.97</td>
<td style="text-align: right;">1.00</td>
<td style="text-align: right;">1.00</td>
<td style="text-align: right;">1.0</td>
<td style="text-align: right;">1</td>
</tr>
<tr class="even">
<td style="text-align: left;">Misha Cirkunov</td>
<td style="text-align: left;">2016-12-10</td>
<td style="text-align: left;">UFC 206: Holloway vs. Pettis</td>
<td style="text-align: left;">Toronto</td>
<td style="text-align: left;">Ontario</td>
<td style="text-align: left;">Canada</td>
<td style="text-align: left;">Light Heavyweight</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">1.88</td>
<td style="text-align: right;">1.88</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">2047</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">205</td>
<td style="text-align: left;">Light Heavyweight</td>
<td style="text-align: right;">77</td>
<td style="text-align: right;">4.18</td>
<td style="text-align: right;">3.22</td>
<td style="text-align: right;">0.51</td>
<td style="text-align: right;">0.60</td>
<td style="text-align: right;">4.28</td>
<td style="text-align: right;">0.57</td>
<td style="text-align: right;">0.71</td>
<td style="text-align: right;">2.3</td>
<td style="text-align: right;">9</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Nikita Krylov</td>
<td style="text-align: left;">2016-12-10</td>
<td style="text-align: left;">UFC 206: Holloway vs. Pettis</td>
<td style="text-align: left;">Toronto</td>
<td style="text-align: left;">Ontario</td>
<td style="text-align: left;">Canada</td>
<td style="text-align: left;">Light Heavyweight</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">1.88</td>
<td style="text-align: right;">1.88</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">2047</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">205</td>
<td style="text-align: left;">Light Heavyweight</td>
<td style="text-align: right;">77</td>
<td style="text-align: right;">4.33</td>
<td style="text-align: right;">2.52</td>
<td style="text-align: right;">0.56</td>
<td style="text-align: right;">0.43</td>
<td style="text-align: right;">1.34</td>
<td style="text-align: right;">0.33</td>
<td style="text-align: right;">0.55</td>
<td style="text-align: right;">1.3</td>
<td style="text-align: right;">11</td>
</tr>
<tr class="even">
<td style="text-align: left;">Ovince Saint Preux</td>
<td style="text-align: left;">2015-08-08</td>
<td style="text-align: left;">UFC Fight Night: Teixeira vs Saint Preux</td>
<td style="text-align: left;">Nashville</td>
<td style="text-align: left;">Tennessee</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Light Heavyweight</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">1.95</td>
<td style="text-align: right;">1.95</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">1093</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">205</td>
<td style="text-align: left;">Light Heavyweight</td>
<td style="text-align: right;">80</td>
<td style="text-align: right;">2.68</td>
<td style="text-align: right;">3.03</td>
<td style="text-align: right;">0.46</td>
<td style="text-align: right;">0.45</td>
<td style="text-align: right;">1.19</td>
<td style="text-align: right;">0.40</td>
<td style="text-align: right;">0.66</td>
<td style="text-align: right;">0.6</td>
<td style="text-align: right;">21</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Paulo Costa</td>
<td style="text-align: left;">2018-07-07</td>
<td style="text-align: left;">UFC 226: Miocic vs. Cormier</td>
<td style="text-align: left;">Las Vegas</td>
<td style="text-align: left;">Nevada</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Middleweight</td>
<td style="text-align: right;">2</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">2199</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">185</td>
<td style="text-align: left;">Middleweight</td>
<td style="text-align: right;">72</td>
<td style="text-align: right;">7.03</td>
<td style="text-align: right;">6.70</td>
<td style="text-align: right;">0.57</td>
<td style="text-align: right;">0.50</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.80</td>
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">5</td>
</tr>
<tr class="even">
<td style="text-align: left;">Paulo Costa</td>
<td style="text-align: left;">2017-11-04</td>
<td style="text-align: left;">UFC 217: Bisping vs. St-Pierre</td>
<td style="text-align: left;">New York City</td>
<td style="text-align: left;">New York</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Middleweight</td>
<td style="text-align: right;">2</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">2198</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">185</td>
<td style="text-align: left;">Middleweight</td>
<td style="text-align: right;">72</td>
<td style="text-align: right;">7.03</td>
<td style="text-align: right;">6.70</td>
<td style="text-align: right;">0.57</td>
<td style="text-align: right;">0.50</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.80</td>
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">5</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Rafael Fiziev</td>
<td style="text-align: left;">2019-04-20</td>
<td style="text-align: left;">UFC Fight Night: Overeem vs. Oleinik</td>
<td style="text-align: left;">Saint Petersburg</td>
<td style="text-align: left;">Saint Petersburg</td>
<td style="text-align: left;">Russia</td>
<td style="text-align: left;">Lightweight</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">2.25</td>
<td style="text-align: right;">2.25</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">1806</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">155</td>
<td style="text-align: left;">Lightweight</td>
<td style="text-align: right;">71</td>
<td style="text-align: right;">4.67</td>
<td style="text-align: right;">4.17</td>
<td style="text-align: right;">0.57</td>
<td style="text-align: right;">0.55</td>
<td style="text-align: right;">0.84</td>
<td style="text-align: right;">0.50</td>
<td style="text-align: right;">1.00</td>
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">2</td>
</tr>
<tr class="even">
<td style="text-align: left;">Rani Yahya</td>
<td style="text-align: left;">2018-08-25</td>
<td style="text-align: left;">UFC Fight Night: Gaethje vs. Vick</td>
<td style="text-align: left;">Lincoln</td>
<td style="text-align: left;">Nebraska</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Bantamweight</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">2.00</td>
<td style="text-align: right;">2.00</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">2261</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">135</td>
<td style="text-align: left;">Bantamweight</td>
<td style="text-align: right;">67</td>
<td style="text-align: right;">1.57</td>
<td style="text-align: right;">1.70</td>
<td style="text-align: right;">0.37</td>
<td style="text-align: right;">0.50</td>
<td style="text-align: right;">2.89</td>
<td style="text-align: right;">0.33</td>
<td style="text-align: right;">0.24</td>
<td style="text-align: right;">2.0</td>
<td style="text-align: right;">10</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Robbie Lawler</td>
<td style="text-align: left;">2016-01-02</td>
<td style="text-align: left;">UFC 195: Lawler vs Condit</td>
<td style="text-align: left;">Las Vegas</td>
<td style="text-align: left;">Nevada</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Welterweight</td>
<td style="text-align: right;">5</td>
<td style="text-align: left;">S-DEC</td>
<td style="text-align: right;">1.95</td>
<td style="text-align: right;">1.95</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">2336</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">170</td>
<td style="text-align: left;">Welterweight</td>
<td style="text-align: right;">74</td>
<td style="text-align: right;">3.50</td>
<td style="text-align: right;">4.16</td>
<td style="text-align: right;">0.45</td>
<td style="text-align: right;">0.60</td>
<td style="text-align: right;">0.68</td>
<td style="text-align: right;">0.64</td>
<td style="text-align: right;">0.64</td>
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">12</td>
</tr>
<tr class="even">
<td style="text-align: left;">Sean Woodson</td>
<td style="text-align: left;">2019-10-18</td>
<td style="text-align: left;">UFC Fight Night: Reyes vs. Weidman</td>
<td style="text-align: left;">Boston</td>
<td style="text-align: left;">Massachusetts</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Featherweight</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">2.00</td>
<td style="text-align: right;">2.00</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">2486</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">145</td>
<td style="text-align: left;">Featherweight</td>
<td style="text-align: right;">78</td>
<td style="text-align: right;">6.40</td>
<td style="text-align: right;">4.43</td>
<td style="text-align: right;">0.45</td>
<td style="text-align: right;">0.58</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.77</td>
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">2</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Steve Garcia</td>
<td style="text-align: left;">2020-02-29</td>
<td style="text-align: left;">UFC Fight Night: Benavidez vs. Figueiredo</td>
<td style="text-align: left;">Norfolk</td>
<td style="text-align: left;">Virginia</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Lightweight</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">1770</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">155</td>
<td style="text-align: left;">Lightweight</td>
<td style="text-align: right;">75</td>
<td style="text-align: right;">4.31</td>
<td style="text-align: right;">2.52</td>
<td style="text-align: right;">0.55</td>
<td style="text-align: right;">0.36</td>
<td style="text-align: right;">0.61</td>
<td style="text-align: right;">0.25</td>
<td style="text-align: right;">1.00</td>
<td style="text-align: right;">0.6</td>
<td style="text-align: right;">1</td>
</tr>
<tr class="even">
<td style="text-align: left;">Takanori Gomi</td>
<td style="text-align: left;">2017-09-22</td>
<td style="text-align: left;">UFC Fight Night: Saint Preux vs. Okami</td>
<td style="text-align: left;">Saitama</td>
<td style="text-align: left;">Saitama</td>
<td style="text-align: left;">Japan</td>
<td style="text-align: left;">Lightweight</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">849</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">155</td>
<td style="text-align: left;">Lightweight</td>
<td style="text-align: right;">70</td>
<td style="text-align: right;">3.81</td>
<td style="text-align: right;">3.52</td>
<td style="text-align: right;">0.41</td>
<td style="text-align: right;">0.60</td>
<td style="text-align: right;">1.23</td>
<td style="text-align: right;">0.65</td>
<td style="text-align: right;">0.63</td>
<td style="text-align: right;">0.8</td>
<td style="text-align: right;">6</td>
</tr>
<tr class="odd">
<td style="text-align: left;">TJ Laramie</td>
<td style="text-align: left;">2020-09-19</td>
<td style="text-align: left;">UFC Fight Night: Covington vs. Woodley</td>
<td style="text-align: left;">Las Vegas</td>
<td style="text-align: left;">Nevada</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Featherweight</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">715</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">145</td>
<td style="text-align: left;">Featherweight</td>
<td style="text-align: right;">66</td>
<td style="text-align: right;">2.73</td>
<td style="text-align: right;">3.24</td>
<td style="text-align: right;">0.51</td>
<td style="text-align: right;">0.26</td>
<td style="text-align: right;">2.56</td>
<td style="text-align: right;">0.50</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">1</td>
</tr>
<tr class="even">
<td style="text-align: left;">Tom Breese</td>
<td style="text-align: left;">2020-10-10</td>
<td style="text-align: left;">UFC Fight Night: Moraes vs. Sandhagen</td>
<td style="text-align: left;">Abu Dhabi</td>
<td style="text-align: left;">Abu Dhabi</td>
<td style="text-align: left;">United Arab Emirates</td>
<td style="text-align: left;">Middleweight</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">2678</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">185</td>
<td style="text-align: left;">Middleweight</td>
<td style="text-align: right;">73</td>
<td style="text-align: right;">3.34</td>
<td style="text-align: right;">2.81</td>
<td style="text-align: right;">0.50</td>
<td style="text-align: right;">0.60</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.70</td>
<td style="text-align: right;">1.1</td>
<td style="text-align: right;">8</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Tony Kelley</td>
<td style="text-align: left;">2020-10-10</td>
<td style="text-align: left;">UFC Fight Night: Moraes vs. Sandhagen</td>
<td style="text-align: left;">Abu Dhabi</td>
<td style="text-align: left;">Abu Dhabi</td>
<td style="text-align: left;">United Arab Emirates</td>
<td style="text-align: left;">Bantamweight</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">2694</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">135</td>
<td style="text-align: left;">Bantamweight</td>
<td style="text-align: right;">70</td>
<td style="text-align: right;">4.57</td>
<td style="text-align: right;">4.77</td>
<td style="text-align: right;">0.47</td>
<td style="text-align: right;">0.43</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.50</td>
<td style="text-align: right;">2.0</td>
<td style="text-align: right;">2</td>
</tr>
<tr class="even">
<td style="text-align: left;">Travis Browne</td>
<td style="text-align: left;">2017-07-08</td>
<td style="text-align: left;">UFC 213: Romero vs. Whittaker</td>
<td style="text-align: left;">Las Vegas</td>
<td style="text-align: left;">Nevada</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Heavyweight</td>
<td style="text-align: right;">2</td>
<td style="text-align: left;">SUB</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">62</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">255</td>
<td style="text-align: left;">Heavyweight</td>
<td style="text-align: right;">79</td>
<td style="text-align: right;">2.93</td>
<td style="text-align: right;">4.31</td>
<td style="text-align: right;">0.41</td>
<td style="text-align: right;">0.42</td>
<td style="text-align: right;">1.21</td>
<td style="text-align: right;">0.68</td>
<td style="text-align: right;">0.75</td>
<td style="text-align: right;">0.2</td>
<td style="text-align: right;">10</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Uriah Hall</td>
<td style="text-align: left;">2018-07-07</td>
<td style="text-align: left;">UFC 226: Miocic vs. Cormier</td>
<td style="text-align: left;">Las Vegas</td>
<td style="text-align: left;">Nevada</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Middleweight</td>
<td style="text-align: right;">2</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">2199</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">185</td>
<td style="text-align: left;">Middleweight</td>
<td style="text-align: right;">79</td>
<td style="text-align: right;">3.34</td>
<td style="text-align: right;">3.54</td>
<td style="text-align: right;">0.51</td>
<td style="text-align: right;">0.53</td>
<td style="text-align: right;">0.67</td>
<td style="text-align: right;">0.38</td>
<td style="text-align: right;">0.69</td>
<td style="text-align: right;">0.2</td>
<td style="text-align: right;">14</td>
</tr>
<tr class="even">
<td style="text-align: left;">Uriah Hall</td>
<td style="text-align: left;">2018-12-29</td>
<td style="text-align: left;">UFC 232: Jones vs. Gustafsson 2</td>
<td style="text-align: left;">Los Angeles</td>
<td style="text-align: left;">California</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Middleweight</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">2881</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">185</td>
<td style="text-align: left;">Middleweight</td>
<td style="text-align: right;">79</td>
<td style="text-align: right;">3.34</td>
<td style="text-align: right;">3.54</td>
<td style="text-align: right;">0.51</td>
<td style="text-align: right;">0.53</td>
<td style="text-align: right;">0.67</td>
<td style="text-align: right;">0.38</td>
<td style="text-align: right;">0.69</td>
<td style="text-align: right;">0.2</td>
<td style="text-align: right;">14</td>
</tr>
<tr class="odd">
<td style="text-align: left;">William Knight</td>
<td style="text-align: left;">2021-04-10</td>
<td style="text-align: left;">UFC Fight Night: Vettori vs. Holland</td>
<td style="text-align: left;">Las Vegas</td>
<td style="text-align: left;">Nevada</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Light Heavyweight</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">3039</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">205</td>
<td style="text-align: left;">Light Heavyweight</td>
<td style="text-align: right;">73</td>
<td style="text-align: right;">3.56</td>
<td style="text-align: right;">2.56</td>
<td style="text-align: right;">0.74</td>
<td style="text-align: right;">0.34</td>
<td style="text-align: right;">2.56</td>
<td style="text-align: right;">0.53</td>
<td style="text-align: right;">0.40</td>
<td style="text-align: right;">0.3</td>
<td style="text-align: right;">2</td>
</tr>
<tr class="even">
<td style="text-align: left;">Wu Yanan</td>
<td style="text-align: left;">2017-11-25</td>
<td style="text-align: left;">UFC Fight Night: Bisping vs. Gastelum</td>
<td style="text-align: left;">Shanghai</td>
<td style="text-align: left;">Hebei</td>
<td style="text-align: left;">China</td>
<td style="text-align: left;">Bantamweight</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">U-DEC</td>
<td style="text-align: right;">2.25</td>
<td style="text-align: right;">2.25</td>
<td style="text-align: left;">Female</td>
<td style="text-align: left;">1087</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">125</td>
<td style="text-align: left;">Flyweight</td>
<td style="text-align: right;">66</td>
<td style="text-align: right;">4.51</td>
<td style="text-align: right;">4.82</td>
<td style="text-align: right;">0.45</td>
<td style="text-align: right;">0.51</td>
<td style="text-align: right;">0.61</td>
<td style="text-align: right;">0.22</td>
<td style="text-align: right;">0.66</td>
<td style="text-align: right;">0.3</td>
<td style="text-align: right;">3</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Yorgan De Castro</td>
<td style="text-align: left;">2021-04-10</td>
<td style="text-align: left;">UFC Fight Night: Vettori vs. Holland</td>
<td style="text-align: left;">Las Vegas</td>
<td style="text-align: left;">Nevada</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Heavyweight</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Male</td>
<td style="text-align: left;">1288</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">250</td>
<td style="text-align: left;">Heavyweight</td>
<td style="text-align: right;">74</td>
<td style="text-align: right;">2.46</td>
<td style="text-align: right;">3.85</td>
<td style="text-align: right;">0.43</td>
<td style="text-align: right;">0.53</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.77</td>
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">3</td>
</tr>
<tr class="even">
<td style="text-align: left;">Zarah Fairn</td>
<td style="text-align: left;">2020-02-29</td>
<td style="text-align: left;">UFC Fight Night: Benavidez vs. Figueiredo</td>
<td style="text-align: left;">Norfolk</td>
<td style="text-align: left;">Virginia</td>
<td style="text-align: left;">USA</td>
<td style="text-align: left;">Featherweight</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">KO/TKO</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: right;">Inf</td>
<td style="text-align: left;">Female</td>
<td style="text-align: left;">974</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">135</td>
<td style="text-align: left;">Bantamweight</td>
<td style="text-align: right;">72</td>
<td style="text-align: right;">1.98</td>
<td style="text-align: right;">6.61</td>
<td style="text-align: right;">0.45</td>
<td style="text-align: right;">0.39</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.50</td>
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">1</td>
</tr>
</tbody>
</table>

Filter out controversial results (DQ and Overturned) and equal odds.

    df_stats %>%
      dplyr::filter(
        (Method != "DQ") & (Method != "Overturned")
        , Winner_Odds != Loser_Odds
        , Num_Fights >= fight_min
      ) -> df_stats

How many rows do we lose?

    nrow(df_master) - nrow(df_stats)

    ## [1] 112

Also convert infinite odds to NAs.

    df_stats %>%
      dplyr::mutate(
        Winner_Odds = ifelse(is.infinite(Winner_Odds), NA, Winner_Odds)
        , Loser_Odds = ifelse(is.infinite(Loser_Odds), NA, Loser_Odds)
      ) -> df_stats

Get rid of lonely fight ids (i.e. instances where one of the two
competitiors was removed from the dataset).

    df_stats %>%
      dplyr::group_by(fight_id) %>%
      dplyr::summarise(Count = length(NAME)) %>%
      dplyr::filter(Count != 2) -> lonely_ids

    idx_lonely_ids = lonely_ids$fight_id

    df_stats = df_stats[!(df_stats$fight_id %in% idx_lonely_ids), ]

How many additional rows do we lose?

    length(idx_lonely_ids)

    ## [1] 0

What percentage of fights, from those that were succesfully scrapped, do
we keep?

    length(unique(df_stats$fight_id)) / length(unique(df_master$fight_id)) 

    ## [1] 0.9816032

How many fights are we left with?

    length(unique(df_stats$fight_id))

    ## [1] 2988

Over what period of time?

    range(df_stats$Date)

    ## [1] "2013-04-27" "2021-04-17"

How many fights per Year?

    df_stats %>%
      dplyr::mutate(
        Year = as.numeric(format(Date,"%Y"), ordered = T)
      ) %>%
      dplyr::group_by(Year) %>%
      dplyr::summarise(
        count = length(unique(fight_id))
      ) -> df_year_count

    kable(df_year_count)

<table>
<thead>
<tr class="header">
<th style="text-align: right;">Year</th>
<th style="text-align: right;">count</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: right;">2013</td>
<td style="text-align: right;">113</td>
</tr>
<tr class="even">
<td style="text-align: right;">2014</td>
<td style="text-align: right;">305</td>
</tr>
<tr class="odd">
<td style="text-align: right;">2015</td>
<td style="text-align: right;">444</td>
</tr>
<tr class="even">
<td style="text-align: right;">2016</td>
<td style="text-align: right;">479</td>
</tr>
<tr class="odd">
<td style="text-align: right;">2017</td>
<td style="text-align: right;">367</td>
</tr>
<tr class="even">
<td style="text-align: right;">2018</td>
<td style="text-align: right;">396</td>
</tr>
<tr class="odd">
<td style="text-align: right;">2019</td>
<td style="text-align: right;">399</td>
</tr>
<tr class="even">
<td style="text-align: right;">2020</td>
<td style="text-align: right;">403</td>
</tr>
<tr class="odd">
<td style="text-align: right;">2021</td>
<td style="text-align: right;">82</td>
</tr>
</tbody>
</table>

Create additional columns to frame everything vis-a-vis favorite.

    df_stats %>%
      dplyr::mutate(
        Favorite_Won = ifelse(Winner_Odds < Loser_Odds, T, F)
        , Was_Favorite = ifelse(
          (Result == "Winner" & Favorite_Won)|(Result == "Loser" & !Favorite_Won)
          , T
          , F
          )
      ) -> df_stats

Get odds and transform probability to logit space.

    df_stats %>%
      dplyr::mutate(
        fighter_odds = ifelse(Result == "Winner", Winner_Odds, Loser_Odds)
        , implied_prob = 1/fighter_odds
        , logit_prob = qlogis(1/fighter_odds)
        , Year = as.numeric(format(Date,"%Y"))
      ) -> df_stats

<br>

### Visualize Data

Many of the stats are repeated several times due to fighters having
several fights. Ideally we would account for this but for the purpose of
visualizing the data to get an idea of what we are dealing with, we
won’t bother.

Later on, the predictors will end up being the difference in stats
between fighters. Since most fights are not re-matches, there will not
be a major concern.

    df_stats %>%
      dplyr::select(
        fight_id
        , Sex
        , Favorite_Won
        , Was_Favorite
        , Result
        , Year
        , REACH
        , implied_prob
        , logit_prob
      ) -> df_for_graph

Examine correlations among potential predictors. There do not appear to
be any notable correlations.

    df_cor = cor(df_for_graph[6:9], method = c("spearman"), use = "na.or.complete")
    corrplot(df_cor)

![](/AttM/rmd_images/2021-04-24-bayesian_logistic_regression_analysis/unnamed-chunk-26-1.png)

    df_cor

    ##                    Year       REACH implied_prob  logit_prob
    ## Year          1.0000000 -0.01396640  -0.02148670 -0.02148670
    ## REACH        -0.0139664  1.00000000   0.03274692  0.03274692
    ## implied_prob -0.0214867  0.03274692   1.00000000  1.00000000
    ## logit_prob   -0.0214867  0.03274692   1.00000000  1.00000000

Visualize the relationship between the Implied Probabilities of the odds
in original and transformed space. The graph also gives a sense of the
distribution of the Implied Probabilities and the number of them which
start racing towards to edges of transformed space (i.e. distortions
close to the limits of the original scale).

    df_for_graph %>%
      ggplot(aes(x=implied_prob, y=logit_prob))+
      geom_point()+
      geom_smooth(se = F, method = "lm")+
      ylab("Logit Implied Probability")+
      xlab("Implied Probability")

![](/AttM/rmd_images/2021-04-24-bayesian_logistic_regression_analysis/unnamed-chunk-27-1.png)

Create function to visualize data as boxplots.

    boxplot_df_for_graph = function(df = df_for_graph, grouping = "Was_Favorite") {
      df$Grouping = df[,which(colnames(df) == grouping)]
      
      df %>%
        gather(key = "Metric", value = "Value", REACH:logit_prob) %>%
        ggplot(aes(x=Grouping, y=Value, group = Grouping, color = Grouping))+
        geom_boxplot()+
        labs(color = grouping) +
        xlab(grouping)+
        facet_wrap(.~Metric, scales = "free", nrow = 2) -> gg
      print(gg)
      
    }

Examine distribution of predictors as a function of which fighter was
the favorite.

    boxplot_df_for_graph()

![](/AttM/rmd_images/2021-04-24-bayesian_logistic_regression_analysis/unnamed-chunk-29-1.png)

Examine distribution of predictors as a function of who won.

    boxplot_df_for_graph(grouping = "Result")

![](/AttM/rmd_images/2021-04-24-bayesian_logistic_regression_analysis/unnamed-chunk-30-1.png)

Examine distribution of predictors as a function of Sex.

    boxplot_df_for_graph(grouping = "Sex")

![](/AttM/rmd_images/2021-04-24-bayesian_logistic_regression_analysis/unnamed-chunk-31-1.png)

Examine distribution of predictors as a function of Year.

    boxplot_df_for_graph(grouping = "Year")

![](/AttM/rmd_images/2021-04-24-bayesian_logistic_regression_analysis/unnamed-chunk-32-1.png)

Examine distribution of potential predictors. Of course, the
distributions of Implied Probabilities are missing their peaks due to
the removal of fights with equal odds.

Otherwise, Reach is somewhat normally distributed.

    df_for_graph %>%
      gather(key = "Metric", value = "Value", Year:logit_prob) %>%
      ggplot(aes(x=Value))+
      geom_histogram()+
      facet_wrap(.~Metric, scales = "free", nrow = 3)

![](/AttM/rmd_images/2021-04-24-bayesian_logistic_regression_analysis/unnamed-chunk-33-1.png)

<br>

### Compute Differences between Fighters

Create separate data frames for favorites and underdogs, then merge
them.

    # Favorites
    df_stats %>%
      dplyr::filter(Was_Favorite) %>%
      dplyr::select(
        fight_id
        , Sex
        , Favorite_Won
        , Year
        , REACH
        , implied_prob 
        , logit_prob
        ) -> df_favs

    # Underdogs
    df_stats %>%
      dplyr::filter(!Was_Favorite) %>%
      dplyr::select(
        fight_id
        , Sex
        , Favorite_Won
        , Year
        , REACH
        , implied_prob
        , logit_prob
      ) -> df_under
    # rename
    df_under %>%
      rename(
        U_REACH = REACH
        , U_implied_prob = implied_prob
        , U_logit_prob = logit_prob
      ) -> df_under

    # Merge
    df_both = merge(df_under, df_favs)

Examine new dataframe.

    summary(df_both)

    ##     fight_id        Sex       Favorite_Won         Year         U_REACH     
    ##  1      :   1   Female: 385   Mode :logical   Min.   :2013   Min.   :58.00  
    ##  2      :   1   Male  :2603   FALSE:1057      1st Qu.:2015   1st Qu.:69.00  
    ##  3      :   1                 TRUE :1931      Median :2017   Median :72.00  
    ##  4      :   1                                 Mean   :2017   Mean   :71.62  
    ##  5      :   1                                 3rd Qu.:2019   3rd Qu.:75.00  
    ##  6      :   1                                 Max.   :2021   Max.   :84.00  
    ##  (Other):2982                                                NA's   :159    
    ##  U_implied_prob     U_logit_prob          REACH        implied_prob   
    ##  Min.   :0.07117   Min.   :-2.56879   Min.   :60.00   Min.   :0.4000  
    ##  1st Qu.:0.27548   1st Qu.:-0.96698   1st Qu.:69.00   1st Qu.:0.5780  
    ##  Median :0.36101   Median :-0.57098   Median :72.00   Median :0.6410  
    ##  Mean   :0.34701   Mean   :-0.67036   Mean   :71.87   Mean   :0.6576  
    ##  3rd Qu.:0.42553   3rd Qu.:-0.30010   3rd Qu.:75.00   3rd Qu.:0.7299  
    ##  Max.   :0.52356   Max.   : 0.09431   Max.   :84.00   Max.   :0.9434  
    ##                                       NA's   :54                      
    ##    logit_prob     
    ##  Min.   :-0.4055  
    ##  1st Qu.: 0.3147  
    ##  Median : 0.5798  
    ##  Mean   : 0.6948  
    ##  3rd Qu.: 0.9943  
    ##  Max.   : 2.8134  
    ## 

How many fights do we have?

    nrow(df_both)

    ## [1] 2988

How often does the favorite win?

    mean(df_both$Favorite_Won)

    ## [1] 0.6462517

Compute differences in Reach. Also, adjust for the overround.

    df_both %>%
      dplyr::group_by(fight_id) %>%
      dplyr::summarise(
        Favorite_Won=Favorite_Won
        , Sex=Sex
        , Year=Year
        , Delta_REACH = REACH - U_REACH
        , Log_Odds = logit_prob
        , Implied_Prob = implied_prob
        , Adjust_Implied_Prob = implied_prob - (implied_prob + U_implied_prob - 1)/2
      ) -> df_og_diff

Get Adjusted Log Odds.

    df_og_diff %>% 
      mutate(Adjust_Log_Odds = qlogis(Adjust_Implied_Prob)) -> df_og_diff

Examine new dataframe. Notice that Adjusted Implied Probabilities never
go under 0.5. Similarly, Adjusted Log Odds never go below 0.

    summary(df_og_diff)

    ##     fight_id    Favorite_Won        Sex            Year       Delta_REACH      
    ##  1      :   1   Mode :logical   Female: 385   Min.   :2013   Min.   :-10.0000  
    ##  2      :   1   FALSE:1057      Male  :2603   1st Qu.:2015   1st Qu.: -2.0000  
    ##  3      :   1   TRUE :1931                    Median :2017   Median :  0.0000  
    ##  4      :   1                                 Mean   :2017   Mean   :  0.2748  
    ##  5      :   1                                 3rd Qu.:2019   3rd Qu.:  2.0000  
    ##  6      :   1                                 Max.   :2021   Max.   : 12.0000  
    ##  (Other):2982                                                NA's   :211       
    ##     Log_Odds        Implied_Prob    Adjust_Implied_Prob Adjust_Log_Odds   
    ##  Min.   :-0.4055   Min.   :0.4000   Min.   :0.5012      Min.   :0.004782  
    ##  1st Qu.: 0.3147   1st Qu.:0.5780   1st Qu.:0.5778      1st Qu.:0.313771  
    ##  Median : 0.5798   Median :0.6410   Median :0.6406      Median :0.577952  
    ##  Mean   : 0.6948   Mean   :0.6576   Mean   :0.6553      Mean   :0.682173  
    ##  3rd Qu.: 0.9943   3rd Qu.:0.7299   3rd Qu.:0.7261      3rd Qu.:0.974797  
    ##  Max.   : 2.8134   Max.   :0.9434   Max.   :0.9327      Max.   :2.628868  
    ## 

Examine correlations among potential predictors.

    df_cor_diff = cor(df_og_diff[5:9], method = c("spearman"), use = "na.or.complete")
    corrplot(df_cor_diff)

![](/AttM/rmd_images/2021-04-24-bayesian_logistic_regression_analysis/unnamed-chunk-41-1.png)

    df_cor_diff

    ##                     Delta_REACH   Log_Odds Implied_Prob Adjust_Implied_Prob
    ## Delta_REACH          1.00000000 0.05662437   0.05662437          0.05569811
    ## Log_Odds             0.05662437 1.00000000   1.00000000          0.99449602
    ## Implied_Prob         0.05662437 1.00000000   1.00000000          0.99449602
    ## Adjust_Implied_Prob  0.05569811 0.99449602   0.99449602          1.00000000
    ## Adjust_Log_Odds      0.05569811 0.99449602   0.99449602          1.00000000
    ##                     Adjust_Log_Odds
    ## Delta_REACH              0.05569811
    ## Log_Odds                 0.99449602
    ## Implied_Prob             0.99449602
    ## Adjust_Implied_Prob      1.00000000
    ## Adjust_Log_Odds          1.00000000

Visualize the relationship between Log Odds and Adjusted Log Odds. The
red line is y=x whereas the blue line is the line of best fit.

The adjustments do not appear to vary with respect to Log Odds
(i.e. closer contests did not tend to have more overround than more
disperate ones, etc.).

    df_og_diff %>%
      ggplot(aes(x=Log_Odds, y=Adjust_Log_Odds))+
      geom_point()+
      geom_smooth(se = F, method = "lm")+
      geom_abline(slope=1, color = "red")+
      ylab("Adjusted Log Odds")+
      xlab("Log_Odds")

![](/AttM/rmd_images/2021-04-24-bayesian_logistic_regression_analysis/unnamed-chunk-42-1.png)

Plot similar graph for Implied Probabilities.

    df_og_diff %>%
      ggplot(aes(x=Implied_Prob, y=Adjust_Implied_Prob))+
      geom_point()+
      geom_smooth(se = F, method = "lm")+
      geom_abline(slope=1, color = "red")+
      ylab("Adjusted Implied Probability")+
      xlab("Implied Probability")

![](/AttM/rmd_images/2021-04-24-bayesian_logistic_regression_analysis/unnamed-chunk-43-1.png)

<br>

### Deal with Missing Values

    missing_reach <- round(mean(is.na(df_og_diff$Delta_REACH))*100)

How many Reach entries are missing? Around 7%.

    df_og_diff %>%
      select("Delta_REACH", "fight_id") -> df_for_amelia

    missmap(df_for_amelia)

![](/AttM/rmd_images/2021-04-24-bayesian_logistic_regression_analysis/unnamed-chunk-45-1.png)

Is there a relationship between missingness of Reach and actual values
of Reach? Based on the random sample below, fighters with no recorded
Reach appear to not be popular overall. Therefore, they are likely NOT
strong competitors on average. This will be something to keep in mind as
it could introduce some kind of bias into the dataset / results.

    df_master %>%
      dplyr::filter(is.na(REACH)) %>%
      dplyr::select(
      "Date"
      , "NAME"
      , "FightWeightClass"
      ) -> df_reach_nas 

    kable(df_reach_nas[sample(1:nrow(df_reach_nas), nrow(df_reach_nas)/10),])

<table>
<thead>
<tr class="header">
<th style="text-align: left;"></th>
<th style="text-align: left;">Date</th>
<th style="text-align: left;">NAME</th>
<th style="text-align: left;">FightWeightClass</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">192</td>
<td style="text-align: left;">2014-01-04</td>
<td style="text-align: left;">Shunichi Shimizu</td>
<td style="text-align: left;">Bantamweight</td>
</tr>
<tr class="even">
<td style="text-align: left;">159</td>
<td style="text-align: left;">2014-10-04</td>
<td style="text-align: left;">Niklas Backstrom</td>
<td style="text-align: left;">Featherweight</td>
</tr>
<tr class="odd">
<td style="text-align: left;">85</td>
<td style="text-align: left;">2017-01-28</td>
<td style="text-align: left;">JC Cottrell</td>
<td style="text-align: left;">Lightweight</td>
</tr>
<tr class="even">
<td style="text-align: left;">43</td>
<td style="text-align: left;">2017-10-28</td>
<td style="text-align: left;">Christian Colombo</td>
<td style="text-align: left;">Heavyweight</td>
</tr>
<tr class="odd">
<td style="text-align: left;">4</td>
<td style="text-align: left;">2016-05-29</td>
<td style="text-align: left;">Alberto Uda</td>
<td style="text-align: left;">Middleweight</td>
</tr>
<tr class="even">
<td style="text-align: left;">158</td>
<td style="text-align: left;">2015-06-20</td>
<td style="text-align: left;">Niklas Backstrom</td>
<td style="text-align: left;">Featherweight</td>
</tr>
<tr class="odd">
<td style="text-align: left;">166</td>
<td style="text-align: left;">2013-11-30</td>
<td style="text-align: left;">Peggy Morgan</td>
<td style="text-align: left;">Bantamweight</td>
</tr>
<tr class="even">
<td style="text-align: left;">27</td>
<td style="text-align: left;">2015-11-07</td>
<td style="text-align: left;">Bruno Rodrigues</td>
<td style="text-align: left;">Bantamweight</td>
</tr>
<tr class="odd">
<td style="text-align: left;">70</td>
<td style="text-align: left;">2016-04-10</td>
<td style="text-align: left;">Filip Pejic</td>
<td style="text-align: left;">Bantamweight</td>
</tr>
<tr class="even">
<td style="text-align: left;">123</td>
<td style="text-align: left;">2016-02-21</td>
<td style="text-align: left;">Kelly Faszholz</td>
<td style="text-align: left;">Bantamweight</td>
</tr>
<tr class="odd">
<td style="text-align: left;">106</td>
<td style="text-align: left;">2016-08-06</td>
<td style="text-align: left;">Joseph Gigliotti</td>
<td style="text-align: left;">Middleweight</td>
</tr>
<tr class="even">
<td style="text-align: left;">69</td>
<td style="text-align: left;">2016-07-08</td>
<td style="text-align: left;">Fernando Bruno</td>
<td style="text-align: left;">Featherweight</td>
</tr>
<tr class="odd">
<td style="text-align: left;">65</td>
<td style="text-align: left;">2013-12-28</td>
<td style="text-align: left;">Estevan Payan</td>
<td style="text-align: left;">Featherweight</td>
</tr>
<tr class="even">
<td style="text-align: left;">148</td>
<td style="text-align: left;">2016-07-07</td>
<td style="text-align: left;">Mehdi Baghdad</td>
<td style="text-align: left;">Lightweight</td>
</tr>
<tr class="odd">
<td style="text-align: left;">119</td>
<td style="text-align: left;">2017-10-07</td>
<td style="text-align: left;">Kalindra Faria</td>
<td style="text-align: left;">Flyweight</td>
</tr>
<tr class="even">
<td style="text-align: left;">214</td>
<td style="text-align: left;">2015-09-26</td>
<td style="text-align: left;">Yusuke Kasuya</td>
<td style="text-align: left;">Lightweight</td>
</tr>
<tr class="odd">
<td style="text-align: left;">39</td>
<td style="text-align: left;">2014-11-15</td>
<td style="text-align: left;">Chris Heatherly</td>
<td style="text-align: left;">Welterweight</td>
</tr>
<tr class="even">
<td style="text-align: left;">154</td>
<td style="text-align: left;">2016-11-19</td>
<td style="text-align: left;">Milana Dudieva</td>
<td style="text-align: left;">Bantamweight</td>
</tr>
<tr class="odd">
<td style="text-align: left;">194</td>
<td style="text-align: left;">2015-08-08</td>
<td style="text-align: left;">Sirwan Kakai</td>
<td style="text-align: left;">Bantamweight</td>
</tr>
<tr class="even">
<td style="text-align: left;">167</td>
<td style="text-align: left;">2014-01-04</td>
<td style="text-align: left;">Quinn Mulhern</td>
<td style="text-align: left;">Lightweight</td>
</tr>
<tr class="odd">
<td style="text-align: left;">5</td>
<td style="text-align: left;">2017-02-19</td>
<td style="text-align: left;">Alex Ricci</td>
<td style="text-align: left;">Lightweight</td>
</tr>
</tbody>
</table>

Compare the summaries of the subset of data without NAs to the one with
NAs to identify notable differences.

    df_og_diff %>%
      dplyr::filter(is.na(Delta_REACH)) -> df_nas

    df_og_diff %>%
      dplyr::filter(!is.na(Delta_REACH)) -> df_nonas

    summary(df_nas)

    ##     fight_id   Favorite_Won        Sex           Year       Delta_REACH 
    ##  1      :  1   Mode :logical   Female: 38   Min.   :2013   Min.   : NA  
    ##  4      :  1   FALSE:52        Male  :173   1st Qu.:2014   1st Qu.: NA  
    ##  39     :  1   TRUE :159                    Median :2015   Median : NA  
    ##  48     :  1                                Mean   :2015   Mean   :NaN  
    ##  78     :  1                                3rd Qu.:2016   3rd Qu.: NA  
    ##  90     :  1                                Max.   :2021   Max.   : NA  
    ##  (Other):205                                               NA's   :211  
    ##     Log_Odds         Implied_Prob    Adjust_Implied_Prob Adjust_Log_Odds  
    ##  Min.   :-0.07696   Min.   :0.4808   Min.   :0.5064      Min.   :0.02564  
    ##  1st Qu.: 0.37106   1st Qu.:0.5917   1st Qu.:0.5893      1st Qu.:0.36108  
    ##  Median : 0.61619   Median :0.6494   Median :0.6504      Median :0.62073  
    ##  Mean   : 0.73200   Mean   :0.6660   Mean   :0.6621      Mean   :0.71134  
    ##  3rd Qu.: 1.07881   3rd Qu.:0.7463   3rd Qu.:0.7389      3rd Qu.:1.04018  
    ##  Max.   : 2.40795   Max.   :0.9174   Max.   :0.9088      Max.   :2.29865  
    ## 

    summary(df_nonas)

    ##     fight_id    Favorite_Won        Sex            Year       Delta_REACH      
    ##  2      :   1   Mode :logical   Female: 347   Min.   :2013   Min.   :-10.0000  
    ##  3      :   1   FALSE:1005      Male  :2430   1st Qu.:2015   1st Qu.: -2.0000  
    ##  5      :   1   TRUE :1772                    Median :2017   Median :  0.0000  
    ##  6      :   1                                 Mean   :2017   Mean   :  0.2748  
    ##  7      :   1                                 3rd Qu.:2019   3rd Qu.:  2.0000  
    ##  8      :   1                                 Max.   :2021   Max.   : 12.0000  
    ##  (Other):2771                                                                  
    ##     Log_Odds        Implied_Prob    Adjust_Implied_Prob Adjust_Log_Odds   
    ##  Min.   :-0.4055   Min.   :0.4000   Min.   :0.5012      Min.   :0.004782  
    ##  1st Qu.: 0.3147   1st Qu.:0.5780   1st Qu.:0.5773      1st Qu.:0.311586  
    ##  Median : 0.5798   Median :0.6410   Median :0.6399      Median :0.574930  
    ##  Mean   : 0.6919   Mean   :0.6570   Mean   :0.6548      Mean   :0.679957  
    ##  3rd Qu.: 0.9676   3rd Qu.:0.7246   3rd Qu.:0.7248      3rd Qu.:0.968347  
    ##  Max.   : 2.8134   Max.   :0.9434   Max.   :0.9327      Max.   :2.628868  
    ## 

Favorites appear to be more likely to win when Reach is NA despite not
being substantially more favored (see above).

    mean(df_nas$Favorite_Won) - mean(df_nonas$Favorite_Won)

    ## [1] 0.1154558

Using original dataset, look at if those without Reach entry tend to be
favored or not. Indeed they tended to be the underdogs. Therefore, it
seems like those with Reach NAs tend to underperform relative to their
odds, when considering the above. As such, removing entries with missing
Reach data in a future analysis could affect the results.

    df_stats %>%
      dplyr::filter(is.na(REACH)) -> df_nas_odds 

    mean(df_nas_odds$implied_prob)

    ## [1] 0.4031639

    mean(df_nas_odds$Was_Favorite)

    ## [1] 0.2535211

Also, the fights with Reach NAs are a couple years older on average.
This may be due to improved stats collection and tracking through the
years.

    mean(df_nas$Year) - mean(df_nonas$Year)

    ## [1] -2.064192

I may consider a simple random imputation for the model with both Reach
and Log Odds as predictors, to avoid losing cases with higher rates of
underperformance.

<br>

### Visualize Difference Data

Create function to generate boxplots of difference data.

    # function for box plot
    boxplot_df_og_diff = function(df = df_og_diff, grouping = NULL, do_result = F) {
      
      if (is.null(grouping)) {
        
        if (do_result) {
          df %>%
            gather(key = "Metric", value = "Value", Delta_REACH:Adjust_Log_Odds) %>%
            dplyr::mutate(Value = ifelse(Favorite_Won, Value, -Value)) %>%  # THIS FLIPS SIGN 
            ggplot(aes(x=Metric, y=Value))+
            geom_boxplot()+
            facet_wrap(.~Metric, scales = "free", nrow = 2)+
            ggtitle("Winner - Loser") -> gg
        } else {
          df %>%
            gather(key = "Metric", value = "Value", Delta_REACH:Adjust_Log_Odds) %>%
            ggplot(aes(x=Metric, y=Value))+
            geom_boxplot()+
            facet_wrap(.~Metric, scales = "free", nrow = 2)+
            ggtitle("Favorite - Underdog") -> gg
        }
        

        
      } else {
        
        df$Grouping = df[,which(colnames(df) == grouping)][[1]]
        
        df %>%
          gather(key = "Metric", value = "Value", Delta_REACH:Adjust_Log_Odds) %>%
          ggplot(aes(x=Grouping, y=Value, group = Grouping, color = Grouping))+
          geom_boxplot()+
          labs(color = grouping) +
          xlab(grouping)+
          ggtitle("Favorite - Underdog")+
          facet_wrap(.~Metric, scales = "free", nrow = 2) -> gg
      }
      
      print(gg)
      
    }

Generate boxplots for potential predictors. I am including all versions
of Implied Probability/Log Odds to compare them. Of course, I will only
include one of these as a predictor in the model.

    boxplot_df_og_diff()

![](/AttM/rmd_images/2021-04-24-bayesian_logistic_regression_analysis/unnamed-chunk-52-1.png)

Compare predictors when the Favorite wins and loses.

    boxplot_df_og_diff(grouping = "Favorite_Won")

![](/AttM/rmd_images/2021-04-24-bayesian_logistic_regression_analysis/unnamed-chunk-53-1.png)

Compare predictors as a function of Sex.

    boxplot_df_og_diff(grouping = "Sex")

![](/AttM/rmd_images/2021-04-24-bayesian_logistic_regression_analysis/unnamed-chunk-54-1.png)

Compare predictors as a function of Year.

    boxplot_df_og_diff(grouping = "Year")

![](/AttM/rmd_images/2021-04-24-bayesian_logistic_regression_analysis/unnamed-chunk-55-1.png)

Modify predictors to look at difference in stats between Winner and
Loser (instead of Favorite and Underdog).

    boxplot_df_og_diff(do_result = T)

![](/AttM/rmd_images/2021-04-24-bayesian_logistic_regression_analysis/unnamed-chunk-56-1.png)

<br>

### Relationship between Predictors and Outcome

Create function to plot Outcome as a function of Predictors.

    # function
    plot_against_log_odds = function(df = df_og_diff, variable = "Log_Odds", pred_log_odds = F, num_bin = 20, min_bin_size = 30) {
      
      # create dummy variable for function
      df$Dummy = df[
        ,which(colnames(df) == sprintf("%s", variable))
      ][[1]]
      
      # as numeric
      df$Dummy = as.numeric(df$Dummy)
      
      # get bins
      df$Dummy_Bin = cut(df$Dummy, num_bin)
      
      
      # get log odds of Favorite victory by bin
      df %>%
        dplyr::group_by(Dummy_Bin) %>%
        dplyr::summarise(
          Prop_of_Victory = mean(Favorite_Won)
          , Log_Odds_Victory = logit(Prop_of_Victory)
          , Size_of_Bin = length(Favorite_Won)
          , Dummy = mean(Dummy)
        ) -> fav_perf
      
      # extract bins
      fav_labs <- as.character(fav_perf$Dummy_Bin) 
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
      
      if (pred_log_odds) {
        fav_perf %>%
        dplyr::filter(Size_of_Bin >= min_bin_size) %>%
        ggplot(aes(x=Dummy, y=Log_Odds_Victory))+
        geom_point()+
        geom_smooth(se=F , method="lm")+
        geom_abline(slope = 1, color = "red")+
        # geom_smooth()+
        ylab("Log Odds that Favorite Won")+
        xlab(sprintf("Mean %s", variable))->gg
      print(gg)
      } else {
          fav_perf %>%
          dplyr::filter(Size_of_Bin >= min_bin_size) %>%
          ggplot(aes(x=Dummy, y=Log_Odds_Victory))+
          geom_point()+
          geom_smooth(se=F , method="lm")+
          # geom_smooth()+
          ylab("Log Odds that Favorite Won")+
          xlab(sprintf("Mean %s", variable))->gg
        print(gg)
      }

      
    }

Unsurprisingly, the log odds of the implied probabilities are good
linear predictors of the actual log odds of victory. Importantly, the
Adjusted Log Odds appear to outperform the non-adjusted Log Odds.

    plot_against_log_odds(pred_log_odds = T)

![](/AttM/rmd_images/2021-04-24-bayesian_logistic_regression_analysis/unnamed-chunk-58-1.png)

    plot_against_log_odds(variable = "Adjust_Log_Odds", pred_log_odds = T)

![](/AttM/rmd_images/2021-04-24-bayesian_logistic_regression_analysis/unnamed-chunk-58-2.png)

The linear fit is not quite as nice using the Implied Probability
metrics. With that said, Implied Probability could likely still be used
very succesfully as a predictor - the fit is still solid. Theoretically,
we would have expected issues at the limits of Implied Probability
(90%+). However, in practice, Implied Probabilities seldom reach those
limits.

    plot_against_log_odds(variable = "Implied_Prob")

![](/AttM/rmd_images/2021-04-24-bayesian_logistic_regression_analysis/unnamed-chunk-59-1.png)

    plot_against_log_odds(variable = "Adjust_Implied_Prob")

![](/AttM/rmd_images/2021-04-24-bayesian_logistic_regression_analysis/unnamed-chunk-59-2.png)

Look at y axis scale. There is virtually no difference in Log Odds of
victory between sexes.

    plot_against_log_odds(variable = "Sex")

![](/AttM/rmd_images/2021-04-24-bayesian_logistic_regression_analysis/unnamed-chunk-60-1.png)

Favorites may be less likely to win in recent years. However, this may
simply be an artifact of an unstable estimate for year 2013. (That point
appears to have a lot of leverage.)

    plot_against_log_odds(variable = "Year") 

![](/AttM/rmd_images/2021-04-24-bayesian_logistic_regression_analysis/unnamed-chunk-61-1.png)

There may be a positive effect of Reach on Log Odds of victory.

    plot_against_log_odds(variable = "Delta_REACH") 

![](/AttM/rmd_images/2021-04-24-bayesian_logistic_regression_analysis/unnamed-chunk-62-1.png)

<br>

### Assumptions

Here are the [assumptions of logistic
regression](https://www.statisticssolutions.com/assumptions-of-logistic-regression):  
- First, binary logistic regression requires the dependent variable to
be binary and ordinal logistic regression requires the dependent
variable to be ordinal.  
- Second, logistic regression requires the observations to be
independent of each other. In other words, the observations should not
come from repeated measurements or matched data.  
- Third, logistic regression requires there to be little or no
multicollinearity among the independent variables. This means that the
independent variables should not be too highly correlated with each
other.  
- Fourth, logistic regression assumes linearity of independent variables
and log odds. although this analysis does not require the dependent and
independent variables to be related linearly, it requires that the
independent variables are linearly related to the log odds.

In our case, (1) is met; (2) should be met, however, there could be
random effects of Fighter or Event, etc. which likely would not impact
prediction substantially but could influence explanatory analysis; (3)
seems satisfactorily met (there are no major correlations); and (4)
appears to be met (regardless of whether or not we use Log Odds or
Implied Probability).

<br>

### Adjusted Log Odds of Implied Probability as Single Predictor

    fit_1 <- stan_glm(Favorite_Won ~ Adjust_Log_Odds, family=binomial(link="logit"), data = df_og_diff)

    ## 
    ## SAMPLING FOR MODEL 'bernoulli' NOW (CHAIN 1).
    ## Chain 1: 
    ## Chain 1: Gradient evaluation took 0.000151 seconds
    ## Chain 1: 1000 transitions using 10 leapfrog steps per transition would take 1.51 seconds.
    ## Chain 1: Adjust your expectations accordingly!
    ## Chain 1: 
    ## Chain 1: 
    ## Chain 1: Iteration:    1 / 2000 [  0%]  (Warmup)
    ## Chain 1: Iteration:  200 / 2000 [ 10%]  (Warmup)
    ## Chain 1: Iteration:  400 / 2000 [ 20%]  (Warmup)
    ## Chain 1: Iteration:  600 / 2000 [ 30%]  (Warmup)
    ## Chain 1: Iteration:  800 / 2000 [ 40%]  (Warmup)
    ## Chain 1: Iteration: 1000 / 2000 [ 50%]  (Warmup)
    ## Chain 1: Iteration: 1001 / 2000 [ 50%]  (Sampling)
    ## Chain 1: Iteration: 1200 / 2000 [ 60%]  (Sampling)
    ## Chain 1: Iteration: 1400 / 2000 [ 70%]  (Sampling)
    ## Chain 1: Iteration: 1600 / 2000 [ 80%]  (Sampling)
    ## Chain 1: Iteration: 1800 / 2000 [ 90%]  (Sampling)
    ## Chain 1: Iteration: 2000 / 2000 [100%]  (Sampling)
    ## Chain 1: 
    ## Chain 1:  Elapsed Time: 0.607679 seconds (Warm-up)
    ## Chain 1:                0.709751 seconds (Sampling)
    ## Chain 1:                1.31743 seconds (Total)
    ## Chain 1: 
    ## 
    ## SAMPLING FOR MODEL 'bernoulli' NOW (CHAIN 2).
    ## Chain 2: 
    ## Chain 2: Gradient evaluation took 0.000102 seconds
    ## Chain 2: 1000 transitions using 10 leapfrog steps per transition would take 1.02 seconds.
    ## Chain 2: Adjust your expectations accordingly!
    ## Chain 2: 
    ## Chain 2: 
    ## Chain 2: Iteration:    1 / 2000 [  0%]  (Warmup)
    ## Chain 2: Iteration:  200 / 2000 [ 10%]  (Warmup)
    ## Chain 2: Iteration:  400 / 2000 [ 20%]  (Warmup)
    ## Chain 2: Iteration:  600 / 2000 [ 30%]  (Warmup)
    ## Chain 2: Iteration:  800 / 2000 [ 40%]  (Warmup)
    ## Chain 2: Iteration: 1000 / 2000 [ 50%]  (Warmup)
    ## Chain 2: Iteration: 1001 / 2000 [ 50%]  (Sampling)
    ## Chain 2: Iteration: 1200 / 2000 [ 60%]  (Sampling)
    ## Chain 2: Iteration: 1400 / 2000 [ 70%]  (Sampling)
    ## Chain 2: Iteration: 1600 / 2000 [ 80%]  (Sampling)
    ## Chain 2: Iteration: 1800 / 2000 [ 90%]  (Sampling)
    ## Chain 2: Iteration: 2000 / 2000 [100%]  (Sampling)
    ## Chain 2: 
    ## Chain 2:  Elapsed Time: 0.580237 seconds (Warm-up)
    ## Chain 2:                0.631632 seconds (Sampling)
    ## Chain 2:                1.21187 seconds (Total)
    ## Chain 2: 
    ## 
    ## SAMPLING FOR MODEL 'bernoulli' NOW (CHAIN 3).
    ## Chain 3: 
    ## Chain 3: Gradient evaluation took 9.8e-05 seconds
    ## Chain 3: 1000 transitions using 10 leapfrog steps per transition would take 0.98 seconds.
    ## Chain 3: Adjust your expectations accordingly!
    ## Chain 3: 
    ## Chain 3: 
    ## Chain 3: Iteration:    1 / 2000 [  0%]  (Warmup)
    ## Chain 3: Iteration:  200 / 2000 [ 10%]  (Warmup)
    ## Chain 3: Iteration:  400 / 2000 [ 20%]  (Warmup)
    ## Chain 3: Iteration:  600 / 2000 [ 30%]  (Warmup)
    ## Chain 3: Iteration:  800 / 2000 [ 40%]  (Warmup)
    ## Chain 3: Iteration: 1000 / 2000 [ 50%]  (Warmup)
    ## Chain 3: Iteration: 1001 / 2000 [ 50%]  (Sampling)
    ## Chain 3: Iteration: 1200 / 2000 [ 60%]  (Sampling)
    ## Chain 3: Iteration: 1400 / 2000 [ 70%]  (Sampling)
    ## Chain 3: Iteration: 1600 / 2000 [ 80%]  (Sampling)
    ## Chain 3: Iteration: 1800 / 2000 [ 90%]  (Sampling)
    ## Chain 3: Iteration: 2000 / 2000 [100%]  (Sampling)
    ## Chain 3: 
    ## Chain 3:  Elapsed Time: 0.582118 seconds (Warm-up)
    ## Chain 3:                0.678056 seconds (Sampling)
    ## Chain 3:                1.26017 seconds (Total)
    ## Chain 3: 
    ## 
    ## SAMPLING FOR MODEL 'bernoulli' NOW (CHAIN 4).
    ## Chain 4: 
    ## Chain 4: Gradient evaluation took 9.6e-05 seconds
    ## Chain 4: 1000 transitions using 10 leapfrog steps per transition would take 0.96 seconds.
    ## Chain 4: Adjust your expectations accordingly!
    ## Chain 4: 
    ## Chain 4: 
    ## Chain 4: Iteration:    1 / 2000 [  0%]  (Warmup)
    ## Chain 4: Iteration:  200 / 2000 [ 10%]  (Warmup)
    ## Chain 4: Iteration:  400 / 2000 [ 20%]  (Warmup)
    ## Chain 4: Iteration:  600 / 2000 [ 30%]  (Warmup)
    ## Chain 4: Iteration:  800 / 2000 [ 40%]  (Warmup)
    ## Chain 4: Iteration: 1000 / 2000 [ 50%]  (Warmup)
    ## Chain 4: Iteration: 1001 / 2000 [ 50%]  (Sampling)
    ## Chain 4: Iteration: 1200 / 2000 [ 60%]  (Sampling)
    ## Chain 4: Iteration: 1400 / 2000 [ 70%]  (Sampling)
    ## Chain 4: Iteration: 1600 / 2000 [ 80%]  (Sampling)
    ## Chain 4: Iteration: 1800 / 2000 [ 90%]  (Sampling)
    ## Chain 4: Iteration: 2000 / 2000 [100%]  (Sampling)
    ## Chain 4: 
    ## Chain 4:  Elapsed Time: 0.534413 seconds (Warm-up)
    ## Chain 4:                0.592038 seconds (Sampling)
    ## Chain 4:                1.12645 seconds (Total)
    ## Chain 4:

    print(fit_1)

    ## stan_glm
    ##  family:       binomial [logit]
    ##  formula:      Favorite_Won ~ Adjust_Log_Odds
    ##  observations: 2988
    ##  predictors:   2
    ## ------
    ##                 Median MAD_SD
    ## (Intercept)     -0.2    0.1  
    ## Adjust_Log_Odds  1.3    0.1  
    ## 
    ## ------
    ## * For help interpreting the printed output see ?print.stanreg
    ## * For info on the priors used see ?prior_summary.stanreg

Display uncertainty in the parameters.

    sims_1 <- as.matrix(fit_1)
    n_sims <- nrow(sims_1)

    draws_1 <- sample(n_sims, 20)

    curve(invlogit(sims_1[draws_1[1],1] + sims_1[draws_1[1],2]*x)
          , from = 0
          , to = 3
          , col = "gray"
          , lwd=0.5
          , xlab="Adjusted Log Odds of Favorite"
          , ylab = "Probability of Favorite Winning"
          , main = "Random Draws from Parameter Simulations"
          )

    for (j in draws_1[2:20]) {
      curve(invlogit(sims_1[j,1] + sims_1[j,2]*x)
            , col = "gray"
            , lwd=0.5
            , add=TRUE
            )
    }

![](/AttM/rmd_images/2021-04-24-bayesian_logistic_regression_analysis/unnamed-chunk-64-1.png)

Now do the same with the backtransformed predictors (i.e. Adjusted Log
Odds to Implied Probabilities). Here we can see that the negative
intercept allows the model to capture the overperformance of large
favorites and the underperformance of mild ones.

    curve(invlogit(sims_1[draws_1[1],1] + sims_1[draws_1[1],2]*logit(x))
          , from = 0.5
          , to = 1
          , col = "gray"
          , lwd=0.5
          , xlab="Adjusted Implied Probability of Favorite"
          , ylab = "Probability of Favorite Winning"
          , main = "Random Draws from Parameter Simulations"
          )

    for (j in draws_1[2:20]) {
      curve(invlogit(sims_1[j,1] + sims_1[j,2]*logit(x))
            , col = "gray"
            , lwd=0.5
            , add=TRUE
            )
    }
    abline(a=0, b=1, col = "red")

![](/AttM/rmd_images/2021-04-24-bayesian_logistic_regression_analysis/unnamed-chunk-65-1.png)

Evaluate intercept (i.e. with Adjusted Log Odds equal to zero). Note:
Implied Probability of 50% is technically right outside the range of the
data.

    b1 <- fit_1$coefficients[[1]]
    b2 <- fit_1$coefficients[[2]]
    invlogit(0)

    ## [1] 0.5

    invlogit(b1 + b2 * 0)

    ## [1] 0.4525427

Now, with Adjusted Log Odds of 1/2 which is equivalent to about 62%
Adjusted Implied Probability.

    invlogit(0.5)

    ## [1] 0.6224593

    invlogit(b1 + b2 * 0.5)

    ## [1] 0.607421

Now, with Adjusted Log Odds of 1 which is equivalent to about 73%
Adjusted Implied Probability.

    invlogit(1)

    ## [1] 0.7310586

    invlogit(b1 + b2 * 1)

    ## [1] 0.7433343

Now, with Adjusted Log Odds of 3/2 which is equivalent to about 82%
Adjusted Implied Probability.

    invlogit(3/2)

    ## [1] 0.8175745

    invlogit(b1 + b2 * 3/2)

    ## [1] 0.8442581

With the intercept, the model captures the fact that mild favorites
underperform whereas large favorites overperform.

Now, we’ll try the divide-by-4-rule. Indeed, the actual change in the
Probability of the Favorite Winning is just under the coefficient
divided by 4.

    b2/4

    ## [1] 0.3134434

    invlogit(b1 + b2 * 1) - invlogit(b1 + b2 * 0)

    ## [1] 0.2907916

Get point predictions using predict() and compare to Adjusted Log Odds
to again get a sense of how model manages to account for
underperformances and overperformances.

    newx = seq(0, 3, 0.5)
    new <- data.frame(Adjust_Log_Odds=newx)
    pred <- predict(fit_1, type = "response", newdata = new)

    new$BackTrans_Implied_Prob <- invlogit(newx)
    new$Point_Pred <- pred

Get expected outcome with uncertainty.

    epred <- posterior_epred(fit_1, newdata=new)

    new$Means <- apply(epred, 2, mean)
    new$SDs <- apply(epred, 2, sd)

Predictive distribution for new observation. Taking the mean of the
predictions gives us similar results as above.

    postpred <- posterior_predict(fit_1, newdata=new)

    new$Mean_Pred <- apply(postpred, 2, mean)
    kable(new)

<table>
<thead>
<tr class="header">
<th style="text-align: right;">Adjust_Log_Odds</th>
<th style="text-align: right;">BackTrans_Implied_Prob</th>
<th style="text-align: right;">Point_Pred</th>
<th style="text-align: right;">Means</th>
<th style="text-align: right;">SDs</th>
<th style="text-align: right;">Mean_Pred</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">0.4523726</td>
<td style="text-align: right;">0.4523726</td>
<td style="text-align: right;">0.0168735</td>
<td style="text-align: right;">0.45050</td>
</tr>
<tr class="even">
<td style="text-align: right;">0.5</td>
<td style="text-align: right;">0.6224593</td>
<td style="text-align: right;">0.6070073</td>
<td style="text-align: right;">0.6070073</td>
<td style="text-align: right;">0.0094670</td>
<td style="text-align: right;">0.61050</td>
</tr>
<tr class="odd">
<td style="text-align: right;">1.0</td>
<td style="text-align: right;">0.7310586</td>
<td style="text-align: right;">0.7427698</td>
<td style="text-align: right;">0.7427698</td>
<td style="text-align: right;">0.0104895</td>
<td style="text-align: right;">0.73500</td>
</tr>
<tr class="even">
<td style="text-align: right;">1.5</td>
<td style="text-align: right;">0.8175745</td>
<td style="text-align: right;">0.8434727</td>
<td style="text-align: right;">0.8434727</td>
<td style="text-align: right;">0.0125003</td>
<td style="text-align: right;">0.84300</td>
</tr>
<tr class="odd">
<td style="text-align: right;">2.0</td>
<td style="text-align: right;">0.8807971</td>
<td style="text-align: right;">0.9093447</td>
<td style="text-align: right;">0.9093447</td>
<td style="text-align: right;">0.0115072</td>
<td style="text-align: right;">0.90775</td>
</tr>
<tr class="even">
<td style="text-align: right;">2.5</td>
<td style="text-align: right;">0.9241418</td>
<td style="text-align: right;">0.9490398</td>
<td style="text-align: right;">0.9490398</td>
<td style="text-align: right;">0.0090143</td>
<td style="text-align: right;">0.95425</td>
</tr>
<tr class="odd">
<td style="text-align: right;">3.0</td>
<td style="text-align: right;">0.9525741</td>
<td style="text-align: right;">0.9718231</td>
<td style="text-align: right;">0.9718231</td>
<td style="text-align: right;">0.0064209</td>
<td style="text-align: right;">0.97575</td>
</tr>
</tbody>
</table>

Calculate log score for pure chance.

    logscore_chance <- log(0.5) * length(fit_1$fitted.values)
    logscore_chance

    ## [1] -2071.124

Calculate log score for simply following adjusted best odds.

    y <- fit_1$data$Favorite_Won
    x <- fit_1$data$Adjust_Implied_Prob
    logscore_bestodds <-  sum(y * log(x) + (1-y)*log(1-x))
    logscore_bestodds

    ## [1] -1844.482

Calculate log score for model.

    predp_1 <- predict(fit_1, type = "response")
    logscore_1 <- sum(y * log(predp_1) + (1-y)*log(1-predp_1))
    logscore_1

    ## [1] -1840.294

Run leave one out cross validation. There is about a two point
difference between the elpd\_loo estimate and the within-sample log
score which makes sense since the fitted model has two parameters.

    loo_1 <- loo(fit_1)
    print(loo_1)

    ## 
    ## Computed from 4000 by 2988 log-likelihood matrix
    ## 
    ##          Estimate   SE
    ## elpd_loo  -1842.3 19.8
    ## p_loo         2.0  0.1
    ## looic      3684.5 39.6
    ## ------
    ## Monte Carlo SE of elpd_loo is 0.0.
    ## 
    ## All Pareto k estimates are good (k < 0.5).
    ## See help('pareto-k-diagnostic') for details.

<br>

### Adjusted Implied Probability as Single Predictor

    fit_2 <- stan_glm(Favorite_Won ~ Adjust_Implied_Prob, family=binomial(link="logit"), data = df_og_diff)

    ## 
    ## SAMPLING FOR MODEL 'bernoulli' NOW (CHAIN 1).
    ## Chain 1: 
    ## Chain 1: Gradient evaluation took 9.6e-05 seconds
    ## Chain 1: 1000 transitions using 10 leapfrog steps per transition would take 0.96 seconds.
    ## Chain 1: Adjust your expectations accordingly!
    ## Chain 1: 
    ## Chain 1: 
    ## Chain 1: Iteration:    1 / 2000 [  0%]  (Warmup)
    ## Chain 1: Iteration:  200 / 2000 [ 10%]  (Warmup)
    ## Chain 1: Iteration:  400 / 2000 [ 20%]  (Warmup)
    ## Chain 1: Iteration:  600 / 2000 [ 30%]  (Warmup)
    ## Chain 1: Iteration:  800 / 2000 [ 40%]  (Warmup)
    ## Chain 1: Iteration: 1000 / 2000 [ 50%]  (Warmup)
    ## Chain 1: Iteration: 1001 / 2000 [ 50%]  (Sampling)
    ## Chain 1: Iteration: 1200 / 2000 [ 60%]  (Sampling)
    ## Chain 1: Iteration: 1400 / 2000 [ 70%]  (Sampling)
    ## Chain 1: Iteration: 1600 / 2000 [ 80%]  (Sampling)
    ## Chain 1: Iteration: 1800 / 2000 [ 90%]  (Sampling)
    ## Chain 1: Iteration: 2000 / 2000 [100%]  (Sampling)
    ## Chain 1: 
    ## Chain 1:  Elapsed Time: 0.537421 seconds (Warm-up)
    ## Chain 1:                0.608507 seconds (Sampling)
    ## Chain 1:                1.14593 seconds (Total)
    ## Chain 1: 
    ## 
    ## SAMPLING FOR MODEL 'bernoulli' NOW (CHAIN 2).
    ## Chain 2: 
    ## Chain 2: Gradient evaluation took 8.8e-05 seconds
    ## Chain 2: 1000 transitions using 10 leapfrog steps per transition would take 0.88 seconds.
    ## Chain 2: Adjust your expectations accordingly!
    ## Chain 2: 
    ## Chain 2: 
    ## Chain 2: Iteration:    1 / 2000 [  0%]  (Warmup)
    ## Chain 2: Iteration:  200 / 2000 [ 10%]  (Warmup)
    ## Chain 2: Iteration:  400 / 2000 [ 20%]  (Warmup)
    ## Chain 2: Iteration:  600 / 2000 [ 30%]  (Warmup)
    ## Chain 2: Iteration:  800 / 2000 [ 40%]  (Warmup)
    ## Chain 2: Iteration: 1000 / 2000 [ 50%]  (Warmup)
    ## Chain 2: Iteration: 1001 / 2000 [ 50%]  (Sampling)
    ## Chain 2: Iteration: 1200 / 2000 [ 60%]  (Sampling)
    ## Chain 2: Iteration: 1400 / 2000 [ 70%]  (Sampling)
    ## Chain 2: Iteration: 1600 / 2000 [ 80%]  (Sampling)
    ## Chain 2: Iteration: 1800 / 2000 [ 90%]  (Sampling)
    ## Chain 2: Iteration: 2000 / 2000 [100%]  (Sampling)
    ## Chain 2: 
    ## Chain 2:  Elapsed Time: 0.492744 seconds (Warm-up)
    ## Chain 2:                0.591973 seconds (Sampling)
    ## Chain 2:                1.08472 seconds (Total)
    ## Chain 2: 
    ## 
    ## SAMPLING FOR MODEL 'bernoulli' NOW (CHAIN 3).
    ## Chain 3: 
    ## Chain 3: Gradient evaluation took 9.2e-05 seconds
    ## Chain 3: 1000 transitions using 10 leapfrog steps per transition would take 0.92 seconds.
    ## Chain 3: Adjust your expectations accordingly!
    ## Chain 3: 
    ## Chain 3: 
    ## Chain 3: Iteration:    1 / 2000 [  0%]  (Warmup)
    ## Chain 3: Iteration:  200 / 2000 [ 10%]  (Warmup)
    ## Chain 3: Iteration:  400 / 2000 [ 20%]  (Warmup)
    ## Chain 3: Iteration:  600 / 2000 [ 30%]  (Warmup)
    ## Chain 3: Iteration:  800 / 2000 [ 40%]  (Warmup)
    ## Chain 3: Iteration: 1000 / 2000 [ 50%]  (Warmup)
    ## Chain 3: Iteration: 1001 / 2000 [ 50%]  (Sampling)
    ## Chain 3: Iteration: 1200 / 2000 [ 60%]  (Sampling)
    ## Chain 3: Iteration: 1400 / 2000 [ 70%]  (Sampling)
    ## Chain 3: Iteration: 1600 / 2000 [ 80%]  (Sampling)
    ## Chain 3: Iteration: 1800 / 2000 [ 90%]  (Sampling)
    ## Chain 3: Iteration: 2000 / 2000 [100%]  (Sampling)
    ## Chain 3: 
    ## Chain 3:  Elapsed Time: 0.526684 seconds (Warm-up)
    ## Chain 3:                0.577734 seconds (Sampling)
    ## Chain 3:                1.10442 seconds (Total)
    ## Chain 3: 
    ## 
    ## SAMPLING FOR MODEL 'bernoulli' NOW (CHAIN 4).
    ## Chain 4: 
    ## Chain 4: Gradient evaluation took 9.1e-05 seconds
    ## Chain 4: 1000 transitions using 10 leapfrog steps per transition would take 0.91 seconds.
    ## Chain 4: Adjust your expectations accordingly!
    ## Chain 4: 
    ## Chain 4: 
    ## Chain 4: Iteration:    1 / 2000 [  0%]  (Warmup)
    ## Chain 4: Iteration:  200 / 2000 [ 10%]  (Warmup)
    ## Chain 4: Iteration:  400 / 2000 [ 20%]  (Warmup)
    ## Chain 4: Iteration:  600 / 2000 [ 30%]  (Warmup)
    ## Chain 4: Iteration:  800 / 2000 [ 40%]  (Warmup)
    ## Chain 4: Iteration: 1000 / 2000 [ 50%]  (Warmup)
    ## Chain 4: Iteration: 1001 / 2000 [ 50%]  (Sampling)
    ## Chain 4: Iteration: 1200 / 2000 [ 60%]  (Sampling)
    ## Chain 4: Iteration: 1400 / 2000 [ 70%]  (Sampling)
    ## Chain 4: Iteration: 1600 / 2000 [ 80%]  (Sampling)
    ## Chain 4: Iteration: 1800 / 2000 [ 90%]  (Sampling)
    ## Chain 4: Iteration: 2000 / 2000 [100%]  (Sampling)
    ## Chain 4: 
    ## Chain 4:  Elapsed Time: 0.51957 seconds (Warm-up)
    ## Chain 4:                0.610287 seconds (Sampling)
    ## Chain 4:                1.12986 seconds (Total)
    ## Chain 4:

    print(fit_2)

    ## stan_glm
    ##  family:       binomial [logit]
    ##  formula:      Favorite_Won ~ Adjust_Implied_Prob
    ##  observations: 2988
    ##  predictors:   2
    ## ------
    ##                     Median MAD_SD
    ## (Intercept)         -3.2    0.3  
    ## Adjust_Implied_Prob  5.9    0.4  
    ## 
    ## ------
    ## * For help interpreting the printed output see ?print.stanreg
    ## * For info on the priors used see ?prior_summary.stanreg

Display uncertainty in the parameters.

    sims_2 <- as.matrix(fit_2)
    n_sims_2 <- nrow(sims_2)

    draws_2 <- sample(n_sims_2, 20)

    curve(invlogit(sims_2[draws_2[1],1] + sims_2[draws_2[1],2]*x)
          , from = 0.5
          , to = 1
          , col = "gray"
          , lwd=0.5
          , xlab="Adjusted Implied Probability of Favorite"
          , ylab = "Probability of Favorite Winning"
          , main = "Random Draws from Parameter Simulations"
          )

    for (j in draws_2[2:20]) {
      curve(invlogit(sims_2[j,1] + sims_2[j,2]*x)
            , col = "gray"
            , lwd=0.5
            , add=TRUE
            )
    }
    abline(a=0, b=1, col = "red")

![](/AttM/rmd_images/2021-04-24-bayesian_logistic_regression_analysis/unnamed-chunk-79-1.png)

Get point predictions using predict() and compare to Adjusted Implied
Probabilities to get a sense of how model manages to account for
underperformances and overperformances.

    newx_2 = seq(0.5, 1, 0.1)
    new_2 <- data.frame(Adjust_Implied_Prob=newx_2)
    new_2$Point_Pred <- predict(fit_2, type = "response", newdata = new_2)

Get expected outcome with uncertainty.

    epred_2 <- posterior_epred(fit_2, newdata=new_2)

    new_2$Means <- apply(epred_2, 2, mean)
    new_2$SDs <- apply(epred_2, 2, sd)

Predictive distribution for new observation. Taking the mean of the
predictions gives us similar results as above.

    postpred_2 <- posterior_predict(fit_2, newdata=new_2)

    new_2$Mean_Pred <- apply(postpred_2, 2, mean)
    kable(new_2)

<table>
<thead>
<tr class="header">
<th style="text-align: right;">Adjust_Implied_Prob</th>
<th style="text-align: right;">Point_Pred</th>
<th style="text-align: right;">Means</th>
<th style="text-align: right;">SDs</th>
<th style="text-align: right;">Mean_Pred</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: right;">0.5</td>
<td style="text-align: right;">0.4346352</td>
<td style="text-align: right;">0.4346352</td>
<td style="text-align: right;">0.0178472</td>
<td style="text-align: right;">0.43400</td>
</tr>
<tr class="even">
<td style="text-align: right;">0.6</td>
<td style="text-align: right;">0.5812958</td>
<td style="text-align: right;">0.5812958</td>
<td style="text-align: right;">0.0106102</td>
<td style="text-align: right;">0.57450</td>
</tr>
<tr class="odd">
<td style="text-align: right;">0.7</td>
<td style="text-align: right;">0.7148974</td>
<td style="text-align: right;">0.7148974</td>
<td style="text-align: right;">0.0100209</td>
<td style="text-align: right;">0.72175</td>
</tr>
<tr class="even">
<td style="text-align: right;">0.8</td>
<td style="text-align: right;">0.8189411</td>
<td style="text-align: right;">0.8189411</td>
<td style="text-align: right;">0.0122480</td>
<td style="text-align: right;">0.80925</td>
</tr>
<tr class="odd">
<td style="text-align: right;">0.9</td>
<td style="text-align: right;">0.8906131</td>
<td style="text-align: right;">0.8906131</td>
<td style="text-align: right;">0.0119773</td>
<td style="text-align: right;">0.88875</td>
</tr>
<tr class="even">
<td style="text-align: right;">1.0</td>
<td style="text-align: right;">0.9359914</td>
<td style="text-align: right;">0.9359914</td>
<td style="text-align: right;">0.0099081</td>
<td style="text-align: right;">0.93300</td>
</tr>
</tbody>
</table>

Calculate log score for second model (i.e. with Implied Probabilities).
The log score is marginally worst than the one using the Adjusted Log
Odds (-1840.29).

    predp_2 <- predict(fit_2, type = "response")
    logscore_2 <- sum(y * log(predp_2) + (1-y)*log(1-predp_2))
    logscore_2

    ## [1] -1841.472

Run leave one out cross validation. Similarly, the elpd\_loo is
marginally worst than the one using the Adjusted Adjusted Log Odds
(-1842.27).

    loo_2 <- loo(fit_2)
    print(loo_2)

    ## 
    ## Computed from 4000 by 2988 log-likelihood matrix
    ## 
    ##          Estimate   SE
    ## elpd_loo  -1843.5 19.7
    ## p_loo         2.0  0.1
    ## looic      3687.0 39.5
    ## ------
    ## Monte Carlo SE of elpd_loo is 0.0.
    ## 
    ## All Pareto k estimates are good (k < 0.5).
    ## See help('pareto-k-diagnostic') for details.

The difference between using the Adjusted Log Odds or Implied
Probabilities as a predictor is fairly small. However, using the
Adjsuted Log Odds makes more sense in principle and leads to a
marginally better performance. Also, it is trivially easy to
back-transform the predictors for interpretability. Therefore, we will
use Adjusted Log Odds.

<br>

### Adjusted Log Odds with Square Term.

    df_og_diff$Adjust_Log_Odds_sq = (df_og_diff$Adjust_Log_Odds)^2
    fit_3 <- stan_glm(Favorite_Won ~ Adjust_Log_Odds + Adjust_Log_Odds_sq, family=binomial(link="logit"), data = df_og_diff)

    ## 
    ## SAMPLING FOR MODEL 'bernoulli' NOW (CHAIN 1).
    ## Chain 1: 
    ## Chain 1: Gradient evaluation took 9.6e-05 seconds
    ## Chain 1: 1000 transitions using 10 leapfrog steps per transition would take 0.96 seconds.
    ## Chain 1: Adjust your expectations accordingly!
    ## Chain 1: 
    ## Chain 1: 
    ## Chain 1: Iteration:    1 / 2000 [  0%]  (Warmup)
    ## Chain 1: Iteration:  200 / 2000 [ 10%]  (Warmup)
    ## Chain 1: Iteration:  400 / 2000 [ 20%]  (Warmup)
    ## Chain 1: Iteration:  600 / 2000 [ 30%]  (Warmup)
    ## Chain 1: Iteration:  800 / 2000 [ 40%]  (Warmup)
    ## Chain 1: Iteration: 1000 / 2000 [ 50%]  (Warmup)
    ## Chain 1: Iteration: 1001 / 2000 [ 50%]  (Sampling)
    ## Chain 1: Iteration: 1200 / 2000 [ 60%]  (Sampling)
    ## Chain 1: Iteration: 1400 / 2000 [ 70%]  (Sampling)
    ## Chain 1: Iteration: 1600 / 2000 [ 80%]  (Sampling)
    ## Chain 1: Iteration: 1800 / 2000 [ 90%]  (Sampling)
    ## Chain 1: Iteration: 2000 / 2000 [100%]  (Sampling)
    ## Chain 1: 
    ## Chain 1:  Elapsed Time: 1.46779 seconds (Warm-up)
    ## Chain 1:                1.4207 seconds (Sampling)
    ## Chain 1:                2.88849 seconds (Total)
    ## Chain 1: 
    ## 
    ## SAMPLING FOR MODEL 'bernoulli' NOW (CHAIN 2).
    ## Chain 2: 
    ## Chain 2: Gradient evaluation took 9.6e-05 seconds
    ## Chain 2: 1000 transitions using 10 leapfrog steps per transition would take 0.96 seconds.
    ## Chain 2: Adjust your expectations accordingly!
    ## Chain 2: 
    ## Chain 2: 
    ## Chain 2: Iteration:    1 / 2000 [  0%]  (Warmup)
    ## Chain 2: Iteration:  200 / 2000 [ 10%]  (Warmup)
    ## Chain 2: Iteration:  400 / 2000 [ 20%]  (Warmup)
    ## Chain 2: Iteration:  600 / 2000 [ 30%]  (Warmup)
    ## Chain 2: Iteration:  800 / 2000 [ 40%]  (Warmup)
    ## Chain 2: Iteration: 1000 / 2000 [ 50%]  (Warmup)
    ## Chain 2: Iteration: 1001 / 2000 [ 50%]  (Sampling)
    ## Chain 2: Iteration: 1200 / 2000 [ 60%]  (Sampling)
    ## Chain 2: Iteration: 1400 / 2000 [ 70%]  (Sampling)
    ## Chain 2: Iteration: 1600 / 2000 [ 80%]  (Sampling)
    ## Chain 2: Iteration: 1800 / 2000 [ 90%]  (Sampling)
    ## Chain 2: Iteration: 2000 / 2000 [100%]  (Sampling)
    ## Chain 2: 
    ## Chain 2:  Elapsed Time: 1.3878 seconds (Warm-up)
    ## Chain 2:                1.53574 seconds (Sampling)
    ## Chain 2:                2.92354 seconds (Total)
    ## Chain 2: 
    ## 
    ## SAMPLING FOR MODEL 'bernoulli' NOW (CHAIN 3).
    ## Chain 3: 
    ## Chain 3: Gradient evaluation took 9.4e-05 seconds
    ## Chain 3: 1000 transitions using 10 leapfrog steps per transition would take 0.94 seconds.
    ## Chain 3: Adjust your expectations accordingly!
    ## Chain 3: 
    ## Chain 3: 
    ## Chain 3: Iteration:    1 / 2000 [  0%]  (Warmup)
    ## Chain 3: Iteration:  200 / 2000 [ 10%]  (Warmup)
    ## Chain 3: Iteration:  400 / 2000 [ 20%]  (Warmup)
    ## Chain 3: Iteration:  600 / 2000 [ 30%]  (Warmup)
    ## Chain 3: Iteration:  800 / 2000 [ 40%]  (Warmup)
    ## Chain 3: Iteration: 1000 / 2000 [ 50%]  (Warmup)
    ## Chain 3: Iteration: 1001 / 2000 [ 50%]  (Sampling)
    ## Chain 3: Iteration: 1200 / 2000 [ 60%]  (Sampling)
    ## Chain 3: Iteration: 1400 / 2000 [ 70%]  (Sampling)
    ## Chain 3: Iteration: 1600 / 2000 [ 80%]  (Sampling)
    ## Chain 3: Iteration: 1800 / 2000 [ 90%]  (Sampling)
    ## Chain 3: Iteration: 2000 / 2000 [100%]  (Sampling)
    ## Chain 3: 
    ## Chain 3:  Elapsed Time: 1.48475 seconds (Warm-up)
    ## Chain 3:                1.52879 seconds (Sampling)
    ## Chain 3:                3.01354 seconds (Total)
    ## Chain 3: 
    ## 
    ## SAMPLING FOR MODEL 'bernoulli' NOW (CHAIN 4).
    ## Chain 4: 
    ## Chain 4: Gradient evaluation took 9.9e-05 seconds
    ## Chain 4: 1000 transitions using 10 leapfrog steps per transition would take 0.99 seconds.
    ## Chain 4: Adjust your expectations accordingly!
    ## Chain 4: 
    ## Chain 4: 
    ## Chain 4: Iteration:    1 / 2000 [  0%]  (Warmup)
    ## Chain 4: Iteration:  200 / 2000 [ 10%]  (Warmup)
    ## Chain 4: Iteration:  400 / 2000 [ 20%]  (Warmup)
    ## Chain 4: Iteration:  600 / 2000 [ 30%]  (Warmup)
    ## Chain 4: Iteration:  800 / 2000 [ 40%]  (Warmup)
    ## Chain 4: Iteration: 1000 / 2000 [ 50%]  (Warmup)
    ## Chain 4: Iteration: 1001 / 2000 [ 50%]  (Sampling)
    ## Chain 4: Iteration: 1200 / 2000 [ 60%]  (Sampling)
    ## Chain 4: Iteration: 1400 / 2000 [ 70%]  (Sampling)
    ## Chain 4: Iteration: 1600 / 2000 [ 80%]  (Sampling)
    ## Chain 4: Iteration: 1800 / 2000 [ 90%]  (Sampling)
    ## Chain 4: Iteration: 2000 / 2000 [100%]  (Sampling)
    ## Chain 4: 
    ## Chain 4:  Elapsed Time: 1.42941 seconds (Warm-up)
    ## Chain 4:                1.57456 seconds (Sampling)
    ## Chain 4:                3.00396 seconds (Total)
    ## Chain 4:

    print(fit_3)

    ## stan_glm
    ##  family:       binomial [logit]
    ##  formula:      Favorite_Won ~ Adjust_Log_Odds + Adjust_Log_Odds_sq
    ##  observations: 2988
    ##  predictors:   3
    ## ------
    ##                    Median MAD_SD
    ## (Intercept)        -0.2    0.1  
    ## Adjust_Log_Odds     1.1    0.3  
    ## Adjust_Log_Odds_sq  0.1    0.2  
    ## 
    ## ------
    ## * For help interpreting the printed output see ?print.stanreg
    ## * For info on the priors used see ?prior_summary.stanreg

Display uncertainty in the parameters. Take 40 draws to capture strange
behavior of some of the draws on implied probability scale.

    sims_3 <- as.matrix(fit_3)
    n_sims_3 <- nrow(sims_3)

    draws_3 <- sample(n_sims_3, 40)

    curve(invlogit(sims_3[draws_3[1],1] + sims_3[draws_3[1],2]*x + sims_3[draws_3[1],3]*(x^2))
          , from = 0
          , to = 3
          , col = "gray"
          , lwd=0.5
          , xlab="Adjusted Log Odds of Favorite"
          , ylab = "Probability of Favorite Winning"
          , main = "Random Draws from Parameter Simulations"
          )

    for (j in draws_3[2:40]) {
      curve(invlogit(sims_3[j,1] + sims_3[j,2]*x + sims_3[j,3]*(x^2))
            , col = "gray"
            , lwd=0.5
            , add=TRUE
            )
    }

![](/AttM/rmd_images/2021-04-24-bayesian_logistic_regression_analysis/unnamed-chunk-86-1.png)

Now do the same with the backtransformed predictors (i.e. Adjusted Log
Odds to Implied Probabilities). Some of the draws exhibit strange
behavior toward the limit of the implied probabilities (i.e. close to 1)
whereby they dip dramatically towards lower outcome values.

    curve(invlogit(sims_3[draws_3[1],1] + sims_3[draws_3[1],2]*logit(x) + sims_3[draws_3[1],3]*(logit(x)^2))
          , from = 0.5
          , to = 1
          , col = "gray"
          , lwd=0.5
          , xlab="Adjusted Implied Probability of Favorite"
          , ylab = "Probability of Favorite Winning"
          , main = "Random Draws from Parameter Simulations"
          )

    for (j in draws_3[2:40]) {
      curve(invlogit(sims_3[j,1] + sims_3[j,2]*logit(x) + sims_3[j,3]*(logit(x)^2))
            , col = "gray"
            , lwd=0.5
            , add=TRUE
            )
    }

    abline(a=0, b=1, col = "red")

![](/AttM/rmd_images/2021-04-24-bayesian_logistic_regression_analysis/unnamed-chunk-87-1.png)

Run leave one out cross validation. The model with the square terms
performs about as well as the model with the Adjusted Implied
Probabilities. Therefore, we will stick with the basic single predictor
model using Adjusted Log Odds as a predictor.

    loo_3 <- loo(fit_3)
    print(loo_3)

    ## 
    ## Computed from 4000 by 2988 log-likelihood matrix
    ## 
    ##          Estimate   SE
    ## elpd_loo  -1843.6 19.9
    ## p_loo         3.5  0.4
    ## looic      3687.1 39.9
    ## ------
    ## Monte Carlo SE of elpd_loo is 0.0.
    ## 
    ## All Pareto k estimates are good (k < 0.5).
    ## See help('pareto-k-diagnostic') for details.

<br>

### Reach as Lone Predictor

We run the model with just Reach as a predictor. There are missing Reach
values that we have not replaced. Indeed, the number of observations is
reduced compared to the models above.

    fit_4 <- stan_glm(Favorite_Won ~ Delta_REACH, family=binomial(link="logit"), data = df_og_diff)

    ## 
    ## SAMPLING FOR MODEL 'bernoulli' NOW (CHAIN 1).
    ## Chain 1: 
    ## Chain 1: Gradient evaluation took 8.6e-05 seconds
    ## Chain 1: 1000 transitions using 10 leapfrog steps per transition would take 0.86 seconds.
    ## Chain 1: Adjust your expectations accordingly!
    ## Chain 1: 
    ## Chain 1: 
    ## Chain 1: Iteration:    1 / 2000 [  0%]  (Warmup)
    ## Chain 1: Iteration:  200 / 2000 [ 10%]  (Warmup)
    ## Chain 1: Iteration:  400 / 2000 [ 20%]  (Warmup)
    ## Chain 1: Iteration:  600 / 2000 [ 30%]  (Warmup)
    ## Chain 1: Iteration:  800 / 2000 [ 40%]  (Warmup)
    ## Chain 1: Iteration: 1000 / 2000 [ 50%]  (Warmup)
    ## Chain 1: Iteration: 1001 / 2000 [ 50%]  (Sampling)
    ## Chain 1: Iteration: 1200 / 2000 [ 60%]  (Sampling)
    ## Chain 1: Iteration: 1400 / 2000 [ 70%]  (Sampling)
    ## Chain 1: Iteration: 1600 / 2000 [ 80%]  (Sampling)
    ## Chain 1: Iteration: 1800 / 2000 [ 90%]  (Sampling)
    ## Chain 1: Iteration: 2000 / 2000 [100%]  (Sampling)
    ## Chain 1: 
    ## Chain 1:  Elapsed Time: 0.470981 seconds (Warm-up)
    ## Chain 1:                0.51835 seconds (Sampling)
    ## Chain 1:                0.989331 seconds (Total)
    ## Chain 1: 
    ## 
    ## SAMPLING FOR MODEL 'bernoulli' NOW (CHAIN 2).
    ## Chain 2: 
    ## Chain 2: Gradient evaluation took 8.9e-05 seconds
    ## Chain 2: 1000 transitions using 10 leapfrog steps per transition would take 0.89 seconds.
    ## Chain 2: Adjust your expectations accordingly!
    ## Chain 2: 
    ## Chain 2: 
    ## Chain 2: Iteration:    1 / 2000 [  0%]  (Warmup)
    ## Chain 2: Iteration:  200 / 2000 [ 10%]  (Warmup)
    ## Chain 2: Iteration:  400 / 2000 [ 20%]  (Warmup)
    ## Chain 2: Iteration:  600 / 2000 [ 30%]  (Warmup)
    ## Chain 2: Iteration:  800 / 2000 [ 40%]  (Warmup)
    ## Chain 2: Iteration: 1000 / 2000 [ 50%]  (Warmup)
    ## Chain 2: Iteration: 1001 / 2000 [ 50%]  (Sampling)
    ## Chain 2: Iteration: 1200 / 2000 [ 60%]  (Sampling)
    ## Chain 2: Iteration: 1400 / 2000 [ 70%]  (Sampling)
    ## Chain 2: Iteration: 1600 / 2000 [ 80%]  (Sampling)
    ## Chain 2: Iteration: 1800 / 2000 [ 90%]  (Sampling)
    ## Chain 2: Iteration: 2000 / 2000 [100%]  (Sampling)
    ## Chain 2: 
    ## Chain 2:  Elapsed Time: 0.459119 seconds (Warm-up)
    ## Chain 2:                0.506495 seconds (Sampling)
    ## Chain 2:                0.965614 seconds (Total)
    ## Chain 2: 
    ## 
    ## SAMPLING FOR MODEL 'bernoulli' NOW (CHAIN 3).
    ## Chain 3: 
    ## Chain 3: Gradient evaluation took 8.4e-05 seconds
    ## Chain 3: 1000 transitions using 10 leapfrog steps per transition would take 0.84 seconds.
    ## Chain 3: Adjust your expectations accordingly!
    ## Chain 3: 
    ## Chain 3: 
    ## Chain 3: Iteration:    1 / 2000 [  0%]  (Warmup)
    ## Chain 3: Iteration:  200 / 2000 [ 10%]  (Warmup)
    ## Chain 3: Iteration:  400 / 2000 [ 20%]  (Warmup)
    ## Chain 3: Iteration:  600 / 2000 [ 30%]  (Warmup)
    ## Chain 3: Iteration:  800 / 2000 [ 40%]  (Warmup)
    ## Chain 3: Iteration: 1000 / 2000 [ 50%]  (Warmup)
    ## Chain 3: Iteration: 1001 / 2000 [ 50%]  (Sampling)
    ## Chain 3: Iteration: 1200 / 2000 [ 60%]  (Sampling)
    ## Chain 3: Iteration: 1400 / 2000 [ 70%]  (Sampling)
    ## Chain 3: Iteration: 1600 / 2000 [ 80%]  (Sampling)
    ## Chain 3: Iteration: 1800 / 2000 [ 90%]  (Sampling)
    ## Chain 3: Iteration: 2000 / 2000 [100%]  (Sampling)
    ## Chain 3: 
    ## Chain 3:  Elapsed Time: 0.458516 seconds (Warm-up)
    ## Chain 3:                0.478289 seconds (Sampling)
    ## Chain 3:                0.936805 seconds (Total)
    ## Chain 3: 
    ## 
    ## SAMPLING FOR MODEL 'bernoulli' NOW (CHAIN 4).
    ## Chain 4: 
    ## Chain 4: Gradient evaluation took 9.1e-05 seconds
    ## Chain 4: 1000 transitions using 10 leapfrog steps per transition would take 0.91 seconds.
    ## Chain 4: Adjust your expectations accordingly!
    ## Chain 4: 
    ## Chain 4: 
    ## Chain 4: Iteration:    1 / 2000 [  0%]  (Warmup)
    ## Chain 4: Iteration:  200 / 2000 [ 10%]  (Warmup)
    ## Chain 4: Iteration:  400 / 2000 [ 20%]  (Warmup)
    ## Chain 4: Iteration:  600 / 2000 [ 30%]  (Warmup)
    ## Chain 4: Iteration:  800 / 2000 [ 40%]  (Warmup)
    ## Chain 4: Iteration: 1000 / 2000 [ 50%]  (Warmup)
    ## Chain 4: Iteration: 1001 / 2000 [ 50%]  (Sampling)
    ## Chain 4: Iteration: 1200 / 2000 [ 60%]  (Sampling)
    ## Chain 4: Iteration: 1400 / 2000 [ 70%]  (Sampling)
    ## Chain 4: Iteration: 1600 / 2000 [ 80%]  (Sampling)
    ## Chain 4: Iteration: 1800 / 2000 [ 90%]  (Sampling)
    ## Chain 4: Iteration: 2000 / 2000 [100%]  (Sampling)
    ## Chain 4: 
    ## Chain 4:  Elapsed Time: 0.4651 seconds (Warm-up)
    ## Chain 4:                0.484291 seconds (Sampling)
    ## Chain 4:                0.949391 seconds (Total)
    ## Chain 4:

    print(fit_4)

    ## stan_glm
    ##  family:       binomial [logit]
    ##  formula:      Favorite_Won ~ Delta_REACH
    ##  observations: 2777
    ##  predictors:   2
    ## ------
    ##             Median MAD_SD
    ## (Intercept) 0.6    0.0   
    ## Delta_REACH 0.0    0.0   
    ## 
    ## ------
    ## * For help interpreting the printed output see ?print.stanreg
    ## * For info on the priors used see ?prior_summary.stanreg

Need to see additional decimal places for coefficients and SEs. It looks
like there is a positive effect of Reach such that fighters with longer
reaches than their opponents have a greater probability of victory than
those with shorter reaches than their opponents.

    fit_4$coefficients

    ## (Intercept) Delta_REACH 
    ##  0.56153475  0.03062914

    fit_4$ses

    ## (Intercept) Delta_REACH 
    ##  0.03856440  0.01229028

Display uncertainty in the parameters. The below graphs gives a sense of
the uncertainty as well as the magnitude of the effect. The effect of
Reach absent any other information does appear to be positive.

    sims_4 <- as.matrix(fit_4)
    n_sims_4 <- nrow(sims_4)



    draws_4 <- sample(n_sims_4, 20)

    curve(invlogit(sims_4[draws_4[1],1] + sims_4[draws_4[1],2]*x)
          , from = -15
          , to = 15
          , col = "gray"
          , lwd=0.5
          , xlab="Difference in Reach (Favorite - Underdog; inches)"
          , ylab = "Probability of Favorite Winning"
          , main = "Random Draws from Parameter Simulations"
          )

    for (j in draws_4[2:20]) {
      curve(invlogit(sims_4[j,1] + sims_4[j,2]*x)
            , col = "gray"
            , lwd=0.5
            , add=TRUE
            )
    }

![](/AttM/rmd_images/2021-04-24-bayesian_logistic_regression_analysis/unnamed-chunk-91-1.png)

Evaluate intercept (i.e. with Difference in Reach equal to zero). This
should approximately represent the average Probability of Victory of the
favorite, although not exactly since Favorites have slightly greater
reaches than their opponents on average (a little over a quarter inch).

    b1_4 <- fit_4$coefficients[[1]]
    b2_4 <- fit_4$coefficients[[2]]
    invlogit(b1_4 + b2_4 * 0)

    ## [1] 0.6368076

    mean(fit_4$data$Delta_REACH, na.rm = T)

    ## [1] 0.2747569

Now, we’ll try the divide by 4 rule for reach differences ranging from 1
to 5 inches.

    b2_4/4 * c(1:5)

    ## [1] 0.007657285 0.015314570 0.022971854 0.030629139 0.038286424

    b2_4_5 <- round(b2_4/4 * 5 * 100)
    b2_4_1 <- round(b2_4/4 * 1 * 100, 1)

It looks like those with a 5 inch reach advantage may have about a 4%
greater probability of victory than those with no reach advantage.
Indeed, each one inch reach advantage corresponds to approximately a
0.8% increase in probability of victory.

Get point predictions using predict(). As with the divide-by-4-rule, a 5
inch Reach advantage is associated with almost a 4% increase with the
Probability of the Favorite Winning.

    newx_4 = seq(-10, 10, 1)
    new_4 <- data.frame(Delta_REACH=newx_4)
    new_4$Point_Pred <- predict(fit_4, type = "response", newdata = new_4)

    min_point_pred <- round(min(new_4$Point_Pred)*100)
    max_point_pred <- round(max(new_4$Point_Pred)*100)
    diff_point_pred <- max_point_pred - min_point_pred 

With the most extreme comparison, from -10 Reach to +10 Difference in
Reach, the Probability of Victory jumps from around 56% to 70% - that’s
a 14% difference. However, as we could see from the parameter draws,
there is likely a lot of uncertainty about those more extreme estimates.

Get expected outcome with uncertainty. The uncertainty in the estimate
increases with larger Reach Difference values, which was expected.
However, for Reach Difference within 5 inches, the SDs for Probability
of Victory are below 2%.

    epred_4 <- posterior_epred(fit_4, newdata=new_4)
    new_4$Means <- apply(epred_4, 2, mean)
    new_4$SDs <- apply(epred_4, 2, sd)

Predictive distribution for new observation. Taking the mean of the
predictions gives us similar results as above.

    postpred_4 <- posterior_predict(fit_4, newdata=new_4)
    new_4$Mean_Pred <- apply(postpred_4, 2, mean)
    kable(new_4)

<table>
<thead>
<tr class="header">
<th style="text-align: right;">Delta_REACH</th>
<th style="text-align: right;">Point_Pred</th>
<th style="text-align: right;">Means</th>
<th style="text-align: right;">SDs</th>
<th style="text-align: right;">Mean_Pred</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: right;">-10</td>
<td style="text-align: right;">0.5625262</td>
<td style="text-align: right;">0.5625262</td>
<td style="text-align: right;">0.0321655</td>
<td style="text-align: right;">0.56400</td>
</tr>
<tr class="even">
<td style="text-align: right;">-9</td>
<td style="text-align: right;">0.5701204</td>
<td style="text-align: right;">0.5701204</td>
<td style="text-align: right;">0.0292140</td>
<td style="text-align: right;">0.57350</td>
</tr>
<tr class="odd">
<td style="text-align: right;">-8</td>
<td style="text-align: right;">0.5776871</td>
<td style="text-align: right;">0.5776871</td>
<td style="text-align: right;">0.0263011</td>
<td style="text-align: right;">0.58275</td>
</tr>
<tr class="even">
<td style="text-align: right;">-7</td>
<td style="text-align: right;">0.5852210</td>
<td style="text-align: right;">0.5852210</td>
<td style="text-align: right;">0.0234433</td>
<td style="text-align: right;">0.57700</td>
</tr>
<tr class="odd">
<td style="text-align: right;">-6</td>
<td style="text-align: right;">0.5927171</td>
<td style="text-align: right;">0.5927171</td>
<td style="text-align: right;">0.0206623</td>
<td style="text-align: right;">0.59700</td>
</tr>
<tr class="even">
<td style="text-align: right;">-5</td>
<td style="text-align: right;">0.6001704</td>
<td style="text-align: right;">0.6001704</td>
<td style="text-align: right;">0.0179895</td>
<td style="text-align: right;">0.59175</td>
</tr>
<tr class="odd">
<td style="text-align: right;">-4</td>
<td style="text-align: right;">0.6075762</td>
<td style="text-align: right;">0.6075762</td>
<td style="text-align: right;">0.0154719</td>
<td style="text-align: right;">0.60250</td>
</tr>
<tr class="even">
<td style="text-align: right;">-3</td>
<td style="text-align: right;">0.6149296</td>
<td style="text-align: right;">0.6149296</td>
<td style="text-align: right;">0.0131836</td>
<td style="text-align: right;">0.61700</td>
</tr>
<tr class="odd">
<td style="text-align: right;">-2</td>
<td style="text-align: right;">0.6222262</td>
<td style="text-align: right;">0.6222262</td>
<td style="text-align: right;">0.0112430</td>
<td style="text-align: right;">0.62250</td>
</tr>
<tr class="even">
<td style="text-align: right;">-1</td>
<td style="text-align: right;">0.6294616</td>
<td style="text-align: right;">0.6294616</td>
<td style="text-align: right;">0.0098272</td>
<td style="text-align: right;">0.62050</td>
</tr>
<tr class="odd">
<td style="text-align: right;">0</td>
<td style="text-align: right;">0.6366315</td>
<td style="text-align: right;">0.6366315</td>
<td style="text-align: right;">0.0091447</td>
<td style="text-align: right;">0.62875</td>
</tr>
<tr class="even">
<td style="text-align: right;">1</td>
<td style="text-align: right;">0.6437321</td>
<td style="text-align: right;">0.6437321</td>
<td style="text-align: right;">0.0093161</td>
<td style="text-align: right;">0.63800</td>
</tr>
<tr class="odd">
<td style="text-align: right;">2</td>
<td style="text-align: right;">0.6507594</td>
<td style="text-align: right;">0.6507594</td>
<td style="text-align: right;">0.0102582</td>
<td style="text-align: right;">0.64225</td>
</tr>
<tr class="even">
<td style="text-align: right;">3</td>
<td style="text-align: right;">0.6577100</td>
<td style="text-align: right;">0.6577100</td>
<td style="text-align: right;">0.0117494</td>
<td style="text-align: right;">0.65525</td>
</tr>
<tr class="odd">
<td style="text-align: right;">4</td>
<td style="text-align: right;">0.6645804</td>
<td style="text-align: right;">0.6645804</td>
<td style="text-align: right;">0.0135759</td>
<td style="text-align: right;">0.66275</td>
</tr>
<tr class="even">
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.6713676</td>
<td style="text-align: right;">0.6713676</td>
<td style="text-align: right;">0.0155891</td>
<td style="text-align: right;">0.66475</td>
</tr>
<tr class="odd">
<td style="text-align: right;">6</td>
<td style="text-align: right;">0.6780687</td>
<td style="text-align: right;">0.6780687</td>
<td style="text-align: right;">0.0176971</td>
<td style="text-align: right;">0.68675</td>
</tr>
<tr class="even">
<td style="text-align: right;">7</td>
<td style="text-align: right;">0.6846809</td>
<td style="text-align: right;">0.6846809</td>
<td style="text-align: right;">0.0198441</td>
<td style="text-align: right;">0.67525</td>
</tr>
<tr class="odd">
<td style="text-align: right;">8</td>
<td style="text-align: right;">0.6912019</td>
<td style="text-align: right;">0.6912019</td>
<td style="text-align: right;">0.0219955</td>
<td style="text-align: right;">0.69250</td>
</tr>
<tr class="even">
<td style="text-align: right;">9</td>
<td style="text-align: right;">0.6976294</td>
<td style="text-align: right;">0.6976294</td>
<td style="text-align: right;">0.0241289</td>
<td style="text-align: right;">0.69825</td>
</tr>
<tr class="odd">
<td style="text-align: right;">10</td>
<td style="text-align: right;">0.7039615</td>
<td style="text-align: right;">0.7039615</td>
<td style="text-align: right;">0.0262296</td>
<td style="text-align: right;">0.70975</td>
</tr>
</tbody>
</table>

Calculate log score for pure chance.

    logscore_chance_4 <- log(0.5) * length(fit_4$fitted.values)
    logscore_chance_4  

    ## [1] -1924.87

Calculate log score for model. The simple model with Reach clearly
outperforms chance.

    y_4 <- fit_4$model$Favorite_Won
    predp_4 <- predict(fit_4, type = "response")
    logscore_4 <- sum(y_4 * log(predp_4) + (1-y_4)*log(1-predp_4))
    logscore_4

    ## [1] -1814.43

However, does the model outperform picking the favorite at the base rate
of victory (i.e. intercept only)?

    base_rate_4 <- mean(fit_4$model$Favorite_Won)
    logscore_inter_4 <- sum(y_4 * log(base_rate_4) + (1-y_4)*log(1-base_rate_4))
    logscore_inter_4

    ## [1] -1817.558

    score_diff_inter_4 <- round(logscore_4 - logscore_inter_4,2)

It does, but not by much - only by a logscore of 3.13, which means
adding Reach as a factor probably minimally improves the predictions.

Run leave one out cross validation. We don’t have another model to
compare it to but we can see that elpd\_loo is is about two points more
negative than the logscore calculation which is not surprising given
that the model has two parameters.

    loo_4 <- loo(fit_4)
    print(loo_4)

    ## 
    ## Computed from 4000 by 2777 log-likelihood matrix
    ## 
    ##          Estimate   SE
    ## elpd_loo  -1816.4 14.6
    ## p_loo         2.0  0.0
    ## looic      3632.8 29.2
    ## ------
    ## Monte Carlo SE of elpd_loo is 0.0.
    ## 
    ## All Pareto k estimates are good (k < 0.5).
    ## See help('pareto-k-diagnostic') for details.

<br>

### Impute Missing Reach Values for Two Predictor Model

Do simple random imputation.

We want to avoid removing cases with missing Reach values since, as we
saw earlier, those cases overrepresent underperformances and underdogs.
Therefore, if we were to remove them, we may bias the results and affect
the relationship between Adjusted Fight Odds and the outcome variable
(Probability of Favorite Winning).

NOTE: With a more complex model, with multiple predictors and missing
values across them, we may consider multiple imputation.

Based on the summary below, we see that the imputed values of Difference
in Reach are virtually the same as the original ones (i.e. with NAs
excluded). This is as expected, especially since we only replaced
approximately 7% of Reach entries (NAs).

    random_imp <- function(a) {
      missing <- is.na(a)
      n_missing <- sum(missing)
      a_obs <- a[!missing]
      imputed <- a
      imputed[missing] <- sample(a_obs, n_missing)
      
      return(imputed)
    }

    df_og_diff$Delta_REACH_imp <- random_imp(df_og_diff$Delta_REACH)

    summary(df_og_diff)

    ##     fight_id    Favorite_Won        Sex            Year       Delta_REACH      
    ##  1      :   1   Mode :logical   Female: 385   Min.   :2013   Min.   :-10.0000  
    ##  2      :   1   FALSE:1057      Male  :2603   1st Qu.:2015   1st Qu.: -2.0000  
    ##  3      :   1   TRUE :1931                    Median :2017   Median :  0.0000  
    ##  4      :   1                                 Mean   :2017   Mean   :  0.2748  
    ##  5      :   1                                 3rd Qu.:2019   3rd Qu.:  2.0000  
    ##  6      :   1                                 Max.   :2021   Max.   : 12.0000  
    ##  (Other):2982                                                NA's   :211       
    ##     Log_Odds        Implied_Prob    Adjust_Implied_Prob Adjust_Log_Odds   
    ##  Min.   :-0.4055   Min.   :0.4000   Min.   :0.5012      Min.   :0.004782  
    ##  1st Qu.: 0.3147   1st Qu.:0.5780   1st Qu.:0.5778      1st Qu.:0.313771  
    ##  Median : 0.5798   Median :0.6410   Median :0.6406      Median :0.577952  
    ##  Mean   : 0.6948   Mean   :0.6576   Mean   :0.6553      Mean   :0.682173  
    ##  3rd Qu.: 0.9943   3rd Qu.:0.7299   3rd Qu.:0.7261      3rd Qu.:0.974797  
    ##  Max.   : 2.8134   Max.   :0.9434   Max.   :0.9327      Max.   :2.628868  
    ##                                                                           
    ##  Adjust_Log_Odds_sq Delta_REACH_imp   
    ##  Min.   :0.000023   Min.   :-10.0000  
    ##  1st Qu.:0.098452   1st Qu.: -2.0000  
    ##  Median :0.334029   Median :  0.0000  
    ##  Mean   :0.699743   Mean   :  0.2734  
    ##  3rd Qu.:0.950229   3rd Qu.:  2.0000  
    ##  Max.   :6.910949   Max.   : 12.0000  
    ## 

<br>

### Two Predictor Model: Imputed Reach and Adjusted Log Odds

    fit_5 <- stan_glm(Favorite_Won ~ Adjust_Log_Odds + Delta_REACH_imp
                      , family=binomial(link="logit")
                      , data = df_og_diff
                      )

    ## 
    ## SAMPLING FOR MODEL 'bernoulli' NOW (CHAIN 1).
    ## Chain 1: 
    ## Chain 1: Gradient evaluation took 0.000108 seconds
    ## Chain 1: 1000 transitions using 10 leapfrog steps per transition would take 1.08 seconds.
    ## Chain 1: Adjust your expectations accordingly!
    ## Chain 1: 
    ## Chain 1: 
    ## Chain 1: Iteration:    1 / 2000 [  0%]  (Warmup)
    ## Chain 1: Iteration:  200 / 2000 [ 10%]  (Warmup)
    ## Chain 1: Iteration:  400 / 2000 [ 20%]  (Warmup)
    ## Chain 1: Iteration:  600 / 2000 [ 30%]  (Warmup)
    ## Chain 1: Iteration:  800 / 2000 [ 40%]  (Warmup)
    ## Chain 1: Iteration: 1000 / 2000 [ 50%]  (Warmup)
    ## Chain 1: Iteration: 1001 / 2000 [ 50%]  (Sampling)
    ## Chain 1: Iteration: 1200 / 2000 [ 60%]  (Sampling)
    ## Chain 1: Iteration: 1400 / 2000 [ 70%]  (Sampling)
    ## Chain 1: Iteration: 1600 / 2000 [ 80%]  (Sampling)
    ## Chain 1: Iteration: 1800 / 2000 [ 90%]  (Sampling)
    ## Chain 1: Iteration: 2000 / 2000 [100%]  (Sampling)
    ## Chain 1: 
    ## Chain 1:  Elapsed Time: 0.618832 seconds (Warm-up)
    ## Chain 1:                0.706744 seconds (Sampling)
    ## Chain 1:                1.32558 seconds (Total)
    ## Chain 1: 
    ## 
    ## SAMPLING FOR MODEL 'bernoulli' NOW (CHAIN 2).
    ## Chain 2: 
    ## Chain 2: Gradient evaluation took 0.000102 seconds
    ## Chain 2: 1000 transitions using 10 leapfrog steps per transition would take 1.02 seconds.
    ## Chain 2: Adjust your expectations accordingly!
    ## Chain 2: 
    ## Chain 2: 
    ## Chain 2: Iteration:    1 / 2000 [  0%]  (Warmup)
    ## Chain 2: Iteration:  200 / 2000 [ 10%]  (Warmup)
    ## Chain 2: Iteration:  400 / 2000 [ 20%]  (Warmup)
    ## Chain 2: Iteration:  600 / 2000 [ 30%]  (Warmup)
    ## Chain 2: Iteration:  800 / 2000 [ 40%]  (Warmup)
    ## Chain 2: Iteration: 1000 / 2000 [ 50%]  (Warmup)
    ## Chain 2: Iteration: 1001 / 2000 [ 50%]  (Sampling)
    ## Chain 2: Iteration: 1200 / 2000 [ 60%]  (Sampling)
    ## Chain 2: Iteration: 1400 / 2000 [ 70%]  (Sampling)
    ## Chain 2: Iteration: 1600 / 2000 [ 80%]  (Sampling)
    ## Chain 2: Iteration: 1800 / 2000 [ 90%]  (Sampling)
    ## Chain 2: Iteration: 2000 / 2000 [100%]  (Sampling)
    ## Chain 2: 
    ## Chain 2:  Elapsed Time: 0.662914 seconds (Warm-up)
    ## Chain 2:                0.699454 seconds (Sampling)
    ## Chain 2:                1.36237 seconds (Total)
    ## Chain 2: 
    ## 
    ## SAMPLING FOR MODEL 'bernoulli' NOW (CHAIN 3).
    ## Chain 3: 
    ## Chain 3: Gradient evaluation took 0.000103 seconds
    ## Chain 3: 1000 transitions using 10 leapfrog steps per transition would take 1.03 seconds.
    ## Chain 3: Adjust your expectations accordingly!
    ## Chain 3: 
    ## Chain 3: 
    ## Chain 3: Iteration:    1 / 2000 [  0%]  (Warmup)
    ## Chain 3: Iteration:  200 / 2000 [ 10%]  (Warmup)
    ## Chain 3: Iteration:  400 / 2000 [ 20%]  (Warmup)
    ## Chain 3: Iteration:  600 / 2000 [ 30%]  (Warmup)
    ## Chain 3: Iteration:  800 / 2000 [ 40%]  (Warmup)
    ## Chain 3: Iteration: 1000 / 2000 [ 50%]  (Warmup)
    ## Chain 3: Iteration: 1001 / 2000 [ 50%]  (Sampling)
    ## Chain 3: Iteration: 1200 / 2000 [ 60%]  (Sampling)
    ## Chain 3: Iteration: 1400 / 2000 [ 70%]  (Sampling)
    ## Chain 3: Iteration: 1600 / 2000 [ 80%]  (Sampling)
    ## Chain 3: Iteration: 1800 / 2000 [ 90%]  (Sampling)
    ## Chain 3: Iteration: 2000 / 2000 [100%]  (Sampling)
    ## Chain 3: 
    ## Chain 3:  Elapsed Time: 0.61107 seconds (Warm-up)
    ## Chain 3:                0.70918 seconds (Sampling)
    ## Chain 3:                1.32025 seconds (Total)
    ## Chain 3: 
    ## 
    ## SAMPLING FOR MODEL 'bernoulli' NOW (CHAIN 4).
    ## Chain 4: 
    ## Chain 4: Gradient evaluation took 9.4e-05 seconds
    ## Chain 4: 1000 transitions using 10 leapfrog steps per transition would take 0.94 seconds.
    ## Chain 4: Adjust your expectations accordingly!
    ## Chain 4: 
    ## Chain 4: 
    ## Chain 4: Iteration:    1 / 2000 [  0%]  (Warmup)
    ## Chain 4: Iteration:  200 / 2000 [ 10%]  (Warmup)
    ## Chain 4: Iteration:  400 / 2000 [ 20%]  (Warmup)
    ## Chain 4: Iteration:  600 / 2000 [ 30%]  (Warmup)
    ## Chain 4: Iteration:  800 / 2000 [ 40%]  (Warmup)
    ## Chain 4: Iteration: 1000 / 2000 [ 50%]  (Warmup)
    ## Chain 4: Iteration: 1001 / 2000 [ 50%]  (Sampling)
    ## Chain 4: Iteration: 1200 / 2000 [ 60%]  (Sampling)
    ## Chain 4: Iteration: 1400 / 2000 [ 70%]  (Sampling)
    ## Chain 4: Iteration: 1600 / 2000 [ 80%]  (Sampling)
    ## Chain 4: Iteration: 1800 / 2000 [ 90%]  (Sampling)
    ## Chain 4: Iteration: 2000 / 2000 [100%]  (Sampling)
    ## Chain 4: 
    ## Chain 4:  Elapsed Time: 0.615998 seconds (Warm-up)
    ## Chain 4:                0.691082 seconds (Sampling)
    ## Chain 4:                1.30708 seconds (Total)
    ## Chain 4:

    print(fit_5)

    ## stan_glm
    ##  family:       binomial [logit]
    ##  formula:      Favorite_Won ~ Adjust_Log_Odds + Delta_REACH_imp
    ##  observations: 2988
    ##  predictors:   3
    ## ------
    ##                 Median MAD_SD
    ## (Intercept)     -0.2    0.1  
    ## Adjust_Log_Odds  1.2    0.1  
    ## Delta_REACH_imp  0.0    0.0  
    ## 
    ## ------
    ## * For help interpreting the printed output see ?print.stanreg
    ## * For info on the priors used see ?prior_summary.stanreg

Get better sense of coefficients. Unsurprisingly, Adjusted Log Odds
still has a large effect. The (imputed) Difference in Reach still seems
to have an effect. The magnitude of the effect decreased a bit but the
standard error stayed about the same (compared to the model with just
Reach).

    fit_5$coefficients

    ##     (Intercept) Adjust_Log_Odds Delta_REACH_imp 
    ##     -0.19006516      1.24198698      0.02357245

    fit_5$ses

    ##     (Intercept) Adjust_Log_Odds Delta_REACH_imp 
    ##      0.06827189      0.09365881      0.01213586

Display uncertainty in the parameters. The graph below plots random
draws from the parameter simulations for 5 values of Difference in
Reach: -10 (green), -5 inches (red), 0 inches (grey), +5 inches (blue),
and +10 (yellow). We see the Difference in Reach sort of just shifts the
curves (and therefore the Probability of the Favorite Winning) upwards.

    sims_5 <- as.matrix(fit_5)
    n_sims_5 <- nrow(sims_5)

    draws_5 <- sample(n_sims_5, 20)

    curve(invlogit(sims_5[draws_5[1],1] + sims_5[draws_5[1],2]*x + sims_5[draws_5[1],3]*(0))
        , from = 0
        , to = 3
        , col = "black"
        , lwd=0.0       # make invisible, just used to set up plot. 
        , xlab="Adjusted Log Odds of Favorite"
        , ylab = "Probability of Favorite Winning"
        , main = "Random Draws from Parameter Simulations"
        )

    for (j in draws_5) {
      
       curve(invlogit(sims_5[j,1] + sims_5[j,2]*x + sims_5[j,3]*(-10))
            , col = "green"
            , lwd=0.3
            , add=TRUE
            )
      
        curve(invlogit(sims_5[j,1] + sims_5[j,2]*x + sims_5[j,3]*(-5))
            , col = "red"
            , lwd=0.3
            , add=TRUE
            )
      
        curve(invlogit(sims_5[j,1] + sims_5[j,2]*x + sims_5[j,3]*(0))
            , col = "black"
            , lwd=0.3
            , add=TRUE
            )
        
          curve(invlogit(sims_5[j,1] + sims_5[j,2]*x + sims_5[j,3]*(+5))
            , col = "blue"
            , lwd=0.3
            , add=TRUE
            )
          
          curve(invlogit(sims_5[j,1] + sims_5[j,2]*x + sims_5[j,3]*(+10))
            , col = "yellow"
            , lwd=0.3
            , add=TRUE
            )
    }

![](/AttM/rmd_images/2021-04-24-bayesian_logistic_regression_analysis/unnamed-chunk-104-1.png)

Now do the same with the backtransformed predictors (i.e. Adjusted Log
Odds to Implied Probabilities). It appears that when there is no Reach
Difference (i.e. black lines), the model account for some of the
underperformance of mild favorites / overperformance of large favorites.
Otherwise, Reach Difference simply results in a shift in the curve.

    curve(invlogit(sims_5[draws_5[1],1] + sims_5[draws_5[1],2]*logit(x) + sims_5[draws_5[1],3]*(0))
        , from = 0.5
        , to = 1
        , col = "black"
        , lwd=0.0       # make invisible, just used to set up plot. 
        , xlab="Adjusted Implied Probability of Favorite"
        , ylab = "Probability of Favorite Winning"
        , main = "Random Draws from Parameter Simulations"
        )

    for (j in draws_5) {
      
       curve(invlogit(sims_5[j,1] + sims_5[j,2]*logit(x) + sims_5[j,3]*(-10))
            , col = "green"
            , lwd=0.3
            , add=TRUE
            )
      
        curve(invlogit(sims_5[j,1] + sims_5[j,2]*logit(x) + sims_5[j,3]*(-5))
            , col = "red"
            , lwd=0.3
            , add=TRUE
            )
      
        curve(invlogit(sims_5[j,1] + sims_5[j,2]*logit(x) + sims_5[j,3]*(0))
            , col = "black"
            , lwd=0.3
            , add=TRUE
            )
        
          curve(invlogit(sims_5[j,1] + sims_5[j,2]*logit(x) + sims_5[j,3]*(+5))
            , col = "blue"
            , lwd=0.3
            , add=TRUE
            )
          
          curve(invlogit(sims_5[j,1] + sims_5[j,2]*logit(x) + sims_5[j,3]*(+10))
            , col = "yellow"
            , lwd=0.3
            , add=TRUE
            )
    }


    abline(a=0, b=1, col = "black", lwd = 2, lty = 3)

![](/AttM/rmd_images/2021-04-24-bayesian_logistic_regression_analysis/unnamed-chunk-105-1.png)

Get point predictions and compare them to Adjusted Log Odds
backtransformed to Implied Probabilities.

    new_5 <- data.frame(Adjust_Log_Odds=rep(newx, each = 21), Delta_REACH_imp=newx_4)
    new_5$Point_Pred <- predict(fit_5, type = "response", newdata = new_5)

    new_5$BackTrans_Implied_Prob <- invlogit(new_5$Adjust_Log_Odds) 

Get expected outcome with uncertainty.

    epred_5 <- posterior_epred(fit_5, newdata=new_5)

    new_5$Means <- apply(epred_5, 2, mean)
    new_5$SDs <- apply(epred_5, 2, sd)

Predictive distribution for new observation.

    postpred_5 <- posterior_predict(fit_5, newdata=new_5)

    new_5$Pred_Ms <- apply(postpred_5, 2, mean)
    kable(new_5)

<table>
<colgroup>
<col style="width: 17%" />
<col style="width: 17%" />
<col style="width: 11%" />
<col style="width: 24%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 8%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: right;">Adjust_Log_Odds</th>
<th style="text-align: right;">Delta_REACH_imp</th>
<th style="text-align: right;">Point_Pred</th>
<th style="text-align: right;">BackTrans_Implied_Prob</th>
<th style="text-align: right;">Means</th>
<th style="text-align: right;">SDs</th>
<th style="text-align: right;">Pred_Ms</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">-10</td>
<td style="text-align: right;">0.3955847</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">0.3955847</td>
<td style="text-align: right;">0.0331463</td>
<td style="text-align: right;">0.38500</td>
</tr>
<tr class="even">
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">-9</td>
<td style="text-align: right;">0.4011308</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">0.4011308</td>
<td style="text-align: right;">0.0308774</td>
<td style="text-align: right;">0.38350</td>
</tr>
<tr class="odd">
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">-8</td>
<td style="text-align: right;">0.4067158</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">0.4067158</td>
<td style="text-align: right;">0.0286508</td>
<td style="text-align: right;">0.42050</td>
</tr>
<tr class="even">
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">-7</td>
<td style="text-align: right;">0.4123376</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">0.4123376</td>
<td style="text-align: right;">0.0264902</td>
<td style="text-align: right;">0.40600</td>
</tr>
<tr class="odd">
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">-6</td>
<td style="text-align: right;">0.4179938</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">0.4179938</td>
<td style="text-align: right;">0.0244261</td>
<td style="text-align: right;">0.42275</td>
</tr>
<tr class="even">
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">-5</td>
<td style="text-align: right;">0.4236821</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">0.4236821</td>
<td style="text-align: right;">0.0224986</td>
<td style="text-align: right;">0.43050</td>
</tr>
<tr class="odd">
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">-4</td>
<td style="text-align: right;">0.4294000</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">0.4294000</td>
<td style="text-align: right;">0.0207595</td>
<td style="text-align: right;">0.42225</td>
</tr>
<tr class="even">
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">-3</td>
<td style="text-align: right;">0.4351451</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">0.4351451</td>
<td style="text-align: right;">0.0192731</td>
<td style="text-align: right;">0.43850</td>
</tr>
<tr class="odd">
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">-2</td>
<td style="text-align: right;">0.4409146</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">0.4409146</td>
<td style="text-align: right;">0.0181143</td>
<td style="text-align: right;">0.43250</td>
</tr>
<tr class="even">
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">-1</td>
<td style="text-align: right;">0.4467061</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">0.4467061</td>
<td style="text-align: right;">0.0173604</td>
<td style="text-align: right;">0.45100</td>
</tr>
<tr class="odd">
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0.4525167</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">0.4525167</td>
<td style="text-align: right;">0.0170750</td>
<td style="text-align: right;">0.45050</td>
</tr>
<tr class="even">
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">0.4583438</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">0.4583438</td>
<td style="text-align: right;">0.0172891</td>
<td style="text-align: right;">0.44925</td>
</tr>
<tr class="odd">
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">2</td>
<td style="text-align: right;">0.4641845</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">0.4641845</td>
<td style="text-align: right;">0.0179906</td>
<td style="text-align: right;">0.46575</td>
</tr>
<tr class="even">
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">3</td>
<td style="text-align: right;">0.4700360</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">0.4700360</td>
<td style="text-align: right;">0.0191293</td>
<td style="text-align: right;">0.47025</td>
</tr>
<tr class="odd">
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">4</td>
<td style="text-align: right;">0.4758956</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">0.4758956</td>
<td style="text-align: right;">0.0206345</td>
<td style="text-align: right;">0.47350</td>
</tr>
<tr class="even">
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.4817602</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">0.4817602</td>
<td style="text-align: right;">0.0224321</td>
<td style="text-align: right;">0.47825</td>
</tr>
<tr class="odd">
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">0.4876271</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">0.4876271</td>
<td style="text-align: right;">0.0244561</td>
<td style="text-align: right;">0.48450</td>
</tr>
<tr class="even">
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">0.4934935</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">0.4934935</td>
<td style="text-align: right;">0.0266519</td>
<td style="text-align: right;">0.48300</td>
</tr>
<tr class="odd">
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">8</td>
<td style="text-align: right;">0.4993563</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">0.4993563</td>
<td style="text-align: right;">0.0289766</td>
<td style="text-align: right;">0.51300</td>
</tr>
<tr class="even">
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">9</td>
<td style="text-align: right;">0.5052129</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">0.5052129</td>
<td style="text-align: right;">0.0313968</td>
<td style="text-align: right;">0.51175</td>
</tr>
<tr class="odd">
<td style="text-align: right;">0.0</td>
<td style="text-align: right;">10</td>
<td style="text-align: right;">0.5110603</td>
<td style="text-align: right;">0.5000000</td>
<td style="text-align: right;">0.5110603</td>
<td style="text-align: right;">0.0338866</td>
<td style="text-align: right;">0.49875</td>
</tr>
<tr class="even">
<td style="text-align: right;">0.5</td>
<td style="text-align: right;">-10</td>
<td style="text-align: right;">0.5486025</td>
<td style="text-align: right;">0.6224593</td>
<td style="text-align: right;">0.5486025</td>
<td style="text-align: right;">0.0317580</td>
<td style="text-align: right;">0.54125</td>
</tr>
<tr class="odd">
<td style="text-align: right;">0.5</td>
<td style="text-align: right;">-9</td>
<td style="text-align: right;">0.5544326</td>
<td style="text-align: right;">0.6224593</td>
<td style="text-align: right;">0.5544326</td>
<td style="text-align: right;">0.0289347</td>
<td style="text-align: right;">0.54700</td>
</tr>
<tr class="even">
<td style="text-align: right;">0.5</td>
<td style="text-align: right;">-8</td>
<td style="text-align: right;">0.5602515</td>
<td style="text-align: right;">0.6224593</td>
<td style="text-align: right;">0.5602515</td>
<td style="text-align: right;">0.0261492</td>
<td style="text-align: right;">0.56875</td>
</tr>
<tr class="odd">
<td style="text-align: right;">0.5</td>
<td style="text-align: right;">-7</td>
<td style="text-align: right;">0.5660565</td>
<td style="text-align: right;">0.6224593</td>
<td style="text-align: right;">0.5660565</td>
<td style="text-align: right;">0.0234171</td>
<td style="text-align: right;">0.56700</td>
</tr>
<tr class="even">
<td style="text-align: right;">0.5</td>
<td style="text-align: right;">-6</td>
<td style="text-align: right;">0.5718448</td>
<td style="text-align: right;">0.6224593</td>
<td style="text-align: right;">0.5718448</td>
<td style="text-align: right;">0.0207599</td>
<td style="text-align: right;">0.56750</td>
</tr>
<tr class="odd">
<td style="text-align: right;">0.5</td>
<td style="text-align: right;">-5</td>
<td style="text-align: right;">0.5776135</td>
<td style="text-align: right;">0.6224593</td>
<td style="text-align: right;">0.5776135</td>
<td style="text-align: right;">0.0182088</td>
<td style="text-align: right;">0.59150</td>
</tr>
<tr class="even">
<td style="text-align: right;">0.5</td>
<td style="text-align: right;">-4</td>
<td style="text-align: right;">0.5833601</td>
<td style="text-align: right;">0.6224593</td>
<td style="text-align: right;">0.5833601</td>
<td style="text-align: right;">0.0158114</td>
<td style="text-align: right;">0.58625</td>
</tr>
<tr class="odd">
<td style="text-align: right;">0.5</td>
<td style="text-align: right;">-3</td>
<td style="text-align: right;">0.5890818</td>
<td style="text-align: right;">0.6224593</td>
<td style="text-align: right;">0.5890818</td>
<td style="text-align: right;">0.0136417</td>
<td style="text-align: right;">0.59100</td>
</tr>
<tr class="even">
<td style="text-align: right;">0.5</td>
<td style="text-align: right;">-2</td>
<td style="text-align: right;">0.5947759</td>
<td style="text-align: right;">0.6224593</td>
<td style="text-align: right;">0.5947759</td>
<td style="text-align: right;">0.0118143</td>
<td style="text-align: right;">0.60325</td>
</tr>
<tr class="odd">
<td style="text-align: right;">0.5</td>
<td style="text-align: right;">-1</td>
<td style="text-align: right;">0.6004400</td>
<td style="text-align: right;">0.6224593</td>
<td style="text-align: right;">0.6004400</td>
<td style="text-align: right;">0.0104937</td>
<td style="text-align: right;">0.60325</td>
</tr>
<tr class="even">
<td style="text-align: right;">0.5</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0.6060714</td>
<td style="text-align: right;">0.6224593</td>
<td style="text-align: right;">0.6060714</td>
<td style="text-align: right;">0.0098651</td>
<td style="text-align: right;">0.60500</td>
</tr>
<tr class="odd">
<td style="text-align: right;">0.5</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">0.6116679</td>
<td style="text-align: right;">0.6224593</td>
<td style="text-align: right;">0.6116679</td>
<td style="text-align: right;">0.0100368</td>
<td style="text-align: right;">0.61775</td>
</tr>
<tr class="even">
<td style="text-align: right;">0.5</td>
<td style="text-align: right;">2</td>
<td style="text-align: right;">0.6172270</td>
<td style="text-align: right;">0.6224593</td>
<td style="text-align: right;">0.6172270</td>
<td style="text-align: right;">0.0109481</td>
<td style="text-align: right;">0.63375</td>
</tr>
<tr class="odd">
<td style="text-align: right;">0.5</td>
<td style="text-align: right;">3</td>
<td style="text-align: right;">0.6227465</td>
<td style="text-align: right;">0.6224593</td>
<td style="text-align: right;">0.6227465</td>
<td style="text-align: right;">0.0124154</td>
<td style="text-align: right;">0.61325</td>
</tr>
<tr class="even">
<td style="text-align: right;">0.5</td>
<td style="text-align: right;">4</td>
<td style="text-align: right;">0.6282242</td>
<td style="text-align: right;">0.6224593</td>
<td style="text-align: right;">0.6282242</td>
<td style="text-align: right;">0.0142472</td>
<td style="text-align: right;">0.64125</td>
</tr>
<tr class="odd">
<td style="text-align: right;">0.5</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.6336580</td>
<td style="text-align: right;">0.6224593</td>
<td style="text-align: right;">0.6336580</td>
<td style="text-align: right;">0.0163018</td>
<td style="text-align: right;">0.63700</td>
</tr>
<tr class="even">
<td style="text-align: right;">0.5</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">0.6390460</td>
<td style="text-align: right;">0.6224593</td>
<td style="text-align: right;">0.6390460</td>
<td style="text-align: right;">0.0184870</td>
<td style="text-align: right;">0.63600</td>
</tr>
<tr class="odd">
<td style="text-align: right;">0.5</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">0.6443862</td>
<td style="text-align: right;">0.6224593</td>
<td style="text-align: right;">0.6443862</td>
<td style="text-align: right;">0.0207450</td>
<td style="text-align: right;">0.65350</td>
</tr>
<tr class="even">
<td style="text-align: right;">0.5</td>
<td style="text-align: right;">8</td>
<td style="text-align: right;">0.6496768</td>
<td style="text-align: right;">0.6224593</td>
<td style="text-align: right;">0.6496768</td>
<td style="text-align: right;">0.0230388</td>
<td style="text-align: right;">0.64625</td>
</tr>
<tr class="odd">
<td style="text-align: right;">0.5</td>
<td style="text-align: right;">9</td>
<td style="text-align: right;">0.6549163</td>
<td style="text-align: right;">0.6224593</td>
<td style="text-align: right;">0.6549163</td>
<td style="text-align: right;">0.0253441</td>
<td style="text-align: right;">0.64875</td>
</tr>
<tr class="even">
<td style="text-align: right;">0.5</td>
<td style="text-align: right;">10</td>
<td style="text-align: right;">0.6601029</td>
<td style="text-align: right;">0.6224593</td>
<td style="text-align: right;">0.6601029</td>
<td style="text-align: right;">0.0276447</td>
<td style="text-align: right;">0.67225</td>
</tr>
<tr class="odd">
<td style="text-align: right;">1.0</td>
<td style="text-align: right;">-10</td>
<td style="text-align: right;">0.6929719</td>
<td style="text-align: right;">0.7310586</td>
<td style="text-align: right;">0.6929719</td>
<td style="text-align: right;">0.0286974</td>
<td style="text-align: right;">0.70400</td>
</tr>
<tr class="even">
<td style="text-align: right;">1.0</td>
<td style="text-align: right;">-9</td>
<td style="text-align: right;">0.6980489</td>
<td style="text-align: right;">0.7310586</td>
<td style="text-align: right;">0.6980489</td>
<td style="text-align: right;">0.0261868</td>
<td style="text-align: right;">0.69100</td>
</tr>
<tr class="odd">
<td style="text-align: right;">1.0</td>
<td style="text-align: right;">-8</td>
<td style="text-align: right;">0.7030720</td>
<td style="text-align: right;">0.7310586</td>
<td style="text-align: right;">0.7030720</td>
<td style="text-align: right;">0.0237609</td>
<td style="text-align: right;">0.70900</td>
</tr>
<tr class="even">
<td style="text-align: right;">1.0</td>
<td style="text-align: right;">-7</td>
<td style="text-align: right;">0.7080398</td>
<td style="text-align: right;">0.7310586</td>
<td style="text-align: right;">0.7080398</td>
<td style="text-align: right;">0.0214350</td>
<td style="text-align: right;">0.70825</td>
</tr>
<tr class="odd">
<td style="text-align: right;">1.0</td>
<td style="text-align: right;">-6</td>
<td style="text-align: right;">0.7129508</td>
<td style="text-align: right;">0.7310586</td>
<td style="text-align: right;">0.7129508</td>
<td style="text-align: right;">0.0192294</td>
<td style="text-align: right;">0.71500</td>
</tr>
<tr class="even">
<td style="text-align: right;">1.0</td>
<td style="text-align: right;">-5</td>
<td style="text-align: right;">0.7178035</td>
<td style="text-align: right;">0.7310586</td>
<td style="text-align: right;">0.7178035</td>
<td style="text-align: right;">0.0171717</td>
<td style="text-align: right;">0.71375</td>
</tr>
<tr class="odd">
<td style="text-align: right;">1.0</td>
<td style="text-align: right;">-4</td>
<td style="text-align: right;">0.7225969</td>
<td style="text-align: right;">0.7310586</td>
<td style="text-align: right;">0.7225969</td>
<td style="text-align: right;">0.0153000</td>
<td style="text-align: right;">0.71550</td>
</tr>
<tr class="even">
<td style="text-align: right;">1.0</td>
<td style="text-align: right;">-3</td>
<td style="text-align: right;">0.7273296</td>
<td style="text-align: right;">0.7310586</td>
<td style="text-align: right;">0.7273296</td>
<td style="text-align: right;">0.0136655</td>
<td style="text-align: right;">0.72325</td>
</tr>
<tr class="odd">
<td style="text-align: right;">1.0</td>
<td style="text-align: right;">-2</td>
<td style="text-align: right;">0.7320006</td>
<td style="text-align: right;">0.7310586</td>
<td style="text-align: right;">0.7320006</td>
<td style="text-align: right;">0.0123344</td>
<td style="text-align: right;">0.72950</td>
</tr>
<tr class="even">
<td style="text-align: right;">1.0</td>
<td style="text-align: right;">-1</td>
<td style="text-align: right;">0.7366091</td>
<td style="text-align: right;">0.7310586</td>
<td style="text-align: right;">0.7366091</td>
<td style="text-align: right;">0.0113822</td>
<td style="text-align: right;">0.74575</td>
</tr>
<tr class="odd">
<td style="text-align: right;">1.0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0.7411541</td>
<td style="text-align: right;">0.7310586</td>
<td style="text-align: right;">0.7411541</td>
<td style="text-align: right;">0.0108759</td>
<td style="text-align: right;">0.73850</td>
</tr>
<tr class="even">
<td style="text-align: right;">1.0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">0.7456350</td>
<td style="text-align: right;">0.7310586</td>
<td style="text-align: right;">0.7456350</td>
<td style="text-align: right;">0.0108450</td>
<td style="text-align: right;">0.74275</td>
</tr>
<tr class="odd">
<td style="text-align: right;">1.0</td>
<td style="text-align: right;">2</td>
<td style="text-align: right;">0.7500511</td>
<td style="text-align: right;">0.7310586</td>
<td style="text-align: right;">0.7500511</td>
<td style="text-align: right;">0.0112620</td>
<td style="text-align: right;">0.75225</td>
</tr>
<tr class="even">
<td style="text-align: right;">1.0</td>
<td style="text-align: right;">3</td>
<td style="text-align: right;">0.7544019</td>
<td style="text-align: right;">0.7310586</td>
<td style="text-align: right;">0.7544019</td>
<td style="text-align: right;">0.0120515</td>
<td style="text-align: right;">0.75175</td>
</tr>
<tr class="odd">
<td style="text-align: right;">1.0</td>
<td style="text-align: right;">4</td>
<td style="text-align: right;">0.7586870</td>
<td style="text-align: right;">0.7310586</td>
<td style="text-align: right;">0.7586870</td>
<td style="text-align: right;">0.0131203</td>
<td style="text-align: right;">0.76750</td>
</tr>
<tr class="even">
<td style="text-align: right;">1.0</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.7629059</td>
<td style="text-align: right;">0.7310586</td>
<td style="text-align: right;">0.7629059</td>
<td style="text-align: right;">0.0143828</td>
<td style="text-align: right;">0.76125</td>
</tr>
<tr class="odd">
<td style="text-align: right;">1.0</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">0.7670586</td>
<td style="text-align: right;">0.7310586</td>
<td style="text-align: right;">0.7670586</td>
<td style="text-align: right;">0.0157720</td>
<td style="text-align: right;">0.76100</td>
</tr>
<tr class="even">
<td style="text-align: right;">1.0</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">0.7711447</td>
<td style="text-align: right;">0.7310586</td>
<td style="text-align: right;">0.7711447</td>
<td style="text-align: right;">0.0172385</td>
<td style="text-align: right;">0.77025</td>
</tr>
<tr class="odd">
<td style="text-align: right;">1.0</td>
<td style="text-align: right;">8</td>
<td style="text-align: right;">0.7751642</td>
<td style="text-align: right;">0.7310586</td>
<td style="text-align: right;">0.7751642</td>
<td style="text-align: right;">0.0187480</td>
<td style="text-align: right;">0.78125</td>
</tr>
<tr class="even">
<td style="text-align: right;">1.0</td>
<td style="text-align: right;">9</td>
<td style="text-align: right;">0.7791172</td>
<td style="text-align: right;">0.7310586</td>
<td style="text-align: right;">0.7791172</td>
<td style="text-align: right;">0.0202760</td>
<td style="text-align: right;">0.77825</td>
</tr>
<tr class="odd">
<td style="text-align: right;">1.0</td>
<td style="text-align: right;">10</td>
<td style="text-align: right;">0.7830037</td>
<td style="text-align: right;">0.7310586</td>
<td style="text-align: right;">0.7830037</td>
<td style="text-align: right;">0.0218057</td>
<td style="text-align: right;">0.79525</td>
</tr>
<tr class="even">
<td style="text-align: right;">1.5</td>
<td style="text-align: right;">-10</td>
<td style="text-align: right;">0.8071793</td>
<td style="text-align: right;">0.8175745</td>
<td style="text-align: right;">0.8071793</td>
<td style="text-align: right;">0.0243405</td>
<td style="text-align: right;">0.81125</td>
</tr>
<tr class="odd">
<td style="text-align: right;">1.5</td>
<td style="text-align: right;">-9</td>
<td style="text-align: right;">0.8109322</td>
<td style="text-align: right;">0.8175745</td>
<td style="text-align: right;">0.8109322</td>
<td style="text-align: right;">0.0225683</td>
<td style="text-align: right;">0.79875</td>
</tr>
<tr class="even">
<td style="text-align: right;">1.5</td>
<td style="text-align: right;">-8</td>
<td style="text-align: right;">0.8146189</td>
<td style="text-align: right;">0.8175745</td>
<td style="text-align: right;">0.8146189</td>
<td style="text-align: right;">0.0209012</td>
<td style="text-align: right;">0.82650</td>
</tr>
<tr class="odd">
<td style="text-align: right;">1.5</td>
<td style="text-align: right;">-7</td>
<td style="text-align: right;">0.8182394</td>
<td style="text-align: right;">0.8175745</td>
<td style="text-align: right;">0.8182394</td>
<td style="text-align: right;">0.0193490</td>
<td style="text-align: right;">0.81250</td>
</tr>
<tr class="even">
<td style="text-align: right;">1.5</td>
<td style="text-align: right;">-6</td>
<td style="text-align: right;">0.8217940</td>
<td style="text-align: right;">0.8175745</td>
<td style="text-align: right;">0.8217940</td>
<td style="text-align: right;">0.0179231</td>
<td style="text-align: right;">0.82250</td>
</tr>
<tr class="odd">
<td style="text-align: right;">1.5</td>
<td style="text-align: right;">-5</td>
<td style="text-align: right;">0.8252827</td>
<td style="text-align: right;">0.8175745</td>
<td style="text-align: right;">0.8252827</td>
<td style="text-align: right;">0.0166367</td>
<td style="text-align: right;">0.82250</td>
</tr>
<tr class="even">
<td style="text-align: right;">1.5</td>
<td style="text-align: right;">-4</td>
<td style="text-align: right;">0.8287060</td>
<td style="text-align: right;">0.8175745</td>
<td style="text-align: right;">0.8287060</td>
<td style="text-align: right;">0.0155044</td>
<td style="text-align: right;">0.82800</td>
</tr>
<tr class="odd">
<td style="text-align: right;">1.5</td>
<td style="text-align: right;">-3</td>
<td style="text-align: right;">0.8320641</td>
<td style="text-align: right;">0.8175745</td>
<td style="text-align: right;">0.8320641</td>
<td style="text-align: right;">0.0145417</td>
<td style="text-align: right;">0.83475</td>
</tr>
<tr class="even">
<td style="text-align: right;">1.5</td>
<td style="text-align: right;">-2</td>
<td style="text-align: right;">0.8353575</td>
<td style="text-align: right;">0.8175745</td>
<td style="text-align: right;">0.8353575</td>
<td style="text-align: right;">0.0137631</td>
<td style="text-align: right;">0.84275</td>
</tr>
<tr class="odd">
<td style="text-align: right;">1.5</td>
<td style="text-align: right;">-1</td>
<td style="text-align: right;">0.8385867</td>
<td style="text-align: right;">0.8175745</td>
<td style="text-align: right;">0.8385867</td>
<td style="text-align: right;">0.0131801</td>
<td style="text-align: right;">0.83550</td>
</tr>
<tr class="even">
<td style="text-align: right;">1.5</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0.8417522</td>
<td style="text-align: right;">0.8175745</td>
<td style="text-align: right;">0.8417522</td>
<td style="text-align: right;">0.0127987</td>
<td style="text-align: right;">0.83950</td>
</tr>
<tr class="odd">
<td style="text-align: right;">1.5</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">0.8448545</td>
<td style="text-align: right;">0.8175745</td>
<td style="text-align: right;">0.8448545</td>
<td style="text-align: right;">0.0126172</td>
<td style="text-align: right;">0.84275</td>
</tr>
<tr class="even">
<td style="text-align: right;">1.5</td>
<td style="text-align: right;">2</td>
<td style="text-align: right;">0.8478944</td>
<td style="text-align: right;">0.8175745</td>
<td style="text-align: right;">0.8478944</td>
<td style="text-align: right;">0.0126252</td>
<td style="text-align: right;">0.85175</td>
</tr>
<tr class="odd">
<td style="text-align: right;">1.5</td>
<td style="text-align: right;">3</td>
<td style="text-align: right;">0.8508724</td>
<td style="text-align: right;">0.8175745</td>
<td style="text-align: right;">0.8508724</td>
<td style="text-align: right;">0.0128045</td>
<td style="text-align: right;">0.85075</td>
</tr>
<tr class="even">
<td style="text-align: right;">1.5</td>
<td style="text-align: right;">4</td>
<td style="text-align: right;">0.8537893</td>
<td style="text-align: right;">0.8175745</td>
<td style="text-align: right;">0.8537893</td>
<td style="text-align: right;">0.0131319</td>
<td style="text-align: right;">0.84950</td>
</tr>
<tr class="odd">
<td style="text-align: right;">1.5</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.8566458</td>
<td style="text-align: right;">0.8175745</td>
<td style="text-align: right;">0.8566458</td>
<td style="text-align: right;">0.0135817</td>
<td style="text-align: right;">0.85500</td>
</tr>
<tr class="even">
<td style="text-align: right;">1.5</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">0.8594427</td>
<td style="text-align: right;">0.8175745</td>
<td style="text-align: right;">0.8594427</td>
<td style="text-align: right;">0.0141289</td>
<td style="text-align: right;">0.86475</td>
</tr>
<tr class="odd">
<td style="text-align: right;">1.5</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">0.8621808</td>
<td style="text-align: right;">0.8175745</td>
<td style="text-align: right;">0.8621808</td>
<td style="text-align: right;">0.0147506</td>
<td style="text-align: right;">0.85900</td>
</tr>
<tr class="even">
<td style="text-align: right;">1.5</td>
<td style="text-align: right;">8</td>
<td style="text-align: right;">0.8648609</td>
<td style="text-align: right;">0.8175745</td>
<td style="text-align: right;">0.8648609</td>
<td style="text-align: right;">0.0154270</td>
<td style="text-align: right;">0.87425</td>
</tr>
<tr class="odd">
<td style="text-align: right;">1.5</td>
<td style="text-align: right;">9</td>
<td style="text-align: right;">0.8674839</td>
<td style="text-align: right;">0.8175745</td>
<td style="text-align: right;">0.8674839</td>
<td style="text-align: right;">0.0161418</td>
<td style="text-align: right;">0.86575</td>
</tr>
<tr class="even">
<td style="text-align: right;">1.5</td>
<td style="text-align: right;">10</td>
<td style="text-align: right;">0.8700507</td>
<td style="text-align: right;">0.8175745</td>
<td style="text-align: right;">0.8700507</td>
<td style="text-align: right;">0.0168815</td>
<td style="text-align: right;">0.87025</td>
</tr>
<tr class="odd">
<td style="text-align: right;">2.0</td>
<td style="text-align: right;">-10</td>
<td style="text-align: right;">0.8856899</td>
<td style="text-align: right;">0.8807971</td>
<td style="text-align: right;">0.8856899</td>
<td style="text-align: right;">0.0190148</td>
<td style="text-align: right;">0.88825</td>
</tr>
<tr class="even">
<td style="text-align: right;">2.0</td>
<td style="text-align: right;">-9</td>
<td style="text-align: right;">0.8881492</td>
<td style="text-align: right;">0.8807971</td>
<td style="text-align: right;">0.8881492</td>
<td style="text-align: right;">0.0178911</td>
<td style="text-align: right;">0.88950</td>
</tr>
<tr class="odd">
<td style="text-align: right;">2.0</td>
<td style="text-align: right;">-8</td>
<td style="text-align: right;">0.8905530</td>
<td style="text-align: right;">0.8807971</td>
<td style="text-align: right;">0.8905530</td>
<td style="text-align: right;">0.0168491</td>
<td style="text-align: right;">0.88725</td>
</tr>
<tr class="even">
<td style="text-align: right;">2.0</td>
<td style="text-align: right;">-7</td>
<td style="text-align: right;">0.8929021</td>
<td style="text-align: right;">0.8807971</td>
<td style="text-align: right;">0.8929021</td>
<td style="text-align: right;">0.0158915</td>
<td style="text-align: right;">0.89925</td>
</tr>
<tr class="odd">
<td style="text-align: right;">2.0</td>
<td style="text-align: right;">-6</td>
<td style="text-align: right;">0.8951974</td>
<td style="text-align: right;">0.8807971</td>
<td style="text-align: right;">0.8951974</td>
<td style="text-align: right;">0.0150211</td>
<td style="text-align: right;">0.89600</td>
</tr>
<tr class="even">
<td style="text-align: right;">2.0</td>
<td style="text-align: right;">-5</td>
<td style="text-align: right;">0.8974398</td>
<td style="text-align: right;">0.8807971</td>
<td style="text-align: right;">0.8974398</td>
<td style="text-align: right;">0.0142407</td>
<td style="text-align: right;">0.89150</td>
</tr>
<tr class="odd">
<td style="text-align: right;">2.0</td>
<td style="text-align: right;">-4</td>
<td style="text-align: right;">0.8996301</td>
<td style="text-align: right;">0.8807971</td>
<td style="text-align: right;">0.8996301</td>
<td style="text-align: right;">0.0135527</td>
<td style="text-align: right;">0.89625</td>
</tr>
<tr class="even">
<td style="text-align: right;">2.0</td>
<td style="text-align: right;">-3</td>
<td style="text-align: right;">0.9017694</td>
<td style="text-align: right;">0.8807971</td>
<td style="text-align: right;">0.9017694</td>
<td style="text-align: right;">0.0129592</td>
<td style="text-align: right;">0.89500</td>
</tr>
<tr class="odd">
<td style="text-align: right;">2.0</td>
<td style="text-align: right;">-2</td>
<td style="text-align: right;">0.9038586</td>
<td style="text-align: right;">0.8807971</td>
<td style="text-align: right;">0.9038586</td>
<td style="text-align: right;">0.0124610</td>
<td style="text-align: right;">0.91075</td>
</tr>
<tr class="even">
<td style="text-align: right;">2.0</td>
<td style="text-align: right;">-1</td>
<td style="text-align: right;">0.9058985</td>
<td style="text-align: right;">0.8807971</td>
<td style="text-align: right;">0.9058985</td>
<td style="text-align: right;">0.0120582</td>
<td style="text-align: right;">0.90650</td>
</tr>
<tr class="odd">
<td style="text-align: right;">2.0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0.9078902</td>
<td style="text-align: right;">0.8807971</td>
<td style="text-align: right;">0.9078902</td>
<td style="text-align: right;">0.0117490</td>
<td style="text-align: right;">0.91000</td>
</tr>
<tr class="even">
<td style="text-align: right;">2.0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">0.9098346</td>
<td style="text-align: right;">0.8807971</td>
<td style="text-align: right;">0.9098346</td>
<td style="text-align: right;">0.0115300</td>
<td style="text-align: right;">0.90800</td>
</tr>
<tr class="odd">
<td style="text-align: right;">2.0</td>
<td style="text-align: right;">2</td>
<td style="text-align: right;">0.9117326</td>
<td style="text-align: right;">0.8807971</td>
<td style="text-align: right;">0.9117326</td>
<td style="text-align: right;">0.0113964</td>
<td style="text-align: right;">0.91300</td>
</tr>
<tr class="even">
<td style="text-align: right;">2.0</td>
<td style="text-align: right;">3</td>
<td style="text-align: right;">0.9135852</td>
<td style="text-align: right;">0.8807971</td>
<td style="text-align: right;">0.9135852</td>
<td style="text-align: right;">0.0113417</td>
<td style="text-align: right;">0.91300</td>
</tr>
<tr class="odd">
<td style="text-align: right;">2.0</td>
<td style="text-align: right;">4</td>
<td style="text-align: right;">0.9153933</td>
<td style="text-align: right;">0.8807971</td>
<td style="text-align: right;">0.9153933</td>
<td style="text-align: right;">0.0113582</td>
<td style="text-align: right;">0.91175</td>
</tr>
<tr class="even">
<td style="text-align: right;">2.0</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.9171579</td>
<td style="text-align: right;">0.8807971</td>
<td style="text-align: right;">0.9171579</td>
<td style="text-align: right;">0.0114377</td>
<td style="text-align: right;">0.91550</td>
</tr>
<tr class="odd">
<td style="text-align: right;">2.0</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">0.9188800</td>
<td style="text-align: right;">0.8807971</td>
<td style="text-align: right;">0.9188800</td>
<td style="text-align: right;">0.0115716</td>
<td style="text-align: right;">0.92350</td>
</tr>
<tr class="even">
<td style="text-align: right;">2.0</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">0.9205603</td>
<td style="text-align: right;">0.8807971</td>
<td style="text-align: right;">0.9205603</td>
<td style="text-align: right;">0.0117515</td>
<td style="text-align: right;">0.92375</td>
</tr>
<tr class="odd">
<td style="text-align: right;">2.0</td>
<td style="text-align: right;">8</td>
<td style="text-align: right;">0.9222000</td>
<td style="text-align: right;">0.8807971</td>
<td style="text-align: right;">0.9222000</td>
<td style="text-align: right;">0.0119694</td>
<td style="text-align: right;">0.92825</td>
</tr>
<tr class="even">
<td style="text-align: right;">2.0</td>
<td style="text-align: right;">9</td>
<td style="text-align: right;">0.9237998</td>
<td style="text-align: right;">0.8807971</td>
<td style="text-align: right;">0.9237998</td>
<td style="text-align: right;">0.0122181</td>
<td style="text-align: right;">0.92650</td>
</tr>
<tr class="odd">
<td style="text-align: right;">2.0</td>
<td style="text-align: right;">10</td>
<td style="text-align: right;">0.9253607</td>
<td style="text-align: right;">0.8807971</td>
<td style="text-align: right;">0.9253607</td>
<td style="text-align: right;">0.0124909</td>
<td style="text-align: right;">0.92050</td>
</tr>
<tr class="even">
<td style="text-align: right;">2.5</td>
<td style="text-align: right;">-10</td>
<td style="text-align: right;">0.9346760</td>
<td style="text-align: right;">0.9241418</td>
<td style="text-align: right;">0.9346760</td>
<td style="text-align: right;">0.0137536</td>
<td style="text-align: right;">0.93425</td>
</tr>
<tr class="odd">
<td style="text-align: right;">2.5</td>
<td style="text-align: right;">-9</td>
<td style="text-align: right;">0.9361667</td>
<td style="text-align: right;">0.9241418</td>
<td style="text-align: right;">0.9361667</td>
<td style="text-align: right;">0.0130704</td>
<td style="text-align: right;">0.94075</td>
</tr>
<tr class="even">
<td style="text-align: right;">2.5</td>
<td style="text-align: right;">-8</td>
<td style="text-align: right;">0.9376190</td>
<td style="text-align: right;">0.9241418</td>
<td style="text-align: right;">0.9376190</td>
<td style="text-align: right;">0.0124389</td>
<td style="text-align: right;">0.94225</td>
</tr>
<tr class="odd">
<td style="text-align: right;">2.5</td>
<td style="text-align: right;">-7</td>
<td style="text-align: right;">0.9390339</td>
<td style="text-align: right;">0.9241418</td>
<td style="text-align: right;">0.9390339</td>
<td style="text-align: right;">0.0118589</td>
<td style="text-align: right;">0.93850</td>
</tr>
<tr class="even">
<td style="text-align: right;">2.5</td>
<td style="text-align: right;">-6</td>
<td style="text-align: right;">0.9404122</td>
<td style="text-align: right;">0.9241418</td>
<td style="text-align: right;">0.9404122</td>
<td style="text-align: right;">0.0113303</td>
<td style="text-align: right;">0.93375</td>
</tr>
<tr class="odd">
<td style="text-align: right;">2.5</td>
<td style="text-align: right;">-5</td>
<td style="text-align: right;">0.9417548</td>
<td style="text-align: right;">0.9241418</td>
<td style="text-align: right;">0.9417548</td>
<td style="text-align: right;">0.0108527</td>
<td style="text-align: right;">0.94900</td>
</tr>
<tr class="even">
<td style="text-align: right;">2.5</td>
<td style="text-align: right;">-4</td>
<td style="text-align: right;">0.9430626</td>
<td style="text-align: right;">0.9241418</td>
<td style="text-align: right;">0.9430626</td>
<td style="text-align: right;">0.0104257</td>
<td style="text-align: right;">0.93700</td>
</tr>
<tr class="odd">
<td style="text-align: right;">2.5</td>
<td style="text-align: right;">-3</td>
<td style="text-align: right;">0.9443364</td>
<td style="text-align: right;">0.9241418</td>
<td style="text-align: right;">0.9443364</td>
<td style="text-align: right;">0.0100485</td>
<td style="text-align: right;">0.93825</td>
</tr>
<tr class="even">
<td style="text-align: right;">2.5</td>
<td style="text-align: right;">-2</td>
<td style="text-align: right;">0.9455771</td>
<td style="text-align: right;">0.9241418</td>
<td style="text-align: right;">0.9455771</td>
<td style="text-align: right;">0.0097201</td>
<td style="text-align: right;">0.94475</td>
</tr>
<tr class="odd">
<td style="text-align: right;">2.5</td>
<td style="text-align: right;">-1</td>
<td style="text-align: right;">0.9467855</td>
<td style="text-align: right;">0.9241418</td>
<td style="text-align: right;">0.9467855</td>
<td style="text-align: right;">0.0094391</td>
<td style="text-align: right;">0.94225</td>
</tr>
<tr class="even">
<td style="text-align: right;">2.5</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0.9479624</td>
<td style="text-align: right;">0.9241418</td>
<td style="text-align: right;">0.9479624</td>
<td style="text-align: right;">0.0092038</td>
<td style="text-align: right;">0.94800</td>
</tr>
<tr class="odd">
<td style="text-align: right;">2.5</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">0.9491087</td>
<td style="text-align: right;">0.9241418</td>
<td style="text-align: right;">0.9491087</td>
<td style="text-align: right;">0.0090120</td>
<td style="text-align: right;">0.95275</td>
</tr>
<tr class="even">
<td style="text-align: right;">2.5</td>
<td style="text-align: right;">2</td>
<td style="text-align: right;">0.9502250</td>
<td style="text-align: right;">0.9241418</td>
<td style="text-align: right;">0.9502250</td>
<td style="text-align: right;">0.0088611</td>
<td style="text-align: right;">0.95325</td>
</tr>
<tr class="odd">
<td style="text-align: right;">2.5</td>
<td style="text-align: right;">3</td>
<td style="text-align: right;">0.9513122</td>
<td style="text-align: right;">0.9241418</td>
<td style="text-align: right;">0.9513122</td>
<td style="text-align: right;">0.0087485</td>
<td style="text-align: right;">0.94825</td>
</tr>
<tr class="even">
<td style="text-align: right;">2.5</td>
<td style="text-align: right;">4</td>
<td style="text-align: right;">0.9523711</td>
<td style="text-align: right;">0.9241418</td>
<td style="text-align: right;">0.9523711</td>
<td style="text-align: right;">0.0086711</td>
<td style="text-align: right;">0.94850</td>
</tr>
<tr class="odd">
<td style="text-align: right;">2.5</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.9534024</td>
<td style="text-align: right;">0.9241418</td>
<td style="text-align: right;">0.9534024</td>
<td style="text-align: right;">0.0086256</td>
<td style="text-align: right;">0.95575</td>
</tr>
<tr class="even">
<td style="text-align: right;">2.5</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">0.9544067</td>
<td style="text-align: right;">0.9241418</td>
<td style="text-align: right;">0.9544067</td>
<td style="text-align: right;">0.0086088</td>
<td style="text-align: right;">0.95100</td>
</tr>
<tr class="odd">
<td style="text-align: right;">2.5</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">0.9553849</td>
<td style="text-align: right;">0.9241418</td>
<td style="text-align: right;">0.9553849</td>
<td style="text-align: right;">0.0086173</td>
<td style="text-align: right;">0.95750</td>
</tr>
<tr class="even">
<td style="text-align: right;">2.5</td>
<td style="text-align: right;">8</td>
<td style="text-align: right;">0.9563376</td>
<td style="text-align: right;">0.9241418</td>
<td style="text-align: right;">0.9563376</td>
<td style="text-align: right;">0.0086480</td>
<td style="text-align: right;">0.95400</td>
</tr>
<tr class="odd">
<td style="text-align: right;">2.5</td>
<td style="text-align: right;">9</td>
<td style="text-align: right;">0.9572654</td>
<td style="text-align: right;">0.9241418</td>
<td style="text-align: right;">0.9572654</td>
<td style="text-align: right;">0.0086978</td>
<td style="text-align: right;">0.95825</td>
</tr>
<tr class="even">
<td style="text-align: right;">2.5</td>
<td style="text-align: right;">10</td>
<td style="text-align: right;">0.9581692</td>
<td style="text-align: right;">0.9241418</td>
<td style="text-align: right;">0.9581692</td>
<td style="text-align: right;">0.0087639</td>
<td style="text-align: right;">0.96100</td>
</tr>
<tr class="odd">
<td style="text-align: right;">3.0</td>
<td style="text-align: right;">-10</td>
<td style="text-align: right;">0.9634555</td>
<td style="text-align: right;">0.9525741</td>
<td style="text-align: right;">0.9634555</td>
<td style="text-align: right;">0.0093830</td>
<td style="text-align: right;">0.96250</td>
</tr>
<tr class="even">
<td style="text-align: right;">3.0</td>
<td style="text-align: right;">-9</td>
<td style="text-align: right;">0.9643181</td>
<td style="text-align: right;">0.9525741</td>
<td style="text-align: right;">0.9643181</td>
<td style="text-align: right;">0.0089749</td>
<td style="text-align: right;">0.96650</td>
</tr>
<tr class="odd">
<td style="text-align: right;">3.0</td>
<td style="text-align: right;">-8</td>
<td style="text-align: right;">0.9651569</td>
<td style="text-align: right;">0.9525741</td>
<td style="text-align: right;">0.9651569</td>
<td style="text-align: right;">0.0085967</td>
<td style="text-align: right;">0.97000</td>
</tr>
<tr class="even">
<td style="text-align: right;">3.0</td>
<td style="text-align: right;">-7</td>
<td style="text-align: right;">0.9659725</td>
<td style="text-align: right;">0.9525741</td>
<td style="text-align: right;">0.9659725</td>
<td style="text-align: right;">0.0082478</td>
<td style="text-align: right;">0.97250</td>
</tr>
<tr class="odd">
<td style="text-align: right;">3.0</td>
<td style="text-align: right;">-6</td>
<td style="text-align: right;">0.9667656</td>
<td style="text-align: right;">0.9525741</td>
<td style="text-align: right;">0.9667656</td>
<td style="text-align: right;">0.0079276</td>
<td style="text-align: right;">0.96500</td>
</tr>
<tr class="even">
<td style="text-align: right;">3.0</td>
<td style="text-align: right;">-5</td>
<td style="text-align: right;">0.9675369</td>
<td style="text-align: right;">0.9525741</td>
<td style="text-align: right;">0.9675369</td>
<td style="text-align: right;">0.0076352</td>
<td style="text-align: right;">0.96475</td>
</tr>
<tr class="odd">
<td style="text-align: right;">3.0</td>
<td style="text-align: right;">-4</td>
<td style="text-align: right;">0.9682869</td>
<td style="text-align: right;">0.9525741</td>
<td style="text-align: right;">0.9682869</td>
<td style="text-align: right;">0.0073699</td>
<td style="text-align: right;">0.96750</td>
</tr>
<tr class="even">
<td style="text-align: right;">3.0</td>
<td style="text-align: right;">-3</td>
<td style="text-align: right;">0.9690162</td>
<td style="text-align: right;">0.9525741</td>
<td style="text-align: right;">0.9690162</td>
<td style="text-align: right;">0.0071308</td>
<td style="text-align: right;">0.96850</td>
</tr>
<tr class="odd">
<td style="text-align: right;">3.0</td>
<td style="text-align: right;">-2</td>
<td style="text-align: right;">0.9697255</td>
<td style="text-align: right;">0.9525741</td>
<td style="text-align: right;">0.9697255</td>
<td style="text-align: right;">0.0069170</td>
<td style="text-align: right;">0.96900</td>
</tr>
<tr class="even">
<td style="text-align: right;">3.0</td>
<td style="text-align: right;">-1</td>
<td style="text-align: right;">0.9704153</td>
<td style="text-align: right;">0.9525741</td>
<td style="text-align: right;">0.9704153</td>
<td style="text-align: right;">0.0067275</td>
<td style="text-align: right;">0.96800</td>
</tr>
<tr class="odd">
<td style="text-align: right;">3.0</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">0.9710861</td>
<td style="text-align: right;">0.9525741</td>
<td style="text-align: right;">0.9710861</td>
<td style="text-align: right;">0.0065611</td>
<td style="text-align: right;">0.97175</td>
</tr>
<tr class="even">
<td style="text-align: right;">3.0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">0.9717386</td>
<td style="text-align: right;">0.9525741</td>
<td style="text-align: right;">0.9717386</td>
<td style="text-align: right;">0.0064167</td>
<td style="text-align: right;">0.96825</td>
</tr>
<tr class="odd">
<td style="text-align: right;">3.0</td>
<td style="text-align: right;">2</td>
<td style="text-align: right;">0.9723732</td>
<td style="text-align: right;">0.9525741</td>
<td style="text-align: right;">0.9723732</td>
<td style="text-align: right;">0.0062929</td>
<td style="text-align: right;">0.97700</td>
</tr>
<tr class="even">
<td style="text-align: right;">3.0</td>
<td style="text-align: right;">3</td>
<td style="text-align: right;">0.9729904</td>
<td style="text-align: right;">0.9525741</td>
<td style="text-align: right;">0.9729904</td>
<td style="text-align: right;">0.0061885</td>
<td style="text-align: right;">0.97750</td>
</tr>
<tr class="odd">
<td style="text-align: right;">3.0</td>
<td style="text-align: right;">4</td>
<td style="text-align: right;">0.9735908</td>
<td style="text-align: right;">0.9525741</td>
<td style="text-align: right;">0.9735908</td>
<td style="text-align: right;">0.0061021</td>
<td style="text-align: right;">0.97400</td>
</tr>
<tr class="even">
<td style="text-align: right;">3.0</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">0.9741749</td>
<td style="text-align: right;">0.9525741</td>
<td style="text-align: right;">0.9741749</td>
<td style="text-align: right;">0.0060322</td>
<td style="text-align: right;">0.97375</td>
</tr>
<tr class="odd">
<td style="text-align: right;">3.0</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">0.9747430</td>
<td style="text-align: right;">0.9525741</td>
<td style="text-align: right;">0.9747430</td>
<td style="text-align: right;">0.0059775</td>
<td style="text-align: right;">0.97275</td>
</tr>
<tr class="even">
<td style="text-align: right;">3.0</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">0.9752957</td>
<td style="text-align: right;">0.9525741</td>
<td style="text-align: right;">0.9752957</td>
<td style="text-align: right;">0.0059365</td>
<td style="text-align: right;">0.97225</td>
</tr>
<tr class="odd">
<td style="text-align: right;">3.0</td>
<td style="text-align: right;">8</td>
<td style="text-align: right;">0.9758335</td>
<td style="text-align: right;">0.9525741</td>
<td style="text-align: right;">0.9758335</td>
<td style="text-align: right;">0.0059079</td>
<td style="text-align: right;">0.97400</td>
</tr>
<tr class="even">
<td style="text-align: right;">3.0</td>
<td style="text-align: right;">9</td>
<td style="text-align: right;">0.9763567</td>
<td style="text-align: right;">0.9525741</td>
<td style="text-align: right;">0.9763567</td>
<td style="text-align: right;">0.0058904</td>
<td style="text-align: right;">0.97375</td>
</tr>
<tr class="odd">
<td style="text-align: right;">3.0</td>
<td style="text-align: right;">10</td>
<td style="text-align: right;">0.9768658</td>
<td style="text-align: right;">0.9525741</td>
<td style="text-align: right;">0.9768658</td>
<td style="text-align: right;">0.0058827</td>
<td style="text-align: right;">0.97500</td>
</tr>
</tbody>
</table>

Calculate log score for model.

    predp_5 <- predict(fit_5, type = "response")
    logscore_5 <- sum(y * log(predp_5) + (1-y)*log(1-predp_5))
    logscore_5

    ## [1] -1838.467

    score_diff_5_m_1 <- round(logscore_5 - logscore_1,2)

The model’s log score is only 1.83 points better than the model with
just Adjusted Log Odds as a predictor. This advantage may go away with
the LOO estimate.

Run leave one out cross validation.

    loo_5 <- loo(fit_5)
    print(loo_5)

    ## 
    ## Computed from 4000 by 2988 log-likelihood matrix
    ## 
    ##          Estimate   SE
    ## elpd_loo  -1841.5 19.9
    ## p_loo         3.0  0.1
    ## looic      3682.9 39.8
    ## ------
    ## Monte Carlo SE of elpd_loo is 0.0.
    ## 
    ## All Pareto k estimates are good (k < 0.5).
    ## See help('pareto-k-diagnostic') for details.

The model with the Reach term (-1841.46) is basically just as good as
the model with just the Adjusted Log Odds (-1842.27). Nonetheless, I
will keep the Reach term since it makes sense a priori to have it in
there. (Reach is typically considered an advantage in UFC fights by
commentators etc.)

<br>

### Plot Coefficients for Best Model

The sign of the intercept is almost certainly negative.

    plot(fit_5, plotfun = "areas", prob = 0.95,
         pars = "(Intercept)")

![](/AttM/rmd_images/2021-04-24-bayesian_logistic_regression_analysis/unnamed-chunk-111-1.png)

The Adjusted Log Odds coefficient is clearly positive. It is also almost
certainly greater than 1, which means the slope is steeper that what you
would expect if the Fight Odds perfectly tracked the Probability of the
Favorite Winning. Indeed, this steep slope along with the negative
intercept manifests in the clear trend whereby the Adjusted Odds
overestimate mild Favorites but underestimate large ones.

    plot(fit_5, plotfun = "areas", prob = 0.95,
         pars = "Adjust_Log_Odds")

![](/AttM/rmd_images/2021-04-24-bayesian_logistic_regression_analysis/unnamed-chunk-112-1.png)

    prob_reach_neg = round(mean(sims_5[, 3] < 0) * 100)

By analyzing the coefficient simulations, we can see that there is
approximately a 2% probability that the effect of Reach is negative.

    plot(fit_5, plotfun = "areas", prob = 0.95,
         pars = "Delta_REACH_imp")

![](/AttM/rmd_images/2021-04-24-bayesian_logistic_regression_analysis/unnamed-chunk-114-1.png)

<br>

### Save Best Model

Save best model - the one with two predictors: Adjusted Log Odds and
(imputed) Difference in Fighter Reach.

    save(fit_5, file = "./Models/bayesian_logistic_regression_two_predictor_model.RData")

<br>

Examine Predictions
===================

Extract data frame from model object.

    df <- fit_5$data

Extract fitted values.

    df$predicted_prob <- fit_5$fitted.values

<br>

### Predicted Outcomes

Compute predicted outcomes (i.e. if predicted probability of victory is
greater than 50%).

    df$predicted_fav_win <- ifelse(df$predicted_prob > 0.5, T, F)

Examine results table.

    pred_table <- table(df$predicted_fav_win, df$Favorite_Won)
    pred_table

    ##        
    ##         FALSE TRUE
    ##   FALSE   182  182
    ##   TRUE    875 1749

Compute accuracy of the model.

    right = (pred_table[1,1] + pred_table[2,2])  # underdog won and you predicted it plus the favorite won and you predicted it
    wrong = (pred_table[2,1] + pred_table[1,2]) # underdog won and you did not predict it plus favorite won and you did not predict it

    accuracy = right/(right + wrong)
    accuracy

    ## [1] 0.6462517

Compute accuracy if you always pick favorite.

    mean(df$Favorite_Won)

    ## [1] 0.6462517

Compute accuracy boost afforded by the model.

    accuracy - mean(df$Favorite_Won)

    ## [1] 0

<br>

### Predicted Bets

Compute predicted bets (note: this is different than predicted outcomes
- with predicted bets we see if the predicted probability of victory
exceeds the adjusted implied probability of victory of the odds).

    df$predicted_bet_fav <- ifelse(df$predicted_prob  > df$Adjust_Implied_Prob, T, F)

Get results table for predicted bets.

    pred_table_bet <- table(df$predicted_bet_fav, df$Favorite_Won)
    pred_table_bet

    ##        
    ##         FALSE TRUE
    ##   FALSE   763 1018
    ##   TRUE    294  913

Get accuracy for predicted bets. Note: it is greater than chance (50%).

    right_bet = (pred_table_bet[1,1] + pred_table_bet[2,2])  # underdog won and you bet on it plus the favorite won and you bet on it
    wrong_bet = (pred_table_bet[2,1] + pred_table_bet[1,2]) # underdog won and you did not bet on it plus favorite won and you did not  bet on it

    accuracy_bet = right_bet/(right_bet + wrong_bet)
    accuracy_bet

    ## [1] 0.5609103

<br>

### In-sample returns on predicted bets

Compute Potential Profit by converting Adjusted Implied Probabilities
into decimal odds, with a standard 3% overround penalty (as an estimate
since the overall overround is usually around 5% total). Also, compute
potential profit without penalty.

    df$Potential_Profit <- ifelse(df$Favorite_Won, 1/(df$Adjust_Implied_Prob + 0.03) - 1,  1/(1-df$Adjust_Implied_Prob + 0.03) - 1)

Compute actual profit.

    df$Profit <- ifelse(
      (df$predicted_bet_fav & df$Favorite_Won) | (!(df$predicted_bet_fav) & !(df$Favorite_Won))
      , df$Potential_Profit 
      , -1
      )

Compute ROI (%) based on in-sample predicted bets.

    mean(df$Profit)

    ## [1] -0.01736408

Compute actual profit for just picking Favorites, and for just picking
Underdogs.

    df$Profit_Fav <- ifelse(
      df$Favorite_Won
      , df$Potential_Profit
      , -1
    )

    df$Profit_Dog <- ifelse(
      !(df$Favorite_Won)
      , df$Potential_Profit
      , -1
    )

Compute ROI (%) for Favorite-only betting strategy.

    mean(df$Profit_Fav)

    ## [1] -0.06242702

Compute ROI (%) for Underdog-only betting strategy.

    mean(df$Profit_Dog)

    ## [1] -0.08220306

Conclusion
==========

From a betting standpoint, the model cannot even overcome a modest
average overround. Moreover, that is just for in-sample estimates -
performance would be even worst with cross-validation estimates. On the
other hand, the model does appear to substantially outperform simple /
blind algorithms (such as just picking Favorites or just picking
Underdogs). Practically, overcoming most of the overround (assuming 6%
total and assuming the out-sample benefits are similar) may still confer
some benefits as part of a larger betting strategy.
