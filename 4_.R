Admission_Predict <- read.csv("***/Admission_Predict.csv")
library(dplyr)

A_P <- Admission_Predict
View(A_P)
# 정렬 : 누가 GRE_Score 가 가장 높은 가 ?
A_P %>% arrange(GRE.Score)          # 오름차순 정렬
A_P %>% arrange(GRE.Score, TOEFL.Score)
A_P %>% arrange(desc(GRE.Score))    # 내림차순 정렬

summary(A_P)
A_P$GRE_Result_1to4 <- ifelse(A_P$GRE.Score<=308,1,
                              ifelse(A_P$GRE.Score<=316.8,2,
                                     ifelse(A_P$GRE.Score<=325,3,4)))

# 아래 5줄은 한 문장이다. => 가독성 증가
A_P %>% 
    select(University.Rating, GRE_Result_1to4) %>% 
    arrange(GRE_Result_1to4) %>% 
    mutate(Total_Score = University.Rating + GRE_Result_1to4) %>% 
    arrange(desc(Total_Score)) %>%
    mutate(accept = ifelse(Total_Score>=6,"Pass","Fail"))
# mutate로 만든 Total_Score 는 A_P에 들어가 있지 않다. 
#따라서 다시 "A_P <- A_P %>%" 이렇게 할당 할 수 있다. 

#######################################################################################################

A_P %>% summarise(mean_GRE.Score = mean(GRE.Score))

# Research 변수같은 경우 성과가 좋다 않좋다 라고 0,1 로 표현한 것이다. 하지만 numeric 으로 되어 있으니까 
# factor 형으로 변경을 시켜서 사용해보자
A_P$Research<-as.factor(A_P$Research)
class(A_P$Research)

# factor(= Research)을 기준으로 그룹을 나누어 보자
A_P %>%
    group_by(Research) %>%
    summarise(mean_GRE.Score = mean(GRE.Score),
              mean_TOEFL.Score = mean(TOEFL.Score),
              mean_CGPA.Score = mean(CGPA)) 

# 여기 까지가 p.149 
#######################################################################################################
# 결측치 갯수 확인하는 방법
sum(is.na(A_P))    
sum(is.na(airquality))
#######################################################################################################

# Quiz 
# SOP 가 0.5 간격으로 되어 있다 이것을 1,2,3,4,5 5개 구간으로 새로 나누어 보아라.

A_P$New_SOP <- ifelse(A_P$SOP<2, 1,
                      ifelse(A_P$SOP<3, 2,
                             ifelse(A_P$SOP<4, 3,
                                    ifelse(A_P$SOP<5, 4, 5))))
A_P$New_SOP<-as.factor(A_P$New_SOP)                                       
class(A_P$New_SOP)

A_P %>%
    group_by(A_P$New_SOP) %>%
    summarise(mean_GRE.Score = mean(GRE.Score),
              mean_TOEFL.Score = mean(TOEFL.Score),
              mean_CGPA.Score = mean(CGPA)) 


# 1.데이터 간략 분석 및 차트 그리기 && 데이터 불러오기
Admission_Predict <- read.csv("***/Admission_Predict.csv")

A_P <- Admission_Predict

# 2. 데이터 상위 10 ~50개 파악
head(A_P, n=10)

# 3. 데이터 행, 열의 갯수 파악
dim(A_P)

# 4. 데이터 구조 파악
str(A_P)

# 5. summary 보기
summary(A_P)

# 5-1. NA가 있을 경우 전체 NA 갯수 파악할 것 
sum(is.na(A_P))

# 6. 데이터 중에 타입 변환이 필요한 경우 변환해 주기 
A_P$Research<-as.factor(A_P$Research)

library(ggplot2)
qplot(A_P$University.Rating)

# [ 난수 발생 ]
# 무작위로 섞고, 카운팅 까지 하는 방법
install.packages('randomForest')
library(randomForest)
set.seed(250)

#해석 : randomForest(Y=X 여기서 '~' = '=' '.' = 'all' 이라는 뜻 , data=A_P) 
# 마음대로 데이터를 sampling 을 하기 위해서 난수 개념을 사용하였다
rf <- randomForest(A_P$Chance.of.Admit~., data=A_P, na.action = na.roughfix)

imp <- importance(rf)
imp_df <- data.frame(Variables = row.names(imp), MSE = imp[,1] )
View(imp_df)

imp_df <- imp_df[order(imp_df$MSE, decreasing = TRUE),]
library(ggplot2)

# aes? x 와 y 값에 어떤 것을 넣을까 라는 뜻이다
ggplot(imp_df[1:6, ], aes(x=reorder(Variables,MSE), y=MSE, fill=MSE)) +
    geom_bar(stat='identity') + labs(x='Variables', y='Increase MSE') + coord_flip() + theme(legend.position = "none")
# coord_flip() ? 수평과 수직을 서로 바꾼다.

#######################################################################################################
# 데이터 합치기
test1 <- data.frame(id = c(1,2,3,4,5),
                    midterm = c(50,60,70,80,90))

test2 <- data.frame(id = c(1,2,3,4,5),
                    final = c(70,60,50,80,90))

# 아이디를 기준으로 합쳐주세요~
# join은 하나를 기준으로 삼아 더하겠다 라는 뜻이다.
# 여러가지 종류의 join 이 있는데 left_join, right_join, inner_join, outter_join, natural_join

total  <- left_join(test1, test2, by='id')
total  <- left_join(test2, test1, by='id')
#p.153
name <- data.frame(class = c(1,2,3,4,5),
                   teacher = c("kim",'lee', 'park', 'choi', 'jung'))

exam <- data.frame(id = c(1,2,3,4,5),
                   class = c(1,1,1,2,2),
                   math = c(50,60,NA,30,25),
                   english = c(98,97,96,95,94),
                   science = c(50,60,NA,58,65))

exam_new <- left_join(exam, name, by='class')


#######################################################################################################
# 데이터 연동
install.packages("sqldf")
library(sqldf)

View(exam_new)
# R의 dplyr 문법
exam_new %<% select(english, math)
# SQL 문법
exam_test <- sqldf("select math, english
                   from exam_new"
                   )

#######################################################################################################
exam <- data.frame(id = c(1,2,3,4,5),
                   class = c(1,1,1,2,2),
                   math = c(50,60,NA,30,25),
                   english = c(98,97,96,95,94),
                   science = c(50,60,NA,58,65))

is.na(exam)
is.na(exam$math)

#중요 명령어 'table' : TT, TF, FT, FF 로 하여 예측 정확도를 산출 할 때 사용 한다.
table(is.na(exam))

pred_accuracy <- data.frame(data = c("yes","yes","yes","yes","no"))
table(pred_accuracy)

mean(exam$math) # NA
mean(exam$math, na.rm = T) # 결측치를 무시하고 구한다.

# exam 의 math 와 science 의 id 3의 값을 NAㄹ로 바꾸고 싶다.
exam <- data.frame(id = c(1,2,3,4,5),
                   class = c(1,1,1,2,2),
                   math = c(50,60,70,30,25),
                   english = c(98,97,96,95,94),
                   science = c(50,60,80,58,65))

exam[3 ,"math"] <- NA

# 만약 math안에 NA가 많을 떄 

age1 <- data.frame(age = c(60,12,13,50,NA,80,NA,25,90,NA))

age1$age <- ifelse(is.na(age1$age == NA), mean(age1$age, na.rm = T), age1$age)

