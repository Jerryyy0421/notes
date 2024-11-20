# 网络流

## 网络流算法

### 最大流

[**P3376 【模板】网络最大流**](https://www.luogu.com.cn/problem/P3376)

**Solution**

主要有 EK 算法 和 Dicnic 算法，其中 Dinic 算法效率更高。

EK 代码实现。时间复杂度是 $O(nm^2)$。

```cpp
#define LL long long
#define N 10010
#define M 200010
using namespace std;

int n,m,S,T;
struct edge{LL u,v,c;};
vector<edge> e;
vector<int> h[N];
LL mf[N],pre[N];

void add(int a,int b,int c){
  e.push_back({a,b,c});
  h[a].push_back(e.size()-1);
}
bool bfs(){//找增广路
  memset(mf,0,sizeof mf);
  queue<int> q;
  q.push(S); mf[S]=1e9;
  while(q.size()){
    int u=q.front(); q.pop();
    for(int i=0;i<h[u].size();i++){
      int j=h[u][i];
      LL v=e[j].v;
      if(mf[v]==0 && e[j].c){
        mf[v]=min(mf[u],e[j].c);
        pre[v]=j;//存前驱边
        q.push(v);
        if(v==T)return true;
      }
    }
  }
  return false;
}
LL EK(){//累加可行流
  LL flow=0;
  while(bfs()){
    int v=T;
    while(v!=S){//更新残留网
      int i=pre[v];
      e[i].c-=mf[T];
      e[i^1].c+=mf[T];
      v=e[i^1].v;
    }
    flow+=mf[T];
  }
  return flow;
}
void solve(){
  int a,b,c;
  scanf("%d%d%d%d",&n,&m,&S,&T);
  while(m--){
    scanf("%d%d%d",&a,&b,&c);
    add(a,b,c); 
    add(b,a,0);//反向边
  }
  printf("%lld\n",EK());
  return ;
}
```


Dinic 代码实现。时间复杂度是 $O(n^2m)$。

```cpp
using i64 = long long;

const int N = 5e5;
const int INF = 0x3f3f3f3f;

struct MF {
    struct edge {
        int v, nxt, cap, flow;
    } e[N];

    int fir[N], cnt = 0;

    int n, S, T;
    i64 maxflow = 0;
    int dep[N], cur[N];

    void init() {
        memset(fir, -1, sizeof fir);
        memset(dep, 0, sizeof dep);
        memset(cur, 0, sizeof cur);
        cnt = 0;
    }

    void add_edge(int u, int v, int c) {
        e[cnt] = {v, fir[u], c, 0};
        fir[u] = cnt++;
        e[cnt] = {u, fir[v], 0, 0};
        fir[v] = cnt++;
    }

    bool bfs() {
        std::queue<int> q;
        memset(dep, 0, sizeof(int) * (n + 1));

        dep[S] = 1;
        q.push(S);
        while (q.size()) {
            int u = q.front();
            q.pop();
            for (int i = fir[u]; ~i; i = e[i].nxt) {
                int v = e[i].v;
                if ((!dep[v]) && (e[i].cap > e[i].flow)) {
                    dep[v] = dep[u] + 1;
                    q.push(v);
                }
            }
        }
        return dep[T];
    }

	int dfs(int u, int flow) {
		if ((u == T) || (!flow)) return flow;

		int ret = 0;
		for (int& i = cur[u]; ~i; i = e[i].nxt) {
			int v = e[i].v, d;
			if ((dep[v] == dep[u] + 1) &&
			        (d = dfs(v, std::min(flow - ret, e[i].cap - e[i].flow)))) {
				ret += d;
				e[i].flow += d;
				e[i ^ 1].flow -= d;
				if (ret == flow) return ret;
			}
		}
		return ret;
	}

	void dinic() {
		while (bfs()) {
			memcpy(cur, fir, sizeof(int) * (n + 1));
			maxflow += dfs(S, INF);
		}
	}
} mf;

void solve() {
    int m, n;
    std::cin >> n >> m >> mf.S >> mf.T;
    mf.n = n;
    mf.init();
    for (int i = 0; i < m; i++) {
        int u, v, w;
        std::cin >> u >> v >> w;
        mf.add_edge(u, v, w);
        mf.add_edge(v, u, 0);
    }
    mf.dinic();
    std::cout << mf.maxflow << '\n';	
}
```

isap 代码实现。时间复杂度优于以上两个算法。

```cpp
using i64 = long long;

const int N = 5000 + 5;
using P = std::pair<int, int>;

int n;
struct MF {
    const int inf = 2147483647;
    int S, T;
    int dep[N], gap[N];
    i64 maxflow;
    std::vector<P> e[N]; 
    std::vector<int> id[N];
    std::queue<int> q;

    void add(int u, int v, i64 w) {
        id[u].push_back(e[v].size());
        id[v].push_back(e[u].size());
        e[u].push_back({v, w});
        e[v].push_back({u, 0});
    }

    void bfs() {
        std::memset(dep, -1, sizeof(dep));
        std::memset(gap, 0, sizeof(gap));
        gap[0] = 1;
        dep[T] = 0;
        q.push(T);
        while(!q.empty()) {
            int x = q.front();
            q.pop();
            for (int i = 0; i < e[x].size(); i++) {
                int v = e[x][i].first;
                if(dep[v] == -1) {                
                    dep[v] = dep[x] + 1;
                    gap[dep[v]]++;
                    q.push(v);
                }
            }
        }
    }

    i64 dfs(int x, int flow) {
        if(x == T) {
            maxflow += flow;
            return flow;
        }
        i64 used = 0;
        for (int i = 0; i < e[x].size() ; i++ ) {
            int v = e[x][i].first, w = e[x][i].second;
            if(w == 0 || dep[v] + 1 != dep[x]) continue;
            i64 f = dfs(v, std::min(flow - used, (i64)w));
            if(f) {
                used += f;
                e[x][i].second -= f;
                e[v][id[x][i]].second += f;
                if(used == flow) return flow;
            }
        }
        gap[dep[x]]--;
        if(!gap[dep[x]]) dep[S] = n + 1;
        dep[x]++;
        gap[dep[x]]++;
        return used;
    }

    void isap() {
        bfs();
        while(dep[S] < n) {
            dfs(S, inf);
        }
    }

} mf;

void solve() {
	int m;
	std::cin >> n >> m >> mf.S >> mf.T;
	for (int i = 0; i < m; i++) {
		int u, v, w;
		std::cin >> u >> v >> w;
		mf.add(u, v, w);
	}
	mf.isap();
	std::cout << mf.maxflow << '\n';	
}
```

### 费用流

在最大流的基础上，每条边都有单位流量的费用。我们需要求出在最大化流量的前提下，还要使得总费用最小。

**定理**：求得同流量中最小费用的流，当且仅当残量网络中不存在负环（费用和为负数的环）。

- 例题

[**P3381 【模板】最小费用最大流**](https://www.luogu.com.cn/problem/P3381)

**Solution**

```cpp
const int N = 5e5;
const int INF = 0x3f3f3f3f;

struct MCMF {
    int S, T, cnt = 1, Mincost, Maxflow;
    int head[N], dis[N], book[N], vis[N];
    std::deque <int> q;
    struct Edge {
        int to, w, c, nxt;
    } e[N << 1];
	
    void init() {
        memset(head, 0, sizeof(head));
        for (int i = 1; i <= cnt; i++)
            e[i].to = e[i].w = e[i].c = e[i].nxt = 0;
       	cnt = 1;
        Mincost = Maxflow = 0;
    }
    
    void add(int from, int to, int w, int c) {
        e[++cnt].nxt = head[from];
        e[cnt].w = w;
        e[cnt].c = c;
        e[cnt].to = to;
        head[from] = cnt;
    }
    
    void ADD(int from, int to, int w, int c) {
        add(from, to, w, c), add(to, from, 0, -c);
    }

    void clear() {
        memset(book, 0, sizeof(book));
        memset(vis, 0, sizeof(vis));
        memset(dis, 0x3f, sizeof(dis));
        dis[S] = 0;
        q.push_front(S);
    }

    bool spfa() {
        clear();
        while (!q.empty()) {
            int x = q.front();
            q.pop_front(), vis[x] = 0;
            for (int i = head[x]; i; i = e[i].nxt) {
                int v = e[i].to;
                if (e[i].w <= 0 || dis[v] <= dis[x] + e[i].c)
                    continue;
                dis[v] = dis[x] + e[i].c;
                if (vis[v]) continue;
                vis[v] = 1;
                if (!q.empty() && dis[q.front()] > dis[v])
                    q.push_front(v);
                else
                    q.push_back(v);
            }
        }
        return dis[T] != INF;
    }

    int dfs(int x, int Min) {
        if (x == T) return Min;
        book[x] = 1;
        int flow = 0;
        for (int i = head[x]; i; i = e[i].nxt) {
            int v = e[i].to, c = e[i].c;
            if (e[i].w <= 0 || book[v] || dis[v] != dis[x] + c)
                continue;
            int tmp = dfs(v, std::min(e[i].w, Min - flow));
            flow += tmp, e[i].w -= tmp, e[i ^ 1].w += tmp, Mincost += c * tmp;
            if (flow == Min)
                break;
        }
        return flow;
    }

    void dinic() {
        while (spfa())
            Maxflow += dfs(S, INF);
    }
    
} mf;
```

### 二分图最大匹配

新增加一个超级源点指向左边所有的点，再新增加一个超级汇点被右边所有的点指向。然后跑最大流即可。

时间复杂度 $O(n\sqrt{e})$。

```cpp
using i64 = long long;

const int N = 1e6 + 5;
using P = std::pair<int, int>;

struct MF {
    const int inf = 0x3f3f3f3f;
    int S, T;
    int dep[N], gap[N], maxflow;
    std::vector<P> e[N]; 
    std::vector<int> id[N];
    std::queue<int> q;

    void add(int u,int v,int w) {
        id[u].push_back(e[v].size());
        id[v].push_back(e[u].size());
        e[u].push_back({v, w});
        e[v].push_back({u, 0});
    }


    void bfs() {
        std::memset(dep, 0x3f, sizeof(dep));
        gap[0] = 1;
        dep[T] = 0;
        q.push(T);
        while(!q.empty()) {
            int x = q.front();
            q.pop();
            for (int i = 0; i < e[x].size(); i++) {
                int v = e[x][i].first;
                if(dep[v] == inf) {                
                    dep[v] = dep[x] + 1;
                    gap[dep[v]]++;
                    q.push(v);
                }
            }
        }
    }

    int dfs(int x, int flow) {
        if(x == T) {
            maxflow += flow;
            return flow;
        }
        int used = 0;
        for ( int i = 0 ; i < e[x].size() ; i++ ) {
            int v = e[x][i].first, w = e[x][i].second;
            if(w == 0 || dep[v] + 1 != dep[x])continue;
            int f = dfs(v, std::min(flow - used, w));
            if(f) {
                used += f;
                e[x][i].second -= f;
                e[v][id[x][i]].second += f;
                if(used == flow) return flow;
            }
        }
        gap[dep[x]]--;
        if(!gap[dep[x]]) dep[S] = T + 1;
        dep[x]++;
        gap[dep[x]]++;
        return used;
    }

    void isap() {
        bfs();
        while(dep[S] <= T) {
            dfs(S, inf);
        }
    }

} mf;

void solve() {
    int n, m, e;
    std::cin >> n >> m >> e;
    mf.S = 0, mf.T = n + m + 1;
    for (int i = 0; i < e; i++) {
        int u, v;
        std::cin >> u >> v;
        mf.add(u, v + n, 1);
    }
    for (int i = 1; i <= n; i++) {
        mf.add(mf.S, i, 1);
    }
    for (int i = 1; i <= m; i++) {
        mf.add(i + n, mf.T, 1);
    }
    mf.isap();
    std::cout << mf.maxflow << '\n';    
}
```

## 网络流和二分图的经典模型

### 最小割



### 最大权闭合子图


