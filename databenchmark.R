# Comparison across file types and tools for saving, loading and other basic data work, 2024-10-16 mail@hhsievertsen.net
# Load libraries
library(tictoc)     # simple time tracker

# Load dataset generated in Stata with benchmark results
column_types <- c("character", "numeric", "character","numeric")

df<-data.table::fread("benchmark_results.csv", colClasses = column_types)

# Add file size for Stata files
df[1,2]<-as.numeric(file.size("rawdata/timss_8_2019_uncompressed.dta")/(1024*1024))
df[2,2]<-(file.size("rawdata/timss_8_2019_compressed.dta")/(1024*1024))



# Load rdata    
  tic()
  load("rawdata/timss_8_2019.Rdata")
  a=toc()
  df_temp<-data.frame(file_name="timss_8_2019.Rdata",
                      file_size_mb=(file.size("rawdata/timss_8_2019.Rdata")/(1024*1024)),
                      loading_tool="R load()",
                      loading_time_seconds=a[[2]]-a[[1]])
  df<-rbind(df,df_temp)
  rm(combined_data)

  write.csv(df,"benchmark_results.csv",row.names = FALSE)
  


  
# Load fread 
  #Uncompressed
  tic()
  combined_data<-data.table::fread("rawdata/timss_8_2019_uncompressed.csv")
  a=toc()
  df_temp<-data.frame(file_name="timss_8_2019_uncompressed.csv",
                      file_size_mb=(file.size("rawdata/timss_8_2019_uncompressed.csv")/(1024*1024)),
                      loading_tool="R data.table::fread()",
                      loading_time_seconds=a[[2]]-a[[1]])
  df<-rbind(df,df_temp)
  rm(combined_data)
  write.csv(df,"benchmark_results.csv",row.names = FALSE)
  # Compressed
  tic()
  combined_data<-data.table::fread("rawdata/timss_8_2019_compressed.csv")
  a=toc()
  df_temp<-data.frame(file_name="timss_8_2019_compressed.csv",
                      file_size_mb=(file.size("rawdata/timss_8_2019_compressed.csv")/(1024*1024)),
                      loading_tool="R data.table::fread()",
                      loading_time_seconds=a[[2]]-a[[1]])
  df<-rbind(df,df_temp)
  rm(combined_data)
  write.csv(df,"benchmark_results.csv",row.names = FALSE)
  
# Load rds
  tic()
  combined_data<-readRDS("rawdata/timss_8_2019.rds")
  a=toc()
  df_temp<-data.frame(file_name="timss_8_2019.rds",
                      file_size_mb=(file.size("rawdata/timss_8_2019.rds")/(1024*1024)),
                      loading_tool="R readRDS()",
                      loading_time_seconds=a[[2]]-a[[1]])
  df<-rbind(df,df_temp)
  rm(combined_data)
  write.csv(df,"benchmark_results.csv",row.names = FALSE)
  
# Load feather
  tic()
  combined_data<-arrow::read_feather("rawdata/timss_8_2019.feather")
  a=toc()
  df_temp<-data.frame(file_name="timss_8_2019.feather",
                      file_size_mb=(file.size("rawdata/timss_8_2019.feather")/(1024*1024)),
                      loading_tool="R arrow::read_feather()",
                      loading_time_seconds=a[[2]]-a[[1]])
  df<-rbind(df,df_temp)
  rm(combined_data)
  write.csv(df,"benchmark_results.csv",row.names = FALSE)
  
# Load parquet
  tic()
  combined_data<-arrow::read_parquet("rawdata/timss_8_2019.parquet")
  a=toc()
  df_temp<-data.frame(file_name="timss_8_2019.parquet",
                         file_size_mb=(file.size("rawdata/timss_8_2019.parquet")/(1024*1024)),
                         loading_tool="R arrow::read_parquet()",
                         loading_time_seconds=a[[2]]-a[[1]])
  df<-rbind(df,df_temp)
  rm(combined_data)
  write.csv(df,"benchmark_results.csv",row.names = FALSE)
  
  
  

  # make plots

  library(ggplot2)
  df$label<-paste(df$loading_tool,"\n",df$file_name,"\n (",round(df$file_size_mb,2),"MB)",sep="")
  ggplot(df,aes(x=reorder(label,loading_time_seconds),y=loading_time_seconds))+
    geom_col()+
    geom_text(aes(label=paste(round(loading_time_seconds,2),"seconds")),nudge_y=140 )+
    coord_flip()+
    labs(x="",y="Loading time in seconds")+
    theme_minimal()+
    theme(axis.text.x = element_text( hjust = 1,size=14),
         axis.text.y = element_text( hjust = 1,size=14))+
    ylim(0,1300)