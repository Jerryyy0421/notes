# 图论

## 网络流

### 最大流

主要有 EK 算法 和 Dicnic 算法，其中 Dinic 算法效率更高。

EK 代码实现

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


Dicnic 代码实现

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

	void add_edge(int u, int v, int w) {
		e[cnt] = {v, fir[u], w, 0};
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

### 二分图最大匹配

新增加一个超级源点指向左边所有的点，再新增加一个超级汇点被右边所有的点指向。然后跑最大流即可。

时间复杂度 $O(n\sqrt{e})$。

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

    void add_edge(int u, int v, int w) {
        e[cnt] = {v, fir[u], w, 0};
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
    int n, m, e;
    std::cin >> n >> m >> e;
    mf.init();
    mf.n = n + m + 1;
    mf.S = 0, mf.T = n + m + 1;
    for (int i = 0; i < e; i++) {
        int u, v;
        std::cin >> u >> v;
        mf.add_edge(u, v + n, 1);
        mf.add_edge(v + n, u, 0);
    }
    for (int i = 1; i <= n; i++) {
        mf.add_edge(mf.S, i, 1);
        mf.add_edge(i, mf.S, 0);
    }
    for (int i = 1; i <= m; i++) {
        mf.add_edge(i + n, mf.T, 1);
        mf.add_edge(mf.T, i + n, 0);
    }
    mf.dinic();
    std::cout << mf.maxflow << '\n';    
}
```
