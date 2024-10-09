# 字符串

## 哈希 && 异或哈希

### 习题

[**P5270 无论怎样神树大人都会删库跑路**](https://www.luogu.com.cn/problem/P5270)

**Solution**

哈希好题。

学到了用哈希如何判断任意排列是否相等。对整个值域弄一个随机映射 $Num_i$，然后对于值 $i$，它对哈希的贡献就是 `qpow(Num[i], i)`，这样哈希冲突的概率很小且可以判断是否任意排列均相等。

本题对于 $q$ 较小的情况，维护双指针，然后对于 $q$ 大的情况，一定是循环的，周期为 $m$，故可以求解。

[**P5537【XR-3】系统设计**](https://www.luogu.com.cn/problem/P5537)

**Solution**

喵喵题。

哈希的另一个神奇用法，**它可以表示一棵树的结构**。

由于本题中树的结构是不改变的，所以从根到某一个固定点的路径也是不变的，我们可以用哈希值把它表示出来。

然后在 $[l, r]$ 区间中，我们二分查找，若根到 $x$ 路线的哈希值加上从 $l$ 到我们判断位置的 $a$ 数组的哈希值相等，则说明可以。

本题卡两个 $\text{log}$ 做法，用线段树二分的时候，我们可以一边二分判断，一边向下递归找区间线段，所以相等于二分和判断过程一起解决了，时间复杂度是 $O(nlogn)$，但是线段树二分常数较大，如果用树状数组 + 二分是两个 $\text{log}$ 的做法，但是常数较小，导致时间上差别不大，都可以通过。

本题还学到了 `pb_ds` 的用法，具体在杂项中可见。在使用 `map` 记录哈希值的时候，往往可以用 `unordered_map` 或 `cc_hash_table` 来代替，用法和 `map` 一样。

以及本题卡模数，但是不卡自然溢出。下次遇到哈希的题目，如果过不掉可以考虑多换几种构造哈希的方式。

## Trie

### 习题

[**P3294 [SCOI2016] 背单词**](https://www.luogu.com.cn/problem/P3294)

**Solution**

本题题意是让依次放入每个文本串，当放入该文本串后，这个文本串的真后缀也一定都被放进去，设所有不为其他文本串真后缀的文本串的位置和为 $S$，问放入方法是 $S$ 最小。

这题一个巧妙转化为后缀变前缀，这样满足真前缀的条件就可以在 Trie 树上完成。然后我们让所有文本串的前缀节点连向它自己，也就是说要放这个节点，要先把它的父节点都先放入。所以我们重构了 Trie 树，只取 Trie 树上表示文本串结束位置的那几个节点。不难证明对于一棵子树，我们每次要按儿子数从小放大放入每个节点。

所以我们先把每个节点的子节点按儿子数排序，然后用 dfs 序算贡献即可，每个节点的贡献就是它的 dfs 序减去父亲的 dfs 序。

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

[**P3193 [HNOI2008] GT考试**](https://www.luogu.com.cn/problem/P3193)

**Solution**

多方面结合的好题。

我们设 $f_{i, j}$ 表示长串匹配到第 $i$ 位时，短串恰好匹配到第 $j$ 位的方案数。那么最终的答案就是 $\sum_{j = 0}^{m - 1} f_{n, j}$。

考虑从 $f_{i, j}$ 转移，它往后增加一个字符 $i + 1$ 后，可能匹配上 $j + 1$，也可能没匹配上，此时可能会匹配上别的前缀，即对 $f_{i + 1, k}$ 造成贡献，我们记贡献为 $g_{i, k}$，这个 $g_{i, j}$ 表示在前缀 $i$ 后有几种方案可以变成前缀 $j$。这个数组是固定的，可以提前处理出来，利用的是 kmp 不断往前跳，求什么时候可以匹配上。

观察动态转移方程，$f_{i, j} = \sum_{k = 0}^{m - 1} f_{i - 1, k}g_{k, j}$，这是矩阵乘法 $F_{i} = F_{i - 1}G$，那么我们就可以用矩阵快速幂优化即可。

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

[**P2292 [HNOI2004] L 语言**](https://www.luogu.com.cn/problem/P2292)

**Solution**

不错的题，ACAM 和 DP 相结合。

先从暴力入手，直接 dp，我们判断当前状态是否可以从前面的状态转移过来，时间复杂度为 $O(mn|t|)$。

观察数据范围发现，文本串长度很小，都不超过 $20$，这引导我们向状压 / `bitset` 方向去想。如果我们可以知道在 $[i - 20, i)$ 范围内有哪些状态是可以的，以及在 $[i - 20, i)$ 范围内有哪些位置加上一个文本串是可以到达 $i$ 的。我们分别将这两个状态状压一下，然后判断的时候用按位与即可。

前一个状态好找，我们找出当前答案是顺便更新一下即可。后一个状态我们可以用 ACAM，其实多文本匹配也指向了 ACAM。我们沿着 Trie 树，当前这个节点的状态会继承它的 `fail`，然后如果当前这个节点本身也是文本串的结尾，那么就 `|= (1u << dep[u])`，即状态要算上自己的贡献。

最后从前往后转移即可，时间复杂度为 $O(m|s|)$。


## SA




## SAM


## bitset 乱搞

### 算法简介

设文本串 $s$，多个模式串 $t$，我们首先对于每一个字符都开一个 bitset 记录每个字符在文本串中出现的位置。

然后对于每次的模式串，我们新开一个 bitset 记录答案，若 $Ans[i] = 1$ 则表示第 $i$ 位可以是模式串结束的位置。我们遍历整个模式串，然后通过左移 + 按位与的方式来进行判断文本串中哪些位置可以让字符串的这个位置满足条件，最后可以通过记录 $Ans$ 里有几个 $1$ 来判断模式串出现了几次。

**这样我们就在 $O\left(\dfrac{|s|\sum |t|}{\omega}\right)$ 的时间内求出了所有模式串在文本串中出现的所有位置。**

### 习题

[**CF914F Substrings in a String**](https://codeforces.com/problemset/problem/914/F)

**Solution**

基本上就是上述思想的模板。而且 bitset 修改十分方便。

数据范围 $1e5$，时限 $6s$，于是可以大力乱搞。


[**CF963D Frequency of String**](https://codeforces.com/problemset/problem/963/D)

**Solution**

数据范围 $1e5$，时限 $1.5s$，依然可以 bitset 乱搞过。

我们求出每个模式串出现的位置在对相邻 $k$ 个长度取 $\text{min}$ 即可。

这里用到了 bitset 里的 `_Find_first()` 和 `_Find_next()` 函数。

```c++
const int N = 1e5 + 5;
std::bitset<N> c[30], tmp;
int cnt[N], tot;

void solve() {
    std::string s;
	std::cin >> s;
	int q, len;
	std::cin >> q;
	len = s.size();
	for (int i = 0; i < 26; i++) c[i].reset();
	for (int i = 0; i < len; i++) c[s[i] - 'a'][i] = 1;
	while (q--) {
		int k;
		std::string m;
		std::cin >> k >> m;
		int ans = 0x3f3f3f3f;
		tmp.set(); tot = 0;
		int L = m.size();
		for (int i = 0; i < L; i++) {
			tmp &= (c[m[i] - 'a'] << (L - i - 1));
		}		
		for (int i = tmp._Find_first(); i != N; i = tmp._Find_next(i)) {
			cnt[++tot] = i;
		}
		for (int i = k; i <= tot; i++) {
			ans = std::min(ans, cnt[i] - cnt[i - k + 1] + L);
		}
		if (ans == 0x3f3f3f3f) std::cout << "-1\n";
		else std::cout << ans << '\n';
	}
}
```

顺便可以说明一下为什么枚举所有文本串出现位置（即 $\text{endpos}$ ）的时候不会超时。

这里给出一个引理：互不相同的长度之和为 $M$ 的字符串的 $\text{endpos}$ 集合大小之和不超过 $n\sqrt{M}$。

证明：长度为 $L$ 的字符串 $\text{endpos}$ 集合大小最多为 $n - L + 1 \le n$，而 $\sum L \le M$ 意味着最多只有 $\sqrt{M}$ 种长度，得证。

故总时间复杂度为 $O\left(\dfrac{|s|\sum |t|}{\omega} + |s|\sqrt{\sum |t|}\right)$。

## 参考资料

[bitset 的妙用：乱搞字符串匹配](https://www.cnblogs.com/alex-wei/p/bitset_yyds.html)

[字符串基础](https://www.cnblogs.com/alex-wei/p/Basic_String_Theory.html)

[常见字符串算法](https://www.cnblogs.com/alex-wei/p/Common_String_Theory_Theory.html)

[常见字符串算法 II：自动机相关](https://www.cnblogs.com/alex-wei/p/Basic_String_Theory.html)

[后缀自动机学习笔记(干货篇)](https://www.luogu.com/article/0hm3l3ik)

[后缀自动机学习笔记(应用篇)](https://www.luogu.com/article/w967d5rp)

