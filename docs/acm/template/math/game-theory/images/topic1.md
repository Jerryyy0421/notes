---
title: 算法笔记 | 数论（一）
date: 2023-07-05 23:42:29
tags:
- 算法竞赛
- 数学
---

扩展欧几里得，逆元，欧拉函数

<!--more-->

## 1. 扩展欧几里得算法

### 1.1 算法介绍

设 $a, b$ 为不全为 $0$ 的整数，存在整数 $x, y$ 使得 $ax + by = (a, b)$。

进一步地，$ax + by = m$ 有解的充要条件是 $(a, b) | m$ （裴蜀定理，又叫做贝祖定理） 。

### 1.2 证明

若我们求 $ax + by = (a, b)$ 的解，不如先求 $bx + (a \mod b) y = (b, a \mod b)$ 的解，而且由欧几里得算法可知 $(a, b) = (b, a \mod b)$。

经过变换 $bx + (a \mod b)y = bx + (a - b \times \left \lfloor \dfrac{a}{b} \right \rfloor )y = ay + b(x - \left \lfloor \dfrac{a}{b} \right \rfloor y)$，所以得出 $bx + (a \mod b) y = (b, a \mod b)$ 的解为 $x_0, y_0$ 后就可以得出 $ax + by = (a, b)$ 的解是 $x = y_0, y = (x_0 - \left \lfloor \dfrac{a}{b} \right \rfloor y_0)$ 而通过不断辗转相除法，显然到最后我们得到的式子为 $(a, b)x + 0\times y = (a, b)$，很容易可以令 $x = 1, y = 0$ 为这里的一组解，然后不断迭代回去求出我们要的解。

对于进一步结论的证明，若 $m$ 是该方程组的解，由于 $(a, b)$ 可以整除左式，那么 $(a, b)$ 也可以整除右式（充分性）。

若 $(a, b)|m$，那么我们已知 $ax + by = (a, b)$ 的一组解，等式两边同时乘以 $\dfrac{m}{(a, b)}$ 便可以得到原方程组的解（必要性）。

### 1.3 实现

```c++
int exgcd(int a, int b, int &x, int &y) {
    if (b == 0) {
        x = 1;
        y = 0;
        return a;
    }
    int d = exgcd(b, a % b, y, x); 
    y -= (a / b) * x;
    return d;
}
```



## 2. 逆元

### 2.1 定义

若 $ab \equiv 1(\mod p)$ 则称 $a$，$b$ 在 模 $p$ 意义下互为逆元，记为 $a = inv(b)$。

### 2.2 扩展欧几里得求逆元 

由上一节可知，扩展欧几里得可以求出 $ax + by = 1$ 的一组 $x, y$ 解，故我们要求 $ax \equiv 1(mod\ b)$ 即求 $ax + by = 1$ 的一组解，而且这里要求有解的条件是 $(a, b) = 1$，利用扩展欧几里得很容易得出。

```c++
ll exgcd(ll a, ll b, ll &x, ll &y) {
    if (b == 0)
    {
        x = 1;
        y = 0;
        return a;
    }
    ll d = exgcd(b, a % b, y, x);
    y -= (a / b) * x;
    return d;
}
ll inv(ll a, ll p) {
    ll x, y;
    if (exgcd(a, p, x, y) != 1)
        return -1;
    return (x % p + p) % p;
}
```



### 2.3 费马小定理求逆元

费马小定理的内容如下：

> 若 $p$ 为素数，且 $(a, p) = 1$，则 $a^{p - 1} \equiv 1(mod \ p)$。

**证明（待完善）**

利用该定理，不难得出 $inv(a) \equiv a^{p - 2}(mod \ p)$，故可以用快速幂来求解。

```c++
inline ll qpow(ll a, ll b, ll p) {
    ll ans = 1;
    while (b) {
        if (b & 1) ans = ans % p * a % p;
        a = a % p * a % p;
        b >>= 1;
    }
    return ans;
}
inline ll inv(ll a, ll p) {
    return qpow(a, p - 2, p);
}
```

### 2.4 线性递推求解逆元

如果题目要求 $1 \sim n$ 的逆元，那么前两种方法都很低效，这里引入第三种，线性递推来求解。

下面用 $O(n)$ 方法求 $1 \sim n$ 关于 $p$ 的逆元。

首先显然 $1^{-1} \equiv 1(mod \ p)$。

对于数 $i$，有 $p = ki + j$，这里 $k = \left \lfloor \dfrac{p}{i} \right \rfloor,j = p \% i$。

那么则有 $ki + j \equiv 0(mod \ p)$，等式两边同时乘以 $i^{-1}j^{-1}$，则有 $kj^{-1} + i^{-1} \equiv 0(mod \ p)$。

故 $i^{-1} \equiv -\left \lfloor \dfrac{p}{i} \right \rfloor(p \ mod \ i)^{-1}(mod \ p)$，而且 $p \ mod \ i$ 肯定小于 $i$ ，所以可以由前递推后。

值得一提的是，这里为防止出现负数，所以写的是 `p - p / i` ，而且当 $i | p$ 时 `inv[i]` 应该是没有意义的，我们往往用大素数 $10^9 + 7$ 来表示。

```c++
inv[1] = 1;
for (int i = 2; i <= n; ++i) {
  inv[i] = (long long)(p - p / i) * inv[p % i] % p;
}
```

### 2.5 求任意 n 个数的逆元

对于求任意 $n$ 个数 $a_i$，我们算这个 $n$ 个数的前缀积，记为 $s_i$。

然后我们计算 $s_n$ 的逆元为 $sInv_n$，那么 $s_i$ 的逆元为 $sInv_i =sInv_{i + 1} \times a_{i + 1}$。

然后易得 $a_i$ 的逆元 $Inv_i = sInv_i \times s_{i - 1}$。

时间复杂度近似 $O(n)$。 

## 3. 欧拉函数





## 4. 中国剩余定理

### 4.1 问题简述

中国剩余定理是用来求解诸如
$$
\begin{cases} x \equiv a_1(\mod n_1) \\ x \equiv a_2(\mod n_2) \\ \ \ \ \ \vdots \\ x \equiv a_k(\mod n_k) \end{cases}
$$
这样的方程组问题。

### 4.2 过程

1. 算所有模数的积 $n$；
2. 对于第 $i$ 个方程：
    - 计算 $m_i = \dfrac{n}{n_i}$；
    - 计算 $m_i$ 在模 $n_i$ 意义下的逆元 $m_i^{-1}$；
    - 计算 $c_i = m_im_i^{-1}$（这时不要对 $n_i$ 取模）
3. 方程组在模 $n$ 意义下的唯一解为 $x = \sum_{i = 1}^k a_ic_i(\mod n)$

### 4.3 实现

```c++
void CRT() {
  ll n, M = 1, ans = 0;
  cin >> n; 
  for(int i = 1; i <= n; i++) {
    cin >> b[i] >> a[i];
    M *= b[i];
  }
  for(int i = 1; i <= n; i++) {
    ll m = M / b[i];
    ll x, y;
    exgcd(m, b[i], x, y); // 注：如果模数不为质数时，求逆元不能用费马小定理来算，只能用扩欧来算
    x = (x + b[i]) % b[i]; x %= M;
    m *= x; m %= M;
    ans += a[i] * m % M;
    ans %= M;
  }
  cout << (ans % M + M) % M << endl;
  return ;
}
```

### 4.4 扩展中国剩余定理

中国剩余定理的适用范围是模数互质的情况，那么当方程模数不互质时我们要用到扩展中国剩余定理。

思路是不断把 $n$ 个方程两两合并，对于
$$
\begin{cases} x \equiv b(\mod a) \\ x \equiv B(\mod A)  \end{cases}
$$
我们令 $x = ya + b = YB + A$ ，那么有 $B - b = ya - YA$，我们利用扩欧可以求解出 $x'a + y'A = (a,A)$ 的一组解，那么若 $(a, A) \nmid B-b$ 则方程无解，对于有解的情况 $(x' \times \dfrac{B - b}{(a, A)})a + (y' \times \dfrac{B - b}{(a, A)})A = B - b$，令 $X = x' \times \dfrac{B - b}{(a, A)}, Y = y' \times \dfrac{B - b}{(a, A)}$ 若是让解最小即是让 $X$ 最小，我们调整 $X$ 可以通过让 $X + k \times \dfrac{A}{(a, A)}$，这时 $Y$ 相应减去同等系数的 $\dfrac{a}{(a, A)}$。所以 $X = (X \mod \dfrac{A}{(a, A)} + \dfrac{A}{(a, A)}) \mod \dfrac{A}{(a, A)}$。求出新的 $X$ 后再根据 $x = yX + a$ 可以求出新的 $x$，新的 $b = x \mod \dfrac{A \times a}{(a, A)}$，新的 $a = \dfrac{A \times a}{(a, A)}$。那么就可以得出新的方程 $x \equiv b(\mod a)$ 了。最后通过不断合并变为一个方程就能求出答案了。  

```c++
void ExCRT() {
  scanf("%d", &n);
  for(int i = 1; i <= n; i++) {
    scanf("%lld%lld", &A, &B);
    if(i == 1) {
      a = A;
      b = B;
    }
    else {
      g = exgcd(a, A, x, y);
      if((B - b) % g) {
        printf("-1");
        return ;
      }
      x = x * ((B - b) / g);
      x = (x % (A / g) + (A / g)) % (A / g);
      l = A / g * a;
      b = ((a * x + b) % l + l) % l;
      a = l;
    }
  }
  printf("%lld\n", b % a);
}
```



## 5. 卢卡斯定理

### 5.1 定义

对于质数 $p$，有
$$
\begin{pmatrix} n \\ m \end{pmatrix} \mod p = \begin{pmatrix} \left \lfloor \dfrac{n}{p} \right \rfloor \\ \left \lfloor \dfrac{m}{p}\right \rfloor \end{pmatrix} \cdot \begin{pmatrix} n \mod p \\m \mod p \end{pmatrix} \mod p
$$
由于$n \mod p$ 和 $m \mod p$ 肯定小于 $p$，所以直接算即可，对 $\left \lfloor \dfrac{n}{p} \right \rfloor$ 部分再用卢卡斯定理计算。

也即 $Lucas(n,m,p)=c(n\%p,m\%p)×Lucas(\dfrac{n}{p},\dfrac{m}{p},p)$。

### 5.2 证明

首先证明首先我们需要证明 $C_p^i \equiv \dfrac{p}{i}C_{p - 1}^{i - 1} \equiv 0(\mod p)(1 \le i \le p-1)$ 由于 $p$ 为质数，故 $\dfrac{1}{i}C_{p - 1}^{i - 1}$ 为整数，乘以 $p$ 后和 $p$ 同余为 $0$，故得证。

根据这个性质有 $(1 + x)^p \equiv 1 + x^p(\mod p)$

对于 $C_m^n \mod p$，其实就是求 $(1 + x^n)\mod p$ 中 $x^m$ 的系数。

我们令 $n = ap +b$，$m = cp + d$。所以接下来证 $C_n^m \equiv C_a^c \times C_b^d(\mod p)$。

我们有
$$
(1 + x)^n \equiv (1 + x)^{pa}(1 + x)^b \equiv (1 + x^p)^a(1 + x)^b(\mod p)
$$
观察 $x^m$ 的系数，故 $C_n^m x^m \equiv C_a^c x^{cp}C_b^dx^d(\mod p)$，由于 $x^b$ 系数一致，所以 
$$
C_n^m \equiv C_a^c \times C_b^d \equiv C_{\left \lfloor \frac{n}{p} \right \rfloor}^{\left \lfloor \frac{m}{p} \right \rfloor} \times C_{n \mod p}^{m \mod p}(\mod p)
$$
故得证。

### 5.3 实现

```c++
ll Lucas(ll n, ll m) {
  return ((m == 0) ? 1 : (c(n % p, m % p) % p * Lucas(n / p, m / p) % p));
}
```

### 5.4 扩展卢卡斯定理

