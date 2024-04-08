# 计算几何初步

!!! abstract 
    - 二维凸包
    
    参考文献：[OI Wiki - 计算几何部分简介](https://oi-wiki.org/geometry/)

!!! warning "Attention"
    - 由于计算几何经常进行 `double` 类型的浮点数计算，因此带来了精度问题和时间问题。

    - 有些问题，例如求点坐标均为整数的三角形面积，可以利用其特殊性进行纯整数计算，避免用浮点数影响精度。

    - 由于浮点数计算比整数计算慢，所以需要注意程序的常数因子给时间带来的影响。


## 0 前置知识
### 0.1 二维计算几何
- 凸多边形
  
    凸多边形是指所有内角大小都在 $[0, \pi]$ 范围内的 **简单多边形**。

- 凸包
    
    在平面上能包含所有给定点的最小凸多边形叫做凸包。

- 判断一个点在直线的哪边

    我们有直线上的一点 $P$ 的直线的方向向量 $\mathbf v$，想知道某个点 $Q$ 在直线的哪边。

    我们利用向量积的性质，算出 $\overrightarrow {PQ}\times \mathbf v$。如果向量积为负，则 $Q$ 在直线上方，如果向量积为 $0$，则 $Q$ 在直线上，如果向量积为正，则 $Q$ 在直线下方。

### 0.2 三维计算几何


### 0.3 距离
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

## 1 二维凸包

在二维平面上给定若干点，求一个最小的凸包使得能包含全部给定点。

### 1.1 Andrew 算法求凸包

- 思路

    首先将每个点按横坐标从小到大排序（横坐标相同就按纵坐标），然后先按升序枚举出下凸壳，然后再按降序求出上凸壳。

    升序枚举的时候，我们用栈存储下凸壳中的元素，设 $S_1$，$S_2$ 是栈顶的两个元素，其中 $S_1$ 是栈顶。遇到一个新的点 $P(x, y)$，当 $\vec {S_2S_1} \times \vec {S_1P} \le 0$ 时，说明 $S_1$ 不应该是下凸壳中的点，弹出 $S_1$，继续判断。直到弹不出时，将 $P$ 插入栈中。

    降序枚举时同理，判断依据也是 $\vec {S_2S_1} \times \vec {S_1P} \le 0$，所以就是相当于倒着跑一遍，即可求出上凸壳。

- 实现

```c++
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

## 2 旋转卡壳 


## 3 半平面交


## 4 辛普森算法

