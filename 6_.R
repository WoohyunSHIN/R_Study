# 분석 결과를 저장할 때 cat()을 이용할 수 있다.
library(ggplot2)
irisSummary <- summary(iris)
cat("iris 데이터 요약 :", "\n", irisSummary, "\n", file = "summary.csv", append = TRUE)
# apply 계열 함수를 이용하면 데이터에 함수를 적용시킨 결과를 얻을 수 있다.
setosaData <- subset(iris, select=c(3:4), subset=iris$Species =="setosa") # setosa 중에서 3번째 4번째 열만 뽑았다

# x: 대상 자료 객체(행렬, 배열)
# MARGIN : 차원을 입력, 숫자가 1이면 행별, 2면 열별, 3이면 차원별 함수 적용
# 만약 c(1,2)로 작성할 경우, (행, 열) 별로 함수를 적용
# FUN : 적용할 함수 이름
apply(setosaData, 2, mean)  # 2 의 뜻은 열별로 뭔가를 하겠다 라는 말임 
apply(setosaData, 2, sum)

library(dplyr)
df_setosaData1 <- iris %>% 
    select(Petal.Length, Petal.Width, Species) %>% 
    filter(iris$Species == "setosa") %>% 
    group_by(Species) %>% 
    summarise(mean_Length = mean(Petal.Length), mean_Width = mean(Petal.Width))

# [ lapply ]
# list apply로 lapply() 함수로 리스트에 지정한 함수를 적용
# list 객체를 생성, 결과를 리스트 형태로 반환
# x : 함수를 적용할 벡터 또는 리스트 객체
# FUN : 적용할 함수 이름
# ... : 함수에서 사용할 인수들
x <- list(a=1:10, beta=exp(-3:3), logic=c(TRUE,FALSE,TRUE,NA))
lapply(x, mean, rm.na=T)                # 일괄적으로 동일한 함수를 적용해버리겠다.
lapply(x, quantile, probs=c(1:3)/4)     # Java 의 class 안에 method 를 써서 호출해 오는거랑 같은 것이다.
# quantile 함수의 probs 인수이다.

# [ sapply ]
# simplification apply, lapply() 함수와 유사하지만 리스트 대신 , 행렬, 벡터등으로 결과를 반환하는 함수
# x : 대상 리스트 객체
# FUN : 적용할 함수 이름 
# ... : 함수에서 사용할 인스, 앞의 FUN 쪽에서 입력한 함수의 인수를 적어야함 
sapply(x,quantile, na.rm=T)

# [ mapply ]
# (가장 중요) sapply 와 유사하지만 "다수의 인자"를 함수에 넘긴다는 데서 차이가 있다.
# 첫번째 인자로 FUN이 적용된다.
# MoreArgs 함수에 전달할 다른 인자 목록입니다.
# USE.NAMES : TRUE (기본값) 이면 이름 속성도 반환합니다. FALSE 이면 이름 속성없이 반환합니다.
mapply(rep, 1:4, 4:1)

# Quiz
job <- c(3,3,5,2,2,3,5,3,4,4,6,3)
income <- c(4879, 6509,4183,0,3884,0,3611,6454,4975,8780,0,4362)
cust <- data.frame(job,income)
income.avg <- c(862,0,3806,3990,3891,3359,3556,2199,227)
names(income.avg) <-0:8     #jobid 매칭
# < income.avg 구조 >
# 0     1     2     3     4     5     6     7     8     === jobid
# 862   0     3806  3990  3891  3359  3556  2199  227   === income.avg

# 만약 income 열에 0 값이 있다면 jobid 매칭을 통해 해당 income.avg 값으로 대체

alter_zero_to_mean <- function(job,income){
    if(income==0){
        return(income.avg[job+1])
    }
    else{
        return(income)
    }
}

cust$income_new <- mapply(alter_zero_to_mean, cust$job, cust$income)
cust

# [ tapply ]
# 데이터를 그룹화 하여 집계하는 것은 분석에 있어서 중요한 일!!!
# tapply()는 그룹별 처리를 위한 apply 함수
# x : 대상 리스트 객체
# INDEX : x와 같은 길이의 하나 이상의 범주형 (factor) 목록입니다.
# FUN : 적용할 함수, 만약 null값이면 벡터를 리턴
# simplify : TRUE 이면 FUN 이 항상 스칼라를 반환하면 tapply 는 스칼라모드의 배열을 반환
# FALSE 이면 tapply는 항상 list 모드의 배열을 리턴

iris<-iris
tapply(iris$Sepal.Length, iris$Species, mean)

# Quiz
job <- c(3,3,5,2,2,3,5,3,4,4,6,3)
job <- factor(job, levels = c(0:8))
str(job)
income <- c(4879, 6509,4183,0,3884,0,3611,6454,4975,8780,0,4362)

tapply(income, job, mean)
tapply(income, job, mean, default=-1)

# tapply는 한번에 여러 열에 대한 집계 연산을 수행할 수 없다.
# 따라서 보완하기 위한 by가 필요
by(iris[,1:4], iris[,"Species"], sum)

#데이터 구조 변경
install.packages("reshape2")
library(reshape2)

# [ melt() ]
# 열 이름과 값을 (variable, value) 열에 저장된 형태로 변환하는 함수를 제공
# 열(이름) => 행(이름) 

# data : melt할 데이터 셋
# ... : 함수에 전달할 인수
# na.rm : 결측치 제거, 만약 FALSE(기본값)이면 NA값도 재구조화에 사용
# value.name : 값을 저장하기 위해 사용할 변수의 이름

airquality.melt <- melt(airquality, id=c("Month","Day"), na.rm=TRUE)
head(airquality.melt)

# [ cast() ]
# molten 데이터 프레임을 배열 또는 데이터 프레임으로 캐스팅 합니다.
# dcast 와 acast로 나뉘며 dcast는 캐스팅 결과가 데이터프레임 타입으로 나옵니다.
# acast 는 캐스팅 결과 타입이 벡터 행렬 또는 배열로 나옵니다
# cast 를 사용하면 variable 에서 반복 되는 부분을 해결해 준다.
reshape.cast <- dcast(airquality.melt, Month + Day ~ variable, fun.aggregate = NULL)
head(reshape.cast)

# =================================================================================================
# [ R + SQL = sqldf ]
# R에서 SQL 문법을 쓰다.
install.packages("sqldf")
library(sqldf)
View(iris)
R_sql <- sqldf('
               select avg("Sepal.Length") as "mean_SL",         
                      avg("Sepal.Width") as "mean_SW",
                      Species 
               from iris 
               group by Species 
               order by Species ')
R_sql                      
# avg() : SQL 에서 평균구하는 함수이다.
# order by : 알파벳 순서로 정렬시킨다.

# sqldf 의 경우 다수의 함수 (sum, count, avg, variance, stdev) 을 그룹변수에 대해 구분하여 집계할 때 편하다.
# 항상 장점만 있는 것은 아니다, quantile 은 dplyr를 이용하여 구하는 것이 더 편하다.

# SQL 문장은 대/소문자 구별을 하지 않음
# SQL 문장은 한줄 이상일 수 있음
# 절은 대개 줄을 나누어 사용

# [ 모든 열 선택 ]
iris_sql <- sqldf('
                  select *
                  from iris
                  ')

# [ 특정 열 선택 및 계산 ]
# Sepal.Length의 110% 수치
iris_sql_1 <- sqldf('
                    select "Sepal.Length", "Sepal.Length" + "Sepal.Length"*0.1
                    from iris
                    ')

# 특정 범위에 해당하는 행을 출력하기 위한 Between 연산자
# 하한 값을 먼저 명시해야한다.
iris_sql_2 <- sqldf('
                    select "Sepal.Length"
                    from iris
                    where "Sepal.Length" between 4.8 and 5.2
                    ')
# where 은 집계 함수를 못쓴다. 따라서 group by & having 을 사용한다.

# 데이터 정렬
iris_sql_3 <- sqldf('
                    select "Sepal.Length", "Petal.Length"
                    from iris
                    order by "Petal.Length"
                    ')

# 데이터 import 후 sqldf 적용해보기
# where 절은 filter와 비슷하며 where절에 그룹함수를 사용하여 제한할 수 없음.
chest <- read.csv("....")

# 문제 : 고객 중에서 하루동안 소비한 chest의 타입과 그 개수를 날짜별, 고객별로 정리하세요
chest_sql <- sqldf('
                   select "date", "mid", "type", count("type")
                   from chest
                   group by "date", "mid", "type"
                   having count("type") > 6
                   ')



#SQL의 서브쿼리 문도 수행가능, 서브쿼리란, sql내 또다른 sql 안에 있는 형태
data()
library(datasets())
View(Orange)

orange_sql <- sqldf('
                    select "age", "circumference"
                    from (select *
                        from Orange
                        where "Tree" = 1)
                    ')
