#pricing
source("uploading and data clearing.R")

# whether does price of app depend on the group? ----------------------------------


play %>% 
  filter(Type == "Paid", Price > 1) %>% 
  ggplot(aes(Price))+
  geom_histogram(bins = 20)

#density plot
col_density <- c("#7aa457","#a46cb7","#cb6a49")
play %>% 
  filter(Type == "Paid", !is.na(Group), Reviews > 200) %>% 
  ggplot(aes(Price, fill = Group))+
  geom_density(alpha = 0.7, adjust = 3)+
  scale_x_log10()+
  scale_fill_manual(values = col_density)

#boxplot
play %>% 
  filter(Type == "Paid", !is.na(Group), Reviews > 200) %>% 
  ggplot(aes(Group, Price))+
  geom_boxplot(coef = 3)+
  scale_y_log10()

#data labels for above
play %>% 
  filter(Reviews > 200, !is.na(Group), Type == "Paid") %>% 
  group_by(Group) %>% 
  summarise(Price = median(Price),
            count = n())



# for who are apps more expensive - for adults or teens? ------------------
play %>% 
  filter(Group %in% c("Teen", "Adults"),
         Type == "Paid", Reviews > 200) %>% 
  ggplot(aes(Price, fill = Group))+
  geom_density(adjust = 3, alpha = 0.6)

play %>% 
  filter(Group %in% c("Teen", "Adults"),
         Type == "Paid", Reviews > 200) %>% 
  ggplot(aes(Group, Price))+
  geom_boxplot(coef = 3)

play %>% 
  filter(Group %in% c("Teen", "Adults"),
         Type == "Paid", Reviews > 200) %>%
  group_by(Group) %>% 
  summarise(median_Price = median(Price),
            max_Price = max(Price),
            count = n())

# which category of paid apps is the most expensive  ----------------------
#selecting the most numeorus categories with their median price
play %>% 
  filter(Type == "Paid", Reviews > 200) %>% 
  group_by(Category) %>% 
  summarise(median_price = median(Price),
            max_price = max(Price),
            min_price = min(Price), count = n()) %>% 
  top_n(3, count)

#density plot
play %>% 
  filter(Type == "Paid", Reviews > 200,
         Category %in% c("FAMILY", "GAME", "MEDICAL")) %>% 
  ggplot(aes(Price, fill = Category))+
  geom_density(adjust = 3, alpha = 0.7)+
  scale_x_log10()

#boxplot
play %>% 
  filter(Type == "Paid", Reviews > 200,
         Category %in% c("FAMILY", "GAME", "MEDICAL")) %>% 
  ggplot(aes(Category, Price))+
  geom_boxplot(coef = 5)+
  scale_y_log10()

#data labels favstats
play %>% 
  filter(Type == "Paid", Reviews > 200) %>% 
  favstats(Price ~ Category , data =.) %>% 
  filter(Category %in% c("FAMILY", "GAME", "MEDICAL")) 

# price and the time range ----------------------------------------------
play %>% 
  filter(Reviews > 200, Type == "Paid") %>%
  group_by(Type) %>% 
  summarise(median_Price = median(Price),
            max_Price = max(Price),
            min_Price = min(Price))

play %>% 
  filter(Reviews > 200, Type == "Paid", Price > 1) %>% 
  ggplot(aes(`Last Updated`, Price))+
  geom_smooth(se = FALSE)+
  geom_hline(yintercept = 2.99, col = "red", size = 0.7)+
  labs(x = "Years", y = "Average Price", 
       title = "Increase after 2016 mainly driven by a couple of the most expensive
       apps over 100 USD")+
  theme(axis.ticks = element_blank()) +
  annotate(geom = "label", x = ymd("2013-09-23"), y = 10, label = "Median price")

play %>% 
  filter(Reviews > 200, Type == "Paid") %>% 
  ggplot(aes(`Last Updated`, Price))+
  geom_point()+
  geom_smooth(se = FALSE)+
  scale_y_log10()  

#price in the time range and customers
play %>% 
  filter(Type == "Paid", Reviews > 200, Group %in% c("Adults", "Teen")) %>% 
  mutate(year = year(`Last Updated`)) %>% 
  group_by(year, Group) %>% 
  summarise(price = median(Price)) %>% 
  ggplot(aes(year, price, col = Group))+
  geom_smooth(se = FALSE)+
  expand_limits(y = 0)+
  labs(y = "Year", x = "Median Price by year",
       title = "Apps for adults have been still noticed decreasing tendency")

#price in the time range and popular categories - table
play %>% 
  filter(Type == "Paid", Reviews > 200, 
         Category %in% c("FAMILY", "GAME", "MEDICAL")) %>%
  ggplot(aes(`Last Updated`, Price, col = Category))+
  geom_smooth(se = FALSE)+
  scale_y_log10()+
  labs(x = "Dates", title = "Medical apps with the strongest prices growth trend")


# which did category become more expensive --------------------------------

play %>% 
  filter(Type == "Paid", Reviews > 200) %>%
  mutate(year = year(`Last Updated`)) %>% 
  group_by(year, Category) %>% 
  summarise(price = median(Price, na.rm = TRUE)) %>% 
  pivot_wider(names_from = year, values_from = price) %>% 
  print(n = Inf) 
