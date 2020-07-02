library(tidyverse)
library(gridExtra)

url <- "https://raw.githubusercontent.com/nytimes/covid-19-data/master/us.csv"
statesurl <- "https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv"

#create data frames for US cases and State cases
covid <- read_csv(url)
covid_states <- read_csv(statesurl)

#function for finding numeric derivative of a time series,
#returns a vector of same length with the first value being "NA"
vec_deriv <- function(x){
  derivec <- numeric(length=length(x)-1)
  for (i in 1:length(derivec)){
    derivec[i] <- x[i+1]-x[i]
  }
  return(c(NA,derivec))
}

dcases <- vec_deriv(covid$cases)


# US nationwide cases plots
#ggplot(covid, aes(x=date, y=cases))+geom_line()+ggtitle("US \"probable cases\"")
p1 <- qplot(covid$date, dcases, geom = 'line')+
  ggtitle("US numeric derivative of cases")+
  labs(x="Date",y="New \"Probable Cases\"")

#oregon plots
oregon_cases <- covid_states %>%
  filter(state=="Oregon")%>%
  mutate(derivative = vec_deriv(cases))
#ggplot(oregon_cases)+
  geom_line(aes(x=date,y=cases))+
  ggtitle("Oregon Cases")
p2 <- ggplot(oregon_cases)+
  geom_line(aes(x=date,y=derivative))+
  ggtitle("Oregon Daily New Cases")+
  ylab("New \"Probable Cases\"")+
  xlab("Date")+
  geom_smooth(aes(x=date,y=derivative), 
              method="loess",
              se=FALSE,
              span=0.4,
              linetype=2)

gridExtra::grid.arrange(p1,p2)








