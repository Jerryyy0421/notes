# 字符串

## 哈希 && 异或哈希

### 习题

[**P5270 无论怎样神树大人都会删库跑路**](https://www.luogu.com.cn/problem/P5270)

**Solution**

哈希好题。

学到了用哈希如何判断任意排列是否相等。对整个值域弄一个随机映射 $Num_i$，然后对于值 $i$，它对哈希的贡献就是 `qpow(Num[i], i)`，这样哈希冲突的概率很小且可以判断是否任意排列均相等。

本题对于 $q$ 较小的情况，维护双指针，然后对于 $q$ 大的情况，一定是循环的，周期为 $m$，故可以求解。

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

