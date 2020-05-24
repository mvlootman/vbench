module bench

import time
import math.stats

// Benchmark: instructions per second (ips)
// 
// pass 1, the code to benchmark is run for N (default 2) seconds
//      and calculates how many 100ms cycles it can execute
// pass 2, the code is run for N (default 5) seconds, where the code is executed in blocks of the cycle size determined in pass 1 
//
// outputs:
//
//    1                       2        3              4                  5                6        7
// alloc_some         mean:85.63ips (11.68ms) variance:0.00000 relative_stddev:2.380 [54 cycles|8 ops]
// 
// 1: label of benchmark
// 2: mean of ips
// 3: duration per iteration in milliseconds
// 4: sample variance of ips
// 5: relative standard deviation of ips
// 6: number of cycles executed
// 7: number of operations (run code to benchmark) per cycle

pub struct Benchmark {
mut:
        cycles          int     // number of iterations per cycles
        name            string  // name of benchmark
        
pub:
        warmup_secs     int
        bench_secs      int
        verbose         bool   // show verbose output
}

pub fn new(b Benchmark) Benchmark{
        bencher := Benchmark{
                warmup_secs: if b.warmup_secs == 0 { 2 } else { b.warmup_secs }
                bench_secs: if b.bench_secs == 0 { 5 } else { b.bench_secs }
                verbose: b.verbose
        }   
        return bencher
}

pub fn (mut b Benchmark) bench(name string, fp fn()) {
        b.log_debug('benching: $name')
        b.name = name
        b.run_warmup(fp) 
        b.run_bench(fp)
}

fn (mut b Benchmark) run_warmup(fp fn()) {
        b.log_debug('\trunning warmup for $b.warmup_secs seconds')
        start_tick := time.ticks()
        end_tick := start_tick + (b.warmup_secs * 1000)
        mut current_tick := start_tick
        
        mut count := i64(0)
        for current_tick < end_tick {
                fp()
                count++
                current_tick = time.ticks()
        }
        duration_ms := (end_tick - start_tick)
        cycles :=  int((f64(count) / f64(duration_ms)) * 100.0) // 100ms cycles
        b.log_debug('count=$count duration_ms:$duration_ms #iterations per 100ms:$cycles')
        b.cycles = if cycles <= 0 { 1 } else { cycles } 
}

fn (b Benchmark) run_bench(fp fn()) {
        b.log_debug('\trun bench N=$b.bench_secs secs')
        mut durations := []i64{}
        start_tick := time.ticks()
        end_tick := start_tick + (b.bench_secs * 1000)
        
        sw := time.StopWatch{}
        mut iter := i64(0)
        for {
                sw.start()
                for iter = 0 ; iter < b.cycles; iter++{
                        fp()
                }
                sw.stop()
                durations << sw.elapsed().milliseconds()

                if time.ticks() > end_tick {
                        break 
                }
        }
        duration_ms  := (end_tick - start_tick) // duration of whole cycle
        ips := to_ips(durations, b.cycles)
        b.calc_stats(ips, duration_ms)
}

fn to_ips(durations []i64, cycle_len i64) []f64{
        mut ips := [f64(0)].repeat(durations.len) //[f64(0); durations.len]
        for i, _ in ips{
                ips[i] = f64(cycle_len) / ( f64(durations[i]))  //dur_mssecs
        }
        return ips
}

fn(b Benchmark) calc_stats(ips []f64, total_ms i64){
        size := ips.len
        mean := stats.mean(ips)
        variance := stats.sample_variance(ips)
        stddev := stats.sample_stddev(ips) // is variance neccessary? or just calc sqrt of variance
        relative_stddev := 100.0 * (stddev / mean)
        b.log('${b.name:-18s} mean:${mean * 1000.0:.2f}ips (${1.0/(mean):.2f}ms) variance:${variance:.5f} relative_stddev:${relative_stddev:.3f} [$size cycles|$b.cycles ops]')
}

fn (b Benchmark) log_debug(msg string){
        if b.verbose{
                println(msg)
        }
}

fn (b Benchmark) log(msg string){
        println(msg)
}
