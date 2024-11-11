# 进阶数据结构

## 线段树

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

[P5787 二分图 /【模板】线段树分治](https://www.luogu.com.cn/problem/P5787)

**Solution**

对于二分图，我们用扩展域并查集进行判断。

对于一条边的信息，在 $[l, r]$ 的时间点出现过，我们在时间轴上建一棵线段树，对于每条边，最多被分为 $O(\log k)$ 段。我们遍历线段树，每到一个节点，就把它上面的每个边都连上。

回溯的时候由于并查集不支持删边，我们使用可撤销并查集（没有路径压缩，有启发式合并，时间复杂度 $O(m\log n)$）来进行操作。

时间复杂度为 $O(m\log n\log k)$。

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
		l++;
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



## 参考资料

[线段树分治 学习笔记](https://www.xht37.com/%E7%BA%BF%E6%AE%B5%E6%A0%91%E5%88%86%E6%B2%BB-%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0/)

[董晓算法](https://www.cnblogs.com/dx123)

