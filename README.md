# vbench
Benchmark code written in V.

Measuring the number of iterations per second (ips) of each function.


First runs warmup (pass 1), the code to benchmark is run for N seconds and calculates how many 100ms cycles it can execute.
Then the code is run for N seconds (pass 2), where the code is executed in blocks of the cycle size determined in pass 1. 

outputs:

```
     1            2             3         4          5             6                7                 8            9
alloc_some: IPS mean:86.09 (0.011616) (11.62ms) variance:0.00 stddev:0.01 relative_stddev:10.00 [cycles:53|# per cycle:8]

1: label of benchmark
2: mean of ips
3: duration per iteration
4: duration per iteration in milliseconds
5: sample variance of ips
6: sample standard deviation of ips
7: relative standard deviation of ips
8: number of cycles executed
9: number of operations per cycle
```

Based on Crystal's Benchmark module.

# usage
```
import bench
import time

fn main(){
        mut b := bench.Benchmark{
                warmup_secs: 2,
                bench_secs: 5
        }
        
        b.bench('sleep short', sleep_short)    
        b.bench('sleep shorter', sleep_shorter)   
        b.bench('alloc_some', alloc_some)   
}

fn sleep_short(){
        time.sleep_ms(10)
}

fn sleep_shorter(){
        time.sleep_ms(1)
}

fn alloc_some(){
        mut s_arr := []string

        for i := 0; i < 100000; i++{
                s_arr << i.str()
        }
}
```
Outputs:
```
sleep short: IPS mean:86.64 (0.011542) (11.54ms) variance:0.00 stddev:0.00 relative_stddev:4.37 [cycles:55|# per cycle:8]
sleep shorter: IPS mean:770.67 (0.001298) (1.30ms) variance:0.00 stddev:0.01 relative_stddev:0.95 [cycles:51|# per cycle:77]
alloc_some: IPS mean:138.69 (0.007210) (7.21ms) variance:0.00 stddev:0.00 relative_stddev:1.65 [cycles:54|# per cycle:13]
```

# Things to improve:
 - formatting of output
 - comparing runs +5%/-5% relative to previous runs
 - use monotonic time instead of tick count (monotonic time is not yet available in V)
 - compare performance of functions to each other
 - use channels to signal completion of benchmark duration (instead of checking tickcount in benchmark loop)
 - use struct defaults (N 2 / 5) when it comes available
 - return stats as struct
