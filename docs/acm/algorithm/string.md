## Manacher

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

## KMP
### Prefix Function

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

### Z Function

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

## Trie
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

01 trie

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


## AC-Automaton

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

## SA

下标从 $1$ 开始。

```c++
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

```c++
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


## PAM
```c++
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

