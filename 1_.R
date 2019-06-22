a<-3
b<-4
a*b

# "%/%" = 몫을 구하는 것
# "%%" = remainder 를 구하는 것

# [변수] = '분석의 대상'
# [상수] = 바뀌지 않기 떄문에 '분석의 대상'이 아니다.
# R 에서 단일 값 ex) 100, 99, 이런 것을 모두 scalar 라고 한다.

# 데이터 품질, 속성, 분석용, 타입 총 4가지에 대해서 나눌수 있다.
# 속성에 따른 구분
# 

kor <- 100
mat <- 99
eng <- 100
avg <- (kor+mat+eng)/3

total <- c(30,40,50)
mean(total)

#=================================================
a<-0
b<-12
c<-'a'
d<-TRUE
f<-1
    
isTRUE(a)
isTRUE(b)   # 진짜 TRUE인지 물어 보는 함수이다.
isTRUE(c)
isTRUE(d)
isTRUE(f)

gender <- factor("m",c("m","f"))    #c 가 뒤에 있기 때문에 뒤에 것만 인식하고 level 2. "m", "f" 2개 있다.
gender1 <- factor(c("m","f"))       #c 때문에 vector형이며 && 2개이기 때문에 level 2. "m", "f" 2개 있다. 
gender2 <- factor("p","f")          #c 가 없으니까 no vector && 뒤에 것만 인식해서 level 1. "f"

vector_1 <- c(1,2,3,4,5)
vector_2 <- c(1,2,3,c(4,5,))        # vector 안에 vector를 넣는다고 차원이 늘어나지 않는다. 따라서 1,2번은 똑같다.
vector_3 <- c(1,2,3,c("a","b"))     # 문자를 섞어 쓰면 numeric type -> charactor type 으로 바뀐다.

# seq 의 방식 seq(from,to,by) 
vector_4 <- seq(1,12)               # by가 없으면 1개씩 한다. 
vector_5 <- seq(13)                 # 끝범위만 지정할 수 있다.
vector_6 <- seq(1,12,1)

length(vector_6)                    # 길이를 나타내는 method
NROW(vector_6)                      # 길이를 나타내는 method

3 %in% vector_6                     # 3 이라는 것이 vector 6안에 있는지 없는지 

# vector의 특징 중복
v1 <- c(2,2,2)                      # 단순 중복 허락한다.

v2 <- c(1,2,3,4)
v3 <- c(3,4,5,6)
intersect(v2,v3)                    # 교집합
setdiff(v2,v3)                      # 차집합
union(v2,v3)                        

rep(1:5,3)                          # 1 부터 5 까지 3번 반복 (x:y,횟수)

#=================================================
a <- 1
c <- 3
c + 8
c < "a"
# 문자열 연산은 cat 이라는 method 를 써서 사용한다.
cat(c, "8")

str1<-"a"
str2<-"b"

str3<-"'a'"                     # str3 = 'a' 다 
str4<-c("a","b","c")
print(str4)

kor<-80
math<-70
eng<-90

(kor+math+eng)/3

total_score <- c(80,70,90)
mean(total_score)
# mean(score_total)  =  sum(total_score)/length(total_score)
max(total_score)

#여기서 결과값을 또 다른 변수 하나에 넣어 놓을 수 있다.
mean_score<-mean(total_score)


#=================================================
str1 <- c('R','cran')
print(str1)                 # "R"   "cran"
paste(str1,collapse = "")  # 여기서 "," 를 붕괴 시켜서 출력값이 "Rcran"
#중요================================================= ggplot2 라는 시각화 
install.packages('ggplot2')
#plyr && reshape2 데이터 셋을 시각화 할때 전처리 역활 

library(ggplot2)
#하드디스크에 있는 패키지를 메모리에 올리는 명령어이다. library
View(iris)

install.packages('quantmod') # "xts", "zoo" 는 시계열 데이터를 분석할 떄 쓰는 패키지 이다 
library(quantmod)
View('AAPL')

getSymbols('AAPL') 
chartSeries(AAPL)
?chartSeries

# R 자체의 힘을 빌려서 만들어 보기 ~~
plot_ex <- c("a","b","c")
qplot(plot_ex)

#stata 처럼 요약 본 볼려면 summary() 중요 mpg 데이터 set은 mile per galin
summary(mpg)
mpg_cp<-mpg
View(mpg_cp)
qplot(data=mpg_cp, x = hwy) # hwy 변수를 지정해서 그래프 생성
# qplot로 그래픽화 하는데 문제가 없지만 size 적 문제가 생기면 frame, margin 함수를 이용하여 사이즈 맞춰 줘야함
qplot(data=mpg_cp, x = drv, y = hwy, geom='line')
qplot(data=mpg_cp, x = drv, y = hwy, geom='boxplot', colour=drv)

# 앞에 물음표를 붙이면 man qplot 과 같은 역활을 한다.
?qplot
?quantmod
