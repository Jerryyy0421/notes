# Day 1

## 1001. [Hide-And-Seek Game](https://acm.hdu.edu.cn/showproblem.php?pid=7275)

### Description

两个人都在一棵树上，沿着树的边走，一次走一条边，一个人从 $S_a$ 出发，前往 $T_a$，到达 $T_a$ 后就返回向 $S_a$ 走，如此往复。另一个人在 $S_b$ 和  $T_b$ 之间走，问最早在那个点能相遇，若不相遇，则输出 `-1` 。$t$ 组数据，每组数据 $n$ 个结点，$m$ 次询问。

### Solution

本题 $n$ 和 $m$ 都较小（ $n, m \le 300$），所以可以枚举所有可能相遇的点。判断点 $i$ 是否在 $(S_a, T_a)$ 路线上的方法是判断 $dist(i, S_a) + dist(i, T_a) == dist(S_a, T_a)$。注意，对于每个点 $i$，相遇的时间节点可能是 $2k \times dist(S_a, T_a) + dist(S_a, i)$ 或 $2k \times dist(S_a, T_a) + 2 \times dist(S_a, T_a) - dist(i, S_a)$ 。另一个人的时间同理，所以这就相当于解二元一次方程。（不了解二元一次方程组的可以先做 [P5656 【模板】二元一次不定方程 (exgcd)](https://www.luogu.com.cn/problem/P5656)）

注意一下，这里算两点间距离利用 LCA 来求，但不能直接用倍增去求（因为这样会超时），要用 dfs 序来求 LCA（时间复杂度要优化很多）。 

[Code](https://acm.hdu.edu.cn/viewcode.php?rid=38826162)



## 1002. [City Upgrading](http://acm.hdu.edu.cn/showproblem.php?pid=7276)

### Description

一棵树，每个点都有权值，选中一个点的话，这个点相连的节点也会被选中，要求花费最小让整棵树全部点都被选中。

### Solution

树形DP，我们令 $f[i][0]$ 表示在 $i$ 位置选，$f[i][1]$ 表示在 $i$ 的儿子位置处选，让 $i$ 被儿子覆盖， $f[i][2]$ 表示在 $i$ 的父亲位置处选，让 $i$ 被父亲覆盖。

如果选 $i$ 位置，那么不难得出 $f[i][1] = a[i] + \sum \min\{f[son][0], f[son][1], f[son][2]\}$ ，因为这时候儿子 $son$ 怎么选都可以。

如果选 $i$ 父亲位置，那么 $f[i][2] = \sum \min\{f[son][1], f[son][2]\}$，这个时候儿子 $son$ 要么自己选，要么被 son 的儿子覆盖。

如果选 $i$ 儿子位置，这个时候有点复杂，因为要决定 $i$ 应该被哪个儿子覆盖，应该由花费最小的儿子覆盖，设这个儿子为 $chosen\_son$ ，那么这个儿子一定是要选的，所以代价是 $f[chosen\_son][0] + \sum_{son \ne chosen\_son} \min\{f[son][0], f[son][1]\}$，而且一定有其他儿子 $son'$ 满足 $f[chosen\_son][0] + \sum_{son \ne chosen\_son} \min\{f[son][0], f[son][1]\} < f[son'][0] + \sum_{son \ne son'} \min\{f[son][0], f[son][1]\}$，两边同类项抵消后，就是要选 $f[son][0] - \min\{f[son][0], f[son][1]\}$ 最小的儿子作为这个 $chosen\_son$，在向下搜索时找到这个儿子，剩下就好解决了。

[Code](http://acm.hdu.edu.cn/viewcode.php?rid=38674964)



## 1003. [Mr. Liang play Card Game](https://acm.hdu.edu.cn/showproblem.php?pid=7277)

### Description

桌上有 $n$ 张牌，第 $i$ 张牌的类型是 $a_i$，然后又告诉你每种牌的价值 $v_i$，每张牌初始等级为 $1$ 级，你每次可以进行两种操作，第一种操作是将某张牌打出去，若等级为 $k$，则获得 $p^{k - 1} \times v[a[i]]$ 的价值，第二种操作是将相邻的两张同类型同等级的牌合并，等级为合并前等级 $+1$。问全部出完牌之后的最大价值。 

### Solution

一道较为基础的区间 DP，想到 $f$ 数组的状态就比较好转移了。

$f[l][r][type][level]$ 表示将 $[l, r]$ 区间全部合并完，只剩下一张 $type$ 类型等级 $level$ 的牌所获得的最大价值。

$g[l][r]$ 表示将 $[l, r]$ 区间内牌全部打出去所获得的最大价值。

每次枚举 $l, r, type, level$，不难推出：
$$
\begin{gather}
g[l][r] = \max \{g[l][r], g[l][mid] + g[mid + 1][r]\}; \\
f[l][r][t][1] =\max \{f[l][r][t][1], f[l][mid][t][1] + g[mid + 1][r], f[mid + 1][r][t][1] + g[l][mid]\}; \\
f[l][r][t][lev] = \max \{f[l][r][t][lev], f[l][mid][t][lev - 1] + f[mid + 1][r][t][lev - 1]\}\ (len > 1)
\end{gather}
$$
更新完 $f$ 数组后再更新 $g$ 数组。
$$
g[l][r] = \max \{g[l][r], f[l][r][t][lev] + v[t] \times c[lev] \};
$$
[Code](https://acm.hdu.edu.cn/viewcode.php?rid=38826810)



## 1009. [Assertion](http://acm.hdu.edu.cn/showproblem.php?pid=7283)

### Description

把 $m$ 个物品放进 $n$ 个柜子，问是否至少有一个里面物品数大于等于 $d$。

### Solution

签到题，判断 $d$ 和 $\left \lfloor \dfrac{m - 1}{n} \right \rfloor + 1$ 即可。

[Code](http://acm.hdu.edu.cn/viewcode.php?rid=38672478)


