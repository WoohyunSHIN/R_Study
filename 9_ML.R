# 분류 모형
# 의사결정 나무 
install.packages("caret")
install.packages("party")
install.packages("tree")

library(caret)
library(tree)

idx <- createDataPartition(iris$Species, p=0.7)
train <- iris[idx$Resample1,]
nrow(train[train$Species == "versicolor",])
test <- iris[-idx$Resample1,]
table(train$Species)

# 트리그리기
treemod <- tree(Species~., data =train)
plot(treemod)
text(treemod)

# k-fold Cross Validation 을 이용하여 가지치기(pruning)
cv_tree <- cv.tree(treemod, FUN= prune.misclass)
plot(cv_tree)
# 가지치기 이후의 그래프 표시
prune_tree <- prune.misclass(treemod, best=3)
plot(prune_tree)
text(prune_tree)

# Decision Tree 의 또 다른 패키지
install.packages("rpart")
library(rpart)

rpartmod <- rpart(Species~., data=train, method="class")
plot(rpartmod)
text(rpartmod)
View(iris)
# 
library(party)
partymod <- ctree(Species~., data=train)
plot(partymod)

# [ 베이즈 분류 ]
install.packages("klaR")
library(klaR)
m <- NaiveBayes(Species~., data=train) # 위에 caret 패키지로 이미 쪼갠 것 "." 은 나머지
op <- par(mfrow=c(2,2))
plot(m)
par(op)
pred<- predict(m)
table(pred$class, train[,5])

print(paste(round(mean(pred$class == train[,5])*100,2),"%분류 일치", sep = ""))

# [ 중요 ]
install.packages("e1071")
library(e1071)
m <- naiveBayes(Species~., data=train)
pred <- predict(m, test[,-5]) # 훈련데이터로 만든 예측모델에 test 데이터를 넣어서 검증, 
# -5 는 마지막 5개를 빼는 것
table(test[,5], pred)

# KNN
library(class)
pred <- knn(train[,1:4], test[,1:4], train[,5],k=3, prob=TRUE)
table(test[,5], pred)

# ANN 인공신경망 모형
library(nnet)
m<-nnet(Species~., data=train, size=3)

pred <- predict(m, train, type="class")
table(pred, train[,5])

pred_1 <- predict(m, test, type ="class")
table(pred, test[,5])