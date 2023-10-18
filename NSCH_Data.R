setwd("~/NSCH_Data")
library(data.table)
library(haven)



url.vec <- c("https://www2.census.gov/programs-surveys/nsch/datasets/2016/nsch_2016_topical.zip",
             "https://www2.census.gov/programs-surveys/nsch/datasets/2017/nsch_2017_topical.zip",
             "https://www2.census.gov/programs-surveys/nsch/datasets/2018/nsch_2018_topical_SAS.zip",
             "https://www2.census.gov/programs-surveys/nsch/datasets/2019/nsch_2019_topical_SAS.zip",
             "https://www2.census.gov/programs-surveys/nsch/datasets/2020/nsch_2020_topical_SAS.zip",
             "https://www2.census.gov/programs-surveys/nsch/datasets/2021/nsch_2021_topical_SAS.zip",
             "https://www2.census.gov/programs-surveys/nsch/datasets/2022/nsch_2022_topical_SAS.zip")

for(item in url.vec){
  file_name = basename(item)
  if(!file.exists(file_name))download.file(item, file_name)
  unzip(file_name)
}

file.list <- Sys.glob("*sas7bdat")
NSCH.data <- list()
for(file in file.list){
  NSCH.data[[paste(file)]] <- haven::read_sas(file)
  print(dim(NSCH.data[[paste(file)]]))
}


column.names.table.list <- list()
for(item in 1:length(NSCH.data)){
    column.names <- colnames(NSCH.data[[item]])
    column.labels <- NSCH.data[[item]]
    column.names.table.list[[item]] <- data.table(column.names, column.labels)
    #column[[sapply(column.labels, is.NULL)]]
}

column.names.table <- rbindlist(column.names.table.list)
instances.dt <- column.names.table[,data.table(instance =.N), by = column.names] 
instances.common <- instances.dt[instance == 7, , ]

#writing to respository
library("writexl")
write_xlsx(instances.common, "~/NSCH_Data/variable_list.xlsx")


for(column in 1:cols(NSCH.data[[item]])){

attribute.labels <- NSCH.data[[3]]$attr(*, "label")



