# 二维计算几何

## 二维几何基础

### 距离
- 欧氏距离
    
    一般也称作欧几里得距离。在平面直角坐标系中，设点 $A,B$ 的坐标分别为 $A(x_1,y_1),B(x_2,y_2)$，则两点间的欧氏距离为：

    $$
      \left | AB \right | = \sqrt{\left ( x_2 - x_1 \right )^2 + \left ( y_2 - y_1 \right )^2}
    $$

    $n$ 维空间中欧氏距离的距离公式：对于 $\vec A(x_{11}, x_{12}, \cdots,x_{1n}) ,~ \vec B(x_{21}, x_{22}, \cdots,x_{2n})$，有

    $$
      \begin{aligned}
      \lVert\overrightarrow{AB}\rVert &= \sqrt{\left ( x_{11} - x_{21} \right )^2 + \left ( x_{12} - x_{22} \right )^2 + \cdot \cdot \cdot +\left ( x_{1n} - x_{2n} \right )^2}\\
      &= \sqrt{\sum_{i = 1}^{n}(x_{1i} - x_{2i})^2}
      \end{aligned}
    $$

- 曼哈顿距离

    在二维空间内，两个点之间的曼哈顿距离（Manhattan distance）为它们横坐标之差的绝对值与纵坐标之差的绝对值之和。设点 $A(x_1,y_1),B(x_2,y_2)$，则 $A,B$ 之间的曼哈顿距离用公式可以表示为：

    $$
      d(A,B) = |x_1 - x_2| + |y_1 - y_2|
    $$

    $n$ 维空间的曼哈顿距离公式为：

    $$
      \begin{aligned}
      d(A,B) &= |x_1 - y_1| + |x_2 - y_2| + \cdot \cdot \cdot + |x_n - y_n|\\
      &= \sum_{i = 1}^{n}|x_i - y_i|
      \end{aligned}
    $$

- 切比雪夫距离

    切比雪夫距离（Chebyshev distance）是向量空间中的一种度量，二个点之间的距离定义为其各坐标数值差的最大值。

    在二维空间内，两个点之间的切比雪夫距离为它们横坐标之差的绝对值与纵坐标之差的绝对值的最大值。设点 $A(x_1,y_1),B(x_2,y_2)$，则 $A,B$ 之间的切比雪夫距离用公式可以表示为：

    $$
      d(A,B) = \max(|x_1 - x_2|, |y_1 - y_2|)
    $$

    $n$ 维空间中切比雪夫距离的距离公式可以表示为：

    $$
      \begin{aligned}
      d(x,y) &= \max\begin{Bmatrix} |x_1 - y_1|,|x_2 - y_2|,\cdot \cdot \cdot,|x_n - y_n|\end{Bmatrix} \\
      &= \max\begin{Bmatrix} |x_i - y_i|\end{Bmatrix}(i \in [1, n])\end{aligned}
    $$

!!! note "切比雪夫距离和曼哈顿距离之间的关系"
    - 曼哈顿坐标系是通过切比雪夫坐标系旋转 $45^\circ$ 后，再缩小到原来的一半得到的。
    - 将一个点 $(x,y)$ 的坐标变为 $(x + y, x - y)$ 后，原坐标系中的曼哈顿距离等于新坐标系中的切比雪夫距离。
    - 将一个点 $(x,y)$ 的坐标变为 $(\dfrac{x + y}{2},\dfrac{x - y}{2})$ 后，原坐标系中的切比雪夫距离等于新坐标系中的曼哈顿距离。


- 凸多边形
  
    凸多边形是指所有内角大小都在 $[0, \pi]$ 范围内的 **简单多边形**。

- 凸包
    
    在平面上能包含所有给定点的最小凸多边形叫做凸包。

- 判断一个点在直线的哪边

    我们有直线上的一点 $P$ 的直线的方向向量 $\mathbf v$，想知道某个点 $Q$ 在直线的哪边。

    我们利用向量积的性质，算出 $\overrightarrow {PQ}\times \mathbf v$。如果向量积为负，则 $Q$ 在直线上方，如果向量积为 $0$，则 $Q$ 在直线上，如果向量积为正，则 $Q$ 在直线下方。

### 点与向量

```cpp
#define y1 yy1
#define nxt(i) ((i + 1) % s.size())
typedef double LD;
const LD PI = 3.14159265358979323846;
const LD eps = 1E-10;
const int MAX_N = 5e5 + 5;
using i64 = long long;
int sgn(LD x) { return fabs(x) < eps ? 0 : (x > 0 ? 1 : -1); }
struct L;
struct P;
typedef P V;
struct P {
    LD x, y;
    explicit P(LD x = 0, LD y = 0): x(x), y(y) {}
    explicit P(const L& l);
};
struct L {
    P s, t;
    L() {}
    L(P s, P t): s(s), t(t) {}
};

using S = std::vector<P>;

P operator + (const P& a, const P& b) { return P(a.x + b.x, a.y + b.y); }
P operator - (const P& a, const P& b) { return P(a.x - b.x, a.y - b.y); }
P operator * (const P& a, LD k) { return P(a.x * k, a.y * k); }
P operator / (const P& a, LD k) { return P(a.x / k, a.y / k); }
inline bool operator < (const P& a, const P& b) {
    return sgn(a.x - b.x) < 0 || (sgn(a.x - b.x) == 0 && sgn(a.y - b.y) < 0);
}
bool operator == (const P& a, const P& b) { return !sgn(a.x - b.x) && !sgn(a.y - b.y); }
P::P(const L& l) { *this = l.t - l.s; }
std::ostream &operator << (std::ostream &os, const P &p) {
    return (os << "(" << p.x << "," << p.y << ")");
}
std::istream &operator >> (std::istream &is, P &p) {
    return (is >> p.x >> p.y);
}

LD dist(const P& p) { return sqrt(p.x * p.x + p.y * p.y); }
LD dot(const V& a, const V& b) { return a.x * b.x + a.y * b.y; } // 点积
LD det(const V& a, const V& b) { return a.x * b.y - a.y * b.x; } // 叉积
LD cross(const P& s, const P& t, const P& o = P()) { return det(s - o, t - o); } // 叉积
// --------------------------------------------
```

### 象限

```cpp
// 象限
int quad(P p) {
    int x = sgn(p.x), y = sgn(p.y);
    if (x > 0 && y >= 0) return 1;
    if (x <= 0 && y > 0) return 2;
    if (x < 0 && y <= 0) return 3;
    if (x >= 0 && y < 0) return 4;
    assert(0);
}

// 仅适用于参照点在所有点一侧的情况
struct cmp_angle {
    P p;
    bool operator () (const P& a, const P& b) {
//        int qa = quad(a - p), qb = quad(b - p);
//        if (qa != qb) return qa < qb;
        int d = sgn(cross(a, b, p));
        if (d) return d > 0;
        return dist(a - p) < dist(b - p);
    }
};
```

### 线

```cpp
// 是否平行
bool parallel(const L& a, const L& b) {
    return !sgn(det(P(a), P(b)));
}
// 直线是否相等
bool l_eq(const L& a, const L& b) {
    return parallel(a, b) && parallel(L(a.s, b.t), L(b.s, a.t));
}
// 逆时针旋转 r 弧度
P rotation(const P& p, const LD& r) { return P(p.x * cos(r) - p.y * sin(r), p.x * sin(r) + p.y * cos(r)); }
P RotateCCW90(const P& p) { return P(-p.y, p.x); }
P RotateCW90(const P& p) { return P(p.y, -p.x); }
// 单位法向量
V normal(const V& v) { return V(-v.y, v.x) / dist(v); }
```

### 点与线

```cpp
// 点在线段上  <= 0包含端点 < 0 则不包含
bool p_on_seg(const P& p, const L& seg) {
    P a = seg.s, b = seg.t;
    return !sgn(det(p - a, b - a)) && sgn(dot(p - a, p - b)) <= 0;
}
// 点到直线距离
LD dist_to_line(const P& p, const L& l) {
    return fabs(cross(l.s, l.t, p)) / dist(l);
}
// 点到线段距离
LD dist_to_seg(const P& p, const L& l) {
    if (l.s == l.t) return dist(p - l);
    V vs = p - l.s, vt = p - l.t;
    if (sgn(dot(l, vs)) < 0) return dist(vs);
    else if (sgn(dot(l, vt)) > 0) return dist(vt);
    else return dist_to_line(p, l);
}
```

### 线与线

```cpp
// 求直线交 需要事先保证有界
P l_intersection(const L& a, const L& b) {
    LD s1 = det(P(a), b.s - a.s), s2 = det(P(a), b.t - a.s);
    return (b.s * s2 - b.t * s1) / (s2 - s1);
}
// 向量夹角的弧度
LD angle(const V& a, const V& b) {
    LD r = asin(fabs(det(a, b)) / dist(a) / dist(b));
    if (sgn(dot(a, b)) < 0) r = PI - r;
    return r;
}
// 线段和直线是否有交   1 = 规范，2 = 不规范
int s_l_cross(const L& seg, const L& line) {
    int d1 = sgn(cross(line.s, line.t, seg.s));
    int d2 = sgn(cross(line.s, line.t, seg.t));
    if ((d1 ^ d2) == -2) return 1; // proper
    if (d1 == 0 || d2 == 0) return 2;
    return 0;
}
// 线段的交   1 = 规范，2 = 不规范
int s_cross(const L& a, const L& b, P& p) {
    int d1 = sgn(cross(a.t, b.s, a.s)), d2 = sgn(cross(a.t, b.t, a.s));
    int d3 = sgn(cross(b.t, a.s, b.s)), d4 = sgn(cross(b.t, a.t, b.s));
    if ((d1 ^ d2) == -2 && (d3 ^ d4) == -2) { p = l_intersection(a, b); return 1; }
    if (!d1 && p_on_seg(b.s, a)) { p = b.s; return 2; }
    if (!d2 && p_on_seg(b.t, a)) { p = b.t; return 2; }
    if (!d3 && p_on_seg(a.s, b)) { p = a.s; return 2; }
    if (!d4 && p_on_seg(a.t, b)) { p = a.t; return 2; }
    return 0;
}
```



## 凸包

可以求出包含点集的凸多边形。

### 代码实现
前置：点与向量

```cpp
// 点在线段上  <= 0包含端点 < 0 则不包含
bool p_on_seg(const P& p, const L& seg) {
    P a = seg.s, b = seg.t;
    return !sgn(det(p - a, b - a)) && sgn(dot(p - a, p - b)) <= 0;
}

typedef std::vector<P> S;

// 点是否在多边形中 0 = 在外部 1 = 在内部 -1 = 在边界上
int inside(const S& s, const P& p) {
    int cnt = 0;
    for (int i = 0; i < s.size(); i++) {
        P a = s[i], b = s[nxt(i)];
        if (p_on_seg(p, L(a, b))) return -1;
        if (sgn(a.y - b.y) <= 0) std::swap(a, b);
        if (sgn(p.y - a.y) > 0) continue;
        if (sgn(p.y - b.y) <= 0) continue;
        cnt += sgn(cross(b, a, p)) > 0;
    }
    return bool(cnt & 1);
}
// 多边形面积，有向面积可能为负
LD polygon_area(const S& s) {
    LD ret = 0;
    for (int i = 1; i < (i64)s.size() - 1; i++)
        ret += cross(s[i], s[i + 1], s[0]);
    return ret / 2;
}
// 构建凸包 点不可以重复 < 0 边上可以有点， <= 0 则不能
// 会改变输入点的顺序
const int MAX_N = 1000;
S convex_hull(S& s) {
//    assert(s.size() >= 3);
    sort(s.begin(), s.end());
    S ret(MAX_N * 2);
    int sz = 0;
    for (int i = 0; i < s.size(); i++) {
        while (sz > 1 && sgn(cross(ret[sz - 1], s[i], ret[sz - 2])) <= 0) --sz;
        ret[sz++] = s[i];
    }
    int k = sz;
    for (int i = (i64)s.size() - 2; i >= 0; i--) {
        while (sz > k && sgn(cross(ret[sz - 1], s[i], ret[sz - 2])) <= 0) --sz;
        ret[sz++] = s[i];
    }
    ret.resize(sz - (s.size() > 1));
    return ret;
}

P compute_centroid(const std::vector<P> &p) {
    P c(0, 0);
    LD scale = 6.0 * polygon_area(p);
    for (unsigned i = 0; i < p.size(); i++) {
        unsigned j = (i + 1) % p.size();
        c = c + (p[i] + p[j]) * (p[i].x * p[j].y - p[j].x * p[i].y);
    }
    return c / scale;
}


void solve() {
    std::vector<P> v;
    int n;
    std::cin >> n;
    for (int i = 0; i < n; i++) {
        P pp;
        std::cin >> pp;
        v.push_back(pp); 
    }
    v = convex_hull(v);
    LD ans = 0;
    for (int i = 0; i < v.size(); i++) {
        ans += dist(v[(i + 1) % v.size()] - v[i]);
    }
    std::cout << std::fixed << std::setprecision(2) << ans << '\n';
}
```
### 习题

[**P3829 [SHOI2012] 信用卡凸包**](https://www.luogu.com.cn/problem/P3829)

**Solution**

本质是凸包板子，转完一周后信用卡的圆角部分长度一定是一个圆，所以就是凸包长度加上圆的周长即可。

## 旋转卡壳

可以求出凸包的直径。

### 代码实现
前置：点与向量

```cpp
typedef std::vector<P> S;

S convex_hull(S& s) {
    sort(s.begin(), s.end());
    S ret(MAX_N * 2);
    int sz = 0;
    for (int i = 0; i < s.size(); i++) {
        while (sz > 1 && sgn(cross(ret[sz - 1], s[i], ret[sz - 2])) <= 0) --sz;
        ret[sz++] = s[i];
    }
    int k = sz;
    for (int i = (i64)s.size() - 2; i >= 0; i--) {
        while (sz > k && sgn(cross(ret[sz - 1], s[i], ret[sz - 2])) <= 0) --sz;
        ret[sz++] = s[i];
    }
    ret.resize(sz - (s.size() > 1));
    return ret;
}

LD rotatingCalipers(std::vector<P>& qs) {
    int n = qs.size();
    if (n == 2)
        return dist(qs[0] - qs[1]);
    LD res = 0;
    for (int i = 0, j = 2; i < n; i++) { 
        res = std::max(res, dist(qs[i + 1] - qs[i]));
        while (cross(qs[i + 1], qs[j], qs[i]) < cross(qs[i + 1], qs[(j + 1) % n], qs[i])) j = (j + 1) % n; 
        res = std::max(res, std::max(dist(qs[i] - qs[j]), dist(qs[i + 1] - qs[j])));
    }
    return res;
}

void solve() {
    int n;
    std::cin >> n;
    S v(n);
    for (int i = 0; i < n; i++) std::cin >> v[i].x >> v[i].y;
    v = convex_hull(v);
    LD dis = rotatingCalipers(v); //凸包最长直径
    std::cout << std::fixed << std::setprecision(0) << dis * dis << '\n';
}
```
### 习题

[**P3187 [HNOI2007] 最小矩形覆盖**](https://www.luogu.com.cn/problem/P3187)

**Solution**

我们观察可知，目标矩形一定有一条边和凸包边重合，故我们可以枚举重合的那条边，不妨设为底边。

然后找凸包在矩形上最左最上最右边的三个点，由于有单调性，直接顺序维护即可。


## 半平面交

取多个半平面相交的部分，往往取左半边平面交。

### 代码实现
前置：点与向量

```cpp
struct LV {
    P p, v; LD ang;
    LV() {}
    LV(P s, P t): p(s), v(t - s) { ang = atan2(v.y, v.x); }
};  // 另一种向量表示

bool operator < (const LV& a, const LV& b) { return a.ang < b.ang; }
bool on_left(const LV& l, const P& p) { return sgn(cross(l.v, p - l.p)) >= 0; }
P l_intersection(const LV& a, const LV& b) {
    P u = a.p - b.p; LD t = cross(b.v, u) / cross(a.v, b.v);
    return a.p + a.v * t;
}

S half_plane_intersection(std::vector<LV>& L) {
    int n = L.size(), fi, la;
    sort(L.begin(), L.end());
    S p(n); std::vector<LV> q(n);
    q[fi = la = 0] = L[0];
    for (int i = 1; i < n; i++) {
        while (fi < la && !on_left(L[i], p[la - 1])) la--;
        while (fi < la && !on_left(L[i], p[fi])) fi++;
        q[++la] = L[i];
        if (sgn(cross(q[la].v, q[la - 1].v)) == 0) {
            la--;
            if (on_left(q[la], L[i].p)) q[la] = L[i];
        }
        if (fi < la) p[la - 1] = l_intersection(q[la - 1], q[la]);
    }
    while (fi < la && !on_left(q[fi], p[la - 1])) la--;
    if (la - fi <= 1) return S();
    p[la] = l_intersection(q[la], q[fi]);
    return S(p.begin() + fi, p.begin() + la + 1);
}

S convex_intersection(const S &v1, const S &v2) {
    std::vector<LV> h; int n = v1.size(), m = v2.size();
    for (int i = 0; i < n; i++) h.push_back(LV(v1[i], v1[(i + 1) % n]));
    for (int i = 0; i < m; i++) h.push_back(LV(v2[i], v2[(i + 1) % m]));
    return half_plane_intersection(h);
}

LD intersection_size(S v) {
    LD tmp = 0;
    for (int i = 1; i < v.size(); i++) {
        tmp += fabs(cross(v[i], v[(i + 1) % v.size()], v[0]) / 2);
    }
    return tmp;
}

void solve() {
    int n;
    std::cin >> n;
    std::vector<LV> a;
    while (n--) {
        int m;
        std::cin >> m;
        S hh(m);
        for (int i = 0; i < m; i++) std::cin >> hh[i];
        for (int i = 0; i < m; i++)
            a.push_back((LV){hh[i], hh[(i + 1) % m]});
    }   
    S ans = half_plane_intersection(a); //相交部分点集
    std::cout << std::fixed << std::setprecision(3) << intersection_size(ans) << '\n'; //相交部分面积
}
```

### 习题

[**P3256 [JLOI2013] 赛车**](https://www.luogu.com.cn/problem/P3256)

**Solution**

每辆赛车可以看作是一条 $y = vx + k$ 的直线，所以每个能得奖的赛车就是半平面交的这些点。

处理的时候还要加上 $y$ 轴负半轴，因为限定在第一象限。

[**P2600 [ZJOI2008] 瞭望塔**](https://www.luogu.com.cn/problem/P2600)

**Solution**

每条线看作是一个指向右边的向量，把整个平面分成两半，那么瞭望台要建在平面左半边。

利用半平面交我们可以得到一个上面的凸多边形轮廓，然后我们还有下面的一个多边形轮廓。

不难发现一定要么是在上面的拐点或下面的拐点选择，然后我们依次枚举拐点，找出和另一个凸包的交点算出距离即可。


