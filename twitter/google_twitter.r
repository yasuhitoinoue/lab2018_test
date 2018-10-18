install.packages("ggplot2")
install.packages("ggmap")
install.packages("twitteR")
install.packages("leaflet")
install.packages("RCurl")
install.packages("base64enc")

library(twitteR)
library(RCurl)
library(base64enc)
library(ggplot2)
library(ggmap)
library(igraph)
library(leaflet)

cacert.name <- "cacert.pem"
download.file(url="http://curl.haxx.se/ca/cacert.pem", destfile = cacert.name)
consumer_key<-'consumer_key'
consumer_secret<-'consumer_secret'
access_token<-'access_token'
access_secret<-'access_secret'
setup_twitter_oauth(consumer_key,consumer_secret, access_token, access_secret)

mizrtweets<-searchTwitter("instagram",                # 検索ワード。複数の場合は+でつなぐ
               n=3200,                   # 取得する件数
               lang=NULL,             # 言語 日本語に限定するなら"ja"
               since=NULL,            # 期間指定
               until=NULL,            # 期間指定
               locale=NULL,           # ロケールを指定 日本なら"ja"
#               geocode=NULL,          # 位置情報を指定
			   geocode='35.621619,135.09204,40km',
               sinceID=NULL,          # ツイートID単位で範囲指定
               maxID=NULL,            # ツイートID単位で範囲指定
               resultType="recent",     # 目的に応じて"popular","recent","mixed"を指定
               retryOnRateLimit=120   # APIコール制限にひっかかったときのリトライ回数指定
               )
length(mizrtweets)
tweet.df <- twListToDF(mizrtweets)
Created  <- tweet.df$created
counts   <- table(as.Date(Created))[-1]
plot(dates, counts, type="h")
tweet.df[c('longitude','latitude')]

df<-na.omit(tweet.df[c('longitude','latitude','text','screenName')])

LonLatData <- geocode("舞鶴市",source = "google")
GMapData <- get_googlemap(center = c(lon = LonLatData[1, 1], lat = LonLatData[1, 2]),zoom = 10, size = c(640, 640), scale = 2, format = "png8",maptype = "roadmap", language = "en", sensor = FALSE,messaging = FALSE, urlonly = FALSE, filename = "ggmapTemp",color = "color", force = FALSE)
#roadmap, satellite, hybrid, toner-lite
ggmap(GMapData)
ggmap(GMapData) + geom_point(data = df,aes(x = as.numeric(longitude),y=as.numeric(latitude)),color = 'red', size = 3)

pdf("~/Desktop/plot.pdf",useDingbats=F)
ggmap(GMapData) + geom_point(data = df,aes(x = as.numeric(longitude),y=as.numeric(latitude)),color = 'red', size = 3)
dev.off()
