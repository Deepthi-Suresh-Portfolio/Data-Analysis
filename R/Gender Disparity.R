library(ggplot2)
library(readxl)
library(tidyverse)
library("RColorBrewer")
library(scales) # percent sign
library(reshape2)



###Weekly earnings by industry by sex
industry <- read_excel("weekly earning by industry by sex.xlsx",skip = 1)

##Data preprocessing
  #converting to longer form - 
industry <- industry %>% pivot_longer(cols = Males:Females, 
             names_to = "Gender", 
             values_to = "Weekly_earnings") 


  # calculating the difference between the pay of men and women in different industry
industry_diff <- industry %>%
  spread(Gender, Weekly_earnings) %>%
  mutate(Difference = abs(Males - Females)) %>%
  arrange(desc(Difference))

  #converting to factor variables to reorder
industry$Industry <- factor(industry$Industry,levels = industry_diff$Industry, ordered = TRUE)
industry$Gender <- factor(industry$Gender)

  #Plot construction
#p <- ggplot(data = industry, aes(y = reorder(Industry,Weekly_earnings), x =Weekly_earnings, fill = Gender ))
p <- ggplot(data = industry, aes(y = Industry, x = Weekly_earnings, fill = Gender))
p + 
  geom_bar( stat='identity', position = 'dodge')  +
  geom_text(aes(label = Weekly_earnings ),vjust = 0.4, colour = "black",
            hjust = -0.1,position = position_dodge(width =1.0),size = 3)+
  labs(
    title = "Weekly earnings by industry by sex",
    x = "Weekly earnings",
    y = "Industry",
    caption = str_wrap("Data Source: Australian Bureau of Statistics. (2023, May). Employee Earnings and Hours, Australia. ABS. https://www.abs.gov.au/statistics/labour/earnings-and-working-conditions/employee-earnings-and-hours-australia/latest-release.)"),
    subtitle = "
    Weekly earning by industry is the highest in the mining industry followed by the Electricity, gas, water and waste services. 
    However, there is a pay gap between the male and female employees in every industry, with the highest noticeable difference in Administrative and support services industries, 
    followed by Construction.The lowest pay gap according to the ABS data is in the Education and training industry, 
    followed by Accommodation and food services industry."
  )+
  theme_minimal()+
  theme(
    plot.title = element_text(size = 20, face = "bold",hjust = 0.5),
    plot.subtitle = element_text(face = "italic",hjust = 0.5),
    plot.caption = element_text(face = "italic")
  )+
  scale_fill_manual(values = c("Males"= "#cab2d6","Females"= "#FFDB6D"))

###Chart of managerial positions

manager <- read_excel("wgea_workforce_composition_2023.xlsx", 
                      sheet = "Sheet2")


#converting to longer form - 
manager <- manager %>% pivot_longer(cols = Men:Women, 
                                      names_to = "Gender", 
                                      values_to = "percent") 

# calculating the difference between the no of men and women in different industry
manager_diff <- manager %>%
  spread(Gender, percent) %>%
  mutate(Difference = abs(Men - Women)) %>%
  arrange(desc(Difference))

manager$Industry <- factor(manager$Industry,levels = manager_diff$Industry,ordered = TRUE)
manager$Gender <- factor(manager$Gender)

p <- ggplot(data = manager, aes(y = reorder(Industry,percent), x = percent, fill = Gender))
p + 
  geom_bar( stat='identity', position = 'dodge')  +
  geom_text(aes(label = scales::percent(percent, accuracy = 0.01)),vjust = 0.4, colour = "black",
            hjust = -0.1,position = position_dodge(width =1.0),size = 3)+
  labs(
    title = "Gender Dynamics Across Industries",
    x = "Percentage of workers",
    y = "Industry",
    caption = str_wrap("Data Source: Workplace Gender Equality Agency (WGEA). (2024, January 8). WGEA Dataset - data.gov.au. https://data.gov.au/data/dataset/wgea-dataset"),
    subtitle = "
    Construction emerges as a male-dominated sector, contrasting with Healthcare, which predominantly employs females.Agriculture, Forestry and Fishing industries and Mining  
    industries have over 50% more males than females,while on the other hand Accommodation and Food Services, Administrative and Support Services  and Retail Trade industries 
    display a minimal gender divide, with less than a 10% difference in composition"
  )+
  theme_minimal()+
  theme(
    plot.title = element_text(size = 20, face = "bold",hjust = 0.5),
    plot.subtitle = element_text(face = "italic",hjust = 0.5),
    plot.caption = element_text(face = "italic")
  )+
  scale_x_continuous(labels = scales::percent_format(accuracy = 1)) +
  scale_fill_manual(values = c("Men"= "#cab2d6","Women"= "#FFDB6D"))

#+scale_fill_brewer(palette = "Set1")

## Heatmap of gender pay gap in industry
pay_gap <- read_excel("weekly earning by industry by sex.xlsx", 
                      sheet = "pay gap", skip = 1)
#converting to longer form - 
pay_gap1 <- pay_gap %>% pivot_longer(cols = Males:Females, 
                                      names_to = "Gender", 
                                      values_to = "Weekly_earnings") 
pay_gap1 <- melt(pay_gap)

ggplot(pay_gap, aes(y = Industry, x = 1, fill = paygap)) +
  geom_tile() +
  labs(
    title = "Pay Gap by Industry",
    x = "Pay Gap",
    y = "Industry",
    subtitle = "The pay gap percentage between males and females across different industries",
    caption = "Data Source: Australian Bureau of Statistics. (2023, May). 
    Employee Earnings and Hours, Australia. ABS. https://www.abs.gov.au/statistics/labour/earnings-and-working-conditions/employee-earnings-and-hours-australia/latest-release.)"
  ) +
  scale_fill_gradient(low = "lightblue", high = "darkblue", name = "Pay Gap (%)",labels = scales::percent_format(accuracy = 1))+
  theme_minimal() +
  geom_text(aes(label = scales::percent(paygap, accuracy = 0.01)),vjust = 0.4, colour = "white",
            hjust = -0.1,position = position_dodge(width =1.0),size = 5, fontface = "bold") +
  theme(
    plot.title = element_text(size = 30, face = "bold",hjust = 0.5),
    plot.subtitle = element_text(face = "italic",hjust = 0.5,size = 18),
    plot.caption = element_text(face = "italic",hjust = 1,size = 10),
    axis.text.y = element_text(face = "bold",size = 15),
    axis.title = element_text(face = "bold",size = 10))+
      scale_x_continuous(labels = label_number(),expand = c(0, 0))

##total level leadership

leader <-read_excel("wgea_workforce_composition_2023.xlsx", 
                    sheet = "R file - manager")
leader <- leader %>%
  pivot_longer(cols = c(Men, Women), names_to = "Gender", values_to = "Numbers")

summary_stats <- leader %>% # to label the medians and quartiles
  group_by(Gender) %>%
  summarise(
    Median = median(Numbers),
    Q1 = quantile(Numbers, 0.25),
    Q3 = quantile(Numbers, 0.75)
  )

#finding outliers
findoutlier <- function(x) {
  return(x < quantile(x, .25) - 1.5*IQR(x) | x > quantile(x, .75) + 1.5*IQR(x))
}

leader <- leader %>% 
  group_by(Gender) %>%
mutate(outlier = ifelse(findoutlier(Numbers), Industry, NA))

p <- ggplot(leader, aes(x = Gender, y = Numbers, fill = Gender)) +
  geom_boxplot() +
  labs(
    title = "Gender Distribution in Leadership positions across Industries",
    x = "Gender",
    y = "Count",
    subtitle = "Men outnumber women in leadership positions across industries by 102.5%, with 12464 men compared to 6143 women.",
    caption = "Data Source: Workplace Gender Equality Agency (WGEA). (2024, January 8). WGEA Dataset - data.gov.au. https://data.gov.au/data/dataset/wgea-dataset"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 30, face = "bold",hjust = 0.5),
    plot.subtitle = element_text(face = "italic",hjust = 0.5,size = 18),
    plot.caption = element_text(face = "italic",hjust = 1,size = 10),
    axis.text.x = element_text(angle = 0, hjust = 0.5),
    legend.position = "none",
    axis.title = element_text(face = "bold",size = 10))+
  geom_text(data = summary_stats, aes(x = Gender, y = Median, label = paste0("Median: ", Median)), vjust = -0.5, size = 5, fontface = "bold", color = "black") +
  geom_text(data = summary_stats, aes(x = Gender, y = Q1, label = paste0("Q1: ", Q1)), vjust = -0.5, size = 5, fontface = "bold", color = "black") +
  geom_text(data = summary_stats, aes(x = Gender, y = Q3, label = paste0("Q3: ", Q3)), vjust = -0.5,hjust =1.2, size = 5, fontface = "bold", color = "black")+
  geom_text(aes(label=outlier), na.rm=TRUE, hjust=-0.1, size = 6)+
  scale_fill_manual(values = c("Men"= "#cab2d6","Women"= "#FFDB6D"))
p

### Movement chart

movement <-read_excel("wgea_workforce_management_statistics_2023.xlsx", 
                      sheet = "movement")

movement <- movement %>%
  pivot_longer(cols = 3:5, names_to = "Leave_type", values_to = "Numbers")

top_movement <- movement %>%
  filter(Industry %in% c("Administrative and Support Services", "Rental, Hiring and Real Estate Services", "Transport, Postal and Warehousing", "Construction"))

#top industries
ggplot(top_movement, aes(x = Industry, y = Numbers, fill = gender)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Gender Dynamics in Parental, Primary Care and Secondary Care Leave Across top 4 industries with highest Pay Gap",
       x = "Industry", y = "No of employees", fill = "Gender",
       subtitle = "Across industries, women often cease their employment once they become parents. Women often undertake more caregiving responsibilities, 
       leading to differences in leave utilization between men and women",
       caption = "Data Source: Workplace Gender Equality Agency (WGEA). (2024, January 8). WGEA Dataset - data.gov.au. https://data.gov.au/data/dataset/wgea-dataset") +
  facet_wrap(~factor(Leave_type), scales = "free_y", ncol = 1) +
  theme_minimal()+
  scale_fill_manual(values = c("Men"= "#cab2d6","Women"= "#FFDB6D"))+
  geom_text(aes(label = Numbers),position = position_dodge(width = 0.9))+
  theme(
    plot.title = element_text(size = 15, face = "bold",hjust = 0.5),
    plot.subtitle = element_text(face = "italic",hjust = 0.5,size = 10),
    plot.caption = element_text(face = "italic",hjust = 1,size = 10),
    axis.title = element_text(face = "bold",size = 10),
    axis.text.x = element_text(face = "bold", hjust = 0.5))

#bottom industries
bottom_movement <- movement %>%
  filter(Industry %in% c("Accommodation and Food Services","Retail Trade", "Arts and Recreation Services", "Education and Training"))
  

ggplot(bottom_movement, aes(x = Industry, y = Numbers, fill = gender)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Gender Dynamics in Parental, Primary Care and Secondary Care Leave Across bottom 4 industries with lowest Pay Gap",
       x = "Industry", y = "No of employees", fill = "Gender",
       subtitle = "While primary carers leave is often associated with women, secondary carers leave is associated with men.Retail Trade industry shows significantly higher numbers in the employment 
       cessation during parental leave among women ",
       caption = "Data Source: Workplace Gender Equality Agency (WGEA). (2024, January 8). WGEA Dataset - data.gov.au. https://data.gov.au/data/dataset/wgea-dataset
       Public Administration and Safety has not been included in the plot due to the low data availability") +
  facet_wrap(~factor(Leave_type), scales = "free_y", ncol = 1) +
  theme_minimal()+
  scale_fill_manual(values = c("Men"= "#cab2d6","Women"= "#FFDB6D"))+
  geom_text(aes(label = Numbers),position = position_dodge(width = 0.9))+
  theme(
    plot.title = element_text(size = 15, face = "bold",hjust = 0.5),
    plot.subtitle = element_text(face = "italic",hjust = 0.5,size = 10),
    plot.caption = element_text(face = "italic",hjust = 1,size = 10),
    axis.title = element_text(face = "bold",size = 10),
    axis.text.x = element_text(face = "bold", hjust = 0.5))  
 
## manager by industry

leadership <- manager %>%
  filter(Industry %in% c("Administrative and Support Services", "Rental, Hiring and Real Estate Services", "Transport, Postal and Warehousing", "Construction","Accommodation and Food Services","Retail Trade", "Arts and Recreation Services", "Education and Training" ))

leadership$Industry <- factor(leadership$Industry, levels = c("Administrative and Support Services", "Rental, Hiring and Real Estate Services", "Transport, Postal and Warehousing", "Construction","Accommodation and Food Services","Retail Trade", "Arts and Recreation Services", "Education and Training"), ordered = TRUE)

p <- ggplot(data = leadership, aes(y = Industry, x = percent, fill = Gender))
p + 
  geom_bar( stat='identity', position = 'dodge')  +
  geom_text(aes(label = scales::percent(percent, accuracy = 0.01)),vjust = 0.4, colour = "black",
            hjust = -0.1,position = position_dodge(width =1.0),size = 3)+
  labs(
    title = "Gender Disparity in leadership roles Across Industries with highest and lowest pay gap",
    x = "Percentage of workers",
    y = "Industry",
    caption = str_wrap("Data Source: Workplace Gender Equality Agency (WGEA). (2024, January 8). WGEA Dataset - data.gov.au. https://data.gov.au/data/dataset/wgea-dataset"),
    subtitle = "
    Industries with the highest pay gap is marked in black, whereas the industries with lower pay gap are marked in blue. There is a clear difference in the 
    no of leadership roles occupied by the male and female in the indusrties with low gender pay gap and high gender pay gap"
  )+
  theme_minimal()+
  theme(
    plot.title = element_text(size = 20, face = "bold",hjust = 0.5),
    plot.subtitle = element_text(face = "italic",hjust = 0.5),
    plot.caption = element_text(face = "italic"),
    axis.text.y = element_text(face = "bold",
      colour = ifelse(levels(leadership$Industry) %in% c("Accommodation and Food Services","Retail Trade", "Arts and Recreation Services", "Education and Training"), "blue", "black")
  ))+
  scale_x_continuous(labels = scales::percent_format(accuracy = 1)) +
  scale_fill_manual(values = c("Men"= "#cab2d6","Women"= "#FFDB6D"))
