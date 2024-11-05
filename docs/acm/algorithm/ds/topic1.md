# 基础数据结构

## 并查集

最朴素的并查集，查找根节点，合并，查询都是 $O(n)$。

我们分别有路径压缩，启发式合并 / 按秩合并来优化。

启发式合并：按照节点数小的连向节点数大的。

按秩合并：按照最大深度小的连向最大深度大的。

一般启发式合并比按秩合并好写，往往可以用启发式合并来代替按秩合并。

!!! note "时间复杂度分析"
    同时使用启发式合并和路径压缩的时间复杂度是 $O(m\alpha (m, n))$。

    不使用启发式合并、只使用路径压缩的最坏时间复杂度是 $O(m\log n)$，在平均情况下，时间复杂度依然是 $O(m\alpha (m, n))$。

    如果只使用启发式合并，而不使用路径压缩，时间复杂度为 $O(m\log n)$。由于路径压缩单次合并可能造成大量修改，有时路径压缩并不适合使用。例如，在可持久化并查集、线段树分治 + 并查集中，一般使用只启发式合并的并查集。


### 代码实现

- 启发式合并

```cpp
struct DSU {
    std::vector<size_t> fa, size;

    size_t find(size_t x) { return fa[x] == x ? x : find(fa[x]); }

    explicit DSU(size_t size_) : fa(size_), size(size_, 1) {
        std::iota(fa.begin(), fa.end(), 0);
    }

    bool query(size_t x, size_t y) {
    	return (find(x) == find(y));
    }

    void merge(size_t x, size_t y) {
        x = find(x), y = find(y);
        if (x == y) return;
        if (size[x] < size[y]) std::swap(x, y);
        fa[y] = x;
        size[x] += size[y];
    }

    void move(size_t x, size_t y) {
        auto fx = find(x), fy = find(y);
        if (fx == fy) return;
        fa[x] = fy;
        --size[fx], ++size[fy];
    }
};
```

- 按秩合并

```cpp
struct DSU {
    std::vector<size_t> fa, rk;

    size_t find(size_t x) { return fa[x] == x ? x : find(fa[x]); }

    explicit DSU(size_t size_) : fa(size_), rk(size_, 1) {
        std::iota(fa.begin(), fa.end(), 0);
    }

    bool query(size_t x, size_t y) {
    	return (find(x) == find(y));
    }

    void merge(size_t x, size_t y) {
        x = find(x), y = find(y);
        if (rk[x] <= rk[y])
            fa[x] = y;
        else
            fa[y] = x;
        if (rk[x] == rk[y] && x != y)
            rk[y]++;
    }
};
```

- 可撤回并查集

这里使用的启发式合并，注意这里不可以路径压缩。

```cpp
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
            auto [x, y] = his.back();
            his.pop_back();
            f[y] = y;
            siz[x] -= siz[y];
        }
    }
};
```

### 扩展域并查集

又称为种类并查集。

本质上是拆点找关系，一般的并查集都是找**朋友的朋友也是朋友**这层关系，但是带权并查集是找**敌人的敌人就是朋友**这层关系。我们把 $1 \sim n$ 扩展为 $1 \sim 2n$，其中 $1$ 被拆为了 $1$ 和 $1 + n$。和 $1$ 在一个连通块表示和他关系好，和 $n + 1$ 在一个连通块表示和他关系不好。

- 例题

[**P2024 [NOI2001] 食物链**](https://www.luogu.com.cn/problem/P2024)

**Solution**

经典扩展并查集的题目了。

我们开三倍空间，$\{i + n\}$ 表示 $\{i\}$ 的捕食者，$\{i + 2n\}$ 表示 $\{i + n\}$ 的捕食者，$\{i\}$ 表示 $\{i + 2n\}$ 的捕食者。然后分别建立连接关系即可。

```cpp
struct DSU {
	std::vector<size_t> fa, size;

	size_t find(size_t x) { return fa[x] == x ? x : find(fa[x]); }

    explicit DSU(size_t size_) : fa(size_), size(size_, 1) {
        std::iota(fa.begin(), fa.end(), 0);
    }

    bool query(size_t x, size_t y) {
    	return (find(x) == find(y));
    }

    void merge(size_t x, size_t y) {
        x = find(x), y = find(y);
        if (x == y) return;
        if (size[x] < size[y]) std::swap(x, y);
        fa[y] = x;
        size[x] += size[y];
    }
};


void solve() {
	int n, k;
	std::cin >> n >> k;
	DSU dsu(3 * n + 10);
	int ans = 0;
	while (k--) {
		int op, x, y;
		std::cin >> op >> x >> y;
		if (x > n || y > n) {
			ans++;
			continue;
		}
		if (op == 1) {
			if (dsu.query(x + 2 * n, y + n) || dsu.query(x + n, y + 2 * n)) {
				ans++;
			}
			else {
				dsu.merge(x, y);
				dsu.merge(x + n, y + n);
				dsu.merge(x + 2 * n, y + 2 * n);
			}
		}
		else {
			if (dsu.query(x + n, y + n) || dsu.query(x + n, y + 2 * n)) {
				ans++;
			}
			else {
				dsu.merge(x + 2 * n, y + n);
				dsu.merge(x + n, y);
				dsu.merge(x, y + 2 * n);
		    }
	    }
    }
    std::cout << ans << '\n';
}
```

本题也可以用带权并查集去做。

我们记点到根节点的距离为 $d_i$，我们在一个模 $3$ 的域下看点之间的关系。

若 $d_x - d_y \equiv 0(\mod 3)$ 则说明 $x$ 和 $y$ 是同类。

若 $d_x - d_y \equiv 1(\mod 3)$ 则说明 $x$ 是 $y$ 的天敌。

若 $d_x - d_y \equiv 2(\mod 3)$ 则说明 $x$ 是 $y$ 的猎物。


### 带权并查集

- 例题

带权并查集，顾名思义，连边的时候是带有权值的，往往是要维护每个元素到根节点的某一属性值。需要改变 `find` 函数。

[**P1196 [NOI2002] 银河英雄传说**](https://www.luogu.com.cn/problem/P1196)

**Solution**

我们要维护每个点到根节点的距离，此外两个队头合并的时候还要记录每个队伍的长度，所以用 `dis` 和 `num` 记录。

使用带权并查集维护即可。

```cpp
struct DSU {
    std::vector<size_t> fa;
    std::vector<int> dis, num;

    size_t find(size_t x) { 
    	if (fa[x] == x) return x;
    	int fx = find(fa[x]);
    	dis[x] += dis[fa[x]];
    	return fa[x] = fx;
    }

    explicit DSU(size_t size_) : fa(size_), dis(size_, 0), num(size_, 1) {
        std::iota(fa.begin(), fa.end(), 0);
    }

    bool query(size_t x, size_t y) {
    	return (find(x) == find(y));
    }

    void merge(size_t x, size_t y) {
        x = find(x), y = find(y);
        if (x == y) return;
        fa[x] = y;
        dis[x] = num[y];
        num[y] += num[x];
    }
};

void solve() {
	DSU dsu(30010);
	int t;
	std::cin >> t;
	int n = 4;
	while (t--) {
		char op;
		int x, y;
		std::cin >> op >> x >> y;
		if (op == 'M') {
			dsu.merge(x, y);
		}
		else {
			if (dsu.query(x, y)) {
				std::cout << std::abs(dsu.dis[x] - dsu.dis[y]) - 1 << '\n';
			}
			else {
				std::cout << "-1\n";
			}
		}
	}
}
```


## 习题




## 参考资料

[OI-Wiki 并查集](https://oi-wiki.org/ds/dsu/)

[算法学习笔记(7)：种类并查集](https://zhuanlan.zhihu.com/p/97813717)