---
category: science
---

Description
-----------

This script scrapes UFC event information from the
<a href="http://ufcstats.com" class="uri">http://ufcstats.com</a>
website.

The script is adapted from:

<a href="https://github.com/jasonchanhku/UFC-MMA-Predictor/blob/master/UFC%20MMA%20Predictor%20Workflow.ipynb" class="uri">https://github.com/jasonchanhku/UFC-MMA-Predictor/blob/master/UFC%20MMA%20Predictor%20Workflow.ipynb</a>

<br>

### Libraries

    library(rvest)
    library(dplyr)
    library(tidyr)
    library(stringr)
    library(data.table)
    library(dtplyr)

<br>

### Web Scrape Event Info

Get urls for all desired events.

    webpage <- read_html("http://ufcstats.com/statistics/events/completed?page=all")
    urls <- webpage %>% html_nodes(".b-link_style_black") %>% html_attr("href")

<br>

#### Initialization

Create data structures to store event info.

    date <- c()
    event <- c()
    city <- c()
    state <- c()
    country <- c()
    winner <- c()
    loser <- c()
    wc <- c()
    method <- c()
    round <- c()

<br>

#### Loop

    # start the clock
    ptm <- proc.time()

    for(i in 1:length(urls)){
      
      # # print iteration
      # print(sprintf("%d of %d", i, length(urls)))
      # # start the clock
      # ptm <- proc.time()
      
      url_link <- read_html(urls[i])
      
      # winner 
      winner_t <- url_link %>% html_nodes(".b-fight-details__table-text:nth-child(1) .b-link_style_black") %>% html_text()
      winner <- c(winner, trimws(winner_t))
      
      # loser
      loser_t <- url_link %>% html_nodes(".b-fight-details__table-text+ .b-fight-details__table-text .b-link_style_black") %>% html_text()
      loser <- c(loser, trimws(loser_t))
      
      # weightclass
      wc_t <- url_link %>% html_nodes(".l-page_align_left:nth-child(7) .b-fight-details__table-text") %>% html_text()
      wc <- c(wc, trimws(wc_t))
      
      # method
      method_t <- url_link %>% html_nodes(".l-page_align_left+ .l-page_align_left .b-fight-details__table-text:nth-child(1)") %>% html_text()
      method <- c(method, trimws(method_t))
      
      # round 
      round_t <- url_link %>% html_nodes(".b-fight-details__table-col:nth-child(9) .b-fight-details__table-text") %>% html_text()
      round <- c(round, as.integer(trimws(round_t)))
      
      # date
      date_t <- url_link %>% html_nodes(".b-list__box-list-item:nth-child(1)") %>% html_text()
      date_t <- trimws(strsplit(trimws(date_t), ":")[[1]][2])
      date_t <- as.character(as.Date(date_t, format = "%B %d, %Y"))
      date_t <- replicate(length(winner_t), date_t)
      date <- c(date, date_t)    
      
      # event
      event_t <- url_link %>% html_nodes(".b-content__title-highlight") %>% html_text()
      event_t <- trimws(event_t)
      event_t <- replicate(length(winner_t), event_t)
      event <- c(event, event_t)
      
      # location
      location_t <- url_link %>% html_nodes(".b-list__box-list-item:nth-child(2)") %>% html_text()
      location_t <- trimws(strsplit(trimws(location_t), ":")[[1]][2])
      location_t <- strsplit(location_t, ",")
      
      city_t <- trimws(location_t[[1]][1])
      city_t <- replicate(length(winner_t), city_t)
      city <- c(city, city_t)
      
      state_t <- trimws(location_t[[1]][2])
      state_t <- replicate(length(winner_t), state_t)
      state <- c(state, state_t)
      
      country_t <- trimws(location_t[[1]][3])
      country_t <- replicate(length(winner_t), ifelse(is.na(country_t), replicate(length(winner_t), state_t),replicate(length(winner_t), country_t)))
      country <- c(country, country_t)

      # # stop the clock
      # print(proc.time() - ptm)
      
    }

    # stop the clock
    print(proc.time() - ptm)

    ##    user  system elapsed 
    ##  45.345   0.878 305.929

<br>

### Create and Save Data Frame

Create data frame.

    event_info <- data.frame(Date = date, Event = event, City = city, State = state, Country = country, Winner = winner, Loser = loser, WeightClass = wc, Round = round, Method = method)

Examine event data.

    summary(event_info)

    ##      Date              Event               City              State          
    ##  Length:5927        Length:5927        Length:5927        Length:5927       
    ##  Class :character   Class :character   Class :character   Class :character  
    ##  Mode  :character   Mode  :character   Mode  :character   Mode  :character  
    ##                                                                             
    ##                                                                             
    ##                                                                             
    ##    Country             Winner             Loser           WeightClass       
    ##  Length:5927        Length:5927        Length:5927        Length:5927       
    ##  Class :character   Class :character   Class :character   Class :character  
    ##  Mode  :character   Mode  :character   Mode  :character   Mode  :character  
    ##                                                                             
    ##                                                                             
    ##                                                                             
    ##      Round          Method         
    ##  Min.   :1.000   Length:5927       
    ##  1st Qu.:1.000   Class :character  
    ##  Median :3.000   Mode  :character  
    ##  Mean   :2.309                     
    ##  3rd Qu.:3.000                     
    ##  Max.   :5.000

Save data frame.

    save(event_info, file = "./Datasets/event_info.RData")
