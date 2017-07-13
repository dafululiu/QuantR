library(dygraphs)
library(xts)
w_wsd_data<-w.wsd("600519.SH",
                  "pre_close,open,high,low,close,volume,amt,dealnum,adjfactor",
                  "2010-01-01",
                  "2017-06-29")
ds<-w_wsd_data$Data
write.csv(ds,file = "data/600519.csv",fileEncoding = "UTF-8")
ds<-read.csv(file ="data/600519.csv",
                   fileEncoding = "UTF-8",
                   header = T )
rownames(ds)<-ds$DATETIME
ds<-ds[,c("OPEN","CLOSE","HIGH","LOW")]
ds$ma5<-rollmean(ds$CLOSE,5,fill = NA,
                    align = 'right')
ds$ma20<-rollmean(ds$CLOSE,20,fill = NA,
                 align = 'right')
ds$lagClose<-c(NA,ds$CLOSE[-length(ds$CLOSE)])
ds$ret<-(ds$CLOSE-ds$lagClose)/ds$lagClose
ds$signal<-sign(ds$ma5-ds$ma20)
ds$s2<-c(NA,diff(ds$signal))
ds$s2<-ifelse(ds$s2==-2,"B",ifelse(ds$s2==2,"S",NA))
ds<-as.xts(ds)

p<-dygraph(ds[,1:6]) %>%
  dyCandlestick() %>%
  dyRangeSelector(height = 10,
                  strokeColor = "")

s<-index(ds[ds$s2=="S",])
b<-index(ds[ds$s2=="B",])

p <- p %>% dyEvent(c(s), c(rep('Sale',length(s))), labelLoc='bottom')
p <- p %>% dyEvent( c(b), c(rep('Buy',length(b))), labelLoc='bottom')
p

