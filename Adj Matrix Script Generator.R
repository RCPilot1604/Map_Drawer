library(dplyr)
setwd("C://Users/ethan/Google Drive/Schoolwork Sync Folder/School/2021/Math")
adj_matrix <- data.frame(matrix(nrow=39,ncol=39))
# 1 and 6
adj_matrix[1,6] <- 1
# 2 and 6
adj_matrix[2,6] <- 1
# 3 and 39
adj_matrix[3,39] <- 1
# 6 and 39
adj_matrix[6,39] <- 1
# 5 and 39
adj_matrix[5,39] <- 1
# 5 and 19
adj_matrix[5,19] <- 1
# 14 and 19
adj_matrix[14,19] <- 1
# 14 and 23
adj_matrix[14,23] <- 1
# 23 and 27
adj_matrix[23,27] <- 1
# 27 and 28
adj_matrix[27,28] <- 1
# 28 and 35
adj_matrix[28,35] <- 1
# 4 and 35
adj_matrix[4,35] <- 1

#Replace the rest with 0
adj_matrix[is.na(adj_matrix)] <- 0
rownames(adj_matrix) <- NULL
write.csv(adj_matrix, "new_adj_matrix.csv", row.names = FALSE)
