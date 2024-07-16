## Manacher

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
```c++
std::vector<int> Get_Pi(std::string s) {
  int n = s.size();
  std::vector<int> pi(n); 
  int j = pi[0] = 0;
  for (int i = 1; i < n; i++) {
    while (j && s[i] != s[j]) j = pi[j - 1];
    pi[i] = j += s[i] == s[j];
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


## AC-Automaton
```c++
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
```c++
struct SuffixArray {
    int n;
    std::vector<int> sa, rk, lc;
    SuffixArray(const std::string &s) {
        n = s.length();
        sa.resize(n);
        lc.resize(n - 1);
        rk.resize(n);
        std::iota(sa.begin(), sa.end(), 0);
        std::sort(sa.begin(), sa.end(), [&](int a, int b) {return s[a] < s[b];});
        rk[sa[0]] = 0;
        for (int i = 1; i < n; ++i)
            rk[sa[i]] = rk[sa[i - 1]] + (s[sa[i]] != s[sa[i - 1]]);
        int k = 1;
        std::vector<int> tmp, cnt(n);
        tmp.reserve(n);
        while (rk[sa[n - 1]] < n - 1) {
            tmp.clear();
            for (int i = 0; i < k; ++i)
                tmp.push_back(n - k + i);
            for (auto i : sa)
                if (i >= k)
                    tmp.push_back(i - k);
            std::fill(cnt.begin(), cnt.end(), 0);
            for (int i = 0; i < n; ++i)
                ++cnt[rk[i]];
            for (int i = 1; i < n; ++i)
                cnt[i] += cnt[i - 1];
            for (int i = n - 1; i >= 0; --i)
                sa[--cnt[rk[tmp[i]]]] = tmp[i];
            std::swap(rk, tmp);
            rk[sa[0]] = 0;
            for (int i = 1; i < n; ++i)
                rk[sa[i]] = rk[sa[i - 1]] + (tmp[sa[i - 1]] < tmp[sa[i]] || sa[i - 1] + k == n || tmp[sa[i - 1] + k] < tmp[sa[i] + k]);
            k *= 2;
        }
        for (int i = 0, j = 0; i < n; ++i) {
            if (rk[i] == 0) {
                j = 0;
            } else {
                for (j -= j > 0; i + j < n && sa[rk[i] - 1] + j < n && s[i + j] == s[sa[rk[i] - 1] + j]; )
                    ++j;
                lc[rk[i] - 1] = j;
            }
        }
    }
};
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
struct PAM {
  static constexpr int ALPHABET_SIZE = 28;
  struct Node {
    int len;
    int link;
    int cnt;
    std::array<int, ALPHABET_SIZE> next;
    Node() : len{}, link{}, cnt{}, next{} {}
  };
  std::vector<Node> t;
  int suff;
  std::string s;
  PAM() {
    init();
  }
  void init() {
    t.assign(2, Node());
    t[0].len = -1;
    suff = 1;
    s.clear();
  }
  int newNode() {
    t.emplace_back();
    return t.size() - 1;
  }
     
  bool add(char c, char offset = 'a') {
    int pos = s.size();
    s += c;
    int let = c - offset;
    int cur = suff, curlen = 0;
 
    while (true) {
      curlen = t[cur].len;
      if (pos - 1 - curlen >= 0 && s[pos - 1 - curlen] == s[pos])
        break;  
      cur = t[cur].link;
    }       
    if (t[cur].next[let]) {  
      suff = t[cur].next[let];
      return false;
    }
         
    int num = newNode();
    suff = num;
    t[num].len = t[cur].len + 2;
    t[cur].next[let] = num;
 
    if (t[num].len == 1) {
      t[num].link = 1;
      t[num].cnt = 1;
      return true;
    }
 
    while (true) {
      cur = t[cur].link;
      curlen = t[cur].len;
      if (pos - 1 - curlen >= 0 && s[pos - 1 - curlen] == s[pos]) {
        t[num].link = t[cur].next[let];
        break;
      }       
    }           
 
    t[num].cnt = 1 + t[t[num].link].cnt;
 
    return true;
  }
};
```

