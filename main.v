module main
// import bench
import time

struct Testfixture{
mut:
        num int
}


fn main(){
        //  mut b := bench.new(bench.Benchmark{
        //         bench_secs: 10,
        //         verbose: false
        // })

        // b.bench('org 1', org)
        // b.bench('upd 1', upd)
        // b.bench('org 2', org)
        // b.bench('upd 2', upd)
        // b.bench('sleep short', sleep_short)    
        // b.bench('sleep shorter', sleep_shorter)   
        // b.bench('alloc_some', alloc_some)   

s := 'a\nb\nc\nd'
println('org    =${org(s)}')
println('org    =${s.split_into_lines()}')
println('upd    =${upd(s)}')


}

fn org(s string) []string {
       // mut t := Testfixture{}

       // s  := 'this \n is a test \n string that needs \n to be tested\nand'
	mut res := []string{}
	if s.len == 0 {
		return res
	}
	mut start := 0
	for i := 0; i < s.len; i++ {
		last := i == s.len - 1
		if int(s[i]) == 10 || last {
			if last {
				i++
			}
			line := s.substr(start, i)
			res << line
			start = i + 1
		}
	}
        return res
}


fn upd(s string) []string {
        //mut t := Testfixture{}
        //s  := 'this \n is a test \n string that needs \n to be tested\nand'
	x  := s.split('\n')
        //t.num = x.len

         return x
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
