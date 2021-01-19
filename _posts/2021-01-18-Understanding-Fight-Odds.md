<br>

Introduction
============

If you are a UFC fight fan, you have likely noticed that the betting
odds are often featured prominently in the lead up to a fight. This page
is intended for those who want to better understand what the betting
odds signify, how to interpret them, and how well they have predicted
fight outcomes in past years.

After reading this page, you will be able to understand what Jon Anik
means when he notes a fighter to be a “prohibitive favourite”, and why
the commentators react so strongly to big upsets.

<br>

![](/AttM/rmd_images/2021-01-18-understanding_fight_odds/rogananikdc_reaction.jpg)
This was a reaction to the Darioush vs. Klose fight. Darioush was
actually the favourite to win here, and did, but you get my point…

<br>

Types of Betting Odds
=====================

Betting odds are typically represented in one of three ways:  
1. Moneyline / American Odds (+140 vs. -160)  
2. Decimal Odds (2.40 vs. 1.63)  
3. Fractional Odds (7/5 vs. 5/8)

As a UFC fan, you would probably be used to seeing American Odds. We
will focus on this format.

<br>

Understanding American Odds
===========================

American Odds are best understood from the perspective of either earning
or betting $100.

As I write this, Calvin Kattar is slated to fight Max Holloway on
January 16, 2021.

According to [www.bestfightodds.com](https://www.bestfightodds.com/#),
5Dimes has Holloway as a -160 favorite over Kattar who is listed as a
+140 underdog.

This means that you need to bet $160 on Holloway to make a $100 profit.
Conversely, if you bet $100 on Kattar, you will make a $140 profit.

As you can see, your potential earnings are greater if you bet on
Kattar. By definition, this makes Kattar the underdog and implies that
Kattar should be less likely to win than Holloway.

Simply put, the fighter associated with the negative number is the
favorite. The larger the negative number, the more that fighter is
favored to win.

Ok, but now you might be wondering, exactly how likely is Kattar (or
Holloway) to win? To answer that question, we’ll have to explore the
Implied Probabilities of the American Odds.

<br>

Implied Probability
===================

What exactly does it mean for a fighter to be a favorite? Well, as
discussed, it means that you make less money betting on that fighter
than you would betting on the underdog. But that is not all it means.
More intuitively, it means that the fighter has greater than a 50%
probability of winning. Conversely, the underdog has less than a 50%
probability of victory.

We can use American Odds to derive the exact probability the favorite
and underdog have of winning. These are called Implied Probabilities
because they are not explicitly established probabilities of victory -
they are probabilities implied by the amounts of money people are
willing to bet on either fighter.

<br>

The following equation calculates the Implied Probability of the
favorite:

> Implied Probability Of Favorite = -American Odds / (-American Odds +
> 100)

<br>

The following equation calculates the Implied Probability of the
underdog:

> Implied Probability Of Underdog = 100/(100 + American Odds)

<br>

Using these equations, we can see that Holloway has about a 62%
probability of victory:

> Implied Probability Of Holloway = -(-160)/(-(-160)+100) = 0.615

<br>

Conversely, Kattar appears to have approximately a 42% probability of
victory:

> Implied Probability Of Kattar = 100/(140 + 100) = 0.416

<br>

At this point, you may have noticed that something is wrong… The Implied
Probabilities don’t add up to 100%! Indeed, 62% + 42% = 104%.

This is by design. The surplus of percentage points (in this case 4%) is
referred to as the overround.

<br>

Overround
=========

The overround guarantees that the oddsmaker (in this case, 5Dimes) turns
a profit. By contrast, the overround makes it more difficult for bettors
to earn money, especially in the long run. As a bettor, the odds are
stacked against you.

However, you can overcome most of the disadvantage of the overround by
selectively choosing the betting website that provides you with the best
fight odds for your particular pick.

What is meant by “best fight odds”? Well, if you are betting $100 on an
underdog, you will want to place your bet with the website that provides
you with the largest positive number because that number describes the
profit you could be making.

In our example, as noted above, 5Dimes has Kattar as a +140 underdog.
However, according to
[www.bestfightodds.com](https://www.bestfightodds.com/#), Pinnacle lists
Kattar at +145. Therefore, if you bet $100 on Kattar with Pinnacle and
he wins, you will make $5 more than you would have if you had placed
your bet with 5Dimes.

Of course, $5 may not seem like much. However, if you compare Kattar’s
best odds (+145) with his worst odds (+133 with Interhops), you have a
$12 difference (for a $100 bet). Moreover, often times, the difference
between the best and worst odds for a given fighter can greatly exceed
+12 points, especially when dealing with big favorites/underdogs
(i.e. larger absolute numbers).

NOTE: If you want to build an intuition for this, just spend a bit of
time scanning the Moneyline / American Odds for a given UFC event listed
on the [www.bestfightodds.com](https://www.bestfightodds.com/#) website.

Over the long run, making sure you pick the best odds for your bets can
have a big impact.

<br>

Dataset - Historical Data of UFC Fight Odds
===========================================

Using data science tools such as web scraping, I have obtained a dataset
with fight odds information regarding the majority of the UFC fights
that occurred between 2013 and present.

In particular, the dataset consists of 2905 UFC fights from 258 UFC
events, spanning from April 27, 2013 to December 19, 2020.

Among other things, the dataset lists the best odds for each fighter
around the time of their fight, as well as the winner of each fight.

<br>

### How much does picking the best odds make up for overround?

**It almost completely makes up for the overround!**

The average (median) overround in the dataset is 0.0083826, which is
less than 1%.

The below graph shows the distribution of fight overrounds, based on
best available odds. As you can see, the vast majority of fight
overrounds lie between -5 and 5 percentage points. The dashed line
corresponds to an overround of 0%, whereas the dotted line showcases the
average overround of just under 1%.

<br>

![](/AttM/rmd_images/2021-01-18-understanding_fight_odds/unnamed-chunk-3-1.png)

<br>

### Will I make money if I just always bet on the underdog?

**No.**

Well, at least not if the past predicts the future… Had you bet 1$ on
the underdog of every UFC fight (included in the dataset) you would have
lost $6.21. Your return on investment (ROI) would have been -0.21%.

The below graphs simulate what your cumulative unit profit (profit if
you bet $1 per fight) and cumulative ROI would have been had you bet on
on the underdog (using the best available odds) for every UFC fight
(from the dataset).

For my money, there does not appear to be any trend in the data…

<br>

![](/AttM/rmd_images/2021-01-18-understanding_fight_odds/unnamed-chunk-5-1.png)![](/AttM/rmd_images/2021-01-18-understanding_fight_odds/unnamed-chunk-5-2.png)
<br>

### Will I make money if I always bet on the favorite instead?

**No.**

Had you bet 1$ on the favorite of every UFC fight you would have lost
$66.48. Your ROI would have been -2.29%.

The below graphs simulate what your cumulative unit profit and
cumulative ROI would have been had you bet on on the favorite for every
UFC fight.

<br>

![](/AttM/rmd_images/2021-01-18-understanding_fight_odds/unnamed-chunk-7-1.png)![](/AttM/rmd_images/2021-01-18-understanding_fight_odds/unnamed-chunk-7-2.png)

<br>

I believe the primary take away of the above graphs is that picking the
best available odds and betting exclusively on underdogs or favorites is
not a fruitful betting strategy.

The calculated ROIs for betting exclusively on underdogs or favorites
are reasonably consistent with those listed at
[BetMMA.tips](https://www.betmma.tips/mma_betting_favorites_vs_underdogs.php?Org=1).

<br>

### Are Fight Odds “Accurate”?

**Basically, yes.**

But what does it mean for the odds to be “accurate”?

Well, as noted earlier in this post, we can derive Implied Probabilities
from fight odds. These probabilities are meant to represent the
probability that a given fighter will win. Of course, a given fight only
occurs once. For instance, there will be only one winner of the Kattar
vs. Holloway contest. We cannot get them to fight 100 times to see how
often each of them wins. What we can do, however, is look at how the
odds perform across fights. For example, if we look at all the fights
for which the Implied Probability of the favorite was between 60-65%, we
would expect that the favorite won 60-65% of the time. We can do this
for the whole spectrum of Implied Probabilities to gauge the overall
accuracy of the Fight Odds.

The below graphs showcase this aforementioned spectrum. For both
underdogs and favorites, I computed the actual probability of victory of
fighters in various ranges of Implied Probabilities. In common
statistical language, we refer to these ranges as “bins”. As such, the x
coordinate of each black dot is simply the middle point of the bin it
represents. The y coordinate is the probability of victory of all the
fighters that fell within that bin. The smooth blue curve represents a
basic statistical model that tries to fit a curve to the black dots. For
our purposes, it gives us a better sense of the trend underlying the
black dots.

The diagonal dotted line represents where we would have expected to data
points to land if the odds were perfectly “accurate”. If the black dots
and/or blue line falls below the dotted line, it means the fighters in
the corresponding bin underperformed relative to the odds. Conversely,
if the black dots and/or blue line rises above the dotted line, it
signifies that the fighters in the corresponding bin overperformed
relative to the odds.

As we can see, moderate favorites underperformed, whereas substantial
favorites overperformed. Conversely, substantial underdogs
underperformed, whereas moderate underdogs overperformed.

Having two graphs (one for favorites and one for underdogs) is a bit
redundant in the sense that the results, by definition, will largely
mirror each other. However, I believe having both graphs helps with
interpretation.

<br>

![](/AttM/rmd_images/2021-01-18-understanding_fight_odds/unnamed-chunk-9-1.png)![](/AttM/rmd_images/2021-01-18-understanding_fight_odds/unnamed-chunk-9-2.png)

<br>

I believe the primary takeaway of the graphs is that the odds do a
pretty good job of predicting who will win across multiple fights. With
that said, the odds do appear to convey some bias whereby underdogs
overperform in close match-ups whereas favorites overperform in
disperate pairings.

According to
[BetMMA.tips](https://www.betmma.tips/mma_betting_favorites_vs_underdogs.php?Org=1),
which noticed a similar trend, this bias may be a result of “bettors
putting money on slight favorites and pushing out their odds beyond what
should really be a pickem fight”. This certainly seems plausible to me.

<br>

Conclusion
==========

In a sentence: fight odds are reasonably representative of a fighter’s
chance of victory and it is difficult to make money betting on UFC
fights.

Admittedly, there is much more nuance to understanding fight odds.
Indeed, my goal is to go into the weeds in future posts by exploring
some of the following points:  
- How does the performance/accuracy of fight odds vary from year to
year?  
- What is the relationship between fight odds and the method of victory
(e.g. TKO vs. U-DEC)?  
- How can fight odds be used to predict the outcome of a particular
fight?

<br>
