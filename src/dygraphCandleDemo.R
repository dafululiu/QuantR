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

ds<-as.xts(ds)
class(ds)

p<-dygraph(ds) %>%
  dyCandlestick() %>%
  dyRangeSelector(height = 10,
                  strokeColor = "")
p

