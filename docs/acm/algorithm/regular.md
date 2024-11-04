# 常规套路

## 习题

[**CF1843F2 Omsk Metro (hard version)**](https://codeforces.com/contest/1843/problem/F2)

> 简单说下题意：

> 给定一颗带点权且只可能为 $1$ 或 $−1$ 的树，若干次询问顶点 $x$ 和顶点 $y$ 之间是否存在点权和为 $k$ 的子路径。

**Solution**

算是经典套路了。

由于全是 $1$ 和 $-1$，如果一个区间能构成的最大值大于等于 $k$，最小值小于等于 $k$，则一定可以构成。

我们则只需维护一个点到它父亲的最大前驱，最小前驱，最大后驱，最小后驱，最大值，最小值，总和即可。

这里用倍增维护，写的时候一个小细节是，可以重载结构体的加法，让写法更加简便。

[**CF2021C2 Adjust The Presentation (Hard Version)**](https://codeforces.com/contest/2021/problem/C2)

**Solution**