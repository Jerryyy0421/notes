# 动态规划

### 习题

[**CF1216F Wi-Fi**](https://codeforces.com/contest/1216/problem/F)

**Solution**

设 `f[i]` 表示连通 $1 \sim i$ 的最小代价。因为操作的时候可能前面不连，然后通过 router 从后面把前面一起连上。所以这里转移的时候，找 $[i - k, i + k]$ 范围内最靠前的 router 位置，若存在，则可以通过那个 router 转移，否则就只能直连。