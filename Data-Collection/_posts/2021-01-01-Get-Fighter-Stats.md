--- 
category: science
---

Description
-----------

This script scrapes UFC fighter information from the
<a href="http://www.fightmetric.com" class="uri">http://www.fightmetric.com</a>
website.

The script is adapted from:

<a href="https://github.com/jasonchanhku/UFC-MMA-Predictor/blob/master/UFC%20MMA%20Predictor%20Workflow.ipynb" class="uri">https://github.com/jasonchanhku/UFC-MMA-Predictor/blob/master/UFC%20MMA%20Predictor%20Workflow.ipynb</a>

<br>

### Libraries

    library(rvest)
    library(dplyr)
    library(tidyr)
    library(stringr)

<br>

### Web Scrape Fighter Stats

Loop through alphabet to get list of all desired webpages.

    webpage <- character(length(letters))
    url_list <- c()

    for(j in 1:length(letters)){
      
      webpage[j] <- paste0("http://www.fightmetric.com/statistics/fighters?char=", letters[j], "&page=all")
      temp <- read_html(webpage[j]) %>% html_nodes(".b-statistics__table-col:nth-child(1) .b-link_style_black") %>% html_attr("href")
      url_list <- c(url_list, temp)     
    }

<br>

#### Initialization

Create data structures to store the following fighter stats:

LEGEND: SLpM - Significant Strikes Landed per Minute Str. Acc. -
Significant Striking Accuracy SApM - Significant Strikes Absorbed per
Minute Str. Def. - Significant Strike Defence (the % of opponents
strikes that did not land) TD Avg. - Average Takedowns Landed per 15
minutes TD Acc. - Takedown Accuracy TD Def. - Takedown Defense (the % of
opponents TD attempts that did not land) Sub. Avg. - Average Submissions
Attempted per 15 minutes

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

<br>

#### Loop

    # start the clock
    ptm <- proc.time()

    for(i in 1:length(url_list)) {
      
      # # print iteration
      # print(sprintf("%d of %d", i, length(url_list)))
      # # start the clock
      # ptm <- proc.time()
      
      # fighter url
      fighter_url <- read_html(url_list[i])
      
      # fighter name
      name_t <- fighter_url %>% html_nodes(".b-content__title-highlight") %>% html_text()
      name_t <- gsub("\n", "", name_t)
      name[i] <- as.character(trimws(name_t))
      
      # weightclass
      weightclass_t <- fighter_url %>% html_nodes(".b-list__info-box_style_small-width .b-list__box-list-item_type_block:nth-child(2)") %>% html_text()
      weightclass_t <- gsub(" ", "", weightclass_t)
      weightclass_t <- gsub("\n", "", weightclass_t)
      weightclass_t <- strsplit(weightclass_t, ":")
      weightclass_t <- weightclass_t[[1]][2]
      weightclass_t <- strsplit(weightclass_t, "l")
      weightclass[i] <- as.numeric(as.character(weightclass_t[[1]][1]))
      
      # reach
      reach_t <- fighter_url %>% html_nodes(".b-list__info-box_style_small-width .b-list__box-list-item_type_block:nth-child(3)") %>% html_text()
      reach_t <- gsub(" ", "", reach_t)
      reach_t <- gsub("\n", "", reach_t)
      reach_t <- strsplit(reach_t, ":")
      reach_t <- reach_t[[1]][2]
      reach_t <- strsplit(reach_t, "\"")
      reach[i] <- as.numeric(as.character(reach_t[[1]][1]))
      
      # feature 1: slpm
      slpm_t <- fighter_url %>% html_nodes(".b-list__info-box-left .b-list__info-box-left .b-list__box-list-item_type_block:nth-child(1)") %>% html_text()
      slpm_t <- gsub(" ", "", slpm_t)
      slpm_t <- gsub("\n", "", slpm_t)
      slpm_t <- strsplit(slpm_t, ":")
      slpm_t <- slpm_t[[1]][2]
      slpm[i] <- as.numeric(slpm_t)
      
      # feature 2: takedown avg
      td_t <- fighter_url %>% html_nodes(".b-list__info-box_style-margin-right .b-list__box-list-item_type_block:nth-child(2)") %>% html_text()
      td_t<- gsub(" ", "", td_t)
      td_t <- gsub("\n", "", td_t)
      td_t <- strsplit(td_t, ":")
      td_t <- td_t[[1]][2]
      td[i] <- as.numeric(td_t)
      
      # feature 3: significant striking accuracy
      stra_t <- fighter_url %>% html_nodes(".b-list__info-box-left .b-list__info-box-left .b-list__box-list-item_type_block:nth-child(2)") %>% html_text()
      stra_t <- gsub(" ", "", stra_t)
      stra_t <- gsub("\n", "", stra_t)
      stra_t <- strsplit(stra_t, ":")
      stra_t <- stra_t[[1]][2]
      stra_t <- strsplit(stra_t, "%")
      stra[i] <- as.numeric(stra_t) / 100
      
      # feature 4: takedown accuracy 
      tda_t <- fighter_url %>% html_nodes(".b-list__info-box_style-margin-right .b-list__box-list-item_type_block:nth-child(3)") %>% html_text()
      tda_t <- gsub(" ", "", tda_t)
      tda_t <- gsub("\n", "", tda_t)
      tda_t <- strsplit(tda_t, ":")
      tda_t <- tda_t[[1]][2]
      tda_t <- strsplit(tda_t, "%")
      tda[i] <- as.numeric(tda_t) / 100
      
      # feature 5: significant absorbed stras per minute
      sapm_t <- fighter_url %>% html_nodes(".b-list__info-box-left .b-list__info-box-left .b-list__box-list-item_type_block:nth-child(3)") %>% html_text()
      sapm_t <- gsub(" ", "", sapm_t)
      sapm_t <- gsub("\n", "", sapm_t)
      sapm_t <- strsplit(sapm_t, ":")
      sapm_t <- sapm_t[[1]][2]
      sapm[i] <- as.numeric(sapm_t)
      
      # feature 6: takedown def
      tdd_t <- fighter_url %>% html_nodes(".b-list__info-box_style-margin-right .b-list__box-list-item_type_block:nth-child(4)") %>% html_text()
      tdd_t <- gsub(" ", "", tdd_t)
      tdd_t <- gsub("\n", "", tdd_t)
      tdd_t <- strsplit(tdd_t, ":")
      tdd_t <- tdd_t[[1]][2]
      tdd_t <- strsplit(tdd_t, "%")
      tdd[i] <- as.numeric(tdd_t) / 100
      
      # feature 7: striking def
      strd_t <- fighter_url %>% html_nodes(".b-list__info-box-left .b-list__info-box-left .b-list__box-list-item_type_block:nth-child(4)") %>% html_text()
      strd_t <- gsub(" ", "", strd_t)
      strd_t <- gsub("\n", "", strd_t)
      strd_t <- strsplit(strd_t, ":")
      strd_t <- strd_t[[1]][2]
      strd_t <- strsplit(strd_t, "%")
      strd[i] <- as.numeric(strd_t) / 100
      
      # feature 8: submission average
      suba_t <- fighter_url %>% html_nodes(".b-list__box-list_margin-top .b-list__box-list-item_type_block:nth-child(5)") %>% html_text()
      suba_t <- gsub(" ", "", suba_t)
      suba_t <- gsub("\n", "", suba_t)
      suba_t <- strsplit(suba_t, ":")
      suba_t <- suba_t[[1]][2]
      suba[i] <- as.numeric(suba_t)
      
      # # stop the clock
      # print(proc.time() - ptm) 
    }

    # stop the clock
    print(proc.time() - ptm) 

    ##     user   system  elapsed 
    ##  343.416    5.386 1494.005

<br>

### Manipulate Data Frame

Create data frame and add column describing weightclass.

    database <- data.frame(NAME = name, Weight = weightclass, REACH = reach, SLPM = slpm, SAPM = sapm, STRA = stra, STRD = strd, TD = td, TDA = tda, TDD = tdd, SUBA = suba )

    data_add_wc <- mutate(database, WeightClass = ifelse(Weight == 115, "strawweight", ifelse(Weight == 125, "flyweight", ifelse(Weight == 135, "bantamweight", ifelse(Weight == 145, "featherweight", ifelse(Weight == 155, "lightweight", ifelse(Weight == 170, "welterweight", ifelse(Weight == 185, "middleweight", ifelse(Weight == 205, "lightheavyweight", ifelse(Weight > 205, "heavyweight", "catchweight"))))))))))

    data_add_wc <- data_add_wc[c(1,2,12,3,4,5,6,7,8,9,10,11)]

The following fighters did not have their weight listed.

    data_add_wc[is.na(data_add_wc$Weight), ]

    ##                    NAME Weight WeightClass REACH SLPM SAPM STRA STRD   TD  TDA
    ## 42          Juan Alcain     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 58          Levi Alford     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 83        Anthony Alves     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 133      Joey Armstrong     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 193         Yohan Banks     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 205     Chris Barnhizer     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 264          Dave Berry     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 288     Jason Blackford     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 301     Jeremy Boczulak     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 323       Chris Bostick     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 362    Drew Brokenshire     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 422      Goldman Butler     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 448     Thomas Campbell     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 467       Frank Caracci     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 558  Nikolajus Cilkinas     NA        <NA>    NA 0.00 5.88 0.00 0.16 0.00 0.00
    ## 581       Chris Coggins     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 707          Mike Davis     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 756         John Devine     NA        <NA>    NA 1.52 2.28 0.18 0.57 0.00 0.00
    ## 796        OJ Dominguez     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 809          John Dowdy     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 866           John Elam     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 981          Cody Floyd     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 1033         Sam Fulton     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 1107   Krishaun Gilmore     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 1112      He-Man Gipson     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 1164         Hugo Govea     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 1243        Stoney Hale     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 1254      Frank Hamaker     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 1280       Luke Hartwig     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 1296         Ryan Hayes     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 1297       Gerric Hayes     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 1327      Noe Hernandez     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 1328      Joe Hernandez     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 1400     Saeed Hosseini     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 1443        Chris Inman     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 1492        Josh Jarvis     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 1517      Devin Johnson     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 1609           Doug Kay     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 1625    Aurelijus Kerpe     NA        <NA>    NA 1.26 8.21 0.16 0.31 0.00 0.00
    ## 1773         Jackie Lee     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 1778          Imani Lee     NA        <NA>    NA 0.00 0.94 0.00 0.33 0.00 0.00
    ## 1800      Michael Lerma     NA        <NA>    NA 0.00 6.47 0.00 0.45 0.00 0.00
    ## 1809      Kyle Levinton     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 1818          Sam Liera     NA        <NA>    NA 0.82 7.36 0.60 0.51 0.00 0.00
    ## 1829     Miguel Linares     NA        <NA>    NA 6.51 8.84 0.50 0.36 0.00 0.00
    ## 1909        Eric Magana     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 1918       Lolohea Mahe     NA        <NA>    NA 1.71 6.92 0.29 0.40 2.44 0.40
    ## 1959    Cesar Marscucci     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 1961           CJ Marsh     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 1967        Eric Martin     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 2003   Francesco Maturi     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 2016    Bobby McAndrews     NA        <NA>    NA 2.56 1.03 0.83 0.50 0.00 0.00
    ## 2028     Scott McDonald     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 2039   Jack McGlaughlin     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 2054    Charles McTorry     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 2121      Mike Minniger     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 2133 Felix Lee Mitchell     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 2312        Jack Nilson     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 2369    Masakatsu Okuda     NA        <NA>    NA 0.00 4.27 0.00 0.34 0.00 0.00
    ## 2471         Matt Pedro     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 2485  Justin Pennington     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 2500         Jose Perez     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 2850     Adriano Santos     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 2851       Paulo Santos     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 2956        Wes Shivers     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 3024         Eric Smith     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 3027         Adam Smith     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 3137   Gennaro Strangis     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 3194     Akihito Tanaka     NA        <NA>    NA 0.19 2.05 0.50 0.38 5.59 0.66
    ## 3210         J.T Taylor     NA        <NA>    NA 3.17 3.70 0.80 0.26 3.96 1.00
    ## 3257        Carl Toomey     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 3407     Jeremy Wallace     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 3483        Karl Willis     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 3497         Ray Wizard     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ## 3511       Chris Wright     NA        <NA>    NA 0.00 0.00 0.00 0.00 0.00 0.00
    ##       TDD SUBA
    ## 42   0.00  0.0
    ## 58   0.00  0.0
    ## 83   0.00  0.0
    ## 133  0.00  0.0
    ## 193  0.00  0.0
    ## 205  0.00  0.0
    ## 264  0.00  0.0
    ## 288  0.00  0.0
    ## 301  0.00  0.0
    ## 323  0.00  0.0
    ## 362  0.00  0.0
    ## 422  0.00  0.0
    ## 448  0.00  0.0
    ## 467  0.00  0.0
    ## 558  0.00  0.0
    ## 581  0.00  0.0
    ## 707  0.00  0.0
    ## 756  0.00  0.0
    ## 796  0.00  0.0
    ## 809  0.00  0.0
    ## 866  0.00  0.0
    ## 981  0.00  0.0
    ## 1033 0.00  0.0
    ## 1107 0.00  0.0
    ## 1112 0.00  0.0
    ## 1164 0.00  0.0
    ## 1243 0.00  0.0
    ## 1254 0.00  0.0
    ## 1280 0.00  0.0
    ## 1296 0.00  0.0
    ## 1297 0.00  0.0
    ## 1327 0.00  0.0
    ## 1328 0.00  0.0
    ## 1400 0.00  0.0
    ## 1443 0.00  0.0
    ## 1492 0.00  0.0
    ## 1517 0.00  0.0
    ## 1609 0.00  0.0
    ## 1625 0.00  0.0
    ## 1773 0.00  0.0
    ## 1778 0.00  0.0
    ## 1800 0.00  0.0
    ## 1809 0.00  0.0
    ## 1818 0.66  0.0
    ## 1829 0.00  0.0
    ## 1909 0.00  0.0
    ## 1918 0.00  0.0
    ## 1959 0.00  0.0
    ## 1961 0.00  0.0
    ## 1967 0.00  0.0
    ## 2003 0.00  0.0
    ## 2016 0.33  7.7
    ## 2028 0.00  0.0
    ## 2039 0.00  0.0
    ## 2054 0.00  0.0
    ## 2121 0.00  0.0
    ## 2133 0.00  0.0
    ## 2312 0.00  0.0
    ## 2369 0.00  4.3
    ## 2471 0.00  0.0
    ## 2485 0.00  0.0
    ## 2500 0.00  0.0
    ## 2850 0.00  0.0
    ## 2851 0.00  0.0
    ## 2956 0.00  0.0
    ## 3024 0.00  0.0
    ## 3027 0.00  0.0
    ## 3137 0.00  0.0
    ## 3194 0.00  0.0
    ## 3210 0.00  7.9
    ## 3257 0.00  0.0
    ## 3407 0.00  0.0
    ## 3483 0.00  0.0
    ## 3497 0.00  0.0
    ## 3511 0.00  0.0

Get rid of fighters with no weight listed.

    fighter_stats <- data_add_wc[!is.na(data_add_wc$Weight), ]

The following fighters are listed at catchweight.

    fighter_stats %>% filter(WeightClass == "catchweight")

    ##                       NAME Weight WeightClass REACH SLPM  SAPM STRA STRD   TD
    ## 1            Daniel Acacio    180 catchweight    NA 3.52  2.85 0.36 0.62 0.33
    ## 2            Wes Albritton    188 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 3              Royce Alger    199 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 4              Andre Amado    154 catchweight    NA 2.27  5.91 0.24 0.63 0.00
    ## 5        Bertrand Amoussou    190 catchweight    NA 6.75  2.01 0.39 0.83 0.00
    ## 6          Lowell Anderson    160 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 7             Alex Andrade    200 catchweight    NA 0.20  2.60 0.36 0.53 0.00
    ## 8           Jermaine Andre    200 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 9              Shinya Aoki    154 catchweight    NA 0.97  1.25 0.58 0.58 2.54
    ## 10           Gilles Arsene    190 catchweight    NA 0.06  2.45 0.10 0.32 0.00
    ## 11            Luiz Azeredo    154 catchweight    NA 2.16  2.76 0.39 0.57 1.07
    ## 12         Luciano Azevedo    161 catchweight    NA 0.76  1.97 0.45 0.27 2.28
    ## 13           Karla Benitez    113 catchweight    NA 0.00  2.40 0.00 0.57 0.00
    ## 14           Dieusel Berto    200 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 15         Jerry Bohlander    199 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 16            Kotetsu Boku    154 catchweight    NA 2.47  2.80 0.42 0.53 0.00
    ## 17    Gregory Bouchelaghem    183 catchweight    NA 0.27  1.53 0.21 0.36 0.00
    ## 18   Ebenezer Fontes Braga    199 catchweight    NA 2.42  0.42 0.50 0.71 0.00
    ## 19           Dominic Brown    190 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 20       Murilo Bustamante    183 catchweight    NA 1.33  1.90 0.32 0.60 2.46
    ## 21             Todd Butler    200 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 22          Bruno Carvalho    154 catchweight    NA 0.60  0.93 0.45 0.53 0.00
    ## 23         Donnie Chappell    178 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 24             RJ Clifford    160 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 25             Abel Cullum    139 catchweight    NA 1.82  1.23 0.40 0.46 4.01
    ## 26          Sean Daugherty    175 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 27           Jason DeLucia    190 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 28           Thomas Diagne    154 catchweight    NA 4.53  4.53 0.48 0.63 2.00
    ## 29        Eldo Xavier Dias    180 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 30              David Dodd    200 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 31             Ross Ebanez    154 catchweight    NA 0.74  0.74 0.50 0.62 3.70
    ## 32              Kenny Ento    192 catchweight    NA 8.41  0.00 0.79 1.00 5.49
    ## 33             Won Jin Eoh    160 catchweight    NA 3.74  3.58 0.44 0.46 0.00
    ## 34               Josh Epps    130 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 35         Bobby Escalante    130 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 36             Fred Ettish    180 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 37       Bibiano Fernandes    139 catchweight    NA 2.91  2.02 0.40 0.72 3.97
    ## 38              Ron Fields    200 catchweight    NA 0.33  2.64 0.33 0.11 0.00
    ## 39              Brady Fink    183 catchweight    NA 1.69  1.69 0.41 0.61 3.63
    ## 40            Luiz Firmino    154 catchweight    NA 1.23  1.22 0.50 0.51 3.86
    ## 41             Clay French    161 catchweight    NA 1.52  1.27 0.50 0.16 0.00
    ## 42            Megumi Fujii    113 catchweight    NA 2.40  0.00 0.42 1.00 0.00
    ## 43        Keisuke Fujiwara    139 catchweight    NA 0.73  1.20 0.44 0.47 0.00
    ## 44         Katsuaki Furuki    168 catchweight    NA 0.27  2.67 0.10 0.39 0.00
    ## 45            James Gabert    178 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 46            Andre Galvao    168 catchweight    NA 2.34  1.56 0.52 0.58 2.02
    ## 47           Darrel Gholar    194 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 48             Kultar Gill    154 catchweight    NA 1.14  0.40 0.50 0.41 1.71
    ## 49            Bob Gilstrap    200 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 50            Royce Gracie    175 catchweight    NA 0.88  1.13 0.41 0.37 0.00
    ## 51          Crosley Gracie    190 catchweight    NA 1.69  1.54 0.37 0.60 3.46
    ## 52            Ralph Gracie    183 catchweight    NA 0.86  1.72 0.37 0.31 0.00
    ## 53          Rodrigo Gracie    183 catchweight    NA 1.34  0.86 0.51 0.46 1.49
    ## 54           Royler Gracie    150 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 55             Ryan Gracie    200 catchweight    NA 0.82  0.50 0.61 0.40 2.83
    ## 56            Cesar Gracie    181 catchweight    NA 0.00 17.14 0.00 0.50 0.00
    ## 57           Keith Hackney    200 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 58               Mark Hall    190 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 59          Joachim Hansen    150 catchweight    NA 2.01  2.04 0.43 0.58 2.21
    ## 60              Daiki Hata    139 catchweight    NA 1.44  1.42 0.39 0.55 0.67
    ## 61      Kuniyoshi Hironaka    168 catchweight    70 1.98  3.01 0.40 0.54 1.91
    ## 62              David Hood    200 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 63         Minoki Ichihara    178 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 64          Seichi Ikemoto    168 catchweight    NA 2.59  3.74 0.32 0.57 1.23
    ## 65        Masakazu Imanari    139 catchweight    NA 0.55  1.74 0.30 0.57 0.00
    ## 66              Egan Inoue    190 catchweight    NA 1.66  3.31 0.36 0.57 0.00
    ## 67           Katsuya Inoue    168 catchweight    NA 3.41 12.89 0.24 0.51 0.00
    ## 68           Jason Ireland    161 catchweight    NA 1.20  2.07 0.25 0.51 3.59
    ## 69        Mitsuhiro Ishida    154 catchweight    NA 1.46  1.13 0.41 0.61 4.76
    ## 70           Kevin Jackson    199 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 71           Art Jimmerson    196 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 72         Deshaun Johnson    167 catchweight    NA 2.27  6.67 0.41 0.43 0.00
    ## 73              Paul Jones    199 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 74             Chris Jones    149 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 75            Trevin Jones    140 catchweight    70 3.72  9.45 0.52 0.29 2.15
    ## 76           Bu-Kyung Jung    154 catchweight    NA 0.63  1.85 0.36 0.56 1.10
    ## 77          Young Sam Jung    139 catchweight    NA 0.53  2.79 0.09 0.63 0.00
    ## 78             Geza Kalman    200 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 79      Hiromitsu Kanehara    200 catchweight    NA 0.76  4.39 0.22 0.40 0.00
    ## 80              Ken Kaneko    161 catchweight    NA 0.00  0.94 0.00 0.42 0.00
    ## 81            Casey Kenney    140 catchweight    68 4.79  4.07 0.43 0.59 1.25
    ## 82            Sanae Kikuta    200 catchweight    NA 0.70  0.90 0.45 0.52 1.60
    ## 83             Dae Won Kim    180 catchweight    NA 1.75  2.51 0.32 0.36 3.43
    ## 84            Jong Won Kim    139 catchweight    NA 0.84  3.28 0.15 0.63 2.81
    ## 85            Jong Man Kim    139 catchweight    NA 1.33  3.00 0.21 0.60 0.00
    ## 86          Satoru Kitaoka    154 catchweight    NA 0.68  2.15 0.33 0.45 0.62
    ## 87              Yuki Kondo    183 catchweight    NA 1.14  2.57 0.42 0.51 0.76
    ## 88     Christophe Leninger    200 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 89              John Lober    199 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 90          Federico Lopez    139 catchweight    NA 1.78  5.35 0.23 0.30 0.00
    ## 91           Yoshiro Maeda    139 catchweight    68 2.36  2.55 0.33 0.63 2.93
    ## 92             Bill Mahood    200 catchweight    NA 1.54  3.59 0.85 0.17 0.00
    ## 93           Aliev Makhmud    195 catchweight    NA 1.12  2.24 0.30 0.36 2.10
    ## 94            Carl Malenko    200 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 95       Melchor Manibusan    154 catchweight    NA 1.58  5.79 0.54 0.15 0.00
    ## 96          Rainy Martinez    199 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 97          Shoji Maruyama    139 catchweight    NA 1.40  0.27 0.63 0.55 0.00
    ## 98          Daijiro Matsui    200 catchweight    NA 0.84  1.69 0.45 0.55 1.83
    ## 99             Todd Medina    193 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 100           Jason Medina    180 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 101             Guy Mezger    200 catchweight    NA 2.30  1.36 0.32 0.72 0.39
    ## 102         Ikuhisa Minowa    181 catchweight    NA 0.88  1.66 0.40 0.49 1.82
    ## 103           Kazuo Misaki    183 catchweight    NA 2.85  2.74 0.40 0.63 0.72
    ## 104          Jonathan  Mix    168 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 105       Tomoya Miyashita    139 catchweight    NA 1.67  0.93 0.65 0.33 4.00
    ## 106        Kazuyuki Miyata    139 catchweight    NA 2.04  1.82 0.52 0.63 4.31
    ## 107        Motoki Miyazawa    168 catchweight    NA 1.23  3.91 0.28 0.61 0.00
    ## 108        Rudyard Moncayo    195 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 109         Hidetaka Monma    168 catchweight    NA 1.67  9.76 0.25 0.34 0.00
    ## 110            Joe Moreira    195 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 111              Juan Mott    190 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 112      Flavio Luiz Moura    183 catchweight    NA 0.67  0.00 0.16 0.00 0.00
    ## 113         Ryuichi Murata    183 catchweight    NA 0.84  1.89 0.36 0.50 4.74
    ## 114           Ho Bae Myeon    168 catchweight    NA 3.16  3.16 0.16 0.83 0.00
    ## 115       Katsuhiko Nagata    154 catchweight    NA 1.05  1.50 0.19 0.63 0.98
    ## 116       Daisuke Nakamura    154 catchweight    NA 0.94  1.38 0.30 0.61 0.46
    ## 117         Akiyo Nishiura    139 catchweight    NA 1.59  1.26 0.57 0.57 0.00
    ## 118           Takahiro Oba    200 catchweight    NA 0.23  1.82 0.25 0.69 0.00
    ## 119           Kazuki Okubo    175 catchweight    NA 1.53  1.97 0.38 0.46 0.51
    ## 120            Andy Ologun    154 catchweight    NA 2.36  0.32 0.57 0.85 0.68
    ## 121        Takafumi Otsuka    139 catchweight    NA 1.29  2.12 0.27 0.67 1.64
    ## 122       Artur Oumakhanov    154 catchweight    NA 1.20  1.67 0.33 0.82 3.00
    ## 123         Tulio Palhares    180 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 124        Stephen Palling    143 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 125           Won Sik Park    154 catchweight    NA 2.60  2.20 0.43 0.47 0.00
    ## 126       Onassis Parungao    200 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 127           Tony Petarra    196 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 128              Gary Quan    143 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 129            Andrew Ramm    160 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 130              Raou Raou    195 catchweight    NA 2.01  6.75 0.16 0.60 0.00
    ## 131         Keenan Raymond    165 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 132            John Renken    190 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 133          Vitor Ribeiro    154 catchweight    NA 1.00  1.95 0.28 0.48 1.58
    ## 134            Rafael Rios    150 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 135          Shannon Ritch    190 catchweight    NA 1.00  6.00 1.00 0.50 0.00
    ## 136 Nicdali Rivera-Calanoc    105 catchweight    NA 1.82  2.42 0.20 0.78 0.00
    ## 137           Joey Roberts    200 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 138          Wataru Sakata    195 catchweight    NA 1.11  2.08 0.61 0.31 0.00
    ## 139         Hayato Sakurai    168 catchweight    NA 2.45  1.94 0.49 0.59 1.87
    ## 140          Ryuta Sakurai    183 catchweight    NA 1.80  3.44 0.48 0.58 0.52
    ## 141          Raul Sandoval    130 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 142             Nick Sanzo    190 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 143         Kyosuke Sasaki    183 catchweight    NA 0.33  0.93 0.45 0.46 0.00
    ## 144           Mark Schultz    200 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 145      Katsuyori Shibata    168 catchweight    NA 2.06  2.40 0.35 0.53 0.49
    ## 146            Yuya Shirai    168 catchweight    NA 1.02  4.07 1.00 0.55 0.00
    ## 147            Akira Shoji    195 catchweight    NA 1.03  2.63 0.34 0.53 1.79
    ## 148             Jean Silva    160 catchweight    NA 0.73  2.93 0.22 0.52 0.00
    ## 149        Yokthai Sithoar    143 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 150              Joe Slick    199 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 151     Kestutis Smirnovas    200 catchweight    NA 4.95  5.05 0.52 0.54 1.55
    ## 152            Josh Stuart    160 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 153          Masanori Suda    183 catchweight    NA 1.80  1.20 0.50 0.63 0.00
    ## 154          Daisuke Sugie    160 catchweight    NA 0.00  0.22 0.00 0.80 3.27
    ## 155          Naho Sugiyuma    105 catchweight    NA 2.59  2.45 0.48 0.71 2.05
    ## 156            Amar Suloev    183 catchweight    NA 1.98  2.19 0.37 0.70 0.27
    ## 157          Eugenio Tadeu    160 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 158      Yoshiki Takahashi    199 catchweight    NA 2.26  6.47 0.51 0.44 0.00
    ## 159         Yoko Takahashi    150 catchweight    NA 5.11  8.78 0.54 0.48 0.00
    ## 160        Hiroyuki Takaya    139 catchweight    NA 3.18  3.16 0.33 0.60 0.90
    ## 161        Minoru Toyonaga    195 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 162          Damien Trites    165 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 163           Ryuki Ueyama    180 catchweight    NA 0.13  1.40 0.21 0.46 0.50
    ## 164        Jeremy Umphries    160 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 165              Kengo Ura    165 catchweight    NA 1.05  2.38 0.37 0.48 2.85
    ## 166    Egidijus Valavicius    200 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 167          Ron van Clief    190 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 168            Yuri Vaulin    197 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 169       Jerrel Venetiaan    195 catchweight    NA 0.81  1.51 0.33 0.67 0.00
    ## 170         Ernie Verdicia    199 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 171             Idris Wasi    186 catchweight    NA 0.40  3.53 0.31 0.46 0.00
    ## 172      Kazuhisa Watanabe    139 catchweight    NA 0.62  0.94 0.50 0.00 0.00
    ## 173            Steve White    175 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 174             Xue Do Won    165 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 175         Nathaniel Wood    140 catchweight    69 6.28  4.36 0.46 0.53 1.29
    ## 176              JW Wright    130 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 177       Atsushi Yamamoto    139 catchweight    NA 1.97  1.27 0.39 0.70 1.12
    ## 178       Takeshi Yamazaki    139 catchweight    NA 0.57  1.57 0.25 0.47 4.50
    ## 179         Masutatsu Yano    198 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ## 180         Yoshiaki Yatsu    165 catchweight    NA 0.00  5.57 0.00 0.48 0.00
    ## 181        Kazunori Yokota    154 catchweight    NA 0.67  1.13 0.31 0.57 0.00
    ## 182          Igor Zinoviev    199 catchweight    NA 0.00  0.00 0.00 0.00 0.00
    ##      TDA  TDD SUBA
    ## 1   0.20 0.81  0.0
    ## 2   0.00 0.00  0.0
    ## 3   0.00 0.00  0.0
    ## 4   0.00 0.20  0.0
    ## 5   0.00 0.00  0.0
    ## 6   0.00 0.00  0.0
    ## 7   0.00 0.25  0.8
    ## 8   0.00 0.00  0.0
    ## 9   0.41 0.60  4.0
    ## 10  0.00 0.00  0.0
    ## 11  0.50 0.45  0.3
    ## 12  0.11 0.00  0.0
    ## 13  0.00 1.00  0.0
    ## 14  0.00 0.00  0.0
    ## 15  0.00 0.00  0.0
    ## 16  0.00 0.00  0.0
    ## 17  0.00 0.50  0.0
    ## 18  0.00 0.90  0.6
    ## 19  0.00 0.00  0.0
    ## 20  0.33 0.54  1.2
    ## 21  0.00 0.00  0.0
    ## 22  0.00 0.66  4.0
    ## 23  0.00 0.00  0.0
    ## 24  0.00 0.00  0.0
    ## 25  0.52 0.00  2.8
    ## 26  0.00 0.00  0.0
    ## 27  0.00 0.00  0.0
    ## 28  1.00 0.66  0.0
    ## 29  0.00 0.00  0.0
    ## 30  0.00 0.00  0.0
    ## 31  1.00 0.00  0.0
    ## 32  1.00 0.00 11.0
    ## 33  0.00 0.50  0.0
    ## 34  0.00 0.00  0.0
    ## 35  0.00 0.00  0.0
    ## 36  0.00 0.00  0.0
    ## 37  0.53 0.77  0.6
    ## 38  0.00 0.00  0.0
    ## 39  0.25 0.00  3.6
    ## 40  0.45 0.20  0.9
    ## 41  0.00 1.00  0.0
    ## 42  0.00 0.00 12.0
    ## 43  0.00 0.23  2.5
    ## 44  0.00 0.00  3.0
    ## 45  0.00 0.00  0.0
    ## 46  0.27 0.00  2.8
    ## 47  0.00 0.00  0.0
    ## 48  0.66 0.38  0.0
    ## 49  0.00 0.00  0.0
    ## 50  0.00 0.66  0.8
    ## 51  0.85 0.50  0.6
    ## 52  0.00 0.25  4.0
    ## 53  0.50 0.75  0.4
    ## 54  0.00 0.00  0.0
    ## 55  0.75 0.25  0.9
    ## 56  0.00 0.00  0.0
    ## 57  0.00 0.00  0.0
    ## 58  0.00 0.00  0.0
    ## 59  0.58 0.34  1.9
    ## 60  1.00 0.35  0.7
    ## 61  0.30 0.25  0.6
    ## 62  0.00 0.00  0.0
    ## 63  0.00 0.00  0.0
    ## 64  0.26 0.60  0.0
    ## 65  0.00 0.00  2.1
    ## 66  0.00 0.00  0.0
    ## 67  0.00 0.66  0.0
    ## 68  0.75 0.00  1.2
    ## 69  0.53 0.33  0.7
    ## 70  0.00 0.00  0.0
    ## 71  0.00 0.00  0.0
    ## 72  0.00 0.00  0.0
    ## 73  0.00 0.00  0.0
    ## 74  0.00 0.00  0.0
    ## 75  0.50 0.00  0.0
    ## 76  0.75 0.00  1.5
    ## 77  0.00 0.00  2.0
    ## 78  0.00 0.00  0.0
    ## 79  0.00 0.40  0.4
    ## 80  0.00 0.00  3.5
    ## 81  0.42 0.56  0.6
    ## 82  0.63 0.25  1.8
    ## 83  0.42 0.00  0.0
    ## 84  1.00 0.00  0.0
    ## 85  0.00 0.00  0.0
    ## 86  0.10 0.27  2.1
    ## 87  0.41 0.37  0.5
    ## 88  0.00 0.00  0.0
    ## 89  0.00 0.00  0.0
    ## 90  0.00 0.00  0.0
    ## 91  0.51 0.50  0.7
    ## 92  0.00 0.00  3.9
    ## 93  0.50 0.00  0.0
    ## 94  0.00 0.00  0.0
    ## 95  0.00 0.00  0.0
    ## 96  0.00 0.00  0.0
    ## 97  0.00 0.54  0.0
    ## 98  0.30 0.43  0.4
    ## 99  0.00 0.00  0.0
    ## 100 0.00 0.00  0.0
    ## 101 0.50 0.88  0.0
    ## 102 0.41 0.05  1.9
    ## 103 0.38 0.51  0.6
    ## 104 0.00 0.00  0.0
    ## 105 0.80 0.00  2.0
    ## 106 0.46 0.68  0.0
    ## 107 0.00 0.00  0.0
    ## 108 0.00 0.00  0.0
    ## 109 0.00 0.00  0.0
    ## 110 0.00 0.00  0.0
    ## 111 0.00 0.00  0.0
    ## 112 0.00 0.00  0.0
    ## 113 0.50 1.00  3.2
    ## 114 0.00 0.00  0.0
    ## 115 0.28 0.28  0.0
    ## 116 0.40 0.30  3.6
    ## 117 0.00 0.52  0.3
    ## 118 0.00 0.00  0.0
    ## 119 0.25 0.36  2.0
    ## 120 1.00 0.80  0.0
    ## 121 0.27 0.65  0.0
    ## 122 0.75 0.33  0.0
    ## 123 0.00 0.00  0.0
    ## 124 0.00 0.00  0.0
    ## 125 0.00 0.00  0.0
    ## 126 0.00 0.00  0.0
    ## 127 0.00 0.00  0.0
    ## 128 0.00 0.00  0.0
    ## 129 0.00 0.00  0.0
    ## 130 0.00 0.00  0.0
    ## 131 0.00 0.00  0.0
    ## 132 0.00 0.00  0.0
    ## 133 0.26 1.00  1.2
    ## 134 0.00 0.00  0.0
    ## 135 0.00 0.00  0.0
    ## 136 0.00 0.00  0.0
    ## 137 0.00 0.00  0.0
    ## 138 0.00 0.00  0.0
    ## 139 0.69 0.56  0.3
    ## 140 1.00 0.36  1.6
    ## 141 0.00 0.00  0.0
    ## 142 0.00 0.00  0.0
    ## 143 0.00 0.00  0.0
    ## 144 0.00 0.00  0.0
    ## 145 0.50 0.53  0.7
    ## 146 0.00 0.00  0.0
    ## 147 0.73 0.82  0.4
    ## 148 0.00 0.00  0.0
    ## 149 0.00 0.00  0.0
    ## 150 0.00 0.00  0.0
    ## 151 0.50 1.00  1.6
    ## 152 0.00 0.00  0.0
    ## 153 0.00 0.60  0.0
    ## 154 0.50 0.00  3.3
    ## 155 1.00 0.66  0.0
    ## 156 1.00 0.88  0.3
    ## 157 0.00 0.00  0.0
    ## 158 0.00 0.66  2.3
    ## 159 0.00 0.00  0.0
    ## 160 0.45 0.66  0.0
    ## 161 0.00 0.00  0.0
    ## 162 0.00 0.00  0.0
    ## 163 1.00 0.00  1.5
    ## 164 0.00 0.00  0.0
    ## 165 0.28 0.50  1.4
    ## 166 0.00 0.00  0.0
    ## 167 0.00 0.00  0.0
    ## 168 0.00 0.00  0.0
    ## 169 0.00 0.60  0.0
    ## 170 0.00 0.00  0.0
    ## 171 0.00 0.20  0.0
    ## 172 0.00 0.14  0.0
    ## 173 0.00 0.00  0.0
    ## 174 0.00 0.00  0.0
    ## 175 0.46 0.75  0.9
    ## 176 0.00 0.00  0.0
    ## 177 0.33 1.00  0.0
    ## 178 0.50 1.00  1.0
    ## 179 0.00 0.00  0.0
    ## 180 0.00 0.00  0.0
    ## 181 0.00 0.00  0.0
    ## 182 0.00 0.00  0.0

Examine data frame.

    summary(fighter_stats)

    ##      NAME               Weight      WeightClass            REACH      
    ##  Length:3515        Min.   :105.0   Length:3515        Min.   :58.00  
    ##  Class :character   1st Qu.:145.0   Class :character   1st Qu.:69.00  
    ##  Mode  :character   Median :170.0   Mode  :character   Median :72.00  
    ##                     Mean   :173.1                      Mean   :71.84  
    ##                     3rd Qu.:185.0                      3rd Qu.:75.00  
    ##                     Max.   :770.0                      Max.   :84.00  
    ##                                                        NA's   :1837   
    ##       SLPM             SAPM             STRA             STRD       
    ##  Min.   : 0.000   Min.   : 0.000   Min.   :0.0000   Min.   :0.0000  
    ##  1st Qu.: 0.800   1st Qu.: 1.500   1st Qu.:0.2600   1st Qu.:0.3600  
    ##  Median : 2.210   Median : 2.790   Median :0.4000   Median :0.5000  
    ##  Mean   : 2.327   Mean   : 3.027   Mean   :0.3509   Mean   :0.4308  
    ##  3rd Qu.: 3.460   3rd Qu.: 4.020   3rd Qu.:0.4800   3rd Qu.:0.5800  
    ##  Max.   :17.650   Max.   :52.500   Max.   :1.0000   Max.   :1.0000  
    ##                                                                     
    ##        TD              TDA              TDD             SUBA        
    ##  Min.   : 0.000   Min.   :0.0000   Min.   :0.000   Min.   : 0.0000  
    ##  1st Qu.: 0.000   1st Qu.:0.0000   1st Qu.:0.000   1st Qu.: 0.0000  
    ##  Median : 0.560   Median :0.2100   Median :0.410   Median : 0.0000  
    ##  Mean   : 1.231   Mean   :0.2641   Mean   :0.385   Mean   : 0.6548  
    ##  3rd Qu.: 1.930   3rd Qu.:0.4500   3rd Qu.:0.660   3rd Qu.: 0.8000  
    ##  Max.   :32.140   Max.   :1.0000   Max.   :1.000   Max.   :29.0000  
    ## 

<br>

### Save data.

    save(fighter_stats, file ="./Datasets/fighter_stats.RData")
