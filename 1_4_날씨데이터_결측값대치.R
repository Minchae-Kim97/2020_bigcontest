setwd("C:/Users/Administrator/2020빅콘/2020빅콘테스트 데이터_코드")

## encoding제한없이 데이터프레임읽기 ##
library(devtools)
# install_github("plgrmr/readAny", force = TRUE)
wea <- read.table('weather_data_all_before_na(test).csv',
                  header=TRUE, 
                  sep=",", 
                  row.names=NULL, 
                  fileEncoding = "utf8")
head(wea)


##########################################
## 결측치 대치 ##
library(mice)

## 1. 지점별로 하기
# 108 서울
# 159 부산
# 143 대구
# 112 인천
# 156 광주
# 133 대전
# 152 울산
# 119 수원 -> 경기
# 101 춘천 -> 강원
# 131 청주 -> 충북
# 177 홍성 -> 충남
# 146 전주 -> 전북
# 174 순천 -> 전남
# 136 안동 -> 경북
# 155 창원 -> 경남 
# 184 제주
p1 <- wea[which(wea$지점 == '서울'),]
p2 <- wea[which(wea$지점 == '부산'),]
p3 <- wea[which(wea$지점 == '대구'),]
p4 <- wea[which(wea$지점 == '인천'),]
p5 <- wea[which(wea$지점 == '광주'),]
p6 <- wea[which(wea$지점 == '대전'),]
p7 <- wea[which(wea$지점 == '울산'),]
p8 <- wea[which(wea$지점 == '경기'),]
p9 <- wea[which(wea$지점 == '강원'),]
p10 <- wea[which(wea$지점 == '충북'),]
p11 <- wea[which(wea$지점 == '충남'),]
p12 <- wea[which(wea$지점 == '전북'),]
p13 <- wea[which(wea$지점 == '전남'),]
p14 <- wea[which(wea$지점 == '경북'),]
p15 <- wea[which(wea$지점 == '경남'),]
p16 <- wea[which(wea$지점 == '제주'),]

head(p1)
summary(p1)
m1 = mice(p1[,-c(1:2)], seed=1234, m = 1, method = "cart", MaxNWts = 25)  
df1 = complete(m1, 1) # 1번째 대치 데이터로 대치한다
final_df1 = cbind(p1[,c(1,2)], df1)

write.csv(final_df1, 'weather_predict.서울.csv')


## 2. 반복문
setwd("C:/Users/Administrator/2020빅콘/2020빅콘테스트 데이터_코드/weather_predict_test")

spot = list('서울', '경기', '강원', '부산', 
            '경남', '울산', '광주', '전북', 
            '전남', '제주', '대구', '경북', 
            '대전', '충북', '충남',  '인천')
for(j in spot){
  miss = wea[wea$지점 == j,-c(1,2)]
  m <- mice(miss, seed=1234, m = 1, method = "cart")
  m <- complete(m, 1)
  final_df = cbind(wea[wea$지점 == j,c(1,2)], m)
  write.csv(final_df, paste('weather_predict_test', j, 'csv', sep = '.'))
}

