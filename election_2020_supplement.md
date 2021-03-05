Presidential election Poland 2020 - supplement
================
Wiktor Piela
17 02 2021

# Introduction

Current document is the supplement to the earlier analysis where I
presented and initially analyzed the results of the presidential
elections in Poland in 2020. Now we will focus on some variables that
could have correlation with results of given candidate. Mentioned
elections had exceptional course and very important thing is to
investigate some of factors which occurred.

# Turnout and election results in poviats

As we know very well Overall voter turnout was 68.18 percent and was one
of the highest h in the history of Poland after 1989. In this election
were cast in total 20636635 valid votes. Basically, the turnout is
neutral measure, indicating how much election is important for citizens
and that they want to change or keep country politics, however in mass
media we are able to meet often a lot of comments, that high voter
turnout could favour given candidate - it means more or less that having
relatively high turnout, one on candidates get more votes (in given
constituency).

Let’s see results of each of candidates on the same plot with turnout.
Is there any relationship?

<img src="election_2020_supplement_files/figure-gfm/frekwencja_wyniki-1.png" style="display: block; margin: auto;" />

To summarise, there is no relationship visible, especially linear, what
we could easy measure and present any specific number. But one
phenomenon is possible to notice - Trzaskowski got more votes than Duda
in poviats, where it has been registered very low turnout or very high.
Let’s check those places and their features.

<table class=" lightable-classic" style="font-family: Cambria; width: auto !important; margin-left: auto; margin-right: auto;">

<caption>

Poviats with the lowest and the highets turnout

</caption>

<thead>

<tr>

<th style="text-align:left;">

Powiat

</th>

<th style="text-align:left;">

Województwo

</th>

<th style="text-align:right;">

Turnout

</th>

<th style="text-align:right;">

Duda

</th>

<th style="text-align:right;">

Trzaskowski

</th>

<th style="text-align:left;">

winner

</th>

<th style="text-align:right;">

total\_population

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

grodziski

</td>

<td style="text-align:left;">

mazowieckie

</td>

<td style="text-align:right;">

0.7584456

</td>

<td style="text-align:right;">

0.4515938

</td>

<td style="text-align:right;">

0.5484062

</td>

<td style="text-align:left;">

Trzaskowski

</td>

<td style="text-align:right;">

95963

</td>

</tr>

<tr>

<td style="text-align:left;">

legionowski

</td>

<td style="text-align:left;">

mazowieckie

</td>

<td style="text-align:right;">

0.7643533

</td>

<td style="text-align:right;">

0.4304098

</td>

<td style="text-align:right;">

0.5695902

</td>

<td style="text-align:left;">

Trzaskowski

</td>

<td style="text-align:right;">

118585

</td>

</tr>

<tr>

<td style="text-align:left;">

otwocki

</td>

<td style="text-align:left;">

mazowieckie

</td>

<td style="text-align:right;">

0.7559179

</td>

<td style="text-align:right;">

0.5423647

</td>

<td style="text-align:right;">

0.4576353

</td>

<td style="text-align:left;">

Duda

</td>

<td style="text-align:right;">

124352

</td>

</tr>

<tr>

<td style="text-align:left;">

piaseczyński

</td>

<td style="text-align:left;">

mazowieckie

</td>

<td style="text-align:right;">

0.7737685

</td>

<td style="text-align:right;">

0.4138000

</td>

<td style="text-align:right;">

0.5862000

</td>

<td style="text-align:left;">

Trzaskowski

</td>

<td style="text-align:right;">

188281

</td>

</tr>

<tr>

<td style="text-align:left;">

pruszkowski

</td>

<td style="text-align:left;">

mazowieckie

</td>

<td style="text-align:right;">

0.7612232

</td>

<td style="text-align:right;">

0.4171934

</td>

<td style="text-align:right;">

0.5828066

</td>

<td style="text-align:left;">

Trzaskowski

</td>

<td style="text-align:right;">

165912

</td>

</tr>

<tr>

<td style="text-align:left;">

warszawski zachodni

</td>

<td style="text-align:left;">

mazowieckie

</td>

<td style="text-align:right;">

0.7598664

</td>

<td style="text-align:right;">

0.4504449

</td>

<td style="text-align:right;">

0.5495551

</td>

<td style="text-align:left;">

Trzaskowski

</td>

<td style="text-align:right;">

118613

</td>

</tr>

<tr>

<td style="text-align:left;">

Warszawa

</td>

<td style="text-align:left;">

mazowieckie

</td>

<td style="text-align:right;">

0.7739616

</td>

<td style="text-align:right;">

0.3234606

</td>

<td style="text-align:right;">

0.6765394

</td>

<td style="text-align:left;">

Trzaskowski

</td>

<td style="text-align:right;">

1790658

</td>

</tr>

<tr>

<td style="text-align:left;">

krapkowicki

</td>

<td style="text-align:left;">

opolskie

</td>

<td style="text-align:right;">

0.5333847

</td>

<td style="text-align:right;">

0.4206069

</td>

<td style="text-align:right;">

0.5793931

</td>

<td style="text-align:left;">

Trzaskowski

</td>

<td style="text-align:right;">

63747

</td>

</tr>

<tr>

<td style="text-align:left;">

strzelecki

</td>

<td style="text-align:left;">

opolskie

</td>

<td style="text-align:right;">

0.5410508

</td>

<td style="text-align:right;">

0.4784992

</td>

<td style="text-align:right;">

0.5215008

</td>

<td style="text-align:left;">

Trzaskowski

</td>

<td style="text-align:right;">

74300

</td>

</tr>

<tr>

<td style="text-align:left;">

pucki

</td>

<td style="text-align:left;">

pomorskie

</td>

<td style="text-align:right;">

0.7837631

</td>

<td style="text-align:right;">

0.3755316

</td>

<td style="text-align:right;">

0.6244684

</td>

<td style="text-align:left;">

Trzaskowski

</td>

<td style="text-align:right;">

86684

</td>

</tr>

<tr>

<td style="text-align:left;">

Gdynia

</td>

<td style="text-align:left;">

pomorskie

</td>

<td style="text-align:right;">

0.7504490

</td>

<td style="text-align:right;">

0.2994169

</td>

<td style="text-align:right;">

0.7005831

</td>

<td style="text-align:left;">

Trzaskowski

</td>

<td style="text-align:right;">

246348

</td>

</tr>

<tr>

<td style="text-align:left;">

Sopot

</td>

<td style="text-align:left;">

pomorskie

</td>

<td style="text-align:right;">

0.7759421

</td>

<td style="text-align:right;">

0.2783662

</td>

<td style="text-align:right;">

0.7216338

</td>

<td style="text-align:left;">

Trzaskowski

</td>

<td style="text-align:right;">

35719

</td>

</tr>

<tr>

<td style="text-align:left;">

poznański

</td>

<td style="text-align:left;">

wielkopolskie

</td>

<td style="text-align:right;">

0.7647535

</td>

<td style="text-align:right;">

0.3249365

</td>

<td style="text-align:right;">

0.6750635

</td>

<td style="text-align:left;">

Trzaskowski

</td>

<td style="text-align:right;">

399272

</td>

</tr>

<tr>

<td style="text-align:left;">

Poznań

</td>

<td style="text-align:left;">

wielkopolskie

</td>

<td style="text-align:right;">

0.7543266

</td>

<td style="text-align:right;">

0.2805668

</td>

<td style="text-align:right;">

0.7194332

</td>

<td style="text-align:left;">

Trzaskowski

</td>

<td style="text-align:right;">

534813

</td>

</tr>

</tbody>

</table>

I selected only those poviats where turnout didn’t exceed 55 pct or
exceeded 75 pct. The opposition’s presidential candidate won almost
everywhere, except one constituency (powiat otwocki). The basic feature
which distinguishes these voivodeships is their geographical location -
they are rather inhabited by the liberal electorate, that’s why
Trzaskowski used to won there basically - this explains the matter of
the limits of the above chart (where I presented relationship between
results of candidates and voter turnout). The matter being investigated
counts 14 of observations. This is equal 4 percent of all observations.

In my opinion, this is an interesting phenomenon worth to notice, while
summing up the relationship between the turnout and the results of
candidates in the election, it can be assessed as very weak or
negligible.

# Voting certificate

Sometimes it happens that election takes place when we are on vacation
or while traveling and if we want to cast our vote outside the place of
check-in where we use to stay regurarly, it is neccesary to get voting
certificate to make possible to vote in other electoral district. This
year it was proceeded with election during holiday season - 12 of July,
thats why there were a lot of people who wanted to vote where they spent
vacation.

<img src="election_2020_supplement_files/figure-gfm/voting certificate how many-1.png" style="display: block; margin: auto;" />

<table class=" lightable-classic" style="font-family: Cambria; width: auto !important; margin-left: auto; margin-right: auto;">

<caption>

Poviats with the highest share of voting certificate votes

</caption>

<thead>

<tr>

<th style="text-align:left;">

Powiat

</th>

<th style="text-align:left;">

Województwo

</th>

<th style="text-align:right;">

country\_reference

</th>

<th style="text-align:right;">

voting\_certificate\_share

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

pucki

</td>

<td style="text-align:left;">

pomorskie

</td>

<td style="text-align:right;">

2.858173

</td>

<td style="text-align:right;">

32.73561

</td>

</tr>

<tr>

<td style="text-align:left;">

leski

</td>

<td style="text-align:left;">

podkarpackie

</td>

<td style="text-align:right;">

2.858173

</td>

<td style="text-align:right;">

28.75042

</td>

</tr>

<tr>

<td style="text-align:left;">

nowodworski

</td>

<td style="text-align:left;">

pomorskie

</td>

<td style="text-align:right;">

2.858173

</td>

<td style="text-align:right;">

28.15185

</td>

</tr>

<tr>

<td style="text-align:left;">

kamieński

</td>

<td style="text-align:left;">

zachodniopomorskie

</td>

<td style="text-align:right;">

2.858173

</td>

<td style="text-align:right;">

27.94287

</td>

</tr>

<tr>

<td style="text-align:left;">

kołobrzeski

</td>

<td style="text-align:left;">

zachodniopomorskie

</td>

<td style="text-align:right;">

2.858173

</td>

<td style="text-align:right;">

26.03057

</td>

</tr>

<tr>

<td style="text-align:left;">

sławieński

</td>

<td style="text-align:left;">

zachodniopomorskie

</td>

<td style="text-align:right;">

2.858173

</td>

<td style="text-align:right;">

25.55523

</td>

</tr>

<tr>

<td style="text-align:left;">

gryficki

</td>

<td style="text-align:left;">

zachodniopomorskie

</td>

<td style="text-align:right;">

2.858173

</td>

<td style="text-align:right;">

25.25121

</td>

</tr>

<tr>

<td style="text-align:left;">

koszaliński

</td>

<td style="text-align:left;">

zachodniopomorskie

</td>

<td style="text-align:right;">

2.858173

</td>

<td style="text-align:right;">

23.01923

</td>

</tr>

<tr>

<td style="text-align:left;">

tatrzański

</td>

<td style="text-align:left;">

małopolskie

</td>

<td style="text-align:right;">

2.858173

</td>

<td style="text-align:right;">

22.86658

</td>

</tr>

<tr>

<td style="text-align:left;">

giżycki

</td>

<td style="text-align:left;">

warmińsko-mazurskie

</td>

<td style="text-align:right;">

2.858173

</td>

<td style="text-align:right;">

18.61500

</td>

</tr>

</tbody>

</table>

First of all it is important to mention that 2 of 3 outstanding provices
are the most attractive holiday destinations (pomorskie and
zachodniopomorskie) are located on the coast of the Baltic sea. In the
third area, there are a lot of lakes and forests - thanks to that it is
possible to inland sailing, hiking and camping.

There,the most votes were cast on the basis of a voting certificate
(Trzaskowski won there), but let’s check if there is a correlation
between the percentage of votes cast on the basis of the voting
certificate and the result of a given candidate, did the tourists favour
one of the candidates?

<img src="election_2020_supplement_files/figure-gfm/voting ceritificate trzaskoski duda-1.png" style="display: block; margin: auto;" />

The relationship, that we assumed in here, seems to be more visible than
related to previous investigated factor - turnout and probably is
exists. Let’s count what is the specific amount of correlation between
share of voting certificate and results of each of candidate (x-axis has
been logarithmed, and it is not linear actually that’s why I use
spearman method for calculation).

<table class=" lightable-classic" style="font-family: Cambria; width: auto !important; margin-left: auto; margin-right: auto;">

<caption>

Correlation

</caption>

<thead>

<tr>

<th style="text-align:left;">

Candidate

</th>

<th style="text-align:right;">

correlation

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

Duda

</td>

<td style="text-align:right;">

\-0.2460481

</td>

</tr>

<tr>

<td style="text-align:left;">

Trzaskowski

</td>

<td style="text-align:right;">

0.2460481

</td>

</tr>

</tbody>

</table>

For sure, correlation is existing in this example, but it is not too
significant - let’s cut and select only thos poviats where share of
voting certificate votes was the highest and then calculate again.

<table class=" lightable-classic" style="font-family: Cambria; width: auto !important; margin-left: auto; margin-right: auto;">

<caption>

Correlation - after cutting

</caption>

<thead>

<tr>

<th style="text-align:left;">

Candidate

</th>

<th style="text-align:right;">

correlation

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

Duda

</td>

<td style="text-align:right;">

\-0.4197998

</td>

</tr>

<tr>

<td style="text-align:left;">

Trzaskowski

</td>

<td style="text-align:right;">

0.4197998

</td>

</tr>

</tbody>

</table>

Once we have eliminated poviats with more regular share of voting
certificate, correlation increased significantly - and now it is
obviously that it exists relationship between share of voting
certificate cast in poviats where those share was higher than usually
and results of each of candidate in the same plances. The share has an
impact as 17.62 percent on the candidate’s score in the poviat.

If we consider this matter based on poviats divided by categories, it is
possible to notice very quickly that in conservative voivodships,
despite the high share of votes cast on the basis of the voting
certificate, the president-in-office won there. Exceptionally, in
mazowieckie Voivodeship, where a lot of votes were cast on the basis of
the voting certificate, especially in Warsaw, a liberal candidate won,
despite the fact that the voivodeship is generally inhabited by a
conservative electorate. NA values have been grey marked.

<img src="election_2020_supplement_files/figure-gfm/heatmap voting certificate-1.png" style="display: block; margin: auto;" />

**Insights**

  - correlation between share of votes cast on basis voting certificate
    seems to be exist - especially in places, where this share was
    higher than usually

  - the opportunity to vote on the basis of the voting certificate was
    usually used by people on vacation as well as students and citizens
    of larger cities who are not checked in there.

# Invalid votes

The invalid vote’s matter has been investigated in main election’s
report, but now we will focus on invalid votes as factor that could have
impact on election results in poviats level.

<img src="election_2020_supplement_files/figure-gfm/invalid votes correlation-1.png" style="display: block; margin: auto;" />

Having only above chart, it is very easy to notice that Duda got more
votes in poviats, where share of invalid votes was higher - opposite
phenomenon is able to catch in case of Trzaskowski’s results in poviats.
So correlation seems to be existed, but not to big, because of no linear
shape. Now, correlation of Spearman method is equal 0.19 and it is
possible to claim that share of invalid votes in poviats has impact of
3.61 percent.

**Insight**

  - It is not very strong correlation, however it exists most likely.

# Population and density

In main report I mentioned that Trzaskowski won in 14 of 15 the biggest
polish cities - it could mean that population of poviats (and every
other consituencies) are correlated with election results there. Let’s
check that hypothesis that Trzaskowski have got higher results in more
inhabited poviats than his opponent - President-in-Office Adnrzej Duda.

<img src="election_2020_supplement_files/figure-gfm/population results-1.png" style="display: block; margin: auto;" />
It is clearly visible that in the population range from 30,000 to
300,000 the amount of poviat inhabitants doesn’t matter for the election
results, but once in constituency are more inhabitants than 300,000,
something interesting occurred, because specific tendency appeard - the
points on the right side are the largest cities where Trzaskowski won,
which I mentioned earlier. However we cannot definitely claim, that
populantion of constituencies has direct impact on election results,
because the most of them don’t indicate any trend. To more investigate,
my proposal is to check density of population.

<img src="election_2020_supplement_files/figure-gfm/density of population-1.png" style="display: block; margin: auto;" />

On the basis of the population density of poviats, it is clearly visible
that in poviats with a lower population density, Duda got more votes,
the higher the population density, the higher the percentage of votes
for Trzaskowski. About density of 500 inhabitants per 1km2, we have
there bigger cities, with advantage of Trzaskowski and more significant
tendency. Cut before we more investigate density matter, I present you
table where both of correlations are compared.

<table class=" lightable-classic" style="font-family: Cambria; width: auto !important; margin-left: auto; margin-right: auto;">

<caption>

Correlation - population vs. density

</caption>

<thead>

<tr>

<th style="text-align:left;">

Candidate

</th>

<th style="text-align:right;">

Population

</th>

<th style="text-align:right;">

Density

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

Duda

</td>

<td style="text-align:right;">

\-0.1826059

</td>

<td style="text-align:right;">

\-0.2683263

</td>

</tr>

<tr>

<td style="text-align:left;">

Trzaskowski

</td>

<td style="text-align:right;">

0.1826059

</td>

<td style="text-align:right;">

0.2683263

</td>

</tr>

</tbody>

</table>

Correlation coefficient is visible higher in case of population density,
what we are able to easy notice having both charts and value of Spearman
coefficient in table, that’s why it is worth to more investigate density
matter. If we consider only poviats with density more than 500/km2 we
will get value 0.21 of Spearman coefficient, it means stronger
relationship. However it is not the end, because very significant could
be fact, that this coefficient is inscreasing if we consider next range
of population density, as below table shows:

<table class=" lightable-classic" style="font-family: Cambria; width: auto !important; margin-left: auto; margin-right: auto;">

<caption>

Cut range - value of correlation of the biggest cities

</caption>

<thead>

<tr>

<th style="text-align:left;">

Category.of.density

</th>

<th style="text-align:right;">

Coefficient.value

</th>

<th style="text-align:right;">

Count

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

\>=1000

</td>

<td style="text-align:right;">

0.2876965

</td>

<td style="text-align:right;">

56

</td>

</tr>

<tr>

<td style="text-align:left;">

\>=2000

</td>

<td style="text-align:right;">

0.3357843

</td>

<td style="text-align:right;">

17

</td>

</tr>

<tr>

<td style="text-align:left;">

\>=3000

</td>

<td style="text-align:right;">

0.5000000

</td>

<td style="text-align:right;">

3

</td>

</tr>

</tbody>

</table>

# Correlation table

<table class=" lightable-classic" style="font-family: Cambria; width: auto !important; margin-left: auto; margin-right: auto;">

<caption>

Correlation between votes for Trzaskowski and Duda and other variables

</caption>

<thead>

<tr>

<th style="text-align:left;">

term

</th>

<th style="text-align:right;">

Trzaskowski

</th>

<th style="text-align:right;">

Duda

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

total\_population

</td>

<td style="text-align:right;">

0.1826059

</td>

<td style="text-align:right;">

\-0.1826059

</td>

</tr>

<tr>

<td style="text-align:left;">

Invalid\_votes

</td>

<td style="text-align:right;">

\-0.1868012

</td>

<td style="text-align:right;">

0.1868012

</td>

</tr>

<tr>

<td style="text-align:left;">

Voting Certificate

</td>

<td style="text-align:right;">

0.2369976

</td>

<td style="text-align:right;">

\-0.2369976

</td>

</tr>

<tr>

<td style="text-align:left;">

Turnout

</td>

<td style="text-align:right;">

0.0177260

</td>

<td style="text-align:right;">

\-0.0177260

</td>

</tr>

<tr>

<td style="text-align:left;">

density

</td>

<td style="text-align:right;">

0.2680906

</td>

<td style="text-align:right;">

\-0.2680906

</td>

</tr>

</tbody>

</table>

**Insights**

The most correlated variables with election results are: \* population
density \* share of votes cast on basis of voting certificate \* share
of invalid votes

Below I present correlation matrix to check if other not obviously
relationship exists (not connected with results)

<img src="election_2020_supplement_files/figure-gfm/corrplot matrix-1.png" style="display: block; margin: auto;" />

**Other possible relatioships**

  - population density and share of votes cast on basis of voting
    ceri=tificate

  - density and turnout

  - invalid votes and turnout (very likely, because of the more votes
    cast, the greater the probability that there will be a greater
    percentage of invalid votes)

# Cities

In general report I did basic analysis on election results in 15 the
most inhabited cities in Poland and who on there. Then, the most
important insight was that liberal candidate (Trzaskowski) won in 14 of
15 cities what shows unequivocal tendency. But now I consider the same
matter but more expand and carefully having all of cities (not only 15
the largest) and adding discrete variable - I grouped all of cities by
scopes based on amount of inhabitants.

<img src="election_2020_supplement_files/figure-gfm/cities heatmap-1.png" style="display: block; margin: auto;" />

Trzaskowski didn’t win in every city, a significant difference in votes
is visible only in really large cities, with more than 100,000
inhabitants, there Duda got much less votes than his opponent. In small,
regular and even large cities to 100,000 difference is impossible to
notice any advantage and and there was no dominant candidate.

# Population of poviats and support for candidates

As I have mentioned, presented and calculated before, it exists pretty
significant correlation between population / density of poviats and
results occurred there. Now, I divided all of constituencies by discrete
variable based on population and compile with voivodeships where they
are located. NA values have been grey marked.

<img src="election_2020_supplement_files/figure-gfm/heatmap population and results-1.png" style="display: block; margin: auto;" />

In the most inhabited poviats, Trzaskowski got much higher advantage
counting in percentage share of votes cast there. However, even in the
most liberal provinces like dolnośląskie, opolskie or lubuskie the
support for Trzaskowski is clearer the more inhabited the electoral
district. In conservative voivodeships, where Duda used to get the
highest share of votes, the population of the constituencies doen’t seem
to matter, because as the amount of inhabitants increases, it doesn’t
gain or lose

**Insights**

  - population of electoral districts is important and it has direct
    impact, who has won there

  - results depends on region of Poland

There is no specific indicator to show that, however having chart as
above, we can extract some insight independly of any measure.
