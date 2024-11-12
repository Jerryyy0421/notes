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

## 莫比乌斯反演

将 $I$ 的狄利克雷卷积逆元记为 $\mu$，称作莫比乌斯函数。

$$
\mu = I^{-1} \Leftrightarrow \sum_{d \mid n}\mu(d) = [n = 1]
$$

## 整除