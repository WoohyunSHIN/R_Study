# R에서는 boolean (logical) 연산이다.
a<-c(0,4,5)
a_log<-as.logical(a)

# [주의] is.logical(a) 는 False이다.
# is.logical 은 
# 1. 최우선 데이터가 있는지 없는지를 먼저 판단!

is.logical(a_log)

# 리스트는 list(키=값, 키=값...) 형태로 데이터를 나열해 정의한다. 
# 키를 생략할 수 있다. 이때 키를 생략하면 인뎅싱 접근 방법을 사용하여야 한다.
#
# 단어 자체는 'list' 이지만 컴퓨터에서 흔히 map 또는 dictionary(Python의 경우)라고 불리는
# 자료형과 같다. 이를 컴퓨터용어로 연관 배열(linked list)이라고 한다.
# key 는 unique 한 값을 가져야한다.

list_1<-list("red", "blue", c(50,60), 51.99)
View(list_1)
print(list_1)

list_2<-list(name = 'son', height = 183, team = c("tot", "lev", "hsv"))
View(list_2)
print(list_2)
print(list_2$name)

# list, data_table, data_frame 은 액셀처럼 데이터 sheet을 만드는 것임
# "$" 이름이나 별칭에 접근할 때 사용한다. 
# list ===> data_frame ====> data_table(외부에서 가져와야함) 
# 특징 : list의 상위호환인 data_frame 은 들어갈 수 없고 하위호환인 matrix, vector, scolar 를 담을 수 있다. 

# 내가 원하는 자료만 가져오기 위해서 즉, 전처리 하기 위해서 unlist 를 해야한다.
unlist(list_1)
print(list_1)
#길이
NROW(list_1)

# 행렬에는 한가지 유형의 scolar 만 저장 가능, 즉 숫자 문자가 혼용된 행렬은 불가능하다.
#
# 형렬값을 나열한 뒤에 ncol을 사용해 열의 수를 지정하거나 nrow를 사용해 행의 수를 지정하면 된다.
#
# 행렬의 값을 위부터 채우고 싶다면 byrow의 값을 T(TRUE)로 변경하면 된다.
# 행렬은 기본적으로 "열 우선 규칙"을 따라서 열 우선적으로 값이 채워진다.
#
# 행과 열에 명칭을 부여하고 싶다면 dimnames()을 사용한다.
# 행렬은 2차원 vector 이다.

m1 <- matrix(1:50, nrow=5, ncol=10, byrow=T)

# m1에서 dimnames 의 값은 nrow + ncol 의 값과 같다. 
m2 <- matrix(1:6, nrow=2, ncol=3, byrow=T, 
             dimnames = list( c("a","b"), #행
                              c("포메","치와와","비숑") #열
             ))
m2      

# 행열의 연산은 +, - 기호를 이용한다. 곱셈은 %*%
m3 <- matrix(6:11, nrow=2, ncol=3, byrow=T)
m3

m4 <- matrix(1:6, nrow=2, ncol=3, byrow=T)
m2      

m3+m4
m3-m4
m3%*%m4         #앞 행렬의 행 개수와 뒤의 행렬의 열의 개수

# 전치 행렬
t(m3)

# a matrix의 역행렬 구하는것
solve(a)

# m3 의 2행 3열에 있는 것을 출력하기 위해서는
print(m3[2,3])

# m3 의 2행에 있는 것을 출력 하기 위해서는
print(m3[2,])

# [ from here, Data_Frame ] 
# 표 또는 이차원 배열의 종류
# 중요중요 ! 데이터가 일열로 있으면 'colonne'을 놓치게 된다. 
# 즉, colonne == x 독립 변수! == 속성 == 열 을 나타낸다.
# 열은 지워도 된다. 그말인 즉, 불필요한 열을 어떻게 처리 할지를 생각해야한다.
# 데이터 프레임에서는 어떤 많은 속성 중 어떤것을 줄일 것인지를 항상 생각 해야한다.
# 행은 한사람의 정보이다.

# 사람 4명의 중간고사 점수.
english <- c(90,80,60,70)
mat <- c(50,60,100,20)

df_midterm <- data.frame(english,mat)
View(df_midterm)

# 열을 더 더하기
class <- c(1,1,2,2) #1반 1반 2반 2반
df_midterm <- data.frame(english,mat,class)

# 분석
mean(df_midterm$english)    # 원래 mean 은 NA (= 결측치)가 있으면 작동을 할 수 없다.
summary(df_midterm)

# 결론 : class 라는 쓸데 없는 값이 나온다. 따라서 전처리를 해야 한다.
class<-as.factor(class)
summary(df_midterm)

p<-c(1,2,3,na)
mean(p,na.rm = T)   # 기본값으로 remove na 가 꺼져있는데 옵션을 넣어서 TRUE 로 키면 된다.

# Quiz : 사과라는 데이터는 가격이 1800원, 판매량이 24 딸기라는 데이터는 가격이 1500원 판매량 38,
# 수박 가격은 3000원, 판매량 13개
price <- c(1800,1500,3000)
sales <- c(24,38,13)

df_Tsales<-data.frame(price,sales)
#행 이름 지정할 떄
df_Tsales<-data.frame(df_Tsales,row.names = c("Apple","StrawBerry","Watermelon"))

mean(df_Tsales$price)
mean(df_Tsales$sales)
summary(df_Tsales)

# R 에서 Excel 불러 올 때 package 중에 readxl 이라는 것을 사용한다.
install.packages("readxl")
library(readxl)
attach()
# library 와 attach와 같은 역활을 하지만 attach 가 메모리적으로 효율이 좋다. 
# 왜냐하면 attach는 사용하지 않을 때 대기 상태 이기 때문이다.

# col_name 은 첫번쨰 줄을 이름 처리를 하지 않는다.
# Excel 파일 불러드려오는 것인데 알아서 data.frame 형식으로 받는다.
# 만약
df_exam<-read_excel("***/Excel_exam.xlsx",col_names = F)
View(df_exam)

df_csv_exam<-read.csv("***/csv_exam.csv",col.names = F)
View(df_csv_exam)
mean(df_csv_exam$math)
summary(df_csv_exam)

#질문
tmp <- df_csv_exam$math
tmp <- c(NA,60,45, 30, 25, 50, 80, 90, 20, 50, 65, 45, 46, 48, 75, 58, 65, 80, 89, 78)
df_csv_exam$math <- tmp
View(df_csv_exam)

# Data 의 type을 알고 싶을 떄
class(df_exam)

# Quiz 좋아하는 과일 5가지 이상, 열은 과일이름, 가격, 제철과일 여부, 
# xlsc 확장자로 바탕화면에 저장, R 에서 불러들이고 다시 scv형태로 내보내세요.
# Hint : write.csv(저장할 데이터프레임명, file = "저장하고 싶은 장소의 주소")

df_test<-read_excel("***/test.xlsx")
write.csv(df_test, file= "***/test.csv")






