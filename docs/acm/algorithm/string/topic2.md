## 进阶字符串

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

定义 `rk[i]` 表示 `suf[i]` 在所有后缀中的字典序排序。   

定义 `sa[i]` 表示排名为 $i$ 的后缀开始的位置。

定义 `ht[i]` 表示 `suf[sa[i - 1]]` 与 `suf[sa[i]]` 的最长公共前缀长度 $|\text{lcp}(sa_{i - 1}, sa_i)|$，即排名为 $i$ 和 $i - 1$ 的后缀的 LCP 长度。`ht[1]` 未定义，一般为 $0$。

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
### 相关性质

**任意两个后缀的 LCP**

设 `rk[i]` < `rk[j]`，则 $|\text{lcp}(i, j)| = \min_{p = rk_i + 1}^{rk_j}\{ht_p\}$。

**本质不同子串数**

个数为 

$$
\binom{n + 1}{2} - \sum_{i = 2}^n ht_i
$$

### 习题



## SAM

### SAM 的构造

![](assets/SAM.png)

其中 parent tree（即后缀链接树） 按照子串的 endpos 将其划分为若干集合，每个集合交集为空。

而后缀自动机上的每个转移边都可以形成一个子串。我们维护的就是后缀自动机和 parent tree。

### 代码实现

根节点是 $1$。

```cpp
struct SAM {
    static constexpr int ALPHABET_SIZE = 26;
    struct Node {
        int len;
        int fa; // 链接边，也即 parent tree 父边。
        std::array<int, ALPHABET_SIZE> next; // 转移边
        Node() : len{}, fa{}, next{} {}
    };
    int las, tot; // 最后一个点以及总点数
    std::vector<Node> t;
    SAM() {
        init();
    }
    void init() {
        t.assign(3, Node());
        las = tot = 1;
    }
    void add(int c) {
        int p = las, np = ++tot;
        las = np;
        t.emplace_back();
        t[np].len = t[p].len + 1;
        for (; p && !t[p].next[c]; p = t[p].fa) t[p].next[c] = np;
        if (!p) t[np].fa = 1;
        else {
            int v = t[p].next[c];
            if (t[v].len == t[p].len + 1) t[np].fa = v;
            else { 
                int nv = ++tot;
                t.emplace_back();
                t[nv] = t[v];
                t[nv].len = t[p].len + 1;
                for (; p && (t[p].next[c] == v); p = t[p].fa) t[p].next[c] = nv;
                t[np].fa = t[v].fa = nv;
            } 

        }
    }
    void add(char c, char offset = 'a') {
        return add(c - offset);
    }
    
    int next(int p, int x) {
        return t[p].next[x];
    }
      
    int next(int p, char c, char offset = 'a') {
        return next(p, c - 'a');
    }
      
    int fa(int p) {
        return t[p].fa;
    }
      
    int len(int p) {
        return t[p].len;
    }

    int size() {
        return t.size();
    }

};

```

### 例题

**1. SAM 可以求出所有本质不同子串的出现次数。**

[**P3804 【模板】后缀自动机（SAM）**](https://www.luogu.com.cn/problem/P3804)

> 请你求出 $S$ 的所有出现次数不为 $1$ 的子串的出现次数乘上该子串长度的最大值。

**Solution**

利用 SAM 构造出 parent tree，parent tree 可以表示出全部的子串。在 parent tree 上跑一个 dfs 即可统计出每个子串出现的次数。

```cpp
const int N = 4e6 + 6;
i64 cnt[N];

struct SAM {
    static constexpr int ALPHABET_SIZE = 26;
    struct Node {
        int len;
        int fa; // 链接边，也即 parent tree 父边。
        std::array<int, ALPHABET_SIZE> next; // 转移边
        Node() : len{}, fa{}, next{} {}
    };
    int las, tot; // 最后一个点以及总点数
    std::vector<Node> t;
    SAM() {
        init();
    }
    void init() {
        t.assign(3, Node());
        las = tot = 1;
    }
    void add(int c) {
        int p = las, np = ++tot;
        las = np;
        t.emplace_back();
        t[np].len = t[p].len + 1;
        for (; p && !t[p].next[c]; p = t[p].fa) t[p].next[c] = np;
        if (!p) t[np].fa = 1;
        else {
            int v = t[p].next[c];
            if (t[v].len == t[p].len + 1) t[np].fa = v;
            else { 
                int nv = ++tot;
                t.emplace_back();
                t[nv] = t[v];
                t[nv].len = t[p].len + 1;
                for (; p && (t[p].next[c] == v); p = t[p].fa) t[p].next[c] = nv;
                t[np].fa = t[v].fa = nv;
            } 

        }
    }
    void add(char c, char offset = 'a') {
        return add(c - offset);
    }
    
    int next(int p, int x) {
        return t[p].next[x];
    }
      
    int next(int p, char c, char offset = 'a') {
        return next(p, c - 'a');
    }
      
    int fa(int p) {
        return t[p].fa;
    }
      
    int len(int p) {
        return t[p].len;
    }

    int size() {
        return t.size();
    }

};

std::vector<int> e[N];
SAM sam;
i64 ans = 0;

void dfs(int u) {
    for(auto v: e[u]) {
        dfs(v);
        cnt[u] += cnt[v];
    }
    if(cnt[u] > 1) ans = std::max(ans, 1ll * cnt[u] * sam.len(u));
}

void solve() {
    std::string s;
    std::cin >> s;
    for(int i = 0; i < s.size(); i++) {
        sam.add(s[i]);
    }
    int tmp = 1;
    for (int i = 0; i < s.size(); i++) {
        tmp = sam.next(tmp, s[i]);
        cnt[tmp] = 1;
    }
    for(int i = 2; i <= sam.tot; i++) e[sam.fa(i)].push_back(i); 
    dfs(1);
    std::cout << ans << '\n'; 
}
```

**2. SAM 可以求出所有本质不同子串的总个数。**

[**P2408 不同子串个数**](https://www.luogu.com.cn/problem/P2408)

> 给你一个长为 $n$ 的字符串，求不同的子串的个数。

**Solution**

本题有两种方法。

方法一：

parent tree 每个节点表示的串没有交集，而且一定表示了所有的串。故把所有节点表示的串的个数加起来即为答案。

$ans = \sum sam.len(i) - sam.len(sam.fa(i))$。

```cpp
const int N = 4e6 + 6;
i64 cnt[N];

struct SAM {
    static constexpr int ALPHABET_SIZE = 26;
    struct Node {
        int len;
        int fa; // 链接边，也即 parent tree 父边。
        std::array<int, ALPHABET_SIZE> next; // 转移边
        Node() : len{}, fa{}, next{} {}
    };
    int las, tot; // 最后一个点以及总点数
    std::vector<Node> t;
    SAM() {
        init();
    }
    void init() {
        t.assign(3, Node());
        las = tot = 1;
    }
    void add(int c) {
        int p = las, np = ++tot;
        las = np;
        t.emplace_back();
        t[np].len = t[p].len + 1;
        for (; p && !t[p].next[c]; p = t[p].fa) t[p].next[c] = np;
        if (!p) t[np].fa = 1;
        else {
            int v = t[p].next[c];
            if (t[v].len == t[p].len + 1) t[np].fa = v;
            else { 
                int nv = ++tot;
                t.emplace_back();
                t[nv] = t[v];
                t[nv].len = t[p].len + 1;
                for (; p && (t[p].next[c] == v); p = t[p].fa) t[p].next[c] = nv;
                t[np].fa = t[v].fa = nv;
            } 

        }
    }
    void add(char c, char offset = 'a') {
        return add(c - offset);
    }
    
    int next(int p, int x) {
        return t[p].next[x];
    }
      
    int next(int p, char c, char offset = 'a') {
        return next(p, c - 'a');
    }
      
    int fa(int p) {
        return t[p].fa;
    }
      
    int len(int p) {
        return t[p].len;
    }

    int size() {
        return t.size();
    }

};

std::vector<int> e[N];
SAM sam;
i64 ans = 0;

void solve() {
    int n;
    std::cin >> n;
    std::string s;
    std::cin >> s;
    for(int i = 0; i < n; i++) {
        sam.add(s[i]);
    }
    i64 ans = 0;
    for(int i = 2; i <= sam.tot; i++) ans += sam.len(i) - sam.len(sam.fa(i)); 
    dfs(1);
    std::cout << ans << '\n'; 
}
```

方法二：

SAM 本质是一个 DAG，从根节点所走的转移边可以形成一个子串，我们可以在上面跑 dp，我们令 `f[u]` 表示从 `u` 开始的可以形成的字符串个数。并且由于每个顶点出发形成的串都是互不相同的，那么转移的时候是 `f[u] += f[v]`，再算上自己 `f[u]++`。

最后统计答案的时候要减去空串，答案即为 `f[1] - 1`。

```cpp
void dfs(int u) {
    if (cnt[u]) return ;
    for (int i = 0; i < 26; i++) {
        int v = sam.next(u, i); 
        if (v) dfs(v);
        cnt[u] += cnt[v];
    }
    cnt[u]++;
}

void solve() {
    int n;
    std::cin >> n;
    std::string s;
    std::cin >> s;
    for(int i = 0; i < n; i++) {
        sam.add(s[i]);
    }
    dfs(1);
    std::cout << cnt[1] - 1 << '\n'; 
}
```



## bitset 乱搞

### 算法简介

设文本串 $s$，多个模式串 $t$，我们首先对于每一个字符都开一个 bitset 记录每个字符在文本串中出现的位置。

然后对于每次的模式串，我们新开一个 bitset 记录答案，若 $Ans[i] = 1$ 则表示第 $i$ 位可以是模式串结束的位置。我们遍历整个模式串，然后通过左移 + 按位与的方式来进行判断文本串中哪些位置可以让字符串的这个位置满足条件，最后可以通过记录 $Ans$ 里有几个 $1$ 来判断模式串出现了几次。

**这样我们就在 $O\left(\dfrac{|s|\sum |t|}{\omega}\right)$ 的时间内求出了所有模式串在文本串中出现的所有位置。**

### 例题

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


## 习题

[**CF802I Fake News (hard)**](https://codeforces.com/contest/802/problem/I)

> 给定一个串 $S$，对于所有的子串，求 $\sum_p \text{cnt}^2(s, p)$，其中 $\text{cnt}(s, p)$ 表示 $p$ 在 $s$ 中出现的次数。

**Solution**

SAM 的典型应用，比较板。

SAM 可以方便求出在每个划分集合下子串出现的次数，那么我们直接求出平方相加即可，即为 $\sum cnt^2_u \times (len[u] - len[fa_u] )$。


## 参考资料

[bitset 的妙用：乱搞字符串匹配](https://www.cnblogs.com/alex-wei/p/bitset_yyds.html)

[常见字符串算法 II：自动机相关](https://www.cnblogs.com/alex-wei/p/Basic_String_Theory.html)

[后缀自动机学习笔记(干货篇)](https://www.luogu.com/article/0hm3l3ik)

[后缀自动机学习笔记(应用篇)](https://www.luogu.com/article/w967d5rp)

[回文自动机学习笔记](https://www.cnblogs.com/bztMinamoto/p/9630617.html)

[字符串 - 董晓算法](https://www.cnblogs.com/dx123/category/2356333.html)

