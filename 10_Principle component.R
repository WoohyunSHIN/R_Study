##############################################################################
# 데이터 샘플링 !!
install.packages("doBy")
library(doBy)

# 비복원, 임의추출
sampleBy(~Species, data=iris, frac=0.1)
# 형식은 "~ + factor형 변수"

# 복원 추출
sampleBy(~Species, data=iris, frac=0.1, replace=TRUE)

# 비복원, 계통추출 , 층을 
sampleBy(~Species, data=iris, frac=0.1, systematic = TRUE)

##### 상관분석 #####
# 피어슨 상관 계수
# cor 함수 사용
# 연속형, 연속형(모수적)
cor(iris[ ,1:4])
cor(iris$Petal.Length, iris$Petal.Width)

# cor.test() 함수 
cor.test(iris$Sepal.Length, iris$Petal.Width)

# 스피어만 상관계수
# 분석하고자 하는 두 연속형 분포가 심각하게 정규분포를 벗어나는 경우(비모수적)
# 혹은 두 변수가 순위 척도 자유일 때 아래의 패키지를 사용한다.
install.packages("Hmisc")
library(Hmisc)
rcorr(iris$Petal.Width, iris$Petal.Length, type="spearman")

# [ 독립성 검증 ]
# 단일 무작위 표본에서 추출한 자료에 대해 하나의 특성이 다른 특성에 대해 독립적인지 여부를 알아주는 검증방법
# 범주별로 빈도만이 주어진 범주형 데이터 분석은 일반적으로 카이제곱 분포를 이용한 검정법 사용
library(dplyr)
library(ggplot2)
diamonds
data <- diamonds %>% select(cut, color)
data <- table(data)
chisq.test(data)

# 명목형과 랭크형 데이터는 mcnemar.test()를 한다. 
# 비모수 검정통계
mcnemar.test(data$color)

# [ 다차원 척도법 ]
# 평가 대상의 관계(유사성, 거리)를 활용하여 평가 대상을 n 차원 공간에 표시하는 것
# 근접성 자료를 공간적 거리로 시각화 가능
plot(iris[,1:4])
data <- dist(iris[,1:4], method = "euclidean")
data <- cmdscale(data)
?cmdscale

rownames(data)<- 1:150
plot(data[,1], data[,2], type = "n", main = "iris", xlab = "x", ylab = "y")
text(data[,1], data[,2], rownames(data), cex=0)

# [ 주성분 분석법 ]
# 고차원이라서 계산하기 불편하기 때문에 차원수를 낮춰서 계산 하는 방법을 일컷는다.
# 상관관계가 있는 기존 변수를 선형결합해 분산이 극대화된 상관관계가 없는 새로운 변수로
# 축약하는 것.
data <- airquality[complete.cases(airquality),]
m <- prcomp(data[,2:5], scale=TRUE) # scale=TRUE는 정규화
m

# 주성분 분석은 선형 대수에 대한 이해가 필요하다. 상관 계수는 벡터의 내적이다.
# 선형대수에서 고유값 (eigenvalue) 와 고유벡터 (eigenvector)
# 형렬 A를 선형변환으로 봤을 때 선형변환 A에 의한 변환결과가 자신의 상수배가 되는 0이 아닌 벡터를
# 고유 벡터라고 함
# Ax=(람다)x ???

# [QUIZ]
A = matrix(c(1,2,3,2), nrow = 2, ncol = 2, byrow = T)
lambda_A = eigen(A)

# 손으로 계산한 것과 고유벡터 값이 다르게 보이는 이유는 ?
# => 보통 고유벡터를 표현할 때 단위 벡터로 만들어 주기 때문에 서로 비율은 같다.