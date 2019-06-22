library(ggplot2)
data()      # R 과 관련된 기본 자료들이 들어있다.

iris<-iris
head(iris)          # 위에서 6개
head(iris, n=30)    # 위에서 30개

tail(iris)          # 아래에서 6개
tail(iris, n=30)    # 아래에서 30개

View(tail(iris, n=30))

View(iris)
str(iris)
dim(iris)           # dimension은 Nominal 인 variable 에서의 속성 갯수를 알 수 있다.
                    # 즉, num 이나 int 형인 경우 나오지 않는다.
View(LakeHuron)
str(LakeHuron)
dim(LakeHuron)      # 시계열은 dim으로 하면 NULL 값이 출력된다. 

View(Titanic)
str(Titanic)
dim(Titanic)        # 4 2 2 2
summary(Titanic)    # 범주형 끼리 이리저리 얽혀서, data_frame 형태가 아니다.

View(airquality)
str(airquality)     # Structure 여기서 Month 와 Day 를 합칠수 있지 않을 까 ?
dim(airquality)
summary(airquality) # Summary 의 장점 : NA 가 몇개 있는지 확인 가능하다.

a<-iris$Species
dim(a)              # a를 vector 값으로 뽑아 났기 때문에 NULL 이 출력된다.

a<-as.data.frame(iris$Species)
dim(a)              # a를 이렇게 해야 data_frame 처럼 된다.
#######################################################################################################
mpg <- mpg
class(mpg)          # data의 type을 알수 있다.
dim(mpg)            # type이 data.frame이면 dim() 으로 N.OBSERVATION & N.VARIABLES
summary(mpg)
View(mpg)
# summary 를 했는데, 문자열로 되어있다면 의심을 하고 factor 형으로 바꾸어 줘라.

mpg$class <- as.factor(mpg$class)
nlevels(mpg$class)                  # Number of levels Factors 갯수 => "7"
summary(mpg)                        # 다시 summary 하면 바뀐걸 확이 할 수 있다.
str(mpg)

# Quiz : 데이터(복사본) 내의 'hwy' 라는 열 명칭을 'highway'로 바꿔주세요.
mpg_copy <-mpg 
mpg_copy <- rename(mpg_copy, highway = hwy)

########################################################################################################
# 변수 명을 rename 함수를 사용하여 바꿔 보자 'var1' -> 'var4' 
# 주의 할 점 dplyr 패키지를 사용하여야 한다.
install.packages('dplyr')
library(dplyr)

df_raw <- data.frame(var1 = c(1,2,1),
                     var2 = c(2,3,2))

# 방법 1. 단일 variable 만 바꾼다.
df_new <- rename(df_raw, var4 = var1)
View(df_new)

# 방법 2. 'var1' -> 'var4' && 'var2' -> 'var5' 2개를 한번에 vector 로 해서 바꿔버린다. 
colnames(df_new)<-c("var4","var5")
View(df_new)

#######################################################################################################
# package 안에 있는 함수를 RStudio 가 한번씩 제대로 인식을 못할 수 있다. 그때 "::" 를 이용하여 확인 하면 된다.
?ggplot2::geom_contour
?dplyr::rename

#######################################################################################################
df <- data.frame(val1 = c(20,30,20,40),
                 val2 = c(50,80,40,60))
# colonne 이 2 개 -> 3개 만드는 법
df$mean_val <- (df$val1+df$val2)/ncol(df)     # ncol(df) : 데이터 프레임의 갯수를 반환해주는 함수. 
ncol(df)
df
summary(df)
hist(df$val1)
hist(df$val2)
hist(df$mean_val)

# [ 조건문 만들기 ] : ifelse 는 dplyr Package 안에 있는 함수 이다.
df
ifelse(df$mean_val > 49, "true!!!", "false...")

p_f<-ifelse(df$mean_val > 49, "pass", "fail")
p_f<-as.factor(p_f)
class(p_f)

# 3항 조건으로 처리 
grade <- ifelse(df$mean_val>50, "A", ifelse(df$mean_val>34, 'B', 'C'))

df$p_f <- p_f
df$grade <- grade
df

#######################################################################################################
Admission_Predit <- read.csv("***/Admission_Predict.csv")
View(Admission_Predit)

# Quiz
# summary, str, dim, 함수 이용해서 데이터 파악하기
summary(Admission_Predit)
str(Admission_Predit)
dim(Admission_Predit)

# GRE 열에서 평균을 기준으로 Pass, Fail을 나누세요
bar <- mean(Admission_Predit$GRE.Score)
Admission_Predit$GRE_Result<-ifelse(Admission_Predit$GRE.Score>bar,"Pass","Fail")
View(Admission_Predit)

# TOEFL 열에서 100 이상이면 Pass, 아니면 Fail 로 분류하세요.
Admission_Predit$TOEFL_Result<-ifelse(Admission_Predit$TOEFL.Score > 100,"Pass","Fail")
View(Admission_Predit)

# University Rating 이 5 이면 A, 4일 경우 B, 3일 경우 C, 나머지는 D 로 분류하세요
Admission_Predit$Rating_Result<-ifelse(Admission_Predit$University.Rating==5,"A",
                                       ifelse(Admission_Predit$University.Rating==4,"B",
                                              ifelse(Admission_Predit$University.Rating==3,"C","D")))
View(Admission_Predit)

# CGPA 점수가 8이상 이면 Pass 아니면 Fail 로 분류
Admission_Predit$CGPA_Result<-ifelse(Admission_Predit$CGPA>=8,"Pass","Fail")
View(Admission_Predit$CGPA, Admission_Predit$CGPA_Result) 

# subset 은 R 의 고유 기능이다. 그에 비해 dplyr 는 select 라는 함수가 따로 있다.
# [방법1]
Temp <- subset(Admission_Predit,select = c("GRE_Result","TOEFL_Result","Rating_Result","CGPA_Result"))
View(Temp)

# [방법2] 책 p.125
# (아주 중요) Filter 는 행 조건으로 찾는 것이다.
# (아주 중요) Select 는 열 조건을 찾는 것이다.
# (아주아주 중요) data를 전처리를 할 때 먼저 큰 덩어리인 열을 먼저 짤라낸다.
# SQL 에서 "where" 에 해당 하는 것은 filter 이고 "from" 은 파일을 말하며 select = select 
# 조건 3개 Pass && Rating B 이상 
# Return rows with matching conditions
??filter

# %>% 는 파이프("|") 이다.         
Temp %>% filter(GRE_Result=="Pass")         # 첫번째로 전처리가 들어갔다.
dim(Temp %>% filter(GRE_Result=="Pass"))    # [확인] 400 -> 205

str(Temp)           # Rating_Result 의 자료형을 확인 => chr
b <- Temp %>% filter(GRE_Result=="Pass", TOEFL_Result=="Pass", CGPA_Result=="Pass",Rating_Result %in% c("A","B"))
a <- Temp %>% filter(GRE_Result=="Pass", TOEFL_Result=="Pass", CGPA_Result=="Pass",Rating_Result=="A" | Rating_Result=="B")

########################################################################################################
# [Select] = p.134
A_P <- read.csv("***/Admission_Predict.csv")
A_P %>% select(Serial.No.,GRE.Score)    # 2개만 볼때

A_P1 <- read.csv("***/Admission_Predict.csv")
A_P1 %>% select(-SOP, -LOR)             # 2개만 지울 떄

# [Select & Filter]
Admission_Predit %>% 
    select(-SOP, -LOR) %>% 
    filter(GRE_Result == "Pass")
