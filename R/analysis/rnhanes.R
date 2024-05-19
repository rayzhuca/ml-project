library(RNHANES)
library(qeML)

# Predict smoking status based on demographics

########################################

# DUQ200 - Ever used marijuana or hashish
# Variable Name:DUQ200SAS Label:Ever used marijuana or hashishEnglish Text:The following questions ask about use of drugs not prescribed by a doctor. Please remember that your answers to these questions are strictly confidential. The first questions are about marijuana and hashish. Marijuana is also called pot or grass. Marijuana is usually smoked, either in cigarettes, called joints, or in a pipe. It is sometimes cooked in food. Hashish is a form of marijuana that is also called 'hash.' It is usually smoked in a pipe. Another form of hashish is hash oil. Have you ever, even once, used marijuana or hashish?Target:Both males and females 18 YEARS - 59 YEARS
# Code or Value	Value Description	Count	Cumulative	Skip to Item
# 1	Yes	1774	1774	
# 2	No	1559	3333	DUQ240
# 7	Refused	7	3340	DUQ240
# 9	Don't know	4	3344	DUQ240
# .	Missing	1452	4796	

# RIAGENDR - Gender
# Variable Name:RIAGENDRSAS Label:GenderEnglish Text:Gender of the participant.Target:Both males and females 0 YEARS - 150 YEARS
# Code  Value Description
# 1 	Male
# 2 	Female
# . 	Missing

# RIDAGEYR - Age in years at screening
# Variable Name:RIDAGEYRSAS Label:Age in years at screeningEnglish Text:Age in years of the participant at the time of screening. Individuals 80 and over are topcoded at 80 years of age.Target:Both males and females 0 YEARS - 150 YEARS
# Code  Value Description
# 0 to 79	Range of Values
# 80  	  80 years of age and over	
# .	      Missing	

# RIDRETH3 - Race/Hispanic origin w/ NH Asian
# Variable Name:RIDRETH3SAS Label:Race/Hispanic origin w/ NH AsianEnglish Text:Recode of reported race and Hispanic origin information, with Non-Hispanic Asian CategoryTarget:Both males and females 0 YEARS - 150 YEARS
# Code Value Description
# 1	  Mexican American	
# 2	  Other Hispanic	
# 3	  Non-Hispanic White	
# 4	  Non-Hispanic Black
# 6	  Non-Hispanic Asian	
# 7	  Other Race - Including Multi-Racial
# .	  Missing


# DMDEDUC3 - Education level - Children/Youth 6-19
# Variable Name:DMDEDUC3SAS Label:Education level - Children/Youth 6-19English Text:What is the highest grade or level of school {you have/SP has} completed or the highest degree {you have/s/he has} received?English Instructions:HAND CARD DMQ1 READ HAND CARD CATEGORIES IF NECESSARY ENTER HIGHEST LEVEL OF SCHOOLTarget:Both males and females 6 YEARS - 19 YEARS
# Code or Value Description	
# 0	      Never attended / kindergarten only	
# 1	      1st grade	
# 2	      2nd grade	
# 3	      3rd grade	
# 4	      4th grade	
# 5	      5th grade	
# 6	      6th grade	
# 7	      7th grade	
# 8	      8th grade	
# 9	      9th grade	
# 10	    10th grade	
# 11	    11th grade	
# 12	    12th grade, no diploma	
# 13	    High school graduate	
# 14	    GED or equivalent	
# 15	    More than high school	
# 55	    Less than 5th grade	
# 66	    Less than 9th grade	
# 77	    Refused
# 99	    Don't Know	
#   .	    Missing	7157	

########################################

# load data
df <- nhanes_load_data("DUQ_G", "2011-2012", demographics = TRUE)

# keep relevant columns
df <- df[c("DUQ200", "RIAGENDR", "RIDAGEYR", "RIDRETH3", "DMDEDUC3")]


# drop na rows and other data cleaning
df <- df[complete.cases(df), ]
df <- df[which(df$DUQ200 == 1 | df$DUQ200 == 2), ]
df <- df[which(df$DMDEDUC3 != 77 & df$DMDEDUC3 != 99 & df$DMDEDUC3 != '.'), ]

# separate df for male and female
df_male <- df[which(df$RIAGENDR == 1), ]
df_female <- df[which(df$RIAGENDR == 2), ]

df_male <- subset(df_male, select = -c(RIAGENDR))
df_female <- subset(df_female, select = -c(RIAGENDR))


# fit polynomial regression
model_male <- qePolyLin(df_male, "DUQ200")
model_female <- qePolyLin(df_female, "DUQ200")

print(predict(model_male, data.frame("RIDAGEYR" = 50, "RIDRETH3" = 1, "DMDEDUC3" = 12)))
print(predict(model_female, data.frame("RIDAGEYR" = 50, "RIDRETH3" = 1, "DMDEDUC3" = 12)))

# get difference as a function
f <- function(age, race, edu) {
   p <- data.frame("RIDAGEYR" = age, "RIDRETH3" = race, "DMDEDUC3" = edu)
   predict(model_male, p) - predict(model_female, p)
}

# testing
newton_directory = "newton.R" # CHANGE
source(newton_directory)
z <- root(f, 3, 0.01, max_iter = 100000000)
print("Found a zero point")
print(z)
z <- data.frame("RIDAGEYR" = z[1], "RIDRETH3" = z[2], "DMDEDUC3" = z[3])

print("Male vs female prediction at the zero point")
print(predict(model_male, z))
print(predict(model_female, z))