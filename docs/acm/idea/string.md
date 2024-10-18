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



### 习题

[**P3294 [SCOI2016] 背单词**](https://www.luogu.com.cn/problem/P3294)

**Solution**

本题题意是让依次放入每个文本串，当放入该文本串后，这个文本串的真后缀也一定都被放进去，设所有不为其他文本串真后缀的文本串的位置和为 $S$，问放入方法是 $S$ 最小。

这题一个巧妙转化为后缀变前缀，这样满足真前缀的条件就可以在 Trie 树上完成。然后我们让所有文本串的前缀节点连向它自己，也就是说要放这个节点，要先把它的父节点都先放入。所以我们重构了 Trie 树，只取 Trie 树上表示文本串结束位置的那几个节点。不难证明对于一棵子树，我们每次要按儿子数从小放大放入每个节点。

所以我们先把每个节点的子节点按儿子数排序，然后用 dfs 序算贡献即可，每个节点的贡献就是它的 dfs 序减去父亲的 dfs 序。

## KMP && Border 理论

Border : 字符串的某个前缀(**非原串**)，能与后缀完全匹配。

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

## PAM

回文自动机即回文树。时间复杂度为 $O(n)$。

### 代码实现

字符串下标从 $1$ 开始。

PAM 中 $1$ 号点是奇回文的根，$0$ 号点是偶回文的根。故实际有含义的点是 $2 \sim \text{tot}$。

每个节点对应一个回文串，`fail[i]` 表示和这个 $i$ 回文串同右端点的最长回文串。每个节点均有 `fail` 连接。

可以求出本质不同回文串个数，每个回文串出现次数，长度。板子里只求出这个回文作为最长回文出现的次数，若求全部出现的次数要从后往前对 `cnt` 求和。

```cpp
const int N = 500005;
struct PAM { 
    int fail[N], ch[N][26], cnt[N], len[N];
    int tot, last, p, q;
    std::string s;
    void init() {
        tot = last = 0;
        s[0] = -1, fail[0] = 1, last = 0;
        len[0] = 0, len[1] = -1, tot = 1; 
        memset(ch[0], 0, sizeof(ch[0]));
        memset(ch[1], 0, sizeof(ch[1]));
        std::cin >> s;
        s = ' ' + s;
    }
    int newnode(int x) {
        len[++tot] = x;
        memset(ch[tot], 0, sizeof(ch[tot]));
        return tot;
    }
    int getfail(int x, int n) {
        while(s[n - 1 - len[x]] != s[n]) x = fail[x];
        return x;
    }
    void build() {
        for(int i = 1; s[i]; ++i){
            int x = s[i] - 'a';
            p = getfail(last, i);
            if(!ch[p][x]) {
                // 如果有了转移就不用建了，否则要新建 
                // 前后都加上新字符，所以新回文串长度要加2 
                q = newnode(len[p] + 2);
                // 因为fail指向的得是原串的严格后缀，所以要从p的fail开始找起 
                fail[q] = ch[getfail(fail[p], i)][x]; 
                // 记录转移 
                ch[p][x] = q;
            }
            ++cnt[last = ch[p][x]];
        }
    }
} pam;
```

### 习题

[**P4287 [SHOI2011] 双倍回文**](https://www.luogu.com.cn/problem/P4287)

**Solution**

如果我们对于每一个节点暴力跳 `fail` 一定会超时，所以我们再开一个数组 `kkk[i]` 表示这个 `i` 能往上跳的 `fail` 中长度小于等于 `i` 一半中最长的那个回文。 

所以我们判断一个节点能否作为双倍回文只用判断 `kkk[i]` 的长度是否恰好为 `len[i]` 的一半并且 `len[i]` 是 $4$ 的倍数。


[**P4762 [CERC2014] Virus synthesis**](https://www.luogu.com.cn/problem/P4762)

**Solution**

回文自动机好题。

我们观察可以发现，最终串一定是一个回文加上若干次单个加得来的。

所以我们可以用 dp 求出文本串中每一个回文串的最小操作次数，然后 $ans = \min \{|s| - |i| + f_i\}$。

而且这里注意，我们求的回文是只求偶回文的答案，因为翻转的时候对奇回文操作会破坏其结构。

我们利用上个例题中的 `kkk` 数组，所以转移的时候 $f_v = \min \{f_v, f_{kkk} + len_v - len_{kkk}\}$。

以及，我们转移的时候枚举每次两边新增的字符是什么，若从状态 $u$ 可以转移到状态 $v$， 则有 $f_v = \min \{f_v, f_u + 1\}$。 因为这是偶对称串，我们可以把翻折放到最后做。

## SA

### 代码实现

下标从 $1$ 开始。

```cpp
constexpr int N = 2e5 + 5;
int ht[N], sa[N], rk[N];
int ork[N], buc[N], id[N];
void build(std::string s) {
	int m = N - 1, p = 0;
	int n = s.size() - 1;
	for (int i = 1; i <= n; i++) ork[i] = 0;	
	for (int i = 1; i <= n; i++) buc[i] = 0;
	for(int i = 1; i <= n; i++) buc[rk[i] = s[i]]++;
	for(int i = 1; i <= m; i++) buc[i] += buc[i - 1];
	for(int i = n; i; i--) sa[buc[rk[i]]--] = i;
	for(int w = 1; ; m = p, p = 0, w <<= 1) { // m 表示桶的大小, 等于上一轮的 rk 最大值.
    	for(int i = n - w + 1; i <= n; i++) id[++p] = i; // 循环顺序无关, 顺序倒序都可以, 不影响最终结果.
    	for(int i = 1; i <= n; i++) if(sa[i] > w) id[++p] = sa[i] - w;
    	memset(buc, 0, m + 1 << 2); // 注意清空桶.
    	memcpy(ork, rk, n + 1 << 2); // 注意拷贝 rk -> ork.
    	p = 0;
    	for(int i = 1; i <= n; i++) buc[rk[i]]++;
    	for(int i = 1; i <= m; i++) buc[i] += buc[i - 1];
    	for(int i = n; i; i--) sa[buc[rk[id[i]]]--] = id[i]; // 注意, 倒序枚举保证计数排序的稳定性. 基数排序的正确性基于内层计数排序的稳定性.
    	for(int i = 1; i <= n; i++) rk[sa[i]] = ork[sa[i - 1]] == ork[sa[i]] && ork[sa[i - 1] + w] == ork[sa[i] + w] ? p : ++p; // 原排名二元组相同则新排名相同, 否则排名 +1.
    	if(p == n) break; // n 个排名互不相同, 排序完成.
	}
	for(int i = 1, k = 0; i <= n; i++) {
  		if(k) k--;
  		while(s[i + k] == s[sa[rk[i] - 1] + k]) k++; // sa[rk[i]] = i, 需要保证 s[0] 和 s[n + 1] 为空字符 (多测清空), 否则可能出错.
  		ht[rk[i]] = k;
	}
}
```


## SAM

### 代码实现
```cpp
struct SAM {
  static constexpr int ALPHABET_SIZE = 26;
  struct Node {
    int len;
    int link;
    std::array<int, ALPHABET_SIZE> next;
    Node() : len{}, link{}, next{} {}
  };
  std::vector<Node> t;
  SAM() {
    init();
  }
  void init() {
    t.assign(2, Node());
    t[0].next.fill(1);
    t[0].len = -1;
  }
  int newNode() {
    t.emplace_back();
    return t.size() - 1;
  }
  int extend(int p, int c) {
    if (t[p].next[c]) {
      int q = t[p].next[c];
      if (t[q].len == t[p].len + 1) {
        return q;
      }
      int r = newNode();
      t[r].len = t[p].len + 1;
      t[r].link = t[q].link;
      t[r].next = t[q].next;
      t[q].link = r;
      while (t[p].next[c] == q) {
        t[p].next[c] = r;
        p = t[p].link;
      }
      return r;
    }
    int cur = newNode();
    t[cur].len = t[p].len + 1;
    while (!t[p].next[c]) {
      t[p].next[c] = cur;
      p = t[p].link;
    }
    t[cur].link = extend(p, c);
    return cur;
  }
  int extend(int p, char c, char offset = 'a') {
    return extend(p, c - offset);
  }
    
  int next(int p, int x) {
    return t[p].next[x];
  }
    
  int next(int p, char c, char offset = 'a') {
    return next(p, c - 'a');
  }
    
  int link(int p) {
    return t[p].link;
  }
    
  int len(int p) {
    return t[p].len;
  }

  int size() {
    return t.size();
  }
};

```


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

[回文自动机学习笔记](https://www.cnblogs.com/bztMinamoto/p/9630617.html)