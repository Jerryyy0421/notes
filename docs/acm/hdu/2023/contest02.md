# Day 2

## 1001. [Alice Game](http://acm.hdu.edu.cn/showproblem.php?pid=7287)



## 1002. [Binary Number](http://acm.hdu.edu.cn/showproblem.php?pid=7288)

### Description

对二进制数做 $k$ 次操作，每次任取一段 $[l,r]$ 做 $01$ 翻折，问 $k$ 次之后获得的最大数。

### Solution

总体思路是从高位到低位，把最高位连续的 $0$ 变 $1$，次数多的也不用担心，次数如果多于连续 $0$ 的段数则全为 $1$。这里有两个特判，一个是只给定一位二进制，那么一定是 $1$，答案与 $k$ 的奇偶相关。还有一种情况是给定全是 $1$，$k = 1$，这时候是 $111\dots 10$ 。

[Code](http://acm.hdu.edu.cn/viewcode.php?rid=38686833)



## 1007. [foreverlasting and fried-chicken](http://acm.hdu.edu.cn/showproblem.php?pid=7293)

### Description

给定一张图，找出图中有多少个子图，构造如下。

![D2-1007](D2-1007.png)

### Solution

关键是找到中间的两个蓝色和黄色的点。

![D2-1007(1)](D2-1007(1).png)

把点之间的连接关系用 `bitset` 存储好，枚举蓝点和黄点。中间共有的四个点用 `&` 操作直接求出，剩下的点的个数也好求出，最后答案是 $\sum C_n^2 \times C_m^4$。

[Code](http://acm.hdu.edu.cn/viewcode.php?rid=38687319)



## 1009. [String Problem](http://acm.hdu.edu.cn/showproblem.php?pid=7295)

### Description

将字符串拆成尽可能少的段，使得每段只包含一种字母。每段对答案的贡献为长度减一。

### Solution

签到题。

[Code](http://acm.hdu.edu.cn/viewcode.php?rid=38685806)

