# 数论函数

## 前置知识

数论函数：定义域为正整数的函数。陪域（值域可取的范围）一般认为是复数，在复杂的问题中也代以幂级数等。

完全积性函数：若数论函数 $f$ 满足 $f(xy) = f(x)f(y)$，则称为完全积性函数。

积性函数：若数论函数 $f$ 满足 $x \perp y \Rightarrow f(xy) = f(x)f(y)$，则称为完全积性函数。

积性分解：对于积性函数 $f$，给出质因数分解 $n = p_1^{c_1}...p_m^{c_m}$，则有

$$
    f(n) = \prod_{i = 1}^m f(p_i^{c_i})
$$

点积：两个数论函数 $f, g$ 的点积为一个新的数论函数，记作 $f \cdot g$。其满足

$$
    (f \cdot g)(n) = f(n)g(n)
$$

### 狄利克雷卷积

狄利克雷卷积：

$$
    (f*g)(n) \sum_{x \times y = n} f(x)g(y) = \sum_{d \mid n}f(d)g(n / d)
$$

!!! note "性质"
    - 交换律：$f*g = g*f$。
    - 结合律：$(f*g)*h = f*(g*h)$。
    - 单位元：记 $\epsilon(n) = [n = 1]$，则有对于任意数论函数 $f$，$f*\epsilon = f$。
    - 逆元：对于 $f*g = \epsilon$，则称 $f, g$ 互为逆元。积性函数总是有且仅有一个逆元。

狄利克雷函数的计算：

对于给定的 $f, g$，求 $f * g$，可以转枚举因数为枚举倍数，时间复杂度为 $O(n\log n)$。

逆元的计算：

给出 $f$ 且满足 $f(1) = 1$，求出 $g$ 的前 $n$ 项有：

\begin{eqnarray}
g(n) & = & \begin{cases}
 1 & \text{ if } n & = & 1 \\
 \sum_{d \mid n, d \ne 1}f(d)g(n / d) & \text{ if } n & > & 1 \end{cases}
\end{eqnarray}

时间复杂度为 $O(n\log n)$。

!!! note "积性函数相关定理"
    - 两个积性函数的狄利克雷卷积仍是积性函数。
    - 积性函数的逆仍是积性函数。
    - 对于积性函数 $f, g$，$f\circ g,f\cdot g,f(g(n))$ 都是积性函数。

常用数论函数：

单位函数 $\varepsilon(n) = [n = 1]$，该函数是狄利克雷卷积下的单位元。
幂函数 $\text{Id}_k(n) = n^k$， 当 $k = 1$ 时为恒等函数，当 $k = 0$ 时为常数函数。
除数函数 $\sigma_k(n) = \sum_{d \mid n} d^k$ ，当 $k = 1$ 时为因数和函数，当 $k = 0$ 时为因数个数函数。 
欧拉函数 $\varphi(n)$ 定义为小于 $n$ 的数中和 $n$ 互质的个数，特别地 $\varphi(1) = 1$。

性质：
- $\varphi * 1 = \text{Id}$
- $\text{Id}_k * 1 = \sigma_k$


## 莫比乌斯反演

将 $I$ 的狄利克雷卷积逆元记为 $\mu$，称作莫比乌斯函数。

$$
\mu = I^{-1} \Leftrightarrow \sum_{d \mid n}\mu(d) = [n = 1]
$$

莫比乌斯公式的表达式为

$$
\mu(x) = \left\{\begin{matrix}
 1, & n = 1 \\
 (-1)^m, & n = p_1p_2...p_m \\
 0, & \text{otherwise}
\end{matrix}\right.
$$

莫比乌斯反演公式

$$
    g(n) = \sum_{d \mid n} f(d) \Leftrightarrow f(n) = \sum_{d \mid n} \mu(d) g\left (\dfrac{d}{n}\right )
$$

利用狄利克雷卷积形式改写可得

$$
    f * 1 = g \Leftrightarrow f = g * \mu
$$  

### 例题

> 求 $1 \le x \le n$，$1 \le y \le m$ 且 $\text{gcd}(x, y) = 1$ 的二元组数量。

**Solution**

\begin{align}
\sum_{i = 1}^n\sum_{j = 1}^m [\text{gcd}(x, y) =1]
& = \sum_{i = 1}^n\sum_{j = 1}^m \varepsilon(\text{gcd}(x, y)) \newline
\end{align}

又因为 $\mu * 1 = \varepsilon$，

\begin{align}
\sum_{i = 1}^n\sum_{j = 1}^m \varepsilon(\text{gcd}(x, y))
& = \sum_{i = 1}^n\sum_{j = 1}^m \sum_{d \mid \text{gcd}(i, j)}\mu(d) \newline
& = \sum_{d = 1}^{\min (n, m)} \sum_{i = 1}^{\left \lfloor \frac{n}{d} \right \rfloor } 
\sum_{j = 1}^{\left \lfloor \frac{m}{d} \right \rfloor }\mu(d) \newline
&= \sum_{d = 1}^{\min (n, m)} \left \lfloor \frac{n}{d} \right \rfloor\left \lfloor \frac{m}{d} \right \rfloor
\mu(d)
\end{align}



> 求 $1 \le x \le n$，$1 \le y \le m$ 且 $\text{gcd}(x, y) = k$ 的二元组数量。

**Solution**

令 $i \to ki$，$j \to kj$，所求即为 

$$
\sum_{i = 1}^{\left \lfloor \frac{n}{k} \right \rfloor }\sum_{j = 1}^{\left \lfloor \frac{m}{k} \right \rfloor } [\text{gcd}(i, j) = 1]
$$

那么就和上一道例题一样了。

[**P2398 GCD SUM**](https://www.luogu.com.cn/problem/P2398)

> 求 $\sum_{i = 1}^n\sum_{j = 1}^m\text{gcd}(i, j)$。

**Solution**

\begin{align}
\sum_{i = 1}^n\sum_{j = 1}^m \text{gcd}(x, y)
& = \sum_{i = 1}^n\sum_{j = 1}^m \text{Id}(\text{gcd}(x, y)) \newline
\end{align}

又因为 $\varphi * 1 = \text{Id}$，

\begin{align}
\sum_{i = 1}^n\sum_{j = 1}^m \text{Id}(\text{gcd}(x, y))
& = \sum_{i = 1}^n\sum_{j = 1}^m \sum_{d \mid \text{gcd}(i, j)}\varphi(d) \newline
& = \sum_{d = 1}^{\min (n, m)} \sum_{i = 1}^{\left \lfloor \frac{n}{d} \right \rfloor } 
\sum_{j = 1}^{\left \lfloor \frac{m}{d} \right \rfloor }\varphi(d) \newline
&= \sum_{d = 1}^{\min (n, m)}\left \lfloor \frac{n}{d} \right \rfloor\left \lfloor \frac{m}{d} \right \rfloor
 \varphi(d)
\end{align}



## 整除




## 杜教筛

本质是狄利克雷卷积的自然推导，可以实现以 $O(n^{\frac{2}{3}})$ 的时间复杂度对积性函数的前缀求和。

\begin{align}
\sum_{i = 1}^n (f*g)(i)
&= \sum_{i = 1}^n\sum_{j = 1}^{\left \lfloor \frac{n}{i} \right \rfloor }f(i)g(j)\newline
&= \sum_{i = 1}^n g(i)\sum_{j = 1}^{\left \lfloor \frac{n}{i} \right \rfloor }f(j)\newline
&= \sum_{i = 1}^n g(i)S\left (\left \lfloor \frac{n}{i} \right \rfloor\right )\newline
&= g(1)S(n) + \sum_{i = 2}^n g(i)S\left (\left \lfloor \frac{n}{i} \right \rfloor\right )\newline
\end{align}

那么我们便可以得到

$$
g(1)S(n) = \sum_{i = 1}^n (f*g)(i) - \sum_{i = 2}^n g(i)S\left (\left \lfloor \frac{n}{i} \right \rfloor\right )
$$

对于后面的那堆式子可以递归求解。当 $(f*g)(n)$ 和 $g(n)$ 的前缀和均可以 $O(1)$ 求解出时算法复杂度为 $O(n^{\frac{3}{4}})$，若线性筛预处理 $S(n)$ 的前 $n^{\frac{2}{3}}$ 项的值，则时间复杂度可以优化到 $O(n^{\frac{2}{3}})$。

这里分别以求莫比乌斯函数和欧拉函数的前缀和为例。

由于 $\mu * 1 = \varepsilon$，令 $g = 1$ 则有

\begin{align}
g(1)S(n) &= \sum_{i = 1}^n (f*g)(i) - \sum_{i = 2}^n g(i)S\left (\left \lfloor \frac{n}{i} \right \rfloor\right ) \newline  
S(n) &= \sum_{i = 1}^n\varepsilon (i) - \sum_{i = 2}^n S\left (\left \lfloor \frac{n}{i} \right \rfloor\right ) \newline 
S(n) &= 1 - \sum_{i = 2}^n S\left (\left \lfloor \frac{n}{i} \right \rfloor\right )
\end{align}


由于 $\varphi * 1 = \text{Id}$，令 $g = 1$ 则有

\begin{align}
g(1)S(n) &= \sum_{i = 1}^n (f*g)(i) - \sum_{i = 2}^n g(i)S\left (\left \lfloor \frac{n}{i} \right \rfloor\right ) \newline  
S(n) &= \sum_{i = 1}^n\text{Id} (i) - \sum_{i = 2}^n S\left (\left \lfloor \frac{n}{i} \right \rfloor\right ) \newline 
S(n) &= \dfrac{n(n + 1)}{2} - \sum_{i = 2}^n S\left (\left \lfloor \frac{n}{i} \right \rfloor\right )
\end{align}


[**P4213 【模板】杜教筛**](https://www.luogu.com.cn/problem/P4213)

> 分别求出莫比乌斯函数和欧拉函数的前缀和。

**Solution**

```cpp
bool isnp[N];
std::vector<int> primes;
int mu[N], smu[N];
std::unordered_map<i64, int> umsmu;
i64 phi[N], sphi[N];
std::unordered_map<i64, i64> umsphi;

void sieve() {
    mu[1] = 1;
    phi[1] = 1;
    for (int i = 2; i < N; i++) {
        if (!isnp[i])
            primes.push_back(i), mu[i] = -1, phi[i] = i - 1;
        for (int p : primes) {
            if (p * i >= N)
                break;
            isnp[p * i] = 1;
            if (i % p == 0) {
                mu[p * i] = 0;
                phi[p * i] = phi[i] * p;
                break;
            }
            else {
                mu[p * i] = mu[p] * mu[i];
                phi[p * i] = phi[p] * phi[i];
            }
        }
    }
    for (int i = 1; i < N; ++i) {
        sphi[i] = sphi[i - 1] + phi[i]; 
        smu[i] = smu[i - 1] + mu[i];
    }
}

int sum_mu(i64 n) {
    if (n < N)
        return smu[n];
    if (umsmu.count(n))
        return umsmu[n];
    int ans = 1;
    for (i64 l = 2, r; l <= n; l = r + 1) {
        r = n / (n / l);
        ans -= (r - l + 1) * sum_mu(n / l);
    }
    umsmu[n] = ans;
    return ans;
}

i64 sum_phi(i64 n) {
    if (n < N)
        return sphi[n];
    if (umsphi.count(n))
        return umsphi[n];
    i64 ans = n * (n + 1) / 2; 
    for (i64 l = 2, r; l <= n; l = r + 1) {
        r = n / (n / l);
        ans -= (r - l + 1) * sum_phi(n / l);
    }
    umsphi[n] = ans;
    return ans;
}


void solve() {
    i64 n;
    std::cin >> n;
    std::cout << sum_phi(n) << ' ' << sum_mu(n)<< '\n';
}
```
