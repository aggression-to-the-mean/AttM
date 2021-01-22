---
layout: page
title: Coming Soon
permalink: /coming-soon/
---

### For Fight Fans 

I am hoping to use data analytics to answer the following questions:

* Who are the most and least favored fighters? Which fighters do the odds tend to overvalue or undervalue?  
* To what extent can fight outcomes be explained by the odds?  
* Does fighter reach matter? If so, how much does it matter?   
* Do other fight stats (strikes landed per minute, etc.) matter?   
* How well can we predict fight outcomes by putting relevant factors (fight stats, odds, etc.) into a statistical model?  

I have also started publishing short [YouTube videos](https://www.youtube.com/channel/UC0uVn1nq5HRWLrdMHHJxIsQ) to breakdown and communciate some of the more technical information found on this webpage.  You are a fight fan - you don't care about fancy stats...  What the hell does all of this mean!?

### For Nerds

I am hoping to conduct some of the following analyses:

*  Using stan_glm in R, implementing Bayesian logistic regression to predict fight outcomes (probability that favorite wins) using the following predictors: (i) the best available odds for the favorite and (ii) the difference in reach between the two fighters.    
*  The above analysis will be run on the entire dataset, with events dating back to 2013. Using a smaller dataset (dating back to 2020), I will want to run a similar analysis using a larger number of predictors (including striking accuracy, takedown defence rate, etc.).  
* Further to the above two points, I will use prior knowledge, standard model-selection criteria, cross validation procedures, and posterior predictive checks to contruct a model with good  predictive accuracy.   
* In the future, I may consider adding more complicated predictors (e.g. fan hype based on twitter engagement) and/or contructing more complicated models (e.g. hierachical structure) to improve predictions and answer additional questions.    