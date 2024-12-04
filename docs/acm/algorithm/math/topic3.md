# 线性代数

## 线性基

### 基本概念

**张成：** 设 $T \subseteq S$，所有这样的子集 $T$ 的异或和组成的集合称为集合 $S$ 的张成，记作 $\text{span}(S)$。即在 $S$ 中选出任意多个数，其异或和的所有可能的结果组成的集合。

**线性基**

我们称集合 $B$ 是集合 $S$ 的线性基，当且仅当：

1. $S \subseteq \text{span}(B)$，即 $S$ 是 $B$ 的张成的子集；
2. $B$ 是线性无关的。

集合 $B$ 中元素的个数，称为线性基的长度。

**线性基满足性质：**

1. $B$ 是极小的满足线性基性质的集合，它的任何真子集都不可能是线性基。
2. $S$ 中的任意元素都可以唯一表示为 $B$ 中若干个元素异或起来的结果。

### 代码实现

```cpp
struct LinearBasis {
    static constexpr int MAXN = 50;
    i64 a[MAXN + 1];
    i64 b[MAXN + 1];
    int tot = 0, zero = 0;

    LinearBasis() {
        std::fill(a, a + MAXN + 1, 0);
        std::fill(b, b + MAXN + 1, 0);
        tot = 0; zero = 0;
    }

    LinearBasis(std::vector<i64> x) {
        build(x);
    }

    void insert(i64 t) {
        for (int j = MAXN; j >= 0; j--) {
            if (!(t & (1ll << j))) continue;

            if (a[j]) t ^= a[j];
            else {
                for (int k = 0; k < j; k++) if (t & (1ll << k)) t ^= a[k];
                for (int k = j + 1; k <= MAXN; k++) if (a[k] & (1ll << j)) a[k] ^= t;
                a[j] = t;
                return ;
            }
        }
        if (t == 0) zero = 1;
    }

    // 数组 x 表示集合 S，下标范围 [1...n]
    void build(std::vector<i64> x) {
        std::fill(a, a + MAXN + 1, 0);
        std::fill(b, b + MAXN + 1, 0);
        tot = zero = 0;

        for (auto num: x) {
            insert(num);
        }

        tot = 0;
        for (int i = 0; i <= MAXN; i++) if (a[i]) b[tot++] = a[i];
    }

    i64 queryMax() {
        i64 res = 0;
        for (int i = 0; i <= MAXN; i++) res ^= a[i];
        return res;
    }

    i64 queryMin() {
        for (int i = 0; i <= MAXN; i++) 
            if (a[i]) return a[i];
    }

    i64 query(i64 k) {
    	k -= zero;
    	if (!k) return 0;
		if (k >= (1LL << tot)) return -1;
		i64 ans = 0;
		for(int i = tot - 1; i >= 0; i--)
			if(k & (1LL << i)) ans ^= b[i];
		return ans; 
	}

    void mergeFrom(std::vector<i64> b) {
        for (auto x: b) insert(x);
    }

    static LinearBasis merge(const LinearBasis &a, const LinearBasis &b) {
        LinearBasis res = a;
        for (int i = 0; i <= MAXN; i++) res.insert(b.a[i]);
        return res;
    }

};
```

### 例题

[**P3812 【模板】线性基**](https://www.luogu.com.cn/problem/P3812)

> 给定 $n$ 个整数（数字可能重复），求在这些数中选取任意个，使得他们的异或和最大。

**Solution**

求出这 $n$ 个数的异或线性基，异或起来求 $\text{max}$。

```cpp
struct LinearBasis {
    static constexpr int MAXN = 50;
    i64 a[MAXN + 1];
    i64 b[MAXN + 1];
    int tot = 0, zero = 0;

    LinearBasis() {
        std::fill(a, a + MAXN + 1, 0);
        std::fill(b, b + MAXN + 1, 0);
        tot = 0; zero = 0;
    }

    LinearBasis(std::vector<i64> x) {
        build(x);
    }

    void insert(i64 t) {
        for (int j = MAXN; j >= 0; j--) {
            if (!(t & (1ll << j))) continue;

            if (a[j]) t ^= a[j];
            else {
                for (int k = 0; k < j; k++) if (t & (1ll << k)) t ^= a[k];
                for (int k = j + 1; k <= MAXN; k++) if (a[k] & (1ll << j)) a[k] ^= t;
                a[j] = t;
                return ;
            }
        }
        if (t == 0) zero = 1;
    }

    // 数组 x 表示集合 S，下标范围 [1...n]
    void build(std::vector<i64> x) {
        std::fill(a, a + MAXN + 1, 0);
        std::fill(b, b + MAXN + 1, 0);
        tot = zero = 0;

        for (auto num: x) {
            insert(num);
        }

        tot = 0;
        for (int i = 0; i <= MAXN; i++) if (a[i]) b[tot++] = a[i];
    }

    i64 queryMax() {
        i64 res = 0;
        for (int i = 0; i <= MAXN; i++) res ^= a[i];
        return res;
    }

};

void solve() {
    int n;
    std::cin >> n; 
    std::vector<i64> num(n);
    for (auto &x: num) std::cin >> x;
    LinearBasis lb(num);
    std::cout << lb.queryMax() << '\n';
}

```

[**HDU3949 XOR**](https://acm.hdu.edu.cn/showproblem.php?pid=3949)

> 给定 $n$ 个整数（数字可能重复），求在这些数中选取任意个，第 $k$ 小的异或和。

**Solution**

求出这 $n$ 个数的异或线性基，把其中为 $0$ 的删去，构造出全部非 $0$ 的线性基，然后把 $k$ 按二进制划分，选第 $i$ 个线性基本质上和 $k$ 二进制第 $i$ 位上是否为 $1$ 是等价的。

一个比较大的坑点就是一定要考虑线性基能否得到 $0$。

```cpp
struct LinearBasis {
    static constexpr int MAXN = 50;
    i64 a[MAXN + 1];
    i64 b[MAXN + 1];
    int tot = 0, zero = 0;

    LinearBasis() {
        std::fill(a, a + MAXN + 1, 0);
        std::fill(b, b + MAXN + 1, 0);
        tot = 0; zero = 0;
    }

    LinearBasis(std::vector<i64> x) {
        build(x);
    }

    void insert(i64 t) {
        for (int j = MAXN; j >= 0; j--) {
            if (!(t & (1ll << j))) continue;

            if (a[j]) t ^= a[j];
            else {
                for (int k = 0; k < j; k++) if (t & (1ll << k)) t ^= a[k];
                for (int k = j + 1; k <= MAXN; k++) if (a[k] & (1ll << j)) a[k] ^= t;
                a[j] = t;
                return ;
            }
        }
        if (t == 0) zero = 1;
    }

    // 数组 x 表示集合 S，下标范围 [1...n]
    void build(std::vector<i64> x) {
        std::fill(a, a + MAXN + 1, 0);
        std::fill(b, b + MAXN + 1, 0);
        tot = zero = 0;

        for (auto num: x) {
            insert(num);
        }

        tot = 0;
        for (int i = 0; i <= MAXN; i++) if (a[i]) b[tot++] = a[i];
    }

    i64 queryMax() {
        i64 res = 0;
        for (int i = 0; i <= MAXN; i++) res ^= a[i];
        return res;
    }

    i64 queryMin() {
        for (int i = 0; i <= MAXN; i++) 
            if (a[i]) return a[i];
    }

    i64 query(i64 k) {
    	k -= zero;
    	if (!k) return 0;
		if (k >= (1LL << tot)) return -1;
		i64 ans = 0;
		for(int i = tot - 1; i >= 0; i--)
			if(k & (1LL << i)) ans ^= b[i];
		return ans; 
	}

    void mergeFrom(std::vector<i64> b) {
        for (auto x: b) insert(x);
    }

    static LinearBasis merge(const LinearBasis &a, const LinearBasis &b) {
        LinearBasis res = a;
        for (int i = 0; i <= MAXN; i++) res.insert(b.a[i]);
        return res;
    }

};

void solve() {
	int n;
	std::cin >> n;
	std::vector<i64> a(n);
	for (auto &x: a) std::cin >> x;
	int q;
	std::cin >> q;
	LinearBasis lb(a);
	while (q--) {
		i64 k;
		std::cin >> k;
		std::cout << lb.query(k) << '\n';
	}
}
```



## 参考资料

[线性基学习笔记](https://oi.men.ci/linear-basis-notes/#%E5%BA%94%E7%94%A8)

