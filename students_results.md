Students exam performance - analysis
================
Wiktor Piela
19 03 2021

# Introduction

Current dataset includes exam results of 1000 students divided by
specific areas- mathematic skills, reading and writing. Possibility to
deeper analysis provide us additional information like parents
education, how were students prepared to exam and finally quality of
meals that they have eaten. We can also find out the gender of every
student and ethnicity group they belong to. I will try to investigate,
which factor could have the biggest impact on exam result, find
something interesting, present general information and visualize that
and try to describe features of the best student and the worst one.

# Distribution of exam results and skewness

To average exam results I use median measure, because in case of each of
subject, distribution of results are skewed towards the left:

  - skewness coefficient in case of math score is equal -0.28
  - related to reading part -0.26
  - in according to writing part -0.29

*Negative value indicates that distribution is skewed towards the left*

Although the skewness isn’t too strong, it seem to be more objectively
to use median as average measure. Below I present distribution of
scores, divided by each of subject separately to confirm my assumptions.

<img src="students_results_files/figure-gfm/skewness-1.png" style="display: block; margin: auto;" />

# Initial insights

As below correlation matrix shows, there is not much difference between
results of every subjects- it means that the average student’s results
were not very different when considering each subject separately and
they compare them to each other. For example, the student who got in
writing 10 points, in reading 50 and in math 80 - doesn’t exists. The
scoring that students achieved of each subject are very similar to each
other.

<img src="students_results_files/figure-gfm/correlation matrix plot-1.png" style="display: block; margin: auto;" />

# Gender

Let’s present how did each of gender deal with exam in general and how
it looks like once we consider every specific subject separately.

<img src="students_results_files/figure-gfm/gender general results-1.png" style="display: block; margin: auto;" />

<table class="table table-bordered" style="font-family: Cambria; margin-left: auto; margin-right: auto;">

<caption>

Results table

</caption>

<thead>

<tr>

<th style="text-align:left;">

gender

</th>

<th style="text-align:right;">

min

</th>

<th style="text-align:right;">

Q1

</th>

<th style="text-align:right;">

median

</th>

<th style="text-align:right;">

Q3

</th>

<th style="text-align:right;">

max

</th>

<th style="text-align:right;">

mean

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

female

</td>

<td style="text-align:right;">

10

</td>

<td style="text-align:right;">

62

</td>

<td style="text-align:right;">

72

</td>

<td style="text-align:right;">

81

</td>

<td style="text-align:right;">

100

</td>

<td style="text-align:right;">

71.00965

</td>

</tr>

<tr>

<td style="text-align:left;">

male

</td>

<td style="text-align:right;">

23

</td>

<td style="text-align:right;">

55

</td>

<td style="text-align:right;">

66

</td>

<td style="text-align:right;">

75

</td>

<td style="text-align:right;">

100

</td>

<td style="text-align:right;">

65.40664

</td>

</tr>

</tbody>

</table>

Generally, the females used to look better than males in exam, because
if we focus on median points scored by both gender’s, it gives us
difference of 6 points on females favour. However, important to note it
that the worst average results in whole dataset gets one of women. The
situation looks quite different when we consider all of subjects
separately.

<img src="students_results_files/figure-gfm/col plot gender-1.png" style="display: block; margin: auto;" />

The skills of males are definitely opposite than female ones, because
males got the best results in math, later- in reading, and finally, the
worst in writing; in case of females order is opposite. In line with
average results- randomly selected male is:

  - better than randomly selected female of 4 points in math

  - worse than randomly selected female of 10 points in writing

  - worse than randomly selected female of 7 point in reading

# Ethnicity groups

Also every participant of research belong to one of five specific
ethnicity group. For further investigation, I present the approximate
results of each of groups.

<img src="students_results_files/figure-gfm/ethnicity group boxplot-1.png" style="display: block; margin: auto;" />

Groups A and E seem to be the most outstanding, the first one achieving
the worst result and second one, the highest scoring. Average points
that rest of groups got are rather similar.

Have a look how did each of groups deal with specific subjects:

<img src="students_results_files/figure-gfm/groups heatmap-1.png" style="display: block; margin: auto;" />

<table class="table table-bordered" style="font-family: Cambria; ">

<caption>

Group’s result by subjects

</caption>

<thead>

<tr>

<th style="text-align:left;">

ethnicity\_group

</th>

<th style="text-align:right;">

math

</th>

<th style="text-align:right;">

reading

</th>

<th style="text-align:right;">

writing

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

group A

</td>

<td style="text-align:right;">

61.0

</td>

<td style="text-align:right;">

64

</td>

<td style="text-align:right;">

62

</td>

</tr>

<tr>

<td style="text-align:left;">

group B

</td>

<td style="text-align:right;">

63.0

</td>

<td style="text-align:right;">

67

</td>

<td style="text-align:right;">

67

</td>

</tr>

<tr>

<td style="text-align:left;">

group C

</td>

<td style="text-align:right;">

65.0

</td>

<td style="text-align:right;">

71

</td>

<td style="text-align:right;">

68

</td>

</tr>

<tr>

<td style="text-align:left;">

group D

</td>

<td style="text-align:right;">

69.0

</td>

<td style="text-align:right;">

71

</td>

<td style="text-align:right;">

72

</td>

</tr>

<tr>

<td style="text-align:left;">

group E

</td>

<td style="text-align:right;">

74.5

</td>

<td style="text-align:right;">

74

</td>

<td style="text-align:right;">

72

</td>

</tr>

</tbody>

</table>

As expected, the best results in every subject compared to other groups,
achieved group E. They were the best especially in math, later in
reading and in writing at the end. As it turned out, in maths, the worst
group was A, also in writing group A scored the worst. Very important to
mention is that all of presented values show no too big differences
between each other. It follows that very high correlation coefficient
that I mentioned at the beginning in initial insights chapter.

# Factors affecting exam results

Now let’s consider what factors have a real impact on the student’s
results in the exam, the same, we will try to explain why females
achieved better results and why some ethnicity groups were doing better
than other ones.

# 1st factor- parental level of education

Even without investigating the data, it could be assumed that this
factor have a direct impact on the exam results, but let’s see what the
dataset shows. First of all, let’s check whether children of better
graduated parents used to get higher scoring of the exam.

<img src="students_results_files/figure-gfm/parental results median-1.png" style="display: block; margin: auto;" />

It is clearly visible that on the given dataset there is a relationship,
the higher the education of the parents, the higher the results.
Differences between the groups are not very large, but it comes from the
correlation mentioned at the beginning- the student’s performance in
each of subject was not very different related to scoring achieved.

Let’s see how the results presents divided by individual subjects
separately.

<img src="students_results_files/figure-gfm/parental subject separately-1.png" style="display: block; margin: auto;" />

Also in this approach, children of master’s degree graduated, especially
in reading, did much better than others. Children of people with lower
university education, in reading and writing, obtained points similar to
the results in mathematics of students who parents are the best
educated. While children who parents did or didn’t high school scored
the worst of all - they obtained the worst results especially in maths.

Now let’s check if the parents education contributed to the fact that
group E looks better in the exam than the rest. To present that clearly,
I divided education levels by two base group:

  - university degree (master’s, bachelor’s and associate’s degrees)

  - lower educated (some college, some high school, and fully high
    school)

<table class=" lightable-classic-2" style="font-family: Cambria; margin-left: auto; margin-right: auto;">

<caption>

Parent’s education level by ethnicity groups

</caption>

<thead>

<tr>

<th style="text-align:left;">

ethnicity\_group

</th>

<th style="text-align:left;">

lower educated

</th>

<th style="text-align:left;">

university degree

</th>

<th style="text-align:left;">

Total

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

group A

</td>

<td style="text-align:left;">

67.42%

</td>

<td style="text-align:left;">

32.58%

</td>

<td style="text-align:left;">

100.00%

</td>

</tr>

<tr>

<td style="text-align:left;">

group B

</td>

<td style="text-align:left;">

64.74%

</td>

<td style="text-align:left;">

35.26%

</td>

<td style="text-align:left;">

100.00%

</td>

</tr>

<tr>

<td style="text-align:left;">

group C

</td>

<td style="text-align:left;">

57.05%

</td>

<td style="text-align:left;">

42.95%

</td>

<td style="text-align:left;">

100.00%

</td>

</tr>

<tr>

<td style="text-align:left;">

group D

</td>

<td style="text-align:left;">

61.45%

</td>

<td style="text-align:left;">

38.55%

</td>

<td style="text-align:left;">

100.00%

</td>

</tr>

<tr>

<td style="text-align:left;">

group E

</td>

<td style="text-align:left;">

53.57%

</td>

<td style="text-align:left;">

46.43%

</td>

<td style="text-align:left;">

100.00%

</td>

</tr>

</tbody>

</table>

<img src="students_results_files/figure-gfm/tabyl groups and education-1.png" style="display: block; margin: auto;" />

Almost 46.5 percent of parents of children belonging to group E did
university degree- just for the record, this group deal with exam the
best, at the same time, 67.5 % parents of children from the worst scored
group A, were without university degree, this forms a the lowest
educated group comparing with the other ones.

At this level, parental level of education seems to have direct impact
on children’s exam results, because children the worst educated group
scored noticeable lower than others, while children from well-graduated
families used to get the highest score.

To confirm above insight, we need to check if the same relationship
exists related to gender as well. Females used to scored much better
than males, hence I assume that parents of women should be better
educated than parents of males.

<table class=" lightable-classic-2" style="font-family: Cambria; margin-left: auto; margin-right: auto;">

<caption>

Parental level of education by gender

</caption>

<thead>

<tr>

<th style="text-align:left;">

gender

</th>

<th style="text-align:left;">

lower educated

</th>

<th style="text-align:left;">

university degree

</th>

<th style="text-align:left;">

Total

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

female

</td>

<td style="text-align:left;">

58.49%

</td>

<td style="text-align:left;">

41.51%

</td>

<td style="text-align:left;">

100.00%

</td>

</tr>

<tr>

<td style="text-align:left;">

male

</td>

<td style="text-align:left;">

61.83%

</td>

<td style="text-align:left;">

38.17%

</td>

<td style="text-align:left;">

100.00%

</td>

</tr>

</tbody>

</table>

<img src="students_results_files/figure-gfm/parental level of education by sex-1.png" style="display: block; margin: auto;" />

<table class=" lightable-classic-2" style="font-family: Cambria; margin-left: auto; margin-right: auto;">

<caption>

Parental level of education by gender

</caption>

<thead>

<tr>

<th style="text-align:left;">

parental\_level\_of\_education

</th>

<th style="text-align:left;">

female

</th>

<th style="text-align:left;">

male

</th>

<th style="text-align:left;">

Total

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

master’s degree

</td>

<td style="text-align:left;">

61.02%

</td>

<td style="text-align:left;">

38.98%

</td>

<td style="text-align:left;">

100.00%

</td>

</tr>

</tbody>

</table>

In general, parents of women are better educated than men, but the
difference is not great. However, the decisive factor, seems to be the
fact that 60 percent of people who did master degree, are parents of
women.

# 2nd factor - preparation course participation

<img src="students_results_files/figure-gfm/pie chart test preparation-1.png" style="display: block; margin: auto;" />

As above chart shows, minority of students have participated a
preparation course for the exam. Let’s compare the results of prepared
and not prepared students.

<img src="students_results_files/figure-gfm/course and results-1.png" style="display: block; margin: auto;" />

Basically, those students, who have participated in the test preparation
course, used to achieve higher results, however very important to
mention is that the best scored students in both groups, got 100 points,
even those ones , who didn’t take part in the course. At the same time,
one specific person with the worst average result in whole dataset,
belongs to not prepared group of students.

<img src="students_results_files/figure-gfm/col plot subject results-1.png" style="display: block; margin: auto;" />

Prepared students scored better in every subject, however- the smallest
difference in results we can register in math, the biggest in case of
writing part.

**Course participation by parental education level**

<img src="students_results_files/figure-gfm/participation by paretns education-1.png" style="display: block; margin: auto;" />

<table class=" lightable-classic" style="font-family: Cambria; margin-left: auto; margin-right: auto;">

<caption>

Course participation by parent’s education

</caption>

<thead>

<tr>

<th style="text-align:left;">

parental\_level\_of\_education

</th>

<th style="text-align:left;">

test\_preparation\_course

</th>

<th style="text-align:right;">

prop

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

some high school

</td>

<td style="text-align:left;">

completed

</td>

<td style="text-align:right;">

43.02

</td>

</tr>

<tr>

<td style="text-align:left;">

bachelor’s degree

</td>

<td style="text-align:left;">

completed

</td>

<td style="text-align:right;">

38.98

</td>

</tr>

<tr>

<td style="text-align:left;">

associate’s degree

</td>

<td style="text-align:left;">

completed

</td>

<td style="text-align:right;">

36.94

</td>

</tr>

<tr>

<td style="text-align:left;">

some college

</td>

<td style="text-align:left;">

completed

</td>

<td style="text-align:right;">

34.07

</td>

</tr>

<tr>

<td style="text-align:left;">

master’s degree

</td>

<td style="text-align:left;">

completed

</td>

<td style="text-align:right;">

33.90

</td>

</tr>

<tr>

<td style="text-align:left;">

high school

</td>

<td style="text-align:left;">

completed

</td>

<td style="text-align:right;">

28.57

</td>

</tr>

</tbody>

</table>

It is very interesting fact, that among group of parents who didn’t even
graduate high school, it was the biggest share of students who have
participated test preparation course- this information could discredit
effectiveness of course that we are talking about, because those
students used to get lower scoring than rest of groups, however; the
group of students who took part in the course in the smallest amount
were children of parents who graduated from high school, so group who
didn’t score the best.

**Ethnicity group and preparation course**

Let’s check which of ethnicity groups was the best prepared and if it
could have impact on their results

<img src="students_results_files/figure-gfm/ethnicity and course-1.png" style="display: block; margin: auto;" />

<table class=" lightable-classic" style="font-family: Cambria; margin-left: auto; margin-right: auto;">

<caption>

Which ethnicity group were the best prepared?

</caption>

<thead>

<tr>

<th style="text-align:left;">

ethnicity\_group

</th>

<th style="text-align:left;">

completed

</th>

<th style="text-align:left;">

none

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

group A

</td>

<td style="text-align:left;">

34.83%

</td>

<td style="text-align:left;">

65.17%

</td>

</tr>

<tr>

<td style="text-align:left;">

group B

</td>

<td style="text-align:left;">

35.79%

</td>

<td style="text-align:left;">

64.21%

</td>

</tr>

<tr>

<td style="text-align:left;">

group C

</td>

<td style="text-align:left;">

36.68%

</td>

<td style="text-align:left;">

63.32%

</td>

</tr>

<tr>

<td style="text-align:left;">

group D

</td>

<td style="text-align:left;">

31.30%

</td>

<td style="text-align:left;">

68.70%

</td>

</tr>

<tr>

<td style="text-align:left;">

group E

</td>

<td style="text-align:left;">

42.86%

</td>

<td style="text-align:left;">

57.14%

</td>

</tr>

</tbody>

</table>

The most numerous group of people who have participated the course was
from ethnicity group E, because almost 43 percent, the same time, the
smallest share of students who took part in course concerns group D-
there, less than every third student attended this preparation for the
exam.

**Course participation by gender**

To definitely check, if participation in course had direct impact on
students results on exam, I present how many females and males took part
in this course.

<img src="students_results_files/figure-gfm/course by gender-1.png" style="display: block; margin: auto;" />

So, as you can see, as many females as males took part in the
preparation course; to be aware whether course was effectively and
impact on test results, keep in mind that females scored better than
males in this exam in total.

**Why in my opinion participation in the preparatory course doesn’t have
a big impact on the exam results?**

  - very small share of people from group D participated in the course,
    but they achieved results similar to group E, which scored the best

  - it was quite big share of students, which parent’s didn’t graduate
    high school, who took part in this course, however finally, they
    weren’t be effectively on the exam

  - as many females as males took part in the preparation course,
    however women used to much better scored than males in exam in
    total- if course would be efectively and have impact on exam’s
    results, more females than males should take part in the course-
    proportion presented on above bar plot should look another than are
    actually

  - in fact, participating students got better results than not
    participating, but it cannot be due to hat the exam is effective and
    impacting on exam performance, but only because better students took
    part in the course.

# 3rd factor - type of lunch

As you know, mental effort requires energy intake, so it is important to
eat a wholesome meal before your exam. Also in our dataset, some
students ate a full meal, others didn’t take a meal at all, or a little
one. We can compare the performance of students on exam based on this
criterion.

<img src="students_results_files/figure-gfm/lunch boxplot-1.png" style="display: block; margin: auto;" />

In total, students who ate standard meal, used to scored better, also
they achieved higher results at each subject separately.

<img src="students_results_files/figure-gfm/barplot lunch subject-1.png" style="display: block; margin: auto;" />

**How did the representatives of ethnic groups eat?**

In order to refute or to confirm the hypothesis that the type of meal
did affect the student’s results in the exam, let’s check how did people
belonging to specific ethnic groups eat.

<img src="students_results_files/figure-gfm/lunch and ethnicity-1.png" style="display: block; margin: auto;" />

<table class="table" style="font-family: Cambria; margin-left: auto; margin-right: auto;">

<caption>

Lunch type among ethnicity groups

</caption>

<thead>

<tr>

<th style="text-align:left;">

ethnicity\_group

</th>

<th style="text-align:left;">

free/reduced

</th>

<th style="text-align:left;">

standard

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

group E

</td>

<td style="text-align:left;">

29.29%

</td>

<td style="text-align:left;">

70.71%

</td>

</tr>

<tr>

<td style="text-align:left;">

group C

</td>

<td style="text-align:left;">

35.74%

</td>

<td style="text-align:left;">

64.26%

</td>

</tr>

<tr>

<td style="text-align:left;">

group D

</td>

<td style="text-align:left;">

36.26%

</td>

<td style="text-align:left;">

63.74%

</td>

</tr>

<tr>

<td style="text-align:left;">

group B

</td>

<td style="text-align:left;">

36.32%

</td>

<td style="text-align:left;">

63.68%

</td>

</tr>

<tr>

<td style="text-align:left;">

group A

</td>

<td style="text-align:left;">

40.45%

</td>

<td style="text-align:left;">

59.55%

</td>

</tr>

</tbody>

</table>

**Why in my opinion lunch type affect on the exam performance of
students?**

  - over 70 percent of the students in group E, who scored the best in
    the exam, ate a standard meal before the exam, it was the largest
    share among any ethnic group

  - in group A, which scored the worst, most students took an exam
    eating reduced meal or without any

# Final insights vs my initial assumptions

1.  as it turned out, the exam’s performance were mainly driven by the
    parents’ education level and the type of meal consumed by students

2.  participation in the exam preparation course turned out to be
    irrelevant, however an the beginning I assumed another otherwise

3.  students who completed the course obtained better results, however,
    as I proved, it was due to the fact that the course was attended by
    better students, not because the exam turned out to be effective and
    affecting final exam performance of students

4.  females used to scored better, but if we consider each subject
    separately, males, in mathematics, achieved more points than females

5.  the best educated were parents of students from group E and also
    females come from better graduated families than males.
