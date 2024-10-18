// Comparison across file types and tools for saving, loading and other basic data work, 2024-10-16 mail@hhsievertsen.net
cd "/Users/hhs/Dropbox/Work/Research/Data/Data Benchmarking Exercise/"
clear
// Record load data speed uncompressed
timer clear
timer on 1
use "rawdata/timss_8_2019_uncompressed.dta"
timer off 1
timer list
local timer=r(t1)
// Store results
cap file close mf
file open mf using "benchmark_results.csv", write replace
file write mf "file_name,file_size_mb,loading_tool,loading_time_seconds"_n
file write mf "timss_8_2019_uncompressed.dta,,Stata,`timer'"_n

// Record load data speed compressed
timer clear
timer on 1
use "rawdata/timss_8_2019_compressed.dta"
timer off 1
timer list
local timer=r(t1)
file write mf "timss_8_2019_compressed.dta,,Stata,`timer'"
cap file close mf
 