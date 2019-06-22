# [내가 한거]
master_df<- read.csv("***/suicide-rates-overview-1985-to-2016/master.csv")
View(master_df)

install.packages("dplyr")
library(dplyr)

View(master_df)

summary(master_df)
tail(master_df)

# 1. "크로아티아, 프랑스, 이탈리아, 독일, 노르웨이" 의 데이터만 전처리한다.
# 2. 1995년에서 2015 년 사이의 자료만 처리한다.

Europe_data_95to15 <- master_df %>% 
    select(country, year, suicides_no, population) %>%  
    filter(country == c("France","Norway","Italy","Germany","Croatia")) %>% 
    filter(year >= 1995 & year <= 2015) 

str(Europe_data_95to15)

Europe_data_95to15 %>% 
    group_by(country) %>% 
    group_by(year) %>% 
    summarise(population)


View(Europe_data_95to15)

i <- 1995

##############################################################################################
#[선생님]
suicide_rate <- read.csv("***/suicide-rates-overview-1985-to-2016/master.csv")
    names(suicide_rate) # 열 이름 출력하기
    
# [만약 country 의 이름이 이상하게 되어있다면] 
colnames(suicide_rate)[1] <- c("country") #한개만 줄바꿀 것

# [Check]
names(suicide_rate)

# 항상 구조부터 파악할 것 !!!!
str(suicide_rate)

#열 이름에 대한 것들을 찾아야 함
# country : 국가
# year : 연도
# sex : 성별
# age : 나이
# suicides_no : 사망자 수
# population: 해당 나이 대의 인구 수
# suicides.100k.pop : 인구 100000명 당 자살 사망자
# country.year :국가와 날짜 묶은 것
# HDI.for.year : 인간개발지수(세계은행에서 발표하는 것)
# gdp_for_year : 해당 국가의 gdp
# gdp_per_capita: 1인당 국내 총생산
# generation : 세대 구분
# 세대는 다음 자료 참고(미국 및 유럽에서의 세대 구분)
#https://namu.wiki/w/%EC%84%B8%EB%8C%80#s-2.2

#데이터 구조를 볼때 HDI에 결측치가 많이 있는 것으로 판단됨
NROW(suicide_rate) #데이터  27820
summary(suicide_rate)

# HDI.for.year는 결측치가 27820 중에서 19456개 만큼 있으므로 해당열은
# 분석에서 제거하기로 결정
# 또한 굳이 연도와 국가 열이 존재하는 상황에 country.year과 같은 전처리가 필요한
# 열은 시간 상 문제가 됨 따라서 제거

library(dplyr)
library(reshape2)

# 편의를 위해 데이터 명칭을 간단히 바꿈 .으로 연결된 명칭 또한 함수랑
# 헷갈릴 수 있으므로 변경, 마지막으로 경제자료는 항상 통화량 표시하는 것이
# 실수가 적음

data_s <- suicide_rate
data_s <- data_s %>% 
    select( -c("country.year","HDI.for.year"))

names(data_s)
data_s <- data_s %>% 
    rename(suicides_100k_pop = suicides.100k.pop,
           gdp_for_year = gdp_for_year....,
           gdp_per_capital = gdp_per_capita....)
# 주의할 것은 통화단위가 들어가는 것, 특히 $의 경우 열을 연결할 때 쓰는 $와 헷갈릴 수 있어서 
# 위의 경우 rename을 다른 열과 다르게 ' ' 로 묶어줌
names(data_s)

# 그룹별 통계, 두개 코드는 서로 값은 결과
View(data_s %>% 
         group_by(country) %>% 
         summarise(n=n()))

View(data_s %>% 
         group_by(year) %>% 
         count())

# 2016 년도 데이터가 너무 적으므로 제거
data_s <- data_s %>% 
    filter(year != 2016)
str(data_s)
View(data_s)

#이탈리아의 연 자살 파악
italy <- data_s %>% 
    select(country, year, sex, age, suicides_no, population, suicides_100k_pop) %>% 
    filter(country == "Italy") %>% 
    group_by(year) %>% 
    summarise(population = sum(population),
              suicides = sum(suicides_no))

View(italy)

# 그래프 그리기
library(ggplot2)
global_average <- mean(italy$suicides)
italy_plot <- ggplot(italy, aes(x=year, y=suicides)) + geom_line(col ='deepskyblue3', size =1) +
    geom_point(col = 'red', size=2) +
    geom_hline(yintercept = global_average, linetype = 3, color ='grey', size =2) +
    labs(title =' Suicides in Italy(Demographic)',
         subtitle = 'year 1985 - 2015',
         x ='Year',
         y = 'Suicide_no')

italy_plot

summary(data_s$country)

#######################################################################################
# 이탈리아 프랑스 독일 노르웨이 크로아티아 국가 자살률 통계
IFGNC_suicide <- data_s %>% 
    select(country, year, sex, age, suicides_no, population, suicides_100k_pop) %>% 
    filter (country == c("Italy", "France", "Germany", "Norway", "Croatia"))
View(IFGNC_suicide)

Five_Countries <- IFGNC_suicide %>% 
    group_by(country) %>% 
    summarise(suicides_100k_pop = sum(suicides_100k_pop)) %>% 
    arrange(desc(suicides_100k_pop))

# geom_bar 를 쓸때는 꼭 stat = "identity"를 꼭써주기!
plot_Five_Countires <- ggplot(Five_Countries, aes(x = country, y = suicides_100k_pop, fill=country)) +
    goem_bar(stat = "identity") +
    labs(title = "Compare 5 Europe Countries (suicide rate)",
         subtitle = "Per 100k",
         x = "Countries",
         y = "suicides per 100k")

over_time # 그냥 그리게 되면 서로 시간 길이가 안맞는다.

over_time <- over_time + scale_x_continuous(limits = c(1995,2015))
over_time

#위의 2개 그래프 합치기
install.packages('gridExtra')
library(gridExtra)
grid.arrange(plot_5, over_time, ncol=2)

######################################################################################
# [air_quality_Nov2017.csv ]
# datetime == Epoch & Unix Timestamp  Conversion Tools 에 .
air_qual<-read.csv("***/barcelona-data-sets/air_quality_Nov2017.csv")

# anytime 패키지를 쓰면 시간변환에 가능한 모든 작업이 가능하다.
install.packages("anytime")
library(anytime)
air_qual$new_gen <- anytime(air_qual$Date.Time)
View(air_qual)
######################################################################################
library(ggplot2)
here<-read.csv("***/barcelona-data-sets/accidents_2017.csv")
View(here)

use <- here %>% 
    select("Weekday","Victims") %>% 
    group_by(Weekday) %>% 
    summarise(Total_Victims = sum(Victims))

p <- ggplot(use, aes(x=Weekday, y=Victims)) +
    geom_bar(stat = "identity")

######################################################################################
#[ factor 요소중 한개의 이름을 바꾸고 싶을때 ]

library(datasets())
View(iris)
str(iris)

levels(iris$Species)[match("setosa", levels(iris$Species))] <- "ppap"
iris$Species<-as.character(iris$Species)
str(iris)

# [문자열 "ppap"를 "setosa"로 모두 대체 할때]
iris$Species[iris$Species == "ppap"] <- "setosa"

####################################################################
#[ 통계 ]
#Sample z Test
#패키지 없이 진행할 경우
library(datasets())
iris<- iris
NROW(iris$Sepal.Length)

#수식을 작성해야한다. 
#https://ko.wikipedia.org/wiki/%ED%91%9C%EC%A4%80_%EC%A0%90%EC%88%98
#iris 150개 샘플을 토대로 평균과 공식을 이용한 z 값
#5.4의 z값은?
sd_1 <- sd(iris$Sepal.Length)
ZValue <- (5.4 - mean(iris$Sepal.Length))/(sd_1/sqrt(150))

#패키지를 사용한다면? 답은 BSDA
install.packages('BSDA')
library(BSDA)
z.test(x=iris$Sepal.Length, alternative = 'greater',
       sigma.x = sd_1, mu = mean(iris$Sepal.Length))
#alternative 는 양쪽 또는  한쪽인가에 대한 정의
#conf.level 인수는 신뢰구간 설정 90% 95% 99%

#t-test BSDA 계속 사용
vol <- c(151,153,152,152)
t.test(x=vol, mu=150, conf.level=0.95)

install.packages('visualize')
library(visualize)
visualize.t(stat=c(-4.899,4.899), df=3, section='tails')

#One Sample Variance Test - Chi Square
install.packages('EnvStats')
library(EnvStats)
var(iris$Sepal.Length)
varTest(x=iris$Sepal.Length, sigma.squared=sd_1, alternative='greater')


crit <- qchisq(p=0.05, df=49, lower.tail = F)
crit

x <- seq(1,250, by=1)
y <- dchisq(x, 149)

plot(y, type='l', xlab='Chi sq', ylab='f(chi sq)')


#상관분석
attach(mtcars)
cor(wt, mpg) #equivalent to cov(wt, mpg)/(sd(wt)*sd(mpg))

#왜도, 첨도
install.packages('psych')

library(psych)

skew(mtcars$mpg)

kurtosi(mtcars$mpg)

#Paired t Test
bp.before <- c(120,122,143,100,109)
bp.after <- c(122,120,141,109,109)
t.test(x=bp.before, y=bp.after, paired=T)
bp.diff <- bp.after-bp.before
boxplot(bp.diff, main='Effect of medicine on BP', ylab='Post medicine-BP Difference')

#Two sample variance Test - F Test
mca <- c(150,150,151,149,151,151,148,151)
sd(mca)

mean(mca)

mcb <- c(152,146,152,150,155)
var(mcb)

mean(mcb)
var.test(x = mca, y= mcb, ratio=1, conf.level = 0.90)

Fcrit <- qt(p =0.05, df1 = 4, df2 = 7, lower.tail = F)

install.packages('Hmisc')
#spearman correlation
library(Hmisc)
rcorr(iris$Petal.Length, iris$Petal.Width, type='pearson')$r

#Fisher's Test
group<-c("A","A","B","B")
cancer<-c("1.Yes","2.No","1.Yes","2.No")
count<-c(2,28,5,25)
data1<-data.frame(group,cancer,count)
tab<-xtabs(count~group+cancer,data=data1)
tab
fisher.test(tab)


