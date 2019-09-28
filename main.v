import bench
import time

fn main(){
        mut b := bench.new(bench.Benchmark{
                warmup_secs: 2,
                bench_secs: 5
        })
        
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
