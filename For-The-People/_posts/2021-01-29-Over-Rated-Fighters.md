---
category: arts
---

<br>

Introduction
------------

In [a previous
post](https://aggression-to-the-mean.github.io/AttM/for-the-people/arts/2021/01/28/Under-Rated-Fighters.html),
we identified some of the UFC’s most Under Rated fighters by examining
the extent to which they had overperformed relative to the odds.

The purpose of this post is to identify some of the most Over Rated
fighters in the UFC.

<br>

Defining “Over Rated”
=====================

In a previous post, to assess the extent to which a fighter was Under
Rated, we examined if the fighter won at a greater rate than the average
Implied Probability of their odds (i.e. has the fighter been
overperforming)?

In this post, we will examine the converse: has a fighter **lost** at a
greater rate than the average Implied Probability of their odds
(i.e. has the fighter been underperforming). Indeed, if a fighter has
been underperforming, then they have been effectively Over Rated by the
odds.

<br>

Dataset - Historical Data of UFC Fight Odds
===========================================

Using data science tools such as web scraping, I have obtained a dataset
with fight odds information regarding the majority of the UFC fights
that occurred between 2013 and present.

In particular, the dataset consists of 2929 UFC fights from 260 UFC
events, spanning from April 27, 2013 to January 20, 2021.

Among other things, the dataset lists the best odds for each fighter
around the time of their fight, as well as the winner of each fight.

<br>

<table>
<colgroup>
<col style="width: 100%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>NOTE:</strong> Some of the tables below are based on the fight data contained in the dataset described above. Although the dataset captures a large proportion of UFC events and fights since 2013, it is not exhaustive. Therefore, I will do manual searches to retrieve additional data regarding the fighters in question, to provide a more comprehensive picture this fighter-specific odds information.</th>
</tr>
</thead>
<tbody>
</tbody>
</table>

<br>

Over Rated Fighters
-------------------

The below table lists the top 10 Over Rated fighters, in the dataset,
with at least 5 UFC fights. These fighters are listed in order of Under
Performance, which is simply the Average Implied Probabilities of the
odds subtracted by Actual Rate of Victory.

<br>

<table style="width:100%;">
<caption>Top 10 Under Rated Fighters with at least 5 Fights</caption>
<colgroup>
<col style="width: 17%" />
<col style="width: 14%" />
<col style="width: 26%" />
<col style="width: 22%" />
<col style="width: 18%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Fighter Name</th>
<th style="text-align: right;">Number of Fights</th>
<th style="text-align: right;">Average Implied Probability (%)</th>
<th style="text-align: right;">Actual Rate of Victory (%)</th>
<th style="text-align: right;">Under Performance (%)</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Kailin Curran</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">55</td>
<td style="text-align: right;">14</td>
<td style="text-align: right;">41</td>
</tr>
<tr class="even">
<td style="text-align: left;">Hyun Gyu Lim</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">58</td>
<td style="text-align: right;">20</td>
<td style="text-align: right;">38</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Joshua Burkman</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">38</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">38</td>
</tr>
<tr class="even">
<td style="text-align: left;">Alexander Gustafsson</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">63</td>
<td style="text-align: right;">29</td>
<td style="text-align: right;">34</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Gray Maynard</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">51</td>
<td style="text-align: right;">17</td>
<td style="text-align: right;">34</td>
</tr>
<tr class="even">
<td style="text-align: left;">Junior Albini</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">54</td>
<td style="text-align: right;">20</td>
<td style="text-align: right;">34</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Andrea Lee</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">71</td>
<td style="text-align: right;">40</td>
<td style="text-align: right;">31</td>
</tr>
<tr class="even">
<td style="text-align: left;">Rashad Evans</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">51</td>
<td style="text-align: right;">20</td>
<td style="text-align: right;">31</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Johny Hendricks</td>
<td style="text-align: right;">8</td>
<td style="text-align: right;">55</td>
<td style="text-align: right;">25</td>
<td style="text-align: right;">30</td>
</tr>
<tr class="even">
<td style="text-align: left;">Anderson Silva</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">43</td>
<td style="text-align: right;">14</td>
<td style="text-align: right;">29</td>
</tr>
</tbody>
</table>

<br>

I find these findings (the table above) a fair bit less interesting than
those for the most [Under Rated
fighters](https://aggression-to-the-mean.github.io/AttM/for-the-people/arts/2021/01/28/Under-Rated-Fighters.html).

For starters, the names are not as big, overall, and the fighters do not
have as many fights under their belts, on average. I believe that part
of the reason for this is that, by definition, Over Rated fighters have
not performed as well as they should have, which means they likely have
not gotten as many UFC fights or been recognized as much as their peers.

Perhaps an even more important thing to point out is that there are a
few big names (Gustafsson, Evans, Hendricks, and Silva) that are on the
list unfairly. Unfortunately, the dataset only captures the losing
records these fighters had towards the end of their careers (i.e. after
circa 2013). However, these well regarded fighters all had much more
success in an earlier era (i.e. pre 2013). This era simply is not
captured by the dataset.

I am not interested in gathering all the data that is missing from the
dataset. However, I did spend a bit of time analyzing Gustafsson’s
career. I was surprised to see how heavily he was favored in some of his
match-ups.

<br>

Alexander Gustafsson
====================

The below table displays the Alexander Gustafsson fights that are
included in the dataset.

<br>

<table>
<caption>Alexander Gustafsson Fights Included in the Dataset</caption>
<colgroup>
<col style="width: 20%" />
<col style="width: 39%" />
<col style="width: 10%" />
<col style="width: 6%" />
<col style="width: 23%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Fighter Name</th>
<th style="text-align: left;">Event</th>
<th style="text-align: left;">Date</th>
<th style="text-align: left;">Result</th>
<th style="text-align: right;">Implied Probability (%)</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Alexander Gustafsson</td>
<td style="text-align: left;">UFC on FOX: Gustafsson vs Johnson</td>
<td style="text-align: left;">2015-01-24</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">74</td>
</tr>
<tr class="even">
<td style="text-align: left;">Alexander Gustafsson</td>
<td style="text-align: left;">UFC 192: Cormier vs Gustafsson</td>
<td style="text-align: left;">2015-10-03</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">29</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Alexander Gustafsson</td>
<td style="text-align: left;">UFC Fight Night: Arlovski vs. Barnett</td>
<td style="text-align: left;">2016-09-03</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">85</td>
</tr>
<tr class="even">
<td style="text-align: left;">Alexander Gustafsson</td>
<td style="text-align: left;">UFC Fight Night: Gustafsson vs. Teixeira</td>
<td style="text-align: left;">2017-05-28</td>
<td style="text-align: left;">Winner</td>
<td style="text-align: right;">74</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Alexander Gustafsson</td>
<td style="text-align: left;">UFC 232: Jones vs. Gustafsson 2</td>
<td style="text-align: left;">2018-12-29</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">27</td>
</tr>
<tr class="even">
<td style="text-align: left;">Alexander Gustafsson</td>
<td style="text-align: left;">UFC Fight Night: Gustafsson vs. Smith</td>
<td style="text-align: left;">2019-06-01</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">75</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Alexander Gustafsson</td>
<td style="text-align: left;">UFC Fight Night: Whittaker vs. Till</td>
<td style="text-align: left;">2020-07-25</td>
<td style="text-align: left;">Loser</td>
<td style="text-align: right;">77</td>
</tr>
</tbody>
</table>

<br>

I decided to focus on [Gustafsson’s
fights](https://www.ufc.com/athlete/alexander-gustafsson) from the first
Jon Jones contest onward, since I believe it tells an interesting story.
Below are the two fights in that period of time which are not in the
dataset:

<table>
<colgroup>
<col style="width: 18%" />
<col style="width: 15%" />
<col style="width: 15%" />
<col style="width: 16%" />
<col style="width: 19%" />
<col style="width: 14%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Date</th>
<th style="text-align: center;">Opponent</th>
<th style="text-align: center;">Result</th>
<th style="text-align: center;">Decimal Odds</th>
<th style="text-align: center;">Implied Probability (%)</th>
<th style="text-align: right;">Under Performance (%)</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">2013-09-21</td>
<td style="text-align: center;">Jones</td>
<td style="text-align: center;">Loser</td>
<td style="text-align: center;">7.60</td>
<td style="text-align: center;">13</td>
<td style="text-align: right;">13</td>
</tr>
<tr class="even">
<td style="text-align: left;">2014-03-08</td>
<td style="text-align: center;">Manuwa</td>
<td style="text-align: center;">Winner</td>
<td style="text-align: center;">1.20</td>
<td style="text-align: center;">83</td>
<td style="text-align: right;"><strong>-</strong>17</td>
</tr>
</tbody>
</table>

<br>

**What is remarkable about the two fights listed above is that
Gustafsson went from over a 6:1 underdog against Jones to nearly a 5:1
favorite against Manuwa.**

Anyway, by taking a weighted average of (i) the average Under
Performance for the 2 fights above (i.e.-2%) and (ii) the average Under
Performance of the 7 fights in the dataset (i.e. 34%), we get around
26%. Therefore:

**In Gustafsson’s last 9 UFC fights, from his first Jones fight until
retirement, he has underperformed, relative to the odds, by about 26%.**

I wondered if that surprisingly close first fight against Jones swung
the odds in Gustafsson’s favor in subsequent fights. However, if you
look at [Gustafsson’s
odds](https://www.bestfightodds.com/fighters/Alexander-Gustafsson-1559#)
leading up to the Jones fight, he was heavily favored in many of those
bouts. Therefore, it is unclear that Gustafsson’s favorable odds in his
past 8 fights were primarily caused by his epic performance in the first
Jones bout.

Anyway, Gustafsson’s odds profile is quite strange. Overall, he seems to
have been either a substantial favorite or a substantial underdog. He
seems to have lost every fight for which he was the underdog (Jonesx2,
Cormier, Davis). However, what makes him an Over Rated fighter in recent
history are the many losses for which he was the substantial favorite.

<br>

Conclusion
----------

In this post, I discussed what made a fighter Over Rated. The results
emanating from the dataset were somewhat misleading and not as
interesting as those for the [Under Rated
fighters](https://aggression-to-the-mean.github.io/AttM/for-the-people/arts/2021/01/28/Under-Rated-Fighters.html).

As a result, I decided to focus on the interesting odds profile of
Gustafsson. Certainly, Gustafsson appears to have been Over Rated since
his first Jones contest. However, it is unclear if that close decision
against Jones biased the odds in Gustafsson’s favor, or if the bettors
had always had such belief in his talents (preceeding the first Jones
fight).

In future posts, I may explore additional fighter-specific odds
information such as:  
- Least and Most Valued fighters (regardless of performance)
