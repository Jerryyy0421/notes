# 进阶数据结构

## 线段树

### 普通线段树

线段树是一类以分块思想为核心的基础且强大的数据结构。

区间修改 + 区间求和。

```cpp
using i64 = long long;
struct Info {
    i64 sum = 0;
};

Info operator+(const Info &a, const Info &b) {
	return {a.sum + b.sum};
}

struct SegmentTree {
    int n;
    std::vector<int> tag;
    std::vector<Info> info;
    SegmentTree(int n_) : n(n_), tag(4 * n), info(4 * n) {}

    void pull(int p) {
        info[p] = info[2 * p] + info[2 * p + 1];
    }

    void add(int p, int v, int l, int r) {
        tag[p] += v;
        info[p].sum += (i64) v * (r - l + 1);
    }

    void push(int p, int l, int r) {
        int mid = (l + r) >> 1;
        add(2 * p, tag[p], l, mid);
        add(2 * p + 1, tag[p], mid + 1, r);
        tag[p] = 0;
    }
    
    Info query(int p, int l, int r, int nl, int nr) {
        if (l > nr || r < nl) {
            return {};
        }
        if (l >= nl && r <= nr) {
            return info[p];
        }
        int m = (l + r) / 2;
        push(p, l, r);
        return query(2 * p, l, m, nl, nr) + query(2 * p + 1, m + 1, r, nl, nr);
    }
    
    Info query(int x, int y) {
        return query(1, 1, n, x, y);
    }
    
    void rangeAdd(int p, int l, int r, int nl, int nr, int v) {
        if (l > nr || r < nl) {
            return;
        }
        if (l >= nl && r <= nr) {
            return add(p, v, l, r);
        }
        int m = (l + r) / 2;
        push(p, l, r);
        rangeAdd(2 * p, l, m, nl, nr, v);
        rangeAdd(2 * p + 1, m + 1, r, nl, nr, v);
        pull(p);
    }
    
    void rangeAdd(int x, int y, int v) {
        rangeAdd(1, 1, n, x, y, v);
    }
    
    void modify(int p, int l, int r, int x, const Info &v) {
        if (r == l) {
            info[p] = v;
            return;
        }
        int m = (l + r) / 2;
        push(p, l, r);
        if (x <= m) {
            modify(2 * p, l, m, x, v);
        } else {
            modify(2 * p + 1, m + 1, r, x, v);
        }
        pull(p);
    }
    
    void modify(int x, const Info &v) {
        modify(1, 1, n, x, v);
    }
};

void solve() {
	int n, m;
	std::cin >> n >> m;
    std::vector<int> a(n + 1);

    SegmentTree seg(n);

    for (int i = 1; i <= n; i++) {
        std::cin >> a[i];
        seg.modify(i, {a[i]});
    }
    while (m--) {
        int op;
        std::cin >> op;
        if (op == 1) {
            int x, y, k;
            std::cin >> x >> y >> k;
            seg.rangeAdd(x, y, k);
        }
        else {
            int x, y;
            std::cin >> x >> y;
            std::cout << seg.query(x, y).sum << '\n';
        }
    }
}
```




### 线段树分治

以下3摘自 xht37‘s blog

> **核心思想**
> 
> 考虑这样一个问题：

> - 有一些操作，每个操作只在 $l \sim r$ 的时间段内有效。
> - 有一些询问，每个询问某一个时间点所有操作的贡献。

> 对于这样的询问，我们可以离线后**在时间轴上建一棵线段树**，这样对于每个操作，相当于在线段树上进行区间操作。

> 遍历整颗线段树，到达每个节点时执行相应的操作，然后继续向下递归，到达叶子节点时统计贡献，回溯时撤销操作即可。

> 这样的思想被称为**线段树分治**，可以在低时间复杂度内解决一类**在线算法并不优秀**的问题。

- 例题

[**P5787 二分图 /【模板】线段树分治**](https://www.luogu.com.cn/problem/P5787)

**Solution**

对于二分图，我们用扩展域并查集进行判断。

对于一条边的信息，在 $[l, r]$ 的时间点出现过，我们在时间轴上建一棵线段树，对于每条边，最多被分为 $O(\log k)$ 段。我们遍历线段树，每到一个节点，就把它上面的每个边都连上。

回溯的时候由于并查集不支持删边，我们使用可撤销并查集（没有路径压缩，有启发式合并，时间复杂度 $O(m\log n)$）来进行操作。

时间复杂度为 $O(m\log n\log k)$。

```cpp
const int N = 2e5 + 5;

using P = std::pair<int, int>;
int n, m, k;
std::vector<int> E[N << 2];
std::vector<P> e;

struct DSU {
    std::vector<int> siz;
    std::vector<int> f;
    std::vector<std::array<int, 2>> his;

    DSU(int n) : siz(n + 1, 1), f(n + 1) {
        std::iota(f.begin(), f.end(), 0);
    }

    int find(int x) {
        while (f[x] != x) {
            x = f[x];
        }
        return x;
    }

    bool query(int x, int y) {
    	return find(x) == find(y);
    }

    bool merge(int x, int y) {
        x = find(x);
        y = find(y);
        if (x == y) {
            return false;
        }
        if (siz[x] < siz[y]) {
            std::swap(x, y);
        }
        his.push_back({x, y});
        siz[x] += siz[y];
        f[y] = x;
        return true;
    }

    int time() {
        return his.size();
    }

    void revert(int tm) {
        while (his.size() > tm) {
            auto tmp = his.back();
            int x = tmp[0], y = tmp[1];
            his.pop_back();
            f[y] = y;
            siz[x] -= siz[y];
        }
    }
} dsu(N);


void update(int root, int l, int r, int nl, int nr, int id) {
	if (l >= nl && r <= nr) {
		E[root].push_back(id);
		return ;
	}
	int mid = (l + r) >> 1;
	if (mid + 1 <= nr) update(root << 1 | 1, mid + 1, r, nl, nr, id);
  	if (mid >= nl) update(root << 1, l, mid, nl, nr, id);
}


void dfs(int rt, int l, int r) {
	int tt = dsu.time(), ok = 1;
	for (auto i: E[rt]) { 
    	int u = e[i].first, v = e[i].second;
    	if (dsu.query(u, v)) {
      		for (int i = l; i <= r; i++) std::cout << "No\n";
      		ok = 0;
      		break;
    	}
    	dsu.merge(u, v + n);
    	dsu.merge(v, u + n);
  	}
  	if (ok) {
    	if (l == r) std::cout << "Yes\n";
    	else {
      		int mid = (l + r) >> 1;
      		dfs(rt << 1, l, mid);
      		dfs(rt << 1 | 1, mid + 1, r);
    	}
  	} 
  	dsu.revert(tt);
}

void solve() {
	std::cin >> n >> m >> k;
	for (int i = 1; i <= m; i++) {
		int x, y, l, r;
		std::cin >> x >> y >> l >> r;
		e.push_back({x, y});
		update(1, 1, k, l, r, i - 1);
	}
	dfs(1, 1, k);
}
```



## 习题

[**CF19E Boss, Thirsty**](https://codeforces.com/problemset/problem/19/E)

> 给定一张图，只能删一条边，有多少种方法能变成二分图。

**Solution**

仔细想来，对于第 $i$ 条边，我们在第 $i$ 个时刻删掉它，相当于它在 $[1, i - 1]$ 和 $[i + 1, m]$ 时间段出现。

这样第 $i$ 个时刻就是只有 $i$ 边不在，其他都在的情况。和线段树分治的例题一模一样，用线段树分治即可。

[**CF1814F Communication Towers**](https://codeforces.com/problemset/problem/1814/F)

> 每个点只在 $l_i$ 到 $r_i$ 时间段出现过，问对于每个点，是否存在一时刻和 $1$ 联通。

**Solution**

线段树分治 + 一个很巧妙的 trick。

又是在时间轴上处理，很容易想到线段树分治，点的出现时间段转化为边的出现时间段。维护连通块也很自然想到并查集。

但是如何维护每个点是否和 $1$ 联通呢？

这里有一个很巧妙的点，我们可以只记录并查集的根是否和 $1$ 相连，用 `tag` 数组记录状态，若大于 $1$ 则是相连的。

回溯的时候会退回到根节点和之前某个根合并的状态，这里相当于对它进行树上差分，差分的结果 `tag` 数组就表示这个合并前的根在合并之后是否也满足 `tag` 大于 $0$，即是否也满足和 $1$ 联通。

但这里注意一下，由于并查集合并上的边权是差分值，所以在合并的时候，被合并为别人儿子的那个根的 `tag` 要减去新根的 `tag`，因为回溯的时候要加回来，所以那样才是它真正的 `tag`。

[**CF1681F Unique Occurrences**](https://codeforces.com/contest/1681/problem/F)

> 一棵 $n$ 个点的树，每条边都有颜色。求 $\sum_{u = 1}^n \sum_{v = u + 1}^n f(u, v)$。
>
> 其中 $f(u, v)$ 表示 $u$ 到 $v$ 的简单路径中恰好出现了一次的颜色数量。

**Solution**

直接找路径肯定不可以，我们计算每条边可以对哪些路径产生贡献。

对于颜色 $i$ 的贡献，显然就是断掉所有颜色为 $i$ 的边，然后算每条颜色为 $i$ 的两端对应的点所在连通块大小的乘积。累加求和即可。

对于这种断边再连边的操作，我们可以采用线段树分治去做。设第 $i$ 个时刻所有颜色为 $i$ 的边都断开，其余时刻连上，然后算这个时刻连通块大小乘积，用可撤回并查集很好维护。

[**P5227 [AHOI2013] 连通图**](https://www.luogu.com.cn/problem/P5227)

> 给定一张 $n$ 个点 $m$ 条边的无向图，有 $k$ 次询问，每次问删完 $c_i$ 条边之后整个图还是否能联通。

**Solution**

数据范围为 $2\times 10^5$，考虑 $O(n\log n\log n)$ 的线段树分治，设第 $i$ 个时间点，我们把第 $i$ 次询问的边集都删除了，对于每一条边，我们记录它被删掉的时间点，然后只在它存在的时间点连边，跑线段树分治即可。

和 [P10075 [GDKOI2024 普及组] 切割](https://www.luogu.com.cn/problem/P10075) 原了，但是后者数据更强，只能哈希过，做法见  。

[**P5631 最小mex生成树**](https://www.luogu.com.cn/problem/P5631)

> 给定一张 $n$ 个点 $m$ 条边的无向图，边有权值。求这棵树的生成树要求其边权集合的 $\text{mex}$ 最小。

**Solution**

我们按权值的值域来建线段树，设第 $i$ 个时刻，权值为 $i$ 的边是不存在的，若第 $i$ 时刻满足所有点联通，则 $\text{mex}$ 就是 $i$，故在 $[1, w_i - 1]$ 和 $[w_i + 1, maxn]$ 时间段连边即可。

[**P4219 [BJOI2014] 大融合**](https://www.luogu.com.cn/problem/P4219)

> 维护一个 $n$ 个点的森林，初始全是散点。有 $q$ 个操作，支持加边（保证这两个点之前不连边）；输出经过某一边的简单路径数。允许离线。

**Solution**

输出的时候让这条边消失，答案即为边所在两点的连通块乘积。一条边只在第 $i$ 时刻之后出现，且每次访问这条边的时候都会消失，跑线段树分治即可。

[**P2056 [ZJOI2007] 捉迷藏**](https://www.luogu.com.cn/problem/P2056)

> 一棵树，初始所有点都是黑点，每次有两种操作，一种是把黑点变为白点，把白点变为黑点；另一种是查询最远的两个黑点距离。

**Solution**



[**CF601E A Museum Robbery**](https://codeforces.com/contest/601/problem/E)

> 

**Solution**



[**P4585 [FJOI2015] 火星商店问题**](https://www.luogu.com.cn/problem/P4585)

> 

**Solution**



## 参考资料

[线段树分治 学习笔记](https://www.xht37.com/%E7%BA%BF%E6%AE%B5%E6%A0%91%E5%88%86%E6%B2%BB-%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0/)

[董晓算法](https://www.cnblogs.com/dx123)

