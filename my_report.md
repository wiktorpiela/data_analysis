---
```{r, include=FALSE]
knitr::opts_chunk$set(
  warning = FALSE,
  error = FALSE,
  message = FALSE,
  fig.align = "center",
  out.width = "70%",
  fig.width = 6,
  fig.asp = 0.618)
library("tidyverse")
library("lubridate")
library("ggplot2")
library("skimr")
library("descr")
library("scales")
library("viridis")
library("ggthemr")
library("mosaic")
library("knitr")
library("kableExtra")
ggthemr("fresh")
```

---


## Data importing and preparing

This dataset contains information about the applications included in google play store between 2010 and 2018. The analysis purpose to explore the content of the collection in order to find interesting relationships between variables and present the more or less prepared information in graphs.

First task that we need to complete is import data into R environment and clear the data where it is necessary. Have a look at below action:

I use glimpse function to check how this dataset looks like in general: columns, datatypes, first variables and dimensions of tibble and of course if any error occurred. I am checking and judging on which variables will be useful for analysis, which I can remove, which I need to change.


```r
play <- read_csv("data/googleplaystore.csv")

glimpse(play)
```

```
## Rows: 10,841
## Columns: 13
## $ App              <chr> "Photo Editor & Candy Camera & Grid & ScrapBook", ...
## $ Category         <chr> "ART_AND_DESIGN", "ART_AND_DESIGN", "ART_AND_DESIG...
## $ Rating           <dbl> 4.1, 3.9, 4.7, 4.5, 4.3, 4.4, 3.8, 4.1, 4.4, 4.7, ...
## $ Reviews          <dbl> 159, 967, 87510, 215644, 967, 167, 178, 36815, 137...
## $ Size             <chr> "19M", "14M", "8.7M", "25M", "2.8M", "5.6M", "19M"...
## $ Installs         <chr> "10,000+", "500,000+", "5,000,000+", "50,000,000+"...
## $ Type             <chr> "Free", "Free", "Free", "Free", "Free", "Free", "F...
## $ Price            <chr> "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", ...
## $ `Content Rating` <chr> "Everyone", "Everyone", "Everyone", "Teen", "Every...
## $ Genres           <chr> "Art & Design", "Art & Design;Pretend Play", "Art ...
## $ `Last Updated`   <chr> "January 7, 2018", "January 15, 2018", "August 1, ...
## $ `Current Ver`    <chr> "1.0.0", "2.0.0", "1.2.4", "Varies with device", "...
## $ `Android Ver`    <chr> "4.0.3 and up", "4.0.3 and up", "4.0.3 and up", "4...
```

First thing that I want to change is removal dollar sign $ from column Price to make possible change datatype of this variable from character to double. And second action - using *lubridate* package - I change datatype of Last Updated from character to date, because later I am going to work on this variable as date a lot of times.


```
## # A tibble: 93 x 3
##    Price     n count
##    <chr> <int> <int>
##  1 $0.99   148 10841
##  2 $1.00     3 10841
##  3 $1.04     1 10841
##  4 $1.20     1 10841
##  5 $1.26     1 10841
##  6 $1.29     1 10841
##  7 $1.49    46 10841
##  8 $1.50     1 10841
##  9 $1.59     1 10841
## 10 $1.61     1 10841
## # ... with 83 more rows
```

```r
play <- play %>% 
  mutate(Price = as.numeric(str_remove(Price, "[$]"))) %>%  #also str_replace_all()
  replace_na(list(Price = 0)) %>% #Everynone -> NA -> 0
  mutate(`Last Updated` = mdy(`Last Updated`))
```

Now, as you can see, column Size contains also character variables, but I would expect here numeric datatype - that's why first of all I have to distinguish kb from Mb, remove some characters  to switch to a common unit - I have chosen Mb. In this step I lost some of data, because some of variables have "Varies with device" instead of specific values.


```
## # A tibble: 462 x 3
##    Size       n count
##    <chr>  <int> <int>
##  1 1,000+     1 10841
##  2 1.0M       7 10841
##  3 1.1M      32 10841
##  4 1.2M      41 10841
##  5 1.3M      35 10841
##  6 1.4M      37 10841
##  7 1.5M      48 10841
##  8 1.6M      39 10841
##  9 1.7M      40 10841
## 10 1.8M      50 10841
## # ... with 452 more rows
```

```r
play <- play %>% 
  mutate(kb = ifelse(str_detect(Size, "k"), Size, 0),
         Mb = ifelse(str_detect(Size, "M"), Size, 0)) %>% 
  mutate(kb = as.numeric(str_remove(kb, "k")),
         Mb = as.numeric(str_remove(Mb, "M"))) %>% 
  mutate(kb = kb / 1024,
         actual_size = kb + Mb) #Varies with device -> 0
```

```
## # A tibble: 460 x 3
##    actual_size     n count
##          <dbl> <int> <int>
##  1     0        1696 10841
##  2     0.00830     1 10841
##  3     0.0107      1 10841
##  4     0.0137      1 10841
##  5     0.0166      2 10841
##  6     0.0176      2 10841
##  7     0.0195      1 10841
##  8     0.0225      1 10841
##  9     0.0234      1 10841
## 10     0.0244      1 10841
## # ... with 450 more rows
```

Column Content Rating includes target groups of given apps. here I modified the data labels and standardize them in following way and at the same time I renamed the column label.


```
## # A tibble: 7 x 3
##   `Content Rating`     n count
##   <chr>            <int> <int>
## 1 Adults only 18+      3 10841
## 2 Everyone          8714 10841
## 3 Everyone 10+       414 10841
## 4 Mature 17+         499 10841
## 5 Teen              1208 10841
## 6 Unrated              2 10841
## 7 <NA>                 1 10841
```

```r
play <- play %>% 
  rename("Group" = `Content Rating`) %>% 
  mutate(Group = fct_collapse(Group,
                              Adults = c("Adults only 18+", "Mature 17+"),
                              Teen = c("Teen", "Everyone 10+"),
                              Everyone = c("Everyone","Unrated")))
```

```
## # A tibble: 4 x 3
##   Group        n count
##   <fct>    <int> <int>
## 1 Adults     502 10841
## 2 Everyone  8716 10841
## 3 Teen      1622 10841
## 4 <NA>         1 10841
```

From Installs variable I need to delete characters like plus and comma signs
to make possible change default datatype to numeric. Removal of comma sign was especially harder, because of it is special character in R environment. 


```
## # A tibble: 22 x 3
##    Installs           n count
##    <chr>          <int> <int>
##  1 0                  1 10841
##  2 0+                14 10841
##  3 1,000,000,000+    58 10841
##  4 1,000,000+      1579 10841
##  5 1,000+           907 10841
##  6 1+                67 10841
##  7 10,000,000+     1252 10841
##  8 10,000+         1054 10841
##  9 10+              386 10841
## 10 100,000,000+     409 10841
## # ... with 12 more rows
```

```r
play <- play %>% 
  mutate(Installs = str_remove(Installs, "[+]"),
         Installs = as.numeric(str_remove(Installs, "[/,]")))
```

The last step that I would like to do preparing tibble content for further analysis is organizing the columns and finally removing useless ones. And of course preventative I converted datatypes of remaining character variables into factors.


```r
play <- play %>% 
  select(App, Category, Rating, Reviews, Installs, Type, Price,
         Group, `Last Updated`, actual_size) %>% 
  mutate(Category = as.factor(Category),
         Type = as.factor(Type),
         Group = as.factor(Group))
```

```
## Rows: 10,841
## Columns: 10
## $ App            <chr> "Photo Editor & Candy Camera & Grid & ScrapBook", "C...
## $ Category       <fct> ART_AND_DESIGN, ART_AND_DESIGN, ART_AND_DESIGN, ART_...
## $ Rating         <dbl> 4.1, 3.9, 4.7, 4.5, 4.3, 4.4, 3.8, 4.1, 4.4, 4.7, 4....
## $ Reviews        <dbl> 159, 967, 87510, 215644, 967, 167, 178, 36815, 13791...
## $ Installs       <dbl> 1e+04, 5e+05, NA, NA, 1e+05, 5e+04, 5e+04, NA, NA, 1...
## $ Type           <fct> Free, Free, Free, Free, Free, Free, Free, Free, Free...
## $ Price          <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
## $ Group          <fct> Everyone, Everyone, Everyone, Teen, Everyone, Everyo...
## $ `Last Updated` <date> 2018-01-07, 2018-01-15, 2018-08-01, 2018-06-08, 201...
## $ actual_size    <dbl> 19.0, 14.0, 8.7, 25.0, 2.8, 5.6, 19.0, 29.0, 33.0, 3...
```

## Basic information extracting

The first thing that came to my mind thinking about dataset of google play content is how many paid and free apps we have, let's see that. Below pie chart presents that clear. 

<img src="my_report_files/figure-html/pie_chart paid vs free apps-1.png" width="70%" style="display: block; margin: auto;" />
<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>Data labels</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Type </th>
   <th style="text-align:right;"> n </th>
   <th style="text-align:right;"> share </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Free </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 10039 </td>
   <td style="text-align:right;background-color: grey !important;"> 92.619245 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Paid </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 800 </td>
   <td style="text-align:right;background-color: grey !important;"> 7.380755 </td>
  </tr>
</tbody>
</table>

Paid apps are about 7.4% - it is less than we likely expected, but in my opinion enough amount to compare paid and free apps later through other variables.

Later, I would like to present how it looks like through time range 2010-2018. Paid apps have been registered only since 2011. Please be aware that y axis was presented using logarithmic scale. There wasn't such a moment in the entire period under study so that the number of paid apps was greater than the free ones, the difference is large and is constantly growing, especially visible since 2014. However, both types still keep increasing in absolute amount.
<img src="my_report_files/figure-html/smooth_plot_range_time-1.png" width="70%" style="display: block; margin: auto;" />
Although on above plot we saw increasing amount of both paid and free ones, proportionally it looks preety different. Here is visible decreasing of paid apps (showing proportionally). Visibly, after 2014 paid ones have been losing successive on apps market. Likely, it is due to increasing competition from free apps side, free equivalent, etc. 
<img src="my_report_files/figure-html/proportionally-1.png" width="70%" style="display: block; margin: auto;" />
Another interesting information that we are able to extract from given dataset is week day of update release. There is visible relationship here - between week day and update release - in vain to expect any updates during the weekend.
<img src="my_report_files/figure-html/week day and release-1.png" width="70%" style="display: block; margin: auto;" />
And data labels for above:
<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>Week days and last update - data labels</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> weekday </th>
   <th style="text-align:right;"> n </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> czwartek </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 1981 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> niedziela </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 656 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> piątek </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 1819 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> poniedziałek </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 1784 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> sobota </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 747 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> środa </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 1941 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> wtorek </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 1912 </td>
  </tr>
</tbody>
</table>
Having precisely counted, how many updates were released on a given day of the week, let's consider the probability that a randomly selected application was last updated on freely chosen day of the week.
<img src="my_report_files/figure-html/probability weekday occurs-1.png" width="70%" style="display: block; margin: auto;" /><table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>Weekday occurs probability - data labels</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> weekday </th>
   <th style="text-align:right;"> n </th>
   <th style="text-align:right;"> probability </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> czwartek </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 1981 </td>
   <td style="text-align:right;background-color: grey !important;"> 18.274908 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> środa </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 1941 </td>
   <td style="text-align:right;background-color: grey !important;"> 17.905904 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> wtorek </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 1912 </td>
   <td style="text-align:right;background-color: grey !important;"> 17.638376 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> piątek </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 1819 </td>
   <td style="text-align:right;background-color: grey !important;"> 16.780443 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> poniedziałek </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 1784 </td>
   <td style="text-align:right;background-color: grey !important;"> 16.457565 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> sobota </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 747 </td>
   <td style="text-align:right;background-color: grey !important;"> 6.891144 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> niedziela </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 656 </td>
   <td style="text-align:right;background-color: grey !important;"> 6.051660 </td>
  </tr>
</tbody>
</table>
But how would it look like if we only choose the most popular day for the updates (Thursday) and the least popular one (Sunday)? Have a look at distribution of probability:
<img src="my_report_files/figure-html/probability Thursday vs Sunday-1.png" width="70%" style="display: block; margin: auto;" />
Once we throw off other days, the probability that randomly chosen apps was updated on Thursday is more than 3/4, at the same time this is only less than 1/4 related to Sunday.

## Target groups analysis

As you remember, at the beginning, I standardized the names of target groups od applications and I corrected data labels which are untidy before. I did it because in this part I would like to present that and general and try to find any interesting relationship.

First of all let's see, how much target groups we have and how does the distribution look like. As expected, the most apps are dedicated for everyone, without age division. Next in order target groups are teens and then adults, who are also quite a large percentage compared to the general.
<img src="my_report_files/figure-html/target groups pie chart and data labels-1.png" width="70%" style="display: block; margin: auto;" /><table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>Target groups counting - data labels</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Group </th>
   <th style="text-align:right;"> n </th>
   <th style="text-align:right;"> percent </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Adults </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 502 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.630996 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Everyone </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 8716 </td>
   <td style="text-align:right;background-color: grey !important;"> 80.405904 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Teen </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 1622 </td>
   <td style="text-align:right;background-color: grey !important;"> 14.963100 </td>
  </tr>
</tbody>
</table>
At this stage, the natural question that we could ask is - what categories of the apps each groups prefer the most. This is an important question not only from an economic point of view and of course every young and ambitious developer of mobile apps might ask. Let's try to explore the set, count and answer the question. I selected 3 most popular category for each group - (proportions inside group, not in general).

*Assumptions*:

* for current analysis I took only 3 the most representative categories of apps for each groups

* on the charts I presented only those categories which have more than 10% share inside given group

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>Popular categories by target groups</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Group </th>
   <th style="text-align:left;"> Category </th>
   <th style="text-align:right;"> n </th>
   <th style="text-align:right;"> prop </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Adults </td>
   <td style="text-align:left;width: 6em; background-color: grey !important;"> DATING </td>
   <td style="text-align:right;background-color: grey !important;"> 201 </td>
   <td style="text-align:right;background-color: grey !important;"> 40.039841 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Adults </td>
   <td style="text-align:left;width: 6em; background-color: grey !important;"> GAME </td>
   <td style="text-align:right;background-color: grey !important;"> 74 </td>
   <td style="text-align:right;background-color: grey !important;"> 14.741036 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Adults </td>
   <td style="text-align:left;width: 6em; background-color: grey !important;"> SOCIAL </td>
   <td style="text-align:right;background-color: grey !important;"> 67 </td>
   <td style="text-align:right;background-color: grey !important;"> 13.346614 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Everyone </td>
   <td style="text-align:left;width: 6em; background-color: grey !important;"> FAMILY </td>
   <td style="text-align:right;background-color: grey !important;"> 1530 </td>
   <td style="text-align:right;background-color: grey !important;"> 17.553924 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Everyone </td>
   <td style="text-align:left;width: 6em; background-color: grey !important;"> TOOLS </td>
   <td style="text-align:right;background-color: grey !important;"> 836 </td>
   <td style="text-align:right;background-color: grey !important;"> 9.591556 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Everyone </td>
   <td style="text-align:left;width: 6em; background-color: grey !important;"> GAME </td>
   <td style="text-align:right;background-color: grey !important;"> 608 </td>
   <td style="text-align:right;background-color: grey !important;"> 6.975677 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Teen </td>
   <td style="text-align:left;width: 6em; background-color: grey !important;"> GAME </td>
   <td style="text-align:right;background-color: grey !important;"> 462 </td>
   <td style="text-align:right;background-color: grey !important;"> 28.483354 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Teen </td>
   <td style="text-align:left;width: 6em; background-color: grey !important;"> FAMILY </td>
   <td style="text-align:right;background-color: grey !important;"> 392 </td>
   <td style="text-align:right;background-color: grey !important;"> 24.167694 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Teen </td>
   <td style="text-align:left;width: 6em; background-color: grey !important;"> SOCIAL </td>
   <td style="text-align:right;background-color: grey !important;"> 127 </td>
   <td style="text-align:right;background-color: grey !important;"> 7.829840 </td>
  </tr>
</tbody>
</table>
Let's put the data on the charts for adults group:
<img src="my_report_files/figure-html/chart adults category-1.png" width="70%" style="display: block; margin: auto;" />
*Significant insights*:

* group of adult users is dominated by only one category - dating apps make up 40% of all available categories dedicated for adults customers. Thanks to dating apps domination, adults are the least diversified of given group. The same or at least similar share doesn't exist in case of none of next clusters. Every remaining categories of apps (where none achieves more than 10% of general amount in group) it is only 32 percent. So, if some developers are looking for idea for apps for adult clients, the biggest oportunity to success would be if they start create dating, game or social networking apps

For teens:
<img src="my_report_files/figure-html/chart teens category-1.png" width="70%" style="display: block; margin: auto;" />

*Significant insights*:

* the group of teen customers is more diversified than previous one - here we have only two categories that have more than 10% share - those are games and family apps (both with similar share). In sum, they have somewhat bigger share than 50%

And for everyone:
<img src="my_report_files/figure-html/chart everyone category-1.png" width="70%" style="display: block; margin: auto;" />
*Significant insights*:

* only one  kind of apps as a dominator- family apps in this case and aggregate category (82,4%) of other are doing group of everyone the most diversified if we compare with previous ones
 
It is existing one more variable that would be interesting among target groups which are being analyzing, namely before mentioned types of apps - paid and free one. I excluded Everyone group right here, because it is incomparably more numerous as first pie chart indicated on current chapter. 
<img src="my_report_files/figure-html/type of apps inside groups-1.png" width="70%" style="display: block; margin: auto;" /><table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>Popular categories by target groups</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Type </th>
   <th style="text-align:left;"> Group </th>
   <th style="text-align:right;"> n </th>
   <th style="text-align:right;"> prop </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Free </td>
   <td style="text-align:left;width: 6em; background-color: grey !important;"> Adults </td>
   <td style="text-align:right;background-color: grey !important;"> 372 </td>
   <td style="text-align:right;background-color: grey !important;"> 23.16314 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Free </td>
   <td style="text-align:left;width: 6em; background-color: grey !important;"> Teen </td>
   <td style="text-align:right;background-color: grey !important;"> 1234 </td>
   <td style="text-align:right;background-color: grey !important;"> 76.83686 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Paid </td>
   <td style="text-align:left;width: 6em; background-color: grey !important;"> Adults </td>
   <td style="text-align:right;background-color: grey !important;"> 10 </td>
   <td style="text-align:right;background-color: grey !important;"> 14.92537 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Paid </td>
   <td style="text-align:left;width: 6em; background-color: grey !important;"> Teen </td>
   <td style="text-align:right;background-color: grey !important;"> 57 </td>
   <td style="text-align:right;background-color: grey !important;"> 85.07463 </td>
  </tr>
</tbody>
</table>
**Insights**

* more than every eighth paid application belongs to teen group

* likely, it is because of game apps what is the most popular category among this cluster of clients, are paid or includes in-app purchase

* nonetheless, proportions in case of both types are very similar and comparable

That's why I present below chart- it shows the same case but on the contrary, there we can find the information how many paid or free apps are inside each of target group. Don't paying attention on scale, because it is logarithmic, we can see that among teen is more paid apps than in case of adults.
<img src="my_report_files/figure-html/on the contrary-1.png" width="70%" style="display: block; margin: auto;" />
To finally judge where is more paid app, for adults or teens, let me present below chart.
<img src="my_report_files/figure-html/only paid apps-1.png" width="70%" style="display: block; margin: auto;" />
If we consider only adult and teen groups and only paid apps, there is probability of about 85% that randomly selected apps will be dedicated for teens.

## Categories analysis
At this moment it is worth to ask what category is the most numerous, included division by paid and free one as it was mentioned before. I assumed that representative will be two of the most popular categories by each type - curiously, for both type the best known are exactly the same kind of categories.
<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>Categories counting by types</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Type </th>
   <th style="text-align:left;"> Category </th>
   <th style="text-align:right;"> n </th>
   <th style="text-align:right;"> prop </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Free </td>
   <td style="text-align:left;width: 6em; background-color: grey !important;"> FAMILY </td>
   <td style="text-align:right;background-color: grey !important;"> 1119 </td>
   <td style="text-align:right;background-color: grey !important;"> 16.82201 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Free </td>
   <td style="text-align:left;width: 6em; background-color: grey !important;"> GAME </td>
   <td style="text-align:right;background-color: grey !important;"> 940 </td>
   <td style="text-align:right;background-color: grey !important;"> 14.13109 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Paid </td>
   <td style="text-align:left;width: 6em; background-color: grey !important;"> FAMILY </td>
   <td style="text-align:right;background-color: grey !important;"> 96 </td>
   <td style="text-align:right;background-color: grey !important;"> 28.65672 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Paid </td>
   <td style="text-align:left;width: 6em; background-color: grey !important;"> GAME </td>
   <td style="text-align:right;background-color: grey !important;"> 52 </td>
   <td style="text-align:right;background-color: grey !important;"> 15.52239 </td>
  </tr>
</tbody>
</table>

<img src="my_report_files/figure-html/categories paid and free-1.png" width="70%" style="display: block; margin: auto;" />
But above data has been aggregated and chart takes all of the information from time range 2010-2018 in sum. Let's have a look at time range on the example the most popular categories.
<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>Categories selection</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Type </th>
   <th style="text-align:left;"> Category </th>
   <th style="text-align:right;"> n </th>
   <th style="text-align:right;"> prop </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Free </td>
   <td style="text-align:left;width: 6em; background-color: grey !important;"> FAMILY </td>
   <td style="text-align:right;background-color: grey !important;"> 1780 </td>
   <td style="text-align:right;background-color: grey !important;"> 17.730850 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Free </td>
   <td style="text-align:left;width: 6em; background-color: grey !important;"> GAME </td>
   <td style="text-align:right;background-color: grey !important;"> 1061 </td>
   <td style="text-align:right;background-color: grey !important;"> 10.568782 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Free </td>
   <td style="text-align:left;width: 6em; background-color: grey !important;"> TOOLS </td>
   <td style="text-align:right;background-color: grey !important;"> 765 </td>
   <td style="text-align:right;background-color: grey !important;"> 7.620281 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Paid </td>
   <td style="text-align:left;width: 6em; background-color: grey !important;"> FAMILY </td>
   <td style="text-align:right;background-color: grey !important;"> 191 </td>
   <td style="text-align:right;background-color: grey !important;"> 23.875000 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Paid </td>
   <td style="text-align:left;width: 6em; background-color: grey !important;"> MEDICAL </td>
   <td style="text-align:right;background-color: grey !important;"> 109 </td>
   <td style="text-align:right;background-color: grey !important;"> 13.625000 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Paid </td>
   <td style="text-align:left;width: 6em; background-color: grey !important;"> GAME </td>
   <td style="text-align:right;background-color: grey !important;"> 83 </td>
   <td style="text-align:right;background-color: grey !important;"> 10.375000 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Paid </td>
   <td style="text-align:left;width: 6em; background-color: grey !important;"> PERSONALIZATION </td>
   <td style="text-align:right;background-color: grey !important;"> 83 </td>
   <td style="text-align:right;background-color: grey !important;"> 10.375000 </td>
  </tr>
</tbody>
</table>
So, as table indicated, I need to choose given categories for each types separately (because there are a bit different), in addition, for type paid 4 categories are to be selected because both games and personalization files have the same share inside paid type.
<img src="my_report_files/figure-html/free apps time range-1.png" width="70%" style="display: block; margin: auto;" /><img src="my_report_files/figure-html/free apps time range-2.png" width="70%" style="display: block; margin: auto;" />
**Insights**

* although in case of both types the amount of apps given categories increases regularly year by year, dynamic of growth is quite different - have a look at paid apps and y axis - growth is smaller

* free apps growth is almost linearly, in case of paid apps more visible fluctuations than related to free ones (especially games and medical apps)

* family apps have the longest history, they are registered since 2010

* this chart gives us additional information, namely which category of app is more numerous as of specific time

* free apps growth is uniform (differences between amount of categories are not to big, what we can see in case of paid ones - difference of quantity family or game apps and medial and personalization seems to be significant)

## Pricing

Initial assumption - for analysis related to pricing I took only paid apps and  having more than 200 reviews. Thanks that I investigate inside set of the common apps and well-known. The limit over 200 reviews means that apps go through common circulation in google play and it represents opinion of the users. I have also noticed that skewness of price distribution seems to be pretty strong, that's why I use median instead of average measurement for price to show actual situation.


Whether does price of app depend on the target group?
<img src="my_report_files/figure-html/density pricing groups-1.png" width="70%" style="display: block; margin: auto;" />
Density plot shows that the most expensive apps belong to Everyone group, about 150 USD and more, but between 10USD and 100USD, adult's apps dominate in this range of price. We can see also that Everyone group is the most diversified regarding to price than other ones. The set of Everyone seems to be the cheapest group, but there are also protruding items (more than 100USD).  

Box plot will show that in details.
<img src="my_report_files/figure-html/boxplot pricing groups-1.png" width="70%" style="display: block; margin: auto;" /><table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>Data labels - which group has the most expensive apps?</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Group </th>
   <th style="text-align:right;"> median_Price </th>
   <th style="text-align:right;"> max_Price </th>
   <th style="text-align:right;"> count </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Adults </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 4.49 </td>
   <td style="text-align:right;background-color: grey !important;"> 11.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 10 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Everyone </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 2.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 400.00 </td>
   <td style="text-align:right;background-color: grey !important;"> 268 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Teen </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 3.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 19.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 57 </td>
  </tr>
</tbody>
</table>
It confirms the initial insight which are coming from density plot interpretation. Among set of the common apps the most expensive are adults with median price 4.49, later teen apps - median 3.99 and at the end Everyone with median price 2.99 - even though for that category belongs expensive apps, but they aren't so much numerous. 

Ultimate conclusion can be distorted by the sample strength - Everyone's app is too much comparing with other groups. Let's have a look at only two smaller ones and judge definitely which group have more expensive apps dedicated.  
<img src="my_report_files/figure-html/adults vs teens plotting-1.png" width="70%" style="display: block; margin: auto;" /><img src="my_report_files/figure-html/adults vs teens plotting-2.png" width="70%" style="display: block; margin: auto;" /><table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>Adults vs Teens - pricing</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Group </th>
   <th style="text-align:right;"> median_Price </th>
   <th style="text-align:right;"> max_Price </th>
   <th style="text-align:right;"> count </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Adults </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 4.49 </td>
   <td style="text-align:right;background-color: grey !important;"> 11.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 10 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Teen </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 3.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 19.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 57 </td>
  </tr>
</tbody>
</table>
General insights didn't change but now we are able to see distribution clear and get additional info that we haven't noticed before. Admittedly adults has higher median price than Teen's group, but the second one has higher maximum price.

*Which target group has the most expensive apps dedicated?*

1. Adults
2. Teens
3. Everyone (general group)

**Which category of paid apps is the most expensive?**
Below I present table including basic information related to relationship between popular categories and their pricing.
<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>Popular categories and their price</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Category </th>
   <th style="text-align:right;"> median_price </th>
   <th style="text-align:right;"> max_price </th>
   <th style="text-align:right;"> min_price </th>
   <th style="text-align:right;"> count </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> FAMILY </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 2.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 399.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 0.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 96 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> GAME </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 2.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 17.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 0.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 52 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> MEDICAL </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 5.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 33.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 0.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 30 </td>
  </tr>
</tbody>
</table>
Putting the information on the charts to visualize
<img src="my_report_files/figure-html/price vs category, plots-1.png" width="70%" style="display: block; margin: auto;" /><img src="my_report_files/figure-html/price vs category, plots-2.png" width="70%" style="display: block; margin: auto;" />
The most expensive items, that we were able to notice before, belong to category of family, however medical apps characterize the highest median of price. Family and games has the same price median value of price, but we cannot say that both categories has similarly price distribution - games are visibly cheaper because of 1st quartile of price. Other statistical indicator I present on below table.
<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>Statistical summary of price matter</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Category </th>
   <th style="text-align:right;"> min </th>
   <th style="text-align:right;"> Q1 </th>
   <th style="text-align:right;"> median </th>
   <th style="text-align:right;"> Q3 </th>
   <th style="text-align:right;"> max </th>
   <th style="text-align:right;"> mean </th>
   <th style="text-align:right;"> sd </th>
   <th style="text-align:right;"> n </th>
   <th style="text-align:right;"> missing </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> FAMILY </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 0.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 2.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 2.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 399.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 16.699271 </td>
   <td style="text-align:right;background-color: grey !important;"> 68.696162 </td>
   <td style="text-align:right;background-color: grey !important;"> 96 </td>
   <td style="text-align:right;background-color: grey !important;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> GAME </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 0.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 1.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 2.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 17.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.134231 </td>
   <td style="text-align:right;background-color: grey !important;"> 3.375716 </td>
   <td style="text-align:right;background-color: grey !important;"> 52 </td>
   <td style="text-align:right;background-color: grey !important;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> MEDICAL </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 0.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 3.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 5.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 9.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 33.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 9.490667 </td>
   <td style="text-align:right;background-color: grey !important;"> 9.347654 </td>
   <td style="text-align:right;background-color: grey !important;"> 30 </td>
   <td style="text-align:right;background-color: grey !important;"> 0 </td>
  </tr>
</tbody>
</table>

**How has been price run between 2010 and 2018?**
<img src="my_report_files/figure-html/price in time range-1.png" width="70%" style="display: block; margin: auto;" />
The price value depends on proportion between free apps and paid ones on the market, free equivalents and finally on customers awareness. With time run, competition on the market from free applications increases, so before 2018 the price drops significantly. The sudden increase and peak in prices is due to several very expensive applications mentioned above.

Price tendency on time range having (customers included)
<img src="my_report_files/figure-html/time range price adults vs teens-1.png" width="70%" style="display: block; margin: auto;" />
As I indicated on the on of above charts, apps dedicated for adults was basically more expensive than for teens, but on this time range we can see that it wasn't always like that - for example between late 2014 and half of 2016, apps for teens were more expensive. Notice that apps for the youngest customers have been registered in dataset since 2013 and for adults just one year later. At the edn of period being investigated adult's price decreases strongly, but for teens growth slowly. This tendency shows that later teens apps could be more expensive again, like in the past 2014-2016.

**Price in the time range and popular categories**
<img src="my_report_files/figure-html/price categroies time range-1.png" width="70%" style="display: block; margin: auto;" />
It is clearly visible that the price of medical applications has been increased strongly - likely, due to the growing popularity of this category, more people pay attention on their health and it is common that they want to help yourself to take care using mobile apps. While the prices of games was dropping quite suddenly - many games are offered for free and even the paid versions are becoming more common. 

Below I show you general table related to price matter - there you are able to find yearly median price of each category and how old is given category as well - if somewhere *NA* symbol exists, this category hasn't been registered in dataset then.
<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>Price general table</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Category </th>
   <th style="text-align:right;"> 2012 </th>
   <th style="text-align:right;"> 2013 </th>
   <th style="text-align:right;"> 2014 </th>
   <th style="text-align:right;"> 2015 </th>
   <th style="text-align:right;"> 2016 </th>
   <th style="text-align:right;"> 2017 </th>
   <th style="text-align:right;"> 2018 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> MEDICAL </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 2.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 3.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 6.49 </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> 5.49 </td>
   <td style="text-align:right;background-color: grey !important;"> 7.99 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> FAMILY </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> 2.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 2.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 2.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 2.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 2.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 3.99 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> PERSONALIZATION </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> 1.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 1.49 </td>
   <td style="text-align:right;background-color: grey !important;"> 0.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 2.24 </td>
   <td style="text-align:right;background-color: grey !important;"> 2.49 </td>
   <td style="text-align:right;background-color: grey !important;"> 1.49 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> TOOLS </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> 4.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 1.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 1.97 </td>
   <td style="text-align:right;background-color: grey !important;"> 3.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 2.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 2.99 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> COMMUNICATION </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> 2.74 </td>
   <td style="text-align:right;background-color: grey !important;"> 0.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.99 </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> 2.99 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> GAME </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> 2.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 5.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 2.49 </td>
   <td style="text-align:right;background-color: grey !important;"> 2.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 2.99 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> PHOTOGRAPHY </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> 2.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 1.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 3.95 </td>
   <td style="text-align:right;background-color: grey !important;"> 5.99 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> PRODUCTIVITY </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> 1.99 </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> 3.99 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> HEALTH_AND_FITNESS </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> 2.99 </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> 1.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 2.99 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> BUSINESS </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> 2.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.99 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> SPORTS </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> 1.49 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.49 </td>
   <td style="text-align:right;background-color: grey !important;"> 2.49 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> FINANCE </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> 399.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 10.99 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> LIFESTYLE </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> 0.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 6.99 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> SOCIAL </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> 0.99 </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> VIDEO_PLAYERS </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> 1.49 </td>
   <td style="text-align:right;background-color: grey !important;"> 3.99 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> WEATHER </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> 5.99 </td>
   <td style="text-align:right;background-color: grey !important;"> 3.49 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> ART_AND_DESIGN </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> 1.99 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> AUTO_AND_VEHICLES </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> 1.99 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> BOOKS_AND_REFERENCE </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> 4.49 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> DATING </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> 3.99 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> EDUCATION </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> 3.99 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> ENTERTAINMENT </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> 3.99 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> FOOD_AND_DRINK </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> 4.24 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> MAPS_AND_NAVIGATION </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> 2.99 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> PARENTING </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> 4.99 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> SHOPPING </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> 2.99 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> TRAVEL_AND_LOCAL </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> NA </td>
   <td style="text-align:right;background-color: grey !important;"> 3.49 </td>
  </tr>
</tbody>
</table>

## Rating

**Do paid applications are  better rated than free ones?**
Assumption - I don't consider apps having less than 200 reviews and those with no data or wrong data in rating column included. I use median as statistical measure, because of skewness of rating distribution - the same reason as in case of price.
<img src="my_report_files/figure-html/paid vs free - rating-1.png" width="70%" style="display: block; margin: auto;" /><img src="my_report_files/figure-html/paid vs free - rating-2.png" width="70%" style="display: block; margin: auto;" /><table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>Counting items and data labels</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Type </th>
   <th style="text-align:right;"> median_rating </th>
   <th style="text-align:right;"> count </th>
   <th style="text-align:right;"> prop </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Free </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 4.3 </td>
   <td style="text-align:right;background-color: grey !important;"> 6635 </td>
   <td style="text-align:right;background-color: grey !important;"> 95.193687 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Paid </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 4.4 </td>
   <td style="text-align:right;background-color: grey !important;"> 335 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.806313 </td>
  </tr>
</tbody>
</table>
Both density plot and box plot shows that paid app are better rated but with no too big  advantage over free ones - it is about 0.1 of different. It is worth to pay attention on  size of both types -  paid apps have less than 5% of the share (after mentioned assumtpions included). To summarize - paid apps are better rated basically not too much as expected.

**Time range**

How it looks like in time range, in specific periods? Was paid applications always better than free ones, in the past as well? 
<img src="my_report_files/figure-html/time range paid free rating-1.png" width="70%" style="display: block; margin: auto;" />
Paid applications, as a younger category, were rated better than free items from the beginning of the analyzed period, also in the case of both types, the median of ratings was constantly increasing. The most interesting thing is that from about 2016, the rating of free applications began to grow more dynamically, which gradually reduces the difference. That's why we could expect in the upcoming future, free apps would be ahead of paid ones. Below I present table with data labels yearly aggregated.
<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>Yearly median ratings and difference</caption>
 <thead>
  <tr>
   <th style="text-align:right;"> year </th>
   <th style="text-align:right;"> Free </th>
   <th style="text-align:right;"> Paid </th>
   <th style="text-align:right;"> difference </th>
   <th style="text-align:left;"> test </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;font-weight: bold;border-right:1px solid;"> 2012 </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 4.05 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.30 </td>
   <td style="text-align:right;background-color: grey !important;"> 0.25 </td>
   <td style="text-align:left;background-color: grey !important;"> Paid better </td>
  </tr>
  <tr>
   <td style="text-align:right;font-weight: bold;border-right:1px solid;"> 2013 </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 4.10 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.30 </td>
   <td style="text-align:right;background-color: grey !important;"> 0.20 </td>
   <td style="text-align:left;background-color: grey !important;"> Paid better </td>
  </tr>
  <tr>
   <td style="text-align:right;font-weight: bold;border-right:1px solid;"> 2014 </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 4.10 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.30 </td>
   <td style="text-align:right;background-color: grey !important;"> 0.20 </td>
   <td style="text-align:left;background-color: grey !important;"> Paid better </td>
  </tr>
  <tr>
   <td style="text-align:right;font-weight: bold;border-right:1px solid;"> 2015 </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 4.00 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.15 </td>
   <td style="text-align:right;background-color: grey !important;"> 0.15 </td>
   <td style="text-align:left;background-color: grey !important;"> Paid better </td>
  </tr>
  <tr>
   <td style="text-align:right;font-weight: bold;border-right:1px solid;"> 2016 </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 4.10 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.20 </td>
   <td style="text-align:right;background-color: grey !important;"> 0.10 </td>
   <td style="text-align:left;background-color: grey !important;"> Paid better </td>
  </tr>
  <tr>
   <td style="text-align:right;font-weight: bold;border-right:1px solid;"> 2017 </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 4.10 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.20 </td>
   <td style="text-align:right;background-color: grey !important;"> 0.10 </td>
   <td style="text-align:left;background-color: grey !important;"> Paid better </td>
  </tr>
  <tr>
   <td style="text-align:right;font-weight: bold;border-right:1px solid;"> 2018 </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 4.20 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.20 </td>
   <td style="text-align:right;background-color: grey !important;"> 0.00 </td>
   <td style="text-align:left;background-color: grey !important;"> The same </td>
  </tr>
</tbody>
</table>
On the chart, where I put real rating values of given type of apps, after 2018 difference amounts about 0.1, but if you have a look at the table with data labels where I aggregated median ratings by year, difference at the end is equal zero (it is less precisely method, however it presents existing tendency that free apps was becoming to be the same good rated such as paid ones). See, how advantage of paid apps in rating has been melted down through years.
<img src="my_report_files/figure-html/table paid free rating difference plotting-1.png" width="70%" style="display: block; margin: auto;" />
*To sum up:*

* in the past paid apps was better rated, difference seemed to be more significant and although it still remains, is not to big to just say that paid apps are definitely better than free ones

*presented plots at the beginning of current chapter showed in general that paid apps are better rated but it is due to bigger advantage of paid app taken from the past 

Let's consider the same matter but with category on the background - which categories of paid apps are better than the same but of free and on the contrary. 
<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>Paid or free ones - is it worth that</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Category </th>
   <th style="text-align:right;"> Free </th>
   <th style="text-align:right;"> Paid </th>
   <th style="text-align:right;"> difference </th>
   <th style="text-align:left;"> test </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> MEDICAL </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 4.0 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.25 </td>
   <td style="text-align:right;background-color: grey !important;"> 0.25 </td>
   <td style="text-align:left;background-color: grey !important;"> Paid better </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> HEALTH_AND_FITNESS </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 4.2 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.40 </td>
   <td style="text-align:right;background-color: grey !important;"> 0.20 </td>
   <td style="text-align:left;background-color: grey !important;"> Paid better </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> PHOTOGRAPHY </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 4.2 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.40 </td>
   <td style="text-align:right;background-color: grey !important;"> 0.20 </td>
   <td style="text-align:left;background-color: grey !important;"> Paid better </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> PRODUCTIVITY </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 4.2 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.40 </td>
   <td style="text-align:right;background-color: grey !important;"> 0.20 </td>
   <td style="text-align:left;background-color: grey !important;"> Paid better </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> FAMILY </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 4.1 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.25 </td>
   <td style="text-align:right;background-color: grey !important;"> 0.15 </td>
   <td style="text-align:left;background-color: grey !important;"> Paid better </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> VIDEO_PLAYERS </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 4.1 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.25 </td>
   <td style="text-align:right;background-color: grey !important;"> 0.15 </td>
   <td style="text-align:left;background-color: grey !important;"> Paid better </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> BUSINESS </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 4.2 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.30 </td>
   <td style="text-align:right;background-color: grey !important;"> 0.10 </td>
   <td style="text-align:left;background-color: grey !important;"> Paid better </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> DATING </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 4.1 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.20 </td>
   <td style="text-align:right;background-color: grey !important;"> 0.10 </td>
   <td style="text-align:left;background-color: grey !important;"> Paid better </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> GAME </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 4.2 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.30 </td>
   <td style="text-align:right;background-color: grey !important;"> 0.10 </td>
   <td style="text-align:left;background-color: grey !important;"> Paid better </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> PERSONALIZATION </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 4.2 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.30 </td>
   <td style="text-align:right;background-color: grey !important;"> 0.10 </td>
   <td style="text-align:left;background-color: grey !important;"> Paid better </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> SPORTS </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 4.2 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.30 </td>
   <td style="text-align:right;background-color: grey !important;"> 0.10 </td>
   <td style="text-align:left;background-color: grey !important;"> Paid better </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> TRAVEL_AND_LOCAL </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 4.2 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.25 </td>
   <td style="text-align:right;background-color: grey !important;"> 0.05 </td>
   <td style="text-align:left;background-color: grey !important;"> Paid better </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> FOOD_AND_DRINK </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 4.1 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.10 </td>
   <td style="text-align:right;background-color: grey !important;"> 0.00 </td>
   <td style="text-align:left;background-color: grey !important;"> the same rating </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> SHOPPING </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 4.2 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.20 </td>
   <td style="text-align:right;background-color: grey !important;"> 0.00 </td>
   <td style="text-align:left;background-color: grey !important;"> the same rating </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> SOCIAL </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 4.2 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.20 </td>
   <td style="text-align:right;background-color: grey !important;"> 0.00 </td>
   <td style="text-align:left;background-color: grey !important;"> the same rating </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> TOOLS </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 4.1 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.10 </td>
   <td style="text-align:right;background-color: grey !important;"> 0.00 </td>
   <td style="text-align:left;background-color: grey !important;"> the same rating </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> COMMUNICATION </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 4.2 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.00 </td>
   <td style="text-align:right;background-color: grey !important;"> -0.20 </td>
   <td style="text-align:left;background-color: grey !important;"> Free better </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> LIFESTYLE </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 4.0 </td>
   <td style="text-align:right;background-color: grey !important;"> 3.80 </td>
   <td style="text-align:right;background-color: grey !important;"> -0.20 </td>
   <td style="text-align:left;background-color: grey !important;"> Free better </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> FINANCE </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 4.2 </td>
   <td style="text-align:right;background-color: grey !important;"> 3.80 </td>
   <td style="text-align:right;background-color: grey !important;"> -0.40 </td>
   <td style="text-align:left;background-color: grey !important;"> Free better </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> MAPS_AND_NAVIGATION </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 4.2 </td>
   <td style="text-align:right;background-color: grey !important;"> 3.50 </td>
   <td style="text-align:right;background-color: grey !important;"> -0.70 </td>
   <td style="text-align:left;background-color: grey !important;"> Free better </td>
  </tr>
</tbody>
</table>
Paying attention on rating, the most profitable is to buy medical applications instead of install free ones, where the advantage over the free ones is the greatest and amounts to 0.25. But it is not worth to buy map and navigation applications and financial, communication or lifestyles ones, in these categories free applications are rated much better.

But above we didn't consider proportions of amount both types, so let's do the same but keeping in mind proportions - paid apps must be relatively most numerous compared to free ones first of all.
<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>Share and difference in %</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Category </th>
   <th style="text-align:right;"> Free </th>
   <th style="text-align:right;"> Paid </th>
   <th style="text-align:right;"> difference </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> MEDICAL </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 81.17647 </td>
   <td style="text-align:right;background-color: grey !important;"> 18.8235294 </td>
   <td style="text-align:right;background-color: grey !important;"> 62.35294 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> PERSONALIZATION </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 88.14815 </td>
   <td style="text-align:right;background-color: grey !important;"> 11.8518519 </td>
   <td style="text-align:right;background-color: grey !important;"> 76.29630 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> FAMILY </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 93.67946 </td>
   <td style="text-align:right;background-color: grey !important;"> 6.3205418 </td>
   <td style="text-align:right;background-color: grey !important;"> 87.35892 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> SPORTS </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 95.45455 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.5454545 </td>
   <td style="text-align:right;background-color: grey !important;"> 90.90909 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> HEALTH_AND_FITNESS </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 95.53571 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.4642857 </td>
   <td style="text-align:right;background-color: grey !important;"> 91.07143 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> GAME </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 95.78125 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.2187500 </td>
   <td style="text-align:right;background-color: grey !important;"> 91.56250 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> PHOTOGRAPHY </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 96.50000 </td>
   <td style="text-align:right;background-color: grey !important;"> 3.5000000 </td>
   <td style="text-align:right;background-color: grey !important;"> 93.00000 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> LIFESTYLE </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 96.59864 </td>
   <td style="text-align:right;background-color: grey !important;"> 3.4013605 </td>
   <td style="text-align:right;background-color: grey !important;"> 93.19728 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> TOOLS </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 97.02703 </td>
   <td style="text-align:right;background-color: grey !important;"> 2.9729730 </td>
   <td style="text-align:right;background-color: grey !important;"> 94.05405 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> MAPS_AND_NAVIGATION </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 97.05882 </td>
   <td style="text-align:right;background-color: grey !important;"> 2.9411765 </td>
   <td style="text-align:right;background-color: grey !important;"> 94.11765 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> TRAVEL_AND_LOCAL </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 97.18310 </td>
   <td style="text-align:right;background-color: grey !important;"> 2.8169014 </td>
   <td style="text-align:right;background-color: grey !important;"> 94.36620 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> COMMUNICATION </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 97.77778 </td>
   <td style="text-align:right;background-color: grey !important;"> 2.2222222 </td>
   <td style="text-align:right;background-color: grey !important;"> 95.55556 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> VIDEO_PLAYERS </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 97.89474 </td>
   <td style="text-align:right;background-color: grey !important;"> 2.1052632 </td>
   <td style="text-align:right;background-color: grey !important;"> 95.78947 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> FOOD_AND_DRINK </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 98.30508 </td>
   <td style="text-align:right;background-color: grey !important;"> 1.6949153 </td>
   <td style="text-align:right;background-color: grey !important;"> 96.61017 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> PRODUCTIVITY </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 98.33333 </td>
   <td style="text-align:right;background-color: grey !important;"> 1.6666667 </td>
   <td style="text-align:right;background-color: grey !important;"> 96.66667 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> DATING </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 98.41270 </td>
   <td style="text-align:right;background-color: grey !important;"> 1.5873016 </td>
   <td style="text-align:right;background-color: grey !important;"> 96.82540 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> BUSINESS </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 98.48485 </td>
   <td style="text-align:right;background-color: grey !important;"> 1.5151515 </td>
   <td style="text-align:right;background-color: grey !important;"> 96.96970 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> FINANCE </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 98.62069 </td>
   <td style="text-align:right;background-color: grey !important;"> 1.3793103 </td>
   <td style="text-align:right;background-color: grey !important;"> 97.24138 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> SHOPPING </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 99.30070 </td>
   <td style="text-align:right;background-color: grey !important;"> 0.6993007 </td>
   <td style="text-align:right;background-color: grey !important;"> 98.60140 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> SOCIAL </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 99.33775 </td>
   <td style="text-align:right;background-color: grey !important;"> 0.6622517 </td>
   <td style="text-align:right;background-color: grey !important;"> 98.67550 </td>
  </tr>
</tbody>
</table>
So if the share of medical and personalization applications is the largest, let's see how they are rated and put the results on the chart
<img src="my_report_files/figure-html/medial vs personalization-1.png" width="70%" style="display: block; margin: auto;" />

**Does popularity depend on rating?**
At first glance that answer the above question is YES, because regularly, customers are being decided, before they select something ultimately, checking rating of the app - it seems to be obvious, because it is rationally customer's behavior.
<img src="my_report_files/figure-html/populartity vs rating-1.png" width="70%" style="display: block; margin: auto;" />
As you can see, the expected relationship exists for both types, the higher rating trigger more reviews and therefore the greater the number of installations. However, in the case of the paid ones it increases linearly, while the free ones growth more dynamically. The question is the price - the regular user likes to install a well-rated application for free because nothing is lost on it.


## Sizing

**General assumptions:**

* because of strong skewness of actual_size distribution I use median as average measure 

* for current analysis I excluded items with no data or zero value assigned to variable actual_size that I have cleared and prepared for analysis at the beginning

* unit of apps sizing was standardized and based on Mb

The first question that we would like to ask is following -  was applications becoming more and more virtual memory demanding ?
<img src="my_report_files/figure-html/sizing time range-1.png" width="70%" style="display: block; margin: auto;" />
As above chart confirmed - apps was requiring successive more virtual memory. This trend was growing from the beginning of investigating period, but over the years it became more and more dynamic. Next let's focus on common statistical indicators of dynamics to check in details this matter. 
I calculated median size by year, absolute growth with constant base, absolute growth with variable base and relative growth with constant base.
<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>Basic statistical dynamic's indicators</caption>
 <thead>
  <tr>
   <th style="text-align:right;"> year </th>
   <th style="text-align:right;"> size </th>
   <th style="text-align:right;"> abs_growth_const </th>
   <th style="text-align:right;"> abs_growth_vrbl </th>
   <th style="text-align:right;"> relative_growth_const </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;font-weight: bold;border-right:1px solid;"> 2011 </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 3.35 </td>
   <td style="text-align:right;background-color: grey !important;"> 0.00 </td>
   <td style="text-align:right;background-color: grey !important;"> 0.00 </td>
   <td style="text-align:right;background-color: grey !important;"> 0.00000 </td>
  </tr>
  <tr>
   <td style="text-align:right;font-weight: bold;border-right:1px solid;"> 2012 </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 6.40 </td>
   <td style="text-align:right;background-color: grey !important;"> 3.05 </td>
   <td style="text-align:right;background-color: grey !important;"> 3.05 </td>
   <td style="text-align:right;background-color: grey !important;"> 91.04478 </td>
  </tr>
  <tr>
   <td style="text-align:right;font-weight: bold;border-right:1px solid;"> 2013 </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 7.60 </td>
   <td style="text-align:right;background-color: grey !important;"> 4.25 </td>
   <td style="text-align:right;background-color: grey !important;"> 1.20 </td>
   <td style="text-align:right;background-color: grey !important;"> 126.86567 </td>
  </tr>
  <tr>
   <td style="text-align:right;font-weight: bold;border-right:1px solid;"> 2014 </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 6.95 </td>
   <td style="text-align:right;background-color: grey !important;"> 3.60 </td>
   <td style="text-align:right;background-color: grey !important;"> -0.65 </td>
   <td style="text-align:right;background-color: grey !important;"> 107.46269 </td>
  </tr>
  <tr>
   <td style="text-align:right;font-weight: bold;border-right:1px solid;"> 2015 </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 6.30 </td>
   <td style="text-align:right;background-color: grey !important;"> 2.95 </td>
   <td style="text-align:right;background-color: grey !important;"> -0.65 </td>
   <td style="text-align:right;background-color: grey !important;"> 88.05970 </td>
  </tr>
  <tr>
   <td style="text-align:right;font-weight: bold;border-right:1px solid;"> 2016 </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 8.90 </td>
   <td style="text-align:right;background-color: grey !important;"> 5.55 </td>
   <td style="text-align:right;background-color: grey !important;"> 2.60 </td>
   <td style="text-align:right;background-color: grey !important;"> 165.67164 </td>
  </tr>
  <tr>
   <td style="text-align:right;font-weight: bold;border-right:1px solid;"> 2017 </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 9.80 </td>
   <td style="text-align:right;background-color: grey !important;"> 6.45 </td>
   <td style="text-align:right;background-color: grey !important;"> 0.90 </td>
   <td style="text-align:right;background-color: grey !important;"> 192.53731 </td>
  </tr>
  <tr>
   <td style="text-align:right;font-weight: bold;border-right:1px solid;"> 2018 </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 17.00 </td>
   <td style="text-align:right;background-color: grey !important;"> 13.65 </td>
   <td style="text-align:right;background-color: grey !important;"> 7.20 </td>
   <td style="text-align:right;background-color: grey !important;"> 407.46269 </td>
  </tr>
</tbody>
</table>
Relative dynamics plot by year
<img src="my_report_files/figure-html/dynamic plot by year-1.png" width="70%" style="display: block; margin: auto;" />
2018 apps required an average of more than 4 times more virtual memory than 2011. 

And below - how does distribution of other indicator look on time range being researched.
<img src="my_report_files/figure-html/other indicators on time range-1.png" width="70%" style="display: block; margin: auto;" />
All of indicators measure the same, but differ in their sensitivity to change. 

**Which type of apps requires more virtual space on device? Does it depend on type if app is paid or free?**

For answer this question, I present on charts below.

<img src="my_report_files/figure-html/type and sizing, charts-1.png" width="70%" style="display: block; margin: auto;" /><img src="my_report_files/figure-html/type and sizing, charts-2.png" width="70%" style="display: block; margin: auto;" />
By charts, it seems to be no relationship between type and size of the apps. To confirm, have a look at the table where you can find basic statistical ratios:
<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>Basic statistical indicators</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Type </th>
   <th style="text-align:right;"> min </th>
   <th style="text-align:right;"> Q1 </th>
   <th style="text-align:right;"> median </th>
   <th style="text-align:right;"> Q3 </th>
   <th style="text-align:right;"> max </th>
   <th style="text-align:right;"> mean </th>
   <th style="text-align:right;"> sd </th>
   <th style="text-align:right;"> n </th>
   <th style="text-align:right;"> missing </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Free </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 1.1 </td>
   <td style="text-align:right;background-color: grey !important;"> 7.7 </td>
   <td style="text-align:right;background-color: grey !important;"> 19 </td>
   <td style="text-align:right;background-color: grey !important;"> 40 </td>
   <td style="text-align:right;background-color: grey !important;"> 100 </td>
   <td style="text-align:right;background-color: grey !important;"> 27.35071 </td>
   <td style="text-align:right;background-color: grey !important;"> 24.72577 </td>
   <td style="text-align:right;background-color: grey !important;"> 5021 </td>
   <td style="text-align:right;background-color: grey !important;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Paid </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 1.1 </td>
   <td style="text-align:right;background-color: grey !important;"> 7.8 </td>
   <td style="text-align:right;background-color: grey !important;"> 18 </td>
   <td style="text-align:right;background-color: grey !important;"> 39 </td>
   <td style="text-align:right;background-color: grey !important;"> 100 </td>
   <td style="text-align:right;background-color: grey !important;"> 25.93852 </td>
   <td style="text-align:right;background-color: grey !important;"> 23.68507 </td>
   <td style="text-align:right;background-color: grey !important;"> 257 </td>
   <td style="text-align:right;background-color: grey !important;"> 0 </td>
  </tr>
</tbody>
</table>
As you can see, by median value, there is no significant relationship between sizing and type on the apps.

What about target groups? Let's check if there any relationships exists.
<img src="my_report_files/figure-html/sizing target groups-1.png" width="70%" style="display: block; margin: auto;" /><img src="my_report_files/figure-html/sizing target groups-2.png" width="70%" style="display: block; margin: auto;" /><table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>Basic statistical indicators</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Group </th>
   <th style="text-align:right;"> min </th>
   <th style="text-align:right;"> Q1 </th>
   <th style="text-align:right;"> median </th>
   <th style="text-align:right;"> Q3 </th>
   <th style="text-align:right;"> max </th>
   <th style="text-align:right;"> mean </th>
   <th style="text-align:right;"> sd </th>
   <th style="text-align:right;"> n </th>
   <th style="text-align:right;"> missing </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Adults </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 1.4 </td>
   <td style="text-align:right;background-color: grey !important;"> 9.9 </td>
   <td style="text-align:right;background-color: grey !important;"> 22.5 </td>
   <td style="text-align:right;background-color: grey !important;"> 44 </td>
   <td style="text-align:right;background-color: grey !important;"> 100 </td>
   <td style="text-align:right;background-color: grey !important;"> 30.13264 </td>
   <td style="text-align:right;background-color: grey !important;"> 25.35495 </td>
   <td style="text-align:right;background-color: grey !important;"> 288 </td>
   <td style="text-align:right;background-color: grey !important;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Everyone </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 1.1 </td>
   <td style="text-align:right;background-color: grey !important;"> 6.6 </td>
   <td style="text-align:right;background-color: grey !important;"> 16.0 </td>
   <td style="text-align:right;background-color: grey !important;"> 35 </td>
   <td style="text-align:right;background-color: grey !important;"> 100 </td>
   <td style="text-align:right;background-color: grey !important;"> 24.26219 </td>
   <td style="text-align:right;background-color: grey !important;"> 22.99576 </td>
   <td style="text-align:right;background-color: grey !important;"> 3994 </td>
   <td style="text-align:right;background-color: grey !important;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> Teen </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 1.3 </td>
   <td style="text-align:right;background-color: grey !important;"> 17.0 </td>
   <td style="text-align:right;background-color: grey !important;"> 31.0 </td>
   <td style="text-align:right;background-color: grey !important;"> 57 </td>
   <td style="text-align:right;background-color: grey !important;"> 100 </td>
   <td style="text-align:right;background-color: grey !important;"> 38.56697 </td>
   <td style="text-align:right;background-color: grey !important;"> 27.48260 </td>
   <td style="text-align:right;background-color: grey !important;"> 996 </td>
   <td style="text-align:right;background-color: grey !important;"> 0 </td>
  </tr>
</tbody>
</table>
We are able to see visible relationship right here - applications for the youngest customers require the most space in mobile devices. As you might remember, the most numerous category among young people are games, and they usually take the most virtual storage.

To confirm above let's have a look how much virtual memory do popular categories require.
<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>Selecting categories</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Category </th>
   <th style="text-align:right;"> n </th>
   <th style="text-align:right;"> prop </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> FAMILY </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 1084 </td>
   <td style="text-align:right;background-color: grey !important;"> 20.538083 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> GAME </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 867 </td>
   <td style="text-align:right;background-color: grey !important;"> 16.426677 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> TOOLS </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 359 </td>
   <td style="text-align:right;background-color: grey !important;"> 6.801819 </td>
  </tr>
</tbody>
</table>

<img src="my_report_files/figure-html/categories sizing-1.png" width="70%" style="display: block; margin: auto;" /><img src="my_report_files/figure-html/categories sizing-2.png" width="70%" style="display: block; margin: auto;" /><table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>Basic statistical indicators</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Category </th>
   <th style="text-align:right;"> min </th>
   <th style="text-align:right;"> Q1 </th>
   <th style="text-align:right;"> median </th>
   <th style="text-align:right;"> Q3 </th>
   <th style="text-align:right;"> max </th>
   <th style="text-align:right;"> mean </th>
   <th style="text-align:right;"> sd </th>
   <th style="text-align:right;"> n </th>
   <th style="text-align:right;"> missing </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> FAMILY </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 1.1 </td>
   <td style="text-align:right;background-color: grey !important;"> 13 </td>
   <td style="text-align:right;background-color: grey !important;"> 29.5 </td>
   <td style="text-align:right;background-color: grey !important;"> 54 </td>
   <td style="text-align:right;background-color: grey !important;"> 100 </td>
   <td style="text-align:right;background-color: grey !important;"> 36.145941 </td>
   <td style="text-align:right;background-color: grey !important;"> 27.28513 </td>
   <td style="text-align:right;background-color: grey !important;"> 1084 </td>
   <td style="text-align:right;background-color: grey !important;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> GAME </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 1.1 </td>
   <td style="text-align:right;background-color: grey !important;"> 25 </td>
   <td style="text-align:right;background-color: grey !important;"> 46.0 </td>
   <td style="text-align:right;background-color: grey !important;"> 68 </td>
   <td style="text-align:right;background-color: grey !important;"> 100 </td>
   <td style="text-align:right;background-color: grey !important;"> 47.750865 </td>
   <td style="text-align:right;background-color: grey !important;"> 27.36064 </td>
   <td style="text-align:right;background-color: grey !important;"> 867 </td>
   <td style="text-align:right;background-color: grey !important;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;border-right:1px solid;"> TOOLS </td>
   <td style="text-align:right;width: 6em; background-color: grey !important;"> 1.1 </td>
   <td style="text-align:right;background-color: grey !important;"> 3 </td>
   <td style="text-align:right;background-color: grey !important;"> 5.8 </td>
   <td style="text-align:right;background-color: grey !important;"> 11 </td>
   <td style="text-align:right;background-color: grey !important;"> 72 </td>
   <td style="text-align:right;background-color: grey !important;"> 8.980501 </td>
   <td style="text-align:right;background-color: grey !important;"> 9.10688 </td>
   <td style="text-align:right;background-color: grey !important;"> 359 </td>
   <td style="text-align:right;background-color: grey !important;"> 0 </td>
  </tr>
</tbody>
</table>
Here the relationship is also very visible (because of obvious technical conditions), moreover, the hypothesis about games is also confirmed, they take the most places, so the group of young people clearly stands out from the rest when it comes to hardware requirements.
  

  



