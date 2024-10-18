# 计算几何

## 基础

### 二维几何：点与向量

```cpp
#define y1 yy1
#define nxt(i) ((i + 1) % s.size())
typedef double LD;
const LD PI = 3.14159265358979323846;
const LD eps = 1E-10;
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
LD dot(const V& a, const V& b) { return a.x * b.x + a.y * b.y; }
LD det(const V& a, const V& b) { return a.x * b.y - a.y * b.x; }
LD cross(const P& s, const P& t, const P& o = P()) { return det(s - o, t - o); }
// --------------------------------------------

```



## 凸包

可以求出包含点集的凸多边形。

### 代码实现

```cpp
#include<bits/stdc++.h>
#define eps 1e-6
typedef long long ll;
using namespace std;

const int N = 1e5 + 5;
struct Node {
    double x, y;
    Node operator - (Node a) { return {x - a.x, y - a.y}; }
    double operator * (Node a) { return x * a.y - y * a.x; }
};
Node s[N];
double len(double x, double y) {
    return sqrt(x * x + y * y);
}

bool cmp(Node a, Node b) {
    return (fabs(a.x - b.x) < eps ? a.y < b.y : a.x < b.x);
}

int main(){
    std::ios::sync_with_stdio(false);
    std::cin.tie(nullptr);
    int n;
    cin >> n;
    vector<int> q(n + 1);
    for(int i = 1; i <= n; i++) {
        cin >> s[i].x >> s[i].y;
    } 
    sort(s + 1, s + 1 + n, cmp);
    int tmp = 0;
    for(int i = 1; i <= n; i++) {
        while(tmp >= 2 && (s[q[tmp]] - s[q[tmp - 1]]) * (s[i] - s[q[tmp]]) <= 0) tmp--;
        q[++tmp] = i;
    }
    int kdl = tmp;
    for(int i = n - 1; i >= 1; i--) {
        while(kdl > tmp && (s[q[kdl]] - s[q[kdl - 1]]) * (s[i] - s[q[kdl]]) <= 0) kdl--;
        q[++kdl] = i;
    }
    double ans = 0;
    for(int i = 2; i <= kdl; i++) {
        ans += len(s[q[i]].x - s[q[i - 1]].x, s[q[i]].y - s[q[i - 1]].y);
    }
    cout << fixed << setprecision(2) << ans << endl; // 保留两位小数
    return 0;
}
```
### 习题


## 旋转卡壳

可以求出凸包的直径。

### 代码实现

```cpp
#include <bits/stdc++.h>
#define y1 yy1
#define nxt(i) ((i + 1) % s.size())
typedef double LD;
using i64 = long long;
const LD PI = 3.14159265358979323846;
const LD eps = 1E-10;
const int MAX_N = 5e5 + 5;
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

int dist(const P& p) { return p.x * p.x + p.y * p.y; }
LD dot(const V& a, const V& b) { return a.x * b.x + a.y * b.y; }
LD det(const V& a, const V& b) { return a.x * b.y - a.y * b.x; }
LD cross(const P& s, const P& t, const P& o = P()) { return det(s - o, t - o); }
// --------------------------------------------


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

int rotatingCalipers(std::vector<P>& qs) {
    int n = qs.size();
    if (n == 2)
        return dist(qs[0] - qs[1]);
    int res = 0;
    for (int i = 0, j = 2; i < n; i++) { 
        res = std::max(res, dist(qs[i + 1] - qs[i]));
        while (cross(qs[i + 1], qs[j], qs[i]) < cross(qs[i + 1], qs[(j + 1) % n], qs[i])) j = (j + 1) % n; 
        res = std::max(res, std::max(dist(qs[i] - qs[j]), dist(qs[i + 1] - qs[j])));
    }
    return res;
}

int main() {
    int n;
    std::cin >> n;
    S v(n);
    for (int i = 0; i < n; i++) std::cin >> v[i].x >> v[i].y;
    v = convex_hull(v);
    printf("%d\n", rotatingCalipers(v));
}


```
### 习题


## 半平面交

取多个半平面相交的部分，往往取左半边平面交。

### 代码实现

```cpp
#include <bits/stdc++.h>

#define y1 yy1
#define nxt(i) ((i + 1) % s.size())
typedef double LD;
const LD PI = 3.14159265358979323846;
const LD eps = 1E-10;
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
LD dot(const V& a, const V& b) { return a.x * b.x + a.y * b.y; }
LD det(const V& a, const V& b) { return a.x * b.y - a.y * b.x; }
LD cross(const P& s, const P& t, const P& o = P()) { return det(s - o, t - o); }
// --------------------------------------------


struct LV {
    P p, v; LD ang;
    LV() {}
    LV(P s, P t): p(s), v(t - s) { ang = atan2(v.y, v.x); }
};  // 另一种向量表示

bool operator < (const LV &a, const LV& b) { return a.ang < b.ang; }
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

int main() {
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
    S ans = half_plane_intersection(a);
    printf("%.3lf\n", intersection_size(ans));
}
```

### 习题
