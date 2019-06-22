df_accident<-read.csv("***/barcelona-data-sets/accidents_2017.csv")
install.packages("maps")
install.packages("mapproj")
install.packages("ggmap")
library(ggplot2)
library(dplyr)
library(maps)
library(mapproj)
library(reshape2)
library(ggmap)

#######################################################################################################
qmap("barcelona", zoom = 14)
?register_google
?qmap

showing_key()



states_map <- map_data("state")

View(df_accident)
str(df_accident)

df_accident<-df_accident %>% 
    select(District.Name, Victims, Longitude, Latitude) %>% 
    filter(District.Name != "Unknown") %>% 
    group_by(District.Name) %>% 
    summarise()
#######################################################################################################
# [ data set 2개를 가지고 ggplot 할 수 없다. ]
NE_Spain <- map_data(map = 'world',
                    region = "Spain")

NE_Spain_map <- ggplot(data = NE_Spain, mapping = aes(x = long, y = lat, group = group)) +
    geom_polygon(fill =  'white', color = 'black') +
    coord_map()

NE_Spain_map + ggplot(df_accident, aes(x=Longitude, y=Latitude)) + geom_point(color = "red", size = 1)

#######################################################################################################

View(NE_Spain)

p <- ggplot(df_accident, aes(map_id=Barcelona)) +
    geom_map(aes(fill=Victims), map=df_accident) +
    expand_limits(x=df_accident$Longitude, y=df_accident$Latitude) +
    coord_map()

Spain_Barcelona <- map_data(map = "world", )



#######################################################################################################
# [선생님이 한 것 ]

#data => barcelona-data-sets.zip 참고할것!!!!


air_NOV_2017 <- read.csv('/Users/Shinwoohyun/Desktop/ITBANK/R/day07/barcelona-data-sets/air_quality_Nov2017.csv')

View(air_NOV_2017)
install.packages('leaflet')
# [ leaflet ] 을 이용하면 앱을 만들수 있다. 방법은 홈페이지에서 확인할 수있음.

install.packages("leaflet")
library(leaflet)

air_2017<- air_NOV_2017 %>% 
    rename(Air_Quality = Air.Quality,
           long = Longitude,
           lat = Latitude) %>% 
    select(Station, Air_Quality, long, lat, Generated)
View(air_2017)

levels(air_2017$Station)[match('Barcelona - Gr횪cia', levels(air_2017$Station))] <- 'Barcelona - gràcia' 
levels(air_2017$Station)
levels(air_2017$Air_Quality)

leaflet() %>% 
    #지도 타일 까는법  이 코드는 외우거나 복사 붙여넣기를 하도록 추천합니다.
    #지도 , 지리정보를 제공하는 회사측의 기능을 쓴다는 것으로 그냥 이해하시면 됩니다.
    addTiles(group="OSM") %>%
    setView(2.1331,41.3788 , zoom = 12) %>% 
    addProviderTiles("OpenStreetMap.BlackAndWhite", group="BlackAndWhite") %>%
    addProviderTiles("Esri", group="Esri") %>%
    
    
    
    addCircleMarkers(data=air_2017 %>% 
                         filter(Air_Quality == "--"), color="red",
                     group = "--", radius=3) %>% 
    addCircleMarkers(data=air_2017 %>% 
                         filter(Air_Quality == "Good"), color="blue",
                     group = "Good", radius=3) %>% 
    addCircleMarkers(data=air_2017 %>% 
                         filter(Air_Quality == "Moderate"), color="green",
                     group = "Moderate", radius=3) %>% 
    
    addLayersControl(overlayGroups = c("--", "Moderate", "Good"),
                     baseGroups =c("OSM", "BlackAndWhite","Esri"))
