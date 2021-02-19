---
category: arts
---


<br>

Introduction
------------

In other posts, we identified some of the UFC’s most [Under
Rated](https://aggression-to-the-mean.github.io/AttM/for-the-people/arts/2021/02/19/Under-Rated-Fighters.html)
and [Over
Rated](https://aggression-to-the-mean.github.io/AttM/for-the-people/arts/2021/02/19/Over-Rated-Fighters.html)
fighters by examining the extent to which they had underperformed or
overperformed relative to the odds.

The purpose of this post is to identify the most and least valued
fighters, regardless of performance. In other words, which fighters have
had reliably favorable or unfavorable fight odds?

<br>

Defining Most and Least Valued
==============================

These terms are more straightforward than Over and Under Rated. The Most
Valued fighters are simply those with the highest average Implied
Probability of winning, based on the odds. Conversely, the Least Valued
fighters are those with the lowest average Implied Probability of
winning.

With the above definitions, it does not matter how the fighters actually
performed. We are only interested in how the oddsmakers viewed them.

<br>

Dataset - Historical Data of UFC Fight Odds
===========================================

Using data science tools such as web scraping, I have obtained a dataset
with fight odds information regarding the majority of the UFC fights
that occurred between 2013 and present.

In particular, the dataset consists of 2941 UFC fights from 261 UFC
events, spanning from April 27, 2013 to February 06, 2021.

Among other things, the dataset lists the best odds for each fighter
around the time of their fight, as well as the winner of each fight.

<br>

<table>
<colgroup>
<col style="width: 100%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>NOTE:</strong> Some of the tables below are based on the fight data contained in the dataset described above. Although the dataset captures a large proportion of UFC events and fights since 2013, it is not exhaustive.</th>
</tr>
</thead>
<tbody>
</tbody>
</table>

<br>

Most Valued Fighters
--------------------

The below table lists the top 10 Most Valued fighters, in the dataset,
with at least 5 UFC fights. These fighters are listed in order of the
Average Implied Probabilities of the odds.

There are no real surprises below. Many of the fighters on the list are
widely considered to be among the most dominant fighters (and champions)
of their time.

Demetrious Johnson stands out as having an astonishing Average Implied
Probability of 86%, based on 9 of his many UFC fights.

<br>

<table>
<caption>Top 10 Most Valued Fighters with at least 5 Fights</caption>
<thead>
<tr class="header">
<th style="text-align: left;">Fighter Name</th>
<th style="text-align: right;">Number of Fights</th>
<th style="text-align: right;">Average Adjusted Implied Probability (%)</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Demetrious Johnson</td>
<td style="text-align: right;">9</td>
<td style="text-align: right;">86</td>
</tr>
<tr class="even">
<td style="text-align: left;">Cristiane Justino</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">83</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Ronda Rousey</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">83</td>
</tr>
<tr class="even">
<td style="text-align: left;">Petr Yan</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">81</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Zabit Magomedsharipov</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">81</td>
</tr>
<tr class="even">
<td style="text-align: left;">Tatiana Suarez</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">80</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Jon Jones</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">79</td>
</tr>
<tr class="even">
<td style="text-align: left;">Khabib Nurmagomedov</td>
<td style="text-align: right;">9</td>
<td style="text-align: right;">76</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Magomed Ankalaev</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">76</td>
</tr>
<tr class="even">
<td style="text-align: left;">Joe Duffy</td>
<td style="text-align: right;">8</td>
<td style="text-align: right;">73</td>
</tr>
</tbody>
</table>

<br>

As mentioned in the disclaimer box above, these findings are not
complete. For example, Jon Jones obviously has many more than 7 fights.
However, the list above should still give a reasonably representative
estimate of how heavily these top tier fighters are favored.

If you are interested in getting a fuller picture of any particular
fighter’s history with the odds, you can likely get additional
information from the [Best Fight Odds
website](https://www.bestfightodds.com/).

<br>

Least Valued
------------

The below table lists the top 10 Least Valued fighters, in the dataset,
with at least 5 UFC fights. These fighters are listed in reverse order
of the Average Implied Probabilities of the odds.

The one fighter that stands out from the below list is Roxanne
Modafferi, mainly because she has been active as of late. There is a
popular narrative that Modafferi is not highly valued by the odds makers
so it is no surprise that she makes her way towards the top of this
list.

As for Dan Henderson, the only reason he made it to the list is likely
because the dataset captured some fights towards the end of his career
(post 2013). I would imagine that the odds for Hendo would be much more
favorable earlier in his career, when he was in his prime.

<table>
<caption>Top 10 Least Valued Fighters with at least 5 Fights</caption>
<thead>
<tr class="header">
<th style="text-align: left;">Fighter Name</th>
<th style="text-align: right;">Number of Fights</th>
<th style="text-align: right;">Average Adjusted Implied Probability (%)</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Roxanne Modafferi</td>
<td style="text-align: right;">8</td>
<td style="text-align: right;">27</td>
</tr>
<tr class="even">
<td style="text-align: left;">Daniel Kelly</td>
<td style="text-align: right;">10</td>
<td style="text-align: right;">28</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Dan Henderson</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">29</td>
</tr>
<tr class="even">
<td style="text-align: left;">Jessica Aguilar</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">29</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Anthony Perosh</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">30</td>
</tr>
<tr class="even">
<td style="text-align: left;">Leslie Smith</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">30</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Thibault Gouti</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">30</td>
</tr>
<tr class="even">
<td style="text-align: left;">Diego Sanchez</td>
<td style="text-align: right;">10</td>
<td style="text-align: right;">31</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Garreth McLellan</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">31</td>
</tr>
<tr class="even">
<td style="text-align: left;">Rogerio Nogueira</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">31</td>
</tr>
</tbody>
</table>

<br>

Conclusion
----------

The lists of Most and Least valued fighters are interesting mostly
because they tend to match our intuitions fairly well. Fighters that
lose fairly frequently but not enough to be let go by the UFC, tend not
to be highly valued based on the odds. Conversely, well-known dominant
fighters (especially champions) tend to be highly valued by the odds -
how could they not be!?
