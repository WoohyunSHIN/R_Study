library(ggplot2)
View(mpg)

ggplot(data = mpg, aes(x = displ, y = hwy)) + geom_point()
# 점
ggplot(data = mpg, aes(x = cty, y = hwy)) + geom_ablin()
# 회귀선

ggplot(data = mpg, aes(x = displ, y = hwy)) +   # 1st layer : 배경
    geom_point() +                              # 2nd layer : 그래프 종류
    xlim(3,6) +                                 # 3rd layer : 세부 설정
    ylim(10,30)

library(dplyr)
df_mpg <- mpg %>%
    group_by(drv) %>%
    summarise(n = n()) 
# n() 함수를 이용하여 갯수를 반환한다.

ggplot(data = df_mpg, aes(x = drv, y = n)) + 
    geom_col() + 
    ylim(0,120)     # ylim(A, B) 이라는 함수

?geom_bar
# 막대그래프는 geom_bar 또는 geom_col 이 있다. 

# [ Description ] 
# There are two types of bar charts: geom_bar() and geom_col(). geom_bar() makes the height of 
# the bar proportional to the number of cases in each group (or if the weight aesthetic is supplied, 
# the sum of the weights). If you want the heights of the bars to represent values in the data, use geom_col() 
# instead. geom_bar() uses stat_count() by default: it counts the number of cases at each x position. 
# geom_col() uses stat_identity(): it leaves the data as is.

df_mpg <- mpg %>%
    group_by(drv) %>%
    summarise(mean_hwy = mean(hwy))

ggplot(data = df_mpg, aes(x = drv, y = mean_hwy)) + geom_col()

ggplot(data = df_mpg, aes(x = reorder(drv, -mean_hwy), y = mean_hwy)) + geom_col()

ggplot(data = mpg, aes(x = drv)) + geom_bar()

ggplot(data = mpg, aes(x = hwy)) + geom_bar()

# Quiz.1 p.193
df_mpg <- mpg %>% filter(class == "suv") %>% 
    group_by(manufacturer) %>% 
    summarise(mean_cty = mean(cty)) %>% 
    arrange(desc(mean_cty)) %>%
    head(df_mpg, n=5)

ggplot(data = df_mpg, aes(x = reorder(manufacturer, -mean_cty), y= mean_cty)) + geom_col()

# Quiz.2
df2_mpg <- mpg %>% 
    group_by(class) %>% 
    summarise(n=n())

ggplot(data = df2_mpg, aes(x = reorder(class,-n), y = n)) + geom_col()

#======================================================================================================
# [ ggplot2 패키지 구조 ]
#
# 산정도의 구조(예시)
# 관측치를 geom, Scale, Coordinate system 으로 표현한다.
# geom : 관측치를 점으로 표현한 것
# Scale : x축과 y축의 선형 스케일을 갖는 것.
# Coordinate : 직교 좌표계를 사용한다.
# 따라서 우리는 그림을 마치 계층으로 파악하는 것이 중요하다.
# 계속 위에 덧칠하는 느낌으로 접근하면 좋을 것 같다.

# [ ggplot2의 기본 성분 ]
# Data : 주로 데이터 프레임 객체 형태의 데이터
# Aesthetic Mappings : 데이터를 축, 색상 및 점의 크기 등으로 매핑하는 방법
# Geometric object : 점, 선, 도형고 같은 기하학적 객체          geom_path : 시계열그림그릴때 사용한다.
# Facetting : 조건부 플롯을 위해 패널을 분할하여 표현하는 방법
# Statistical transformation : 통계변환
# Scales : 데이터의 스케일을 동적으로 조정하여 어떤 시각적 요소를 사용할 것인가에 대한 정의
# Coordinate system : 좌표계
# Position adujustment : 위치의 조정

library(ggplot2)
View(mtcars)

p <- ggplot(mtcars, aes(wt, mpg, colour=cyl)) # "data =" , "x =", "y =" 생략가능하다. 
# Geometric object로 점 정의
p <- p + geom_point()
p

# geom_point() 함수
p_1 <- ggplot(mtcars, aes(wt,mpg))
p_1 <- geom_point()

p_2 <- ggplot(data=mtcars, aes(x=wt, y=mpg))
p_2 + geom_point(colour = "magenta", size = 6 )

# [ geom_abline() 함수 ]
# 플롯에 선을 추가하는 함수 geom_line()과는 다르다. 일반적인 선그래프가 아닌 선형회귀에서 절편과 기울기에 의해 그려지는 
# geometric 을 추가하여 회귀선이나 추세선을 그리는데 사용한다. 따라서 intercept 와 slope를 가지고 있다.

p_3 <- ggplot(mtcars, aes(wt,mpg))
p_3 + geom_abline()

mtcars_coefs <- coef(lm(mpg ~ wt, mtcars))
mtcars_coefs
?lm
# lm(formula, dataset)
# formula => dependent variable ~ independent variable
# ex) formula => y~ x1+x2+x3+...
summary(mtcars)

p_4 <- ggplot(data = mtcars, aes(x=wt, y=mpg))
p_4 <- p_4 + geom_point()
p_4 + geom_abline(intercept = mtcars_coefs["(Intercept)"], slope = mtcars_coefs["wt"], colour="red")

# 회귀선이나 추세선은 stat_smooth()기능으로도 가능하다
p_5 <- ggplot(data=mtcars, aes(x=wt, y=mpg))
p_5 <- p_5 + geom_point()
p_5 + stat_smooth(method="lm", se=FALSE, colour="red")

# [ geom_bar() 함수 ]
# 이름에서 유추할 수 있듯이 막대 그래프를 플로팅 하는 함수. 막대 그래프, 
# 누적(stacekd), 가로 방향등의 막대 그래프를 모두 그릴 수 있다.

p_6 <- ggplot(data=mtcars, aes(factor(cyl)))
p_6 + geom_bar()

p_6 + geom_bar(aes(fill=cyl), colour="black")       # fill = 채우겠다.

#가로 막대 그래프
p_6 <- p_6 + geom_bar(aes(fill=factor(gear)), colour = "black")
p_6 + coord_flip()

# [ geom_ribbon() 함수 ]
# 시계열을 그리면 선이 생기는데 그 아래의 영역을 채우는 플롯을 그리는 함수이다. geom_area()는 ribbon 함수의 특별한 형태이다.

library(datasets)
huron <- data.frame(year= 1875:1972, level = as.vector(LakeHuron))
View(huron)

p_7 <- ggplot(data=huron, aes(x=year))
p_7 <- p_7 + geom_area(aes(y=level))
p_7 + coord_cartesian(ylim=c(570,590))  #coord_cartesian(ylim=c(A,B)) coord_cartesian 안의 ylim 이기 때문에 combinaison 으로 묶는다.

library(quantmod)
getSymbols("AMZ", from=as.Date("2014-01-01"), to=as.Date("2018-06-01"))
# AMZ 데이터를 load한다. # getSymbols 함수는 : yahoo에 있는 링크로 접근하여 데이터를 가져온다.

amazon <- ggplot(AMZ, aes(x=index(AMZ), y=AMZ.Close))
# 1. x축과 y축을 잡아준다.

amazon <- amazon + geom_ribbon(aes(min=AMZ.Low, max=AMZ.High), fill="lightgreen", colour="black")
# 2. min 은 min 을 따라서 max 은 max 를 따라서 시계열 그래프를 그려주고, 사이 간격은 lightgrenn 색으로 채워준다.

amazon <- amazon + geom_point(aes(y=AMZ.Close), colour="black", size=5)
# 3. 사이즈 5짜리 점으로 마감장시 가격을 나타낸다.

amazon <- amazon + geom_line(aes(y=AMZ.Close), colour="blue")
# 4. 마감장시 가격을 파란색 선으로 이어준다.

amazon <- amazon + stat_smooth(method="loess", se=FALSE, colour="red", lwd=1.2)
# 5. loess
amazon

# "loess" : local regression, 변동성이 존재하는 시계열을 평활화 하기 위한 방법
# "se" : 신뢰구간 표현할 때 사용, 점 없이 선만 표시할때 F, FALSE 처리한다.
# "lwd" : 선 두께 조절

# [ geom_map() 함수 ]
# 지도 그리는 함수
install.packages('maps')
crimes <- data.frame(state = tolower(rownames(USArrests)), USArrests)
# tolower() : 다 소문자로 쓰겠다.

library(maps)
install.packages('mapproj')
library(mapproj)
states_map <- map_data("state")
# 미국의 위도, 경도 뽑아오기 
head(states_map)

library(reshape2)
crimesm <- melt(crimes, id=1)
# id=1 : 첫번쨰 행을 가만히 놓아두고 "열과 행이 서로 뒤바뀜이 생긴다" 

p <- ggplot(crimes, aes(map_id=state))
p <- p + geom_map(aes(fill=Murder), map=states_map)
p <- p + expand_limits(x=states_map$long, y=states_maps$lat)
# 3차원에서 미국지도 보는 것처럼 위도, 경도를 찍어서 나타낸다.

p + coord_map()
# 좌표계에 맵 함수를 찍어달라. 

# ggplot2의 map_data() 함수를 사용해도 된다.
# map : 제공되는 지도 이름, 보통 wolrd map 을 가장 많이 사용한다.
# region : 국가명 입력

# [ map_data() ]
# long => longitude 경도를 의미, x축 (x axis)
# lat => latitude 위도를 의미, y축 (y axis)
# group => 권역, polygon 형태, 국가 또는 아시아 권 대륙 등 area
# order => (매우중요) 좌표의 순번 개념
NE_Asia <- map_data(map = 'world',
                    region = c('Japon', 'South Korea', 'North Korea', 'China', 'Mongolia'))

NE_Asia_map <- ggplot(data = NE_Asia,
                  mapping = aes(x = long, y = lat, group = group)) +
                geom_polygon(fill =  'blue', color = 'black')
NE_Asia_map

# [ stat_density() 함수 ]
# 밀도곡선을 그리는 함수
p <- ggplot(diamonds, aes(x=price))
p <- p + stat_density(aes(ymax =..density.., ymin= -..density..),
                      fill='blue', colour='black', alpha=0.50,
                      geom = 'area', position = 'identity')
# alpha = 0.9로 갈수록 색갈이 진해지고 alpha 값이 0.1쪽으로 갈수록 색이 옅어진다.
p + facet_grid(.~cut)
p
p + facet_grid(cut~.)
p

# ..density.. 는 주어진 데이터를 밀도로 변환하는 작업을 수행한다.
# area 영역을 통해 플롯의 모양을 결정, 영역 플롯을 그림
# facet_grip는 플롯을 패싯별로 나누어 그리는 역활을 함

# scale_*_brewer()함수
# *에 들어갈 내용으로는 colour, color, fill 이 있다.
# http://colorbrewer2.org/ 에 가면 원하는 색상이 있다.

p_2 <- ggplot(data=diamonds, aes(price, carat, colour=clarity))
p_2 <- p_2 + geom_point()
p_2 + scale_color_brewer(type="seq", palette = 5)

# [ stat_ecdf() 함수]
# rnorm => 정규분포 함수 (gaussian distribution)
# rnorm(m, mean = 0, sd = 1)이 기본값 (난수 발생) # random normal distribution
# dnorm(m, mean = 0, sd = 1)이 기본값 (확률밀도 함수, pdf)  # density
# pnorm(m, mean = 0, sd = 1)이 기본값 (누적분포 함수, cdf)

df_ecdf <- data.frame(x = c(rnorm(100,0,2), rnorm(100,0,4)), g = gl(2,100))
summary(df_ecdf)

p_ecdf <- ggplot(df_ecdf, aes(x, colour =g))
p_ecdf + stat_ecdf(geom='line', size =2)

# gl : factor를 생성하는 함수 (Generate Facotr Levels)
# sample : 만약 랜덤하게 섞어서 데이터를 생성하고 싶을 경우 이용하는 함수이다.
# 주의할 점은 셔플한 경우, 그값은 벡터로 리턴되며, 데이터 프레임으로 변환을 따로 해주어야한다.
# shuffle_df <- dfecdf[sample(nrow(df_ecdf)), ]         # 행 몇개가지고 샘플링을 하겠다.
# shuffle_df <- as.data.frame(shuffle_df)
# p_ecdf <- ggplot(shuffle_df, aes(x, colour = g))
# p_ecdf + stat_ecdf(geom = 'line', size = 2)

# [ stat_function() 함수 ]
# 이름에서 처럼 y = f(x) 를 plotting 하는 것이다.
# 밀도 함수관련 그래프
# alpha값을 서로 다르게 조정하여 색상의 진하기 정도를 다르게 표현

set.seed(100)
d_f <- data.frame(x = rnorm(100,0,2))
p_f <- ggplot(d_f, aes( x = x)) # 난수 추출후 그래프
p_f <- p_f + geom_density(fill = 'blue', alpha = 0.4)
p_f + stat_function(fun = pnorm, colour = 'red', fill='green', alpha = 0.1, geom ='area') # 누적밀도 함수 그래프
#=======================================================================================================
# [ scale_alpha : 연속형 스케일로 투명도의 범위를 조절 ]
# scale_alpha_continuous : 연속형 스케일로 투명도의 범위를 조절
# scale_alpha_discrete : 이산화된 스케일로 투명도의 범위를 조절

p_scale <- ggplot(data=mtcars, aes(x=mpg, y=cyl, alpha = cyl))
p_scale <- p_scale + geom_point(size =10)
p_scale + scale_alpha(range=c(0.4,0.8))

# [ scale_linetype 함수 ]
# 선의 종류를 설정하는 함수이다. 그냥 사용시 이산형에만 적용가능하다. 
# 연속형은 scale_linetype_continuous를 사용해야함(잘 안됨, 쓰기도 힘듬)

library(reshape2)
library(plyr)

ecm <- melt(economics, id = "date")
str(ecm)
rescale01 <- function(x) (x-min(x)) / diff(range(x)) # R에서의 함수 방식
rescale02 <- function(x) (x-mean(x)) / sd(x)

# 단일 식의 경우 Java처럼 중괄호 생략가능
# rescale01 : 정규화 공식을 사용한 것
# rescale02 : 표준화 공식을 사용한 것
# diff(range()) : 퍼짐의 정도를 보는 것
# diff : 차분 함수(현재-직전), returns suitably lagged and iterated differences

ecm <- ddply(ecm, "variable", transform, value = rescale01(value))
# ddply 는 데이터프레임을 입력값으로 받아서 데이터프레임 형식으로 결과를 출력

p_ecm <- ggplot(data = ecm, aes(x=date, y = value, group=variable, linetype=variable, colour=variable))
# 그림그릴때 group, linetype, colour 는 항상 일치시켜준다고 생각하면 된다.
p_ecm <- p_ecm + geom_line() 
p_ecm + scale_linetype_discrete()
?scale_linetype_discrete
#=======================================================================================================
# 시계열의 경우
p_ecm2 <- ggplot(data=economics, aes(x = date, y = uempmed))
p_ecm2 + geom_path()

#=======================================================================================================
# 함수 만드는 방법 
함수명 <- function(x){
    return(x^2)
}
