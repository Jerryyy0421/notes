# 基础字符串

## 哈希 && 异或哈希


## Trie

### 代码实现

Trie 树板子

```c++
struct trie {
	int t[N][26], sz, ed[N];
	void init() { sz = 2; memset(ed, 0, sizeof ed); }
	int _new() { memset(t[sz], 0, sizeof t[sz]); return sz++; }
	void ins(std::string s, int p) {
    	int u = 1;
    	for(int i = 0; i < s.size(); i++) {
      		int c = s[i] - 'a';
      		if (!t[u][c]) t[u][c] = _new();
      		u = t[u][c];
    	}
    	ed[u] = p;
  	}
};

```

01 trie 板子

```cpp
struct trie {
	int t[N][2], sz, ed[N];
	void init() { sz = 2; memset(ed, 0, sizeof ed); }
	int _new() { memset(t[sz], 0, sizeof t[sz]); return sz++; }
	void ins(int s) {
	    int u = 1;
	    for (int i = 30; i >= 0; i--) {
	      	int c = (s >> i) & 1;
	     	if (!t[u][c]) t[u][c] = _new();
	      	u = t[u][c];
	    }
	}
	int find(int x) {
	  	int u = 1, num = 0;
	    for (int i = 30; i >= 0; i--) {
	    	int c = (x >> i) & 1;
	      	if (t[u][c ^ 1]) {
	      		u = t[u][c ^ 1], num += (1 << i);
	      	}
	      	else u = t[u][c];
	    }
	   	return num;
	}
} T;

```

## Manacher

### 算法介绍

该算法可以线性求出字符串的以各个位置为轴的回文子串最大长度

### 过程

本算法求的是以各位置为对称中心的最大对称半径是多少，由于会出现长度为奇数的对称区间（对称中心在两个位置中间），偶数长度的对称区间（对称中心在某一个位置处）。所以我们对原字串进行变换，比如 `abcba` 变为 `##a#b#c#b#a#` ，这样的话对称中心就是这个位置本身了。

我们引入一个数组 $len$ ，$len$ 数组表示这个点能够扩展出的回文长度。

我们从前向后遍历一遍，循环变量为 $i$，引入辅助变量 $maxr$ 和 $mid$ ，$maxr$ 表示触及到的最右边的字符位置，$mid$ 表示包含 $maxr$ 回文串的中心轴所在位置。对于每次遍历到的新的位置 $i$，不难发现如果 $i < maxr$，那么 $len[i] = min\{len[mid] \}$

当 $i$ 在 $maxr$ 左边且在 $mid$ 右边时：

设 $i$ 关于 $mid$ 的对称点为 $j$，显然 $len[i]$ 一定不会小于 $len[j]$（对称）。

其中 $j$ 为 $(mid<<1)−i$。

那么我们就设置 $len[i] = min\{len[mid], maxr - i \}$ 然后继续尝试扩展，这样就可以较快地求出 $len[i]$，然后更新 $maxr$ 和 $mid$

当 $i$ 在 $maxr$ 右边时，我们无法得知关于 $len[i]$ 的信息，只好从 $1$ 开始遍历，然后更新 $maxr$ 和 $mid$。

本算法时间复杂度和空间复杂度均为线性的。

### 代码实现

下标从 $0$ 开始。

```c++
std::vector<int> manacher(std::vector<int> s) {
  std::vector<int> t{0};
  for (auto c : s) {
    t.push_back(c);
    t.push_back(0);
  }
  int n = t.size();
  std::vector<int> r(n);
  for (int i = 0, j = 0; i < n; i++) {
    if (2 * j - i >= 0 && j + r[j] > i) {
      r[i] = std::min(r[2 * j - i], j + r[j] - i);
    }
    while (i - r[i] >= 0 && i + r[i] < n && t[i - r[i]] == t[i + r[i]]) {
      r[i] += 1;
    }
    if (i + r[i] > j + r[j]) {
      j = i;
    }
  }
  return r;
}
```


## KMP && Border 理论

Border : 字符串的某个前缀(**非原串**)，能与后缀完全匹配。

### 前缀函数

给定一个长度为 $n$ 的字符串 $s$，其前缀函数被定义为一个长度为 $n$ 的数组 $\pi$。 其中 $\pi[i]$ 的定义是：最长的相等的真后缀真前缀长度（自身除外），举个例子，字串 $s[0\dots i]$ 有一对相等的真前缀 $s[0\dots k - 1]$ 和真后缀 $s[i - (k - 1) \dots i]$ 它们相等且是这个字串中所能找到最长的前缀后缀，那么 $\pi[i] = k$。

### 优化 & 过程

直接最朴素的计算前缀函数时间复杂度为 $O(n^3)$，故我们可以加入优化。

优化一：每次新加入一个数时，贡献最多加 $1$，即 $\pi[i + 1] \le \pi[i] + 1$ ，取等当且仅当 $s[\pi[i] + 1] == s[i + 1]$。

优化二：其实优化一的情况优化了新加入的数依然匹配成功的情况，那么优化二可以优化新加入的数失配的情况。我们假设记录一个数组 $k$，$k[i]$ 表示第 $i + 1$ 位失配之后应该跳到第 $k[i]$ 位上。那么我们每次可以不断向前跳，如果匹配成功就是优化一的情况，匹配不成功就继续回跳。

我们假设向前回跳一次到达的位置为 $j$。仔细观察，我们发现 $s[0\dots j] = s[i - j \dots i] = s[\pi[i] - j \dots \pi[i]](j < \pi[i])$，那么则有 $j = \pi[\pi[i]]$，故每次向前跳只需让 $j = k[j]$，等找到适配时就按优化一更新，一直适配不成功就按 $0$ 来更新 $k[i]$。这样的话相当于让该串自己匹配自己来求 $k[i]$，然后求该串在其他串中出现的位置就让该串与其他串匹配，等到 $j$ 变为该串的长度时，说明整个串出现了，可以记录下出现的位置了。

### 代码实现

Prefix Function

kmp 算法，下标从 $1$ 开始，其中 `pi[0]` 的值为 $-1$。但是 `std::string s` 的下标从 $0$ 开始。 

```c++
std::vector<int> Get_Pi(std::string s) {
    int n = s.size();
    std::vector<int> pi(n + 1); 
    pi[0] = -1;
    for (int i = 1; i <= n; i++) {
    	int j = pi[i - 1];
        while (j != -1 && s[i - 1] != s[j]) j = pi[j];
        pi[i] = j + 1;
    }
    return pi;
}
```

Z Function

```c++
std::vector<int> ZFunction(std::string s) {
    int n = s.size();
    std::vector<int> z(n + 1);
    z[0] = n;
    for (int i = 1, j = 1; i < n; i++) {
        z[i] = std::max(0, std::min(j + z[j] - i, z[i - j]));
        while (i + z[i] < n && s[z[i]] == s[i + z[i]]) {
            z[i]++;
        }
        if (i + z[i] > j + z[j]) {
            j = i;
        }
    }
    return z;
}
```


### 相关结论

KMP 的 fail 数组刻画的就是各个前缀的最大 Border。

一个串所有的 border 长度是 `{fail[n], fail[fail[n]], ...}`。

**Weak Periodicity Lemma:**
若 $p, q$ 为 $S$ 的周期，且 $p + q \le n$ ，则 $gcd⁡(p,q)$ 也是 $S$ 的周期。（简称为 WPL）

强化版 


## ACAM

ACAM 本质就是在 Trie 树上跑 kmp。

### 代码实现

Trie 树根节点是 $0$。初始化 `ac.init()` 一定要记得！

```c++
const int N = 2e5 + 5;
struct AhoCorasick {
	static constexpr int M = 26;
	int ch[N][M], cnt[N], fail[N];
	int sz;
	void init() {
	    sz = 1;
    	std::memset(ch[0], 0, sizeof ch[0]);
    	std::memset(cnt, 0, sizeof cnt);
  	}
  	void insert(const std::string &s) {
    	int n = s.size(); int u = 0, c;
    	for(int i = 0; i < n; i++) {
      		c = s[i] - 'a';
      		if (!ch[u][c]) {
        		memset(ch[sz], 0, sizeof ch[sz]);
        		cnt[sz] = 0; ch[u][c] = sz++;
      		}
      		u = ch[u][c];
    	}
    	cnt[u]++;
  	}
  	void build() {
    	std::queue<int> Q;
    	fail[0] = 0;
    	for (int c = 0, u; c < M; c++) {
      		u = ch[0][c];
      		if (u) { Q.push(u); fail[u] = 0; }
    	}
    	while (!Q.empty()) {
      		int r = Q.front(); Q.pop();
      		for (int c = 0, u; c < M; c++) {
        		u = ch[r][c];
        		if (!u) {
          			ch[r][c] = ch[fail[r]][c];
          			continue;
        		}
        		fail[u] = ch[fail[r]][c];
        		Q.push(u);
      		}
    	}
  	}
  	int query(std::string t) {
    	int u = 0, res = 0, n = t.size();
    	for (int i = 0; i < n; i++) {
      		u = ch[u][t[i] - 'a'];
      		for (int j = u; j && cnt[j] != -1; j = fail[j]) {
        		res += cnt[j], cnt[j] = -1;
      		}
    	}
    	return res;
  	}
} ac;

```


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

[**P3966 [TJOI2013] 单词**](https://www.luogu.com.cn/problem/P3966)

**Solution**

显然是建立 AC 自动机，然后我们在 Trie 树上跑，对于每一个节点，我们都让计数 +1，表示我们经过了这个字符串，同时这个字符串可以作为别的串的后缀出现，所以所有这个节点还要加上所有 fail 子树和。

统计的时候倒着跑一遍统计子树和即可（这里是按照构建 AC 自动机时的节点倒序跑），随后输出每个字符串所在的节点答案。

[**P3121 [USACO15FEB] Censoring G**](https://www.luogu.com.cn/problem/P3121)

**Solution**

本题做法是 ACAM + 栈，对于单词建 ACAM，然后用文本串去跑，对于跑到的每个点用栈存起来，跑到一个单词节点上，我们就跳回这个单词长度即可。

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

[**P3294 [SCOI2016] 背单词**](https://www.luogu.com.cn/problem/P3294)

**Solution**

本题题意是让依次放入每个文本串，当放入该文本串后，这个文本串的真后缀也一定都被放进去，设所有不为其他文本串真后缀的文本串的位置和为 $S$，问放入方法是 $S$ 最小。

这题一个巧妙转化为后缀变前缀，这样满足真前缀的条件就可以在 Trie 树上完成。然后我们让所有文本串的前缀节点连向它自己，也就是说要放这个节点，要先把它的父节点都先放入。所以我们重构了 Trie 树，只取 Trie 树上表示文本串结束位置的那几个节点。不难证明对于一棵子树，我们每次要按儿子数从小放大放入每个节点。

所以我们先把每个节点的子节点按儿子数排序，然后用 dfs 序算贡献即可，每个节点的贡献就是它的 dfs 序减去父亲的 dfs 序。

## 参考资料

[字符串基础](https://www.cnblogs.com/alex-wei/p/Basic_String_Theory.html)

[常见字符串算法](https://www.cnblogs.com/alex-wei/p/Common_String_Theory_Theory.html)
