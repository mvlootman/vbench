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

// Output:
// starting test
// sleep short        mean:87.04ips (11.49ms) variance:0.00000 relative_stddev:2.066 [44 cycles|8 ops]
// sleep shorter      mean:777.63ips (1.29ms) variance:0.00003 relative_stddev:0.732 [41 cycles|77 ops]
// alloc_some         mean:134.87ips (7.41ms) variance:0.00001 relative_stddev:2.040 [42 cycles|13 ops]

// starting test
// sleep short        mean:86.43ips (11.57ms) variance:0.00000 relative_stddev:2.085 [43 cycles|8 ops]
// sleep shorter      mean:780.53ips (1.28ms) variance:0.00005 relative_stddev:0.926 [41 cycles|77 ops]
// alloc_some         mean:135.85ips (7.36ms) variance:0.00001 relative_stddev:2.558 [42 cycles|13 ops]