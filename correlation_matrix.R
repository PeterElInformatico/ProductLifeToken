library(plyr)
df <- Interest_in_digital_innovation_Antworten_1_[ -c(1:6, 20:22)] # removing screening questions, age, profession
colnames(df) <- c("d1", "d2", "d3", "d4", "d5", "trade", "nft", "u1", "n1", "n2", "n3", "n4", "n5") # renaming columns

# categorical into numerical data
df$trade <- revalue(df$trade, c("Yes"=1)) #
df$trade <- revalue(df$trade, c("No"=0))
df$nft <- revalue(df$nft, c("Yes"=1))
df$nft <- revalue(df$nft, c("No"=0))
df$trade <- as.numeric(df$trade)
df$nft <- as.numeric(df$nft)


df_nft <- df[-c(1:5)] # use case related interest
df_dig <-df[c(1:5)]   # general interest
cor(df_dig)
cor(df_nft)
cor(df)