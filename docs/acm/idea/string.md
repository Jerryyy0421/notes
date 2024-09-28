# 字符串

## 哈希 && 异或哈希


## KMP && Border 理论

Border : 字符串的某个前缀(**非原串**)，能与后缀完全匹配。

### 相关结论

KMP 的 fail 数组刻画的就是各个前缀的最大 Border。

一个串所有的 border 长度是 `{fail[n], fail[fail[n]], ...}`。

**Weak Periodicity Lemma:**
若 $p, q$ 为 $S$ 的周期，且 $p + q \le n$ ，则 $gcd⁡(p,q)$ 也是 $S$ 的周期。（简称为 WPL）

强化版 

### 习题

[**P3426 [POI2005] SZA-Template**](https://www.luogu.com.cn/problem/P3426)

**Solution**

喵喵题。

不难发现，如果一个印章可以印出字符串 $S$，那么也可以印出 $fail_{|S|}$，我们对于一个字符串的答案，其实要么是长度 $n$，要么是 $fail_n$。所以只要判断能否用 $fail_n$ 的答案来更新即可。开桶数组 `M[i]` 表示长度为 $i$ 可以印出的最长长度。那么如果有 `M[fail[n]] + fail[n] >= n`，那么答案就可以用 `ans[fail[n]]` 来更新。

注意这里不能是 `fail[n] + fail[n] >= n`，因为可能有多个 $n$ 都有相同的 `fail[n]`，所以 `fail[n]` 可以更新到的长度可能很长。


## ACAM

ACAM 本质就是在 Trie 树上跑 kmp。

### 习题

[**P2414 [NOI2011] 阿狸的打字机**](https://www.luogu.com.cn/problem/P2414)

**Solution**

加深对 ACAM 理解的好题。

我们找 x 在 y 里出现的次数。且我们知道子串 = 前缀的后缀。

又由于：Trie树（AC自动机）的祖先节点 = 前缀，Fail树的祖先节点 = 后缀。

x 在 y 中的出现次数即在 Fail 树中有节点 x 作为祖先的 Trie 树中 y 的祖先的数量，
即 Fail 树中 x 的子树与 Trie 树中 y 到根节点的路径的公共节点数。

对于一个 y，我们可以算出全部和它有关的 x 出现的次数。我们 dfs 一遍 trie 树，走到的点 +1，回溯 -1。然后算出这些点在 fail 树里对他们父节点的贡献（就是对父节点求子树和）。由 子树 容易想到利用 dfs序 转化为区间，用树状数组维护。


## SA




## SAM


## 参考资料

