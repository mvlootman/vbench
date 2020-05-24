import bench
import time

fn main(){
        println('starting test')
        mut b := bench.new(bench.Benchmark{
                bench_secs: 4,
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
        mut s_arr := []string{}

        for i := 0; i < 100000; i++{
                s_arr << i.str()
        }
}

// ticks impl (non -prod)
// starting test
// sleep short        mean:87.14ips (11.48ms) variance:0.00001 relative_stddev:2.937 [44 cycles|8 ops]
// sleep shorter      mean:791.07ips (1.26ms) variance:0.00022 relative_stddev:1.880 [41 cycles|78 ops]
// alloc_some         mean:82.72ips (12.09ms) variance:0.00001 relative_stddev:3.114 [42 cycles|8 ops]

// ticks impl (-prod)
// starting test
// sleep short        mean:87.45ips (11.43ms) variance:0.00001 relative_stddev:2.737 [44 cycles|8 ops]
// sleep shorter      mean:785.48ips (1.27ms) variance:0.00013 relative_stddev:1.460 [41 cycles|77 ops]
// alloc_some         mean:122.89ips (8.14ms) variance:0.00006 relative_stddev:6.125 [41 cycles|12 ops]