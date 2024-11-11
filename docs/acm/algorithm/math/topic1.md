# 数论

## 整除和同余

### 逆元

- **逆元唯一性定理**

逆元若存在，则总是是唯一的。

!!! success "Proof"
    假设不唯一，同时有 $x \ne y$ 且 $ax \equiv ay \equiv 1(\mod m)$，那么则有 $axy = (ax)y = (ay)x = x = y$，矛盾。故逆元唯一。


- **逆元存在性定理**

在模 $m$ 下，当且仅当 $a \perp m$ 时，$a$ 有乘法逆元。

!!! note "推论"
    当 $x \perp m$ 时，$ax \equiv bx(\mod m) \Leftrightarrow a \equiv b(\mod m)$。

- **拓展欧几里得算法**

求解 $ax + by = \text{gcd}(a, b)$ 的通解。

1. b = 0 时，x = 1, y = 0 是一组解。
2. 设 $a' = b, b' = a \mod b$。假设已经求得 $a'x + b'y = \text{gcd}(a', b')$ 的一组解 $x_0, y_0$。且我们由欧几里得算法可知 $\text{gcd}(a', b') = \text{gcd}(a, b)$，所以

\begin{align}
\text{gcd}(a, b) &= bx_0 + (a\mod b)y_0 \\
                 &= bx_0 + (a - b\left \lfloor a / b \right \rfloor)y_0 \\
                 &= ay_0 + b(x_0 - \left \lfloor a / b \right \rfloor y_0)
\end{align}

故有 $x = y_0, y = (x_0 - \left \lfloor a / b \right \rfloor y_0)$。从下向上不断迭代，最后可得一组特解 $x_0, y_0$，通解则是 $x = x_0 + tb, y = y_0 - ta(t \in \mathbb{Z})$。

时间复杂度是 $O(\log a)$。

- **裴蜀定理**

不定方程 $ax + by = c$ 当且仅当 $\text{gcd}(a, b) | c$ 时有解。

!!! success "Proof"
    由拓展欧几里得可以得出。

- **费马小定理**

对于质数 $p$，任意正整数 $a$ 满足 $a^{p - 1} \equiv 1(\mod p)$。

!!! note "推论"
    $a^{p - 2} \equiv a^{-1}(\mod p)$，常用于计算逆元。

!!! success "Proof"
    先取集合 $T = \{1, 2, 3, ..., (p - 1)\}$，该集合乘积为 $(p - 1)!$。再取集合 $T' = \{a, 2a, 3a, ..., (p - 1)a\}$，若满足 $a^{p - 1} \equiv 1$，那么则有这个集合的乘积为 $a^{p - 1}(p - 1)! \equiv (p - 1)!$。那么只需证明这个集合在模 $m$ 意义下是 $1 \sim p$ 的一个排列即可。也就是说每个元素都不相同且没有出现过 $0$。

    证明每个元素都不相同：若相同，设 $ax = ay$，则同时乘以 $a$ 的逆元，有 $x = y$，矛盾。

    证明没有出现 $0$：由于 $a, k \perp m$，故不会出现 $p \mid ak$。

- **欧拉定理**

当 $a \perp m$ 时，$a^{\varphi (m)} \equiv 1(\mod m)$。

!!! success "Proof"
    类似费马小定理的证明，先构造一个子集 $T$，大小是 $|\varphi(m)|$，均是 $m$ 以内和 $m$ 互质的数的集合。设这个集合乘积为 $S$。

    我们将每个元素均乘以 $a$ 构造出新集合 $T'$，类比上面的证明我们可得 $T = T'$。那么则有 $a^{\varphi(m)}S \equiv S$。由于 $T$ 集合中每个元素均和 $m$ 互质，所以 $S$ 也和 $m$ 互质，同乘以 $S$ 在模 $m$ 意义下的逆元，故 $a^{\varphi (m)} \equiv 1(\mod m)$。


- **线性求前缀逆元**

对于质数 $p$，存在 $n^{-1} \equiv -\left \lfloor p / n  \right \rfloor(p\mod n)^{-1} (\mod p)$。

!!! success "Proof"
    利用 $n \left \lfloor p / n \right \rfloor + p \mod n \equiv 0(\mod p)$ 可以推出。

- **批量求逆元**

对于 $A_{1 \sim n}$，$S = (\prod_{i = 1}^n A_i)^{-1}$，则有 $A_i^{-1} = SL_{i - 1}R_{i + 1}$。


### 线性同余方程组

- **中国剩余定理**

$$
\begin{cases} x \equiv c_1(\mod m_1) \\ x \equiv c_2(\mod m_2) \\ \ \ \ \ \vdots \\ x \equiv c_k(\mod m_k) \end{cases}
$$

且满足模数两两互质，求 $x$ 的最小自然数解。

我们先看两个方程组的情况，

\begin{eqnarray}
\left\{\begin{matrix}
x \equiv c_1(\mod m_1) \\
x \equiv c_2(\mod m_2)
\end{matrix}\right.
\end{eqnarray}

求解出答案是 $x \equiv c_1m_2\text{Inv}_{m_1}(m_2) + c_2m_1\text{Inv}_{m_2}(m_1)(\mod m_1m_2)$。

对于 $n$ 个方程组，两两合并即可。

时间复杂度 $O(n\log m)$。

- **拓展中国剩余定理**

不保证模数两两互质。

相当于解方程 $am_1 + bm_2 = c_2 - c_1$，先判断有无解，然后再利用扩欧求解出特解 $x_0$，则满足这两个方程的通解是 $x_0 + k(\text{lcm}(m_1, m_2))(k \in \mathbb{Z})$，新方程相当于变成了

\begin{eqnarray}
\left\{\begin{matrix}
x \equiv x_0(\mod \text{lcm}(m_1, m_2)) \\
x \equiv c_3(\mod m_3)
\end{matrix}\right.
\end{eqnarray}

然后不断两两合并即可。复杂度不变。

### 组合数取模

- **求阶乘逆元小技巧**

先算 $n!$ 逆元，然后不断从后往前乘，依次算逆元。

- **卢卡斯定理**

$$
\binom{n}{m} \equiv \binom{\left \lfloor n/p \right \rfloor}{\left \lfloor m/p \right \rfloor}\binom{n\mod p}{m\mod p}(\mod p)
$$

该公式等价于：将 $n, m$ 表示为 $p$ 进制数，数码为 $\overline{n_1n_2...n_k}$ 和 $\overline{m_1m_2...m_k}$，则有

$$
\binom{n}{m} = \prod_{i = 1}^k \binom{n_i}{m_i}(\mod p)
$$

!!! success "Proof"
    **Lemma**. 对于 $1 \le i \le p - 1$，总有 $\binom{p}{i} \equiv 0(\mod p)$。

    > 因为 $\binom{p}{i} = \dfrac{p!}{i!(p - i)!} = \dfrac{(p - 1)!}{i!(p - i)!} \times p$，这个多出来的 $p$ 不会被分母约掉，故一定是 $p$ 的倍数。

    根据二项式定理 $[x^m](1 + x)^n = \binom{n}{m}$，构造 $(1 + x)^p = 1 + \binom{p}{1}x + ... + \binom{p}{p}x^p$。故 $(1 + x)^p \equiv 1 + x^p(\mod p)$。

    根据 $(1 + x)^n \equiv (1 + x)^{p\left \lfloor n/p \right \rfloor}(1 + x)n \mod p$，分别提取第 $m$ 项的系数，则有

    \begin{align}
    (1 + x)^n &\equiv (1 + x)^{p\left \lfloor n/p \right \rfloor}(1 + x)n \mod p \\
              &\equiv (1 + x^p)^{\left \lfloor n/p \right \rfloor}(1 + x)n \mod p \\
    \binom{n}{m} &\equiv \sum_{p \mid i}^m \binom{\left \lfloor n / p \right \rfloor }{i / p}\binom{n\mod p}{m - i} (\mod p) \\
                &\equiv \binom{\left \lfloor n / p \right \rfloor }{m / p}\binom{n\mod p}{m \mod p} (\mod p)
    \end{align}

    从倒数第二步到最后一步，虽然倒数第二步是一个和式，但其实只有 $i = p\left \lfloor n / p \right \rfloor$ 时才不为 $0$，也就是只有和式展开的最后一项不为 $0$。故可以化简为最后一项。其实也可以直接从倒数第三步到最后一步，也即只有 $m - i \le n \mod p$ 时才有意义。


- **库默尔定理**

$\binom{n + m}{m}$ 中素因子 $p$ 个数等于 $n, m$ 在 $p$ 进制下相加的进位次数。

!!! success "Proof"
    我们发现 $n!$ 中 $p$ 的次数是 $\sum_{i = 1}\left \lfloor n/p^i \right \rfloor$，根据 $\binom{n + m}{m} = \dfrac{(n + m)!}{n!m!}$，因子 $p$ 的个数是 $\sum_{i = 1}\left \lfloor (n + m)/p^i \right \rfloor - \left \lfloor n/p^i \right \rfloor - \left \lfloor m/p^i \right \rfloor$。

    观察发现 $\left \lfloor n/p^i \right \rfloor$ 表示 $n$ 在 $p$ 进制下去除后 $i$ 位的结果。则第 $i$ 位进位的充要条件恰是 $\left \lfloor (n + m)/p^i \right \rfloor = \left \lfloor n/p^i \right \rfloor + \left \lfloor m/p^i \right \rfloor + 1$。

- **拓展卢卡斯定理**

当 $p$ 不保证是质数时，求 $\binom{n}{m}\mod p$ 的值。

我们考虑将 $p$ 分解为 $\prod_i p_i^{c_i}$，求出模各个幂的结果并用中国剩余定理求解。

对于 $\binom{n}{m}\mod p$ 往往有 $p \mid n!$，故无法直接求逆。

我们记 $r(n) = n! / p^{v(n)}$，那么我们就是计算 

$$
    \dfrac{r(n)}{r(m)r(n - m)}p^{v(n) - v(m) - v(n - m)}
$$

我们之前已经能算出 $v(n) = \left \lfloor n/p^i \right \rfloor$，


### 质因数分解

- **Miller-Rabin 素性测试**



- **Pollard's Rho 质因数分解算法**



### 离散对数与原根

给定 $a, c$，求出

$$
    a^x \equiv c (\mod m)
$$

被称为离散对数问题，目前没有多项式复杂度解法。

- **BSGS 大步小布算法**

用分块求解，设 $T = \left \lceil \sqrt{m} \right \rceil$



- **扩展 BSGS**


### 二次剩余

### 杂项

- **威尔逊定理**

当且仅当 $p$ 是质数时，$(p - 1)! \equiv -1(\mod p)$。

!!! success "Proof"
    - 当 $p = 2$ 时显然成立。
    - 设 $p \ge 3$ 时，我们发现 $1 \sim p - 1$ 中的逆元必定两两配对，更近一步，只有 $a \equiv a^{-1}$ 时有些特殊，满足这个的 $a$ 只有 $\pm 1$，也就是 $\{2 \sim p - 2\}$ 的逆元同样也是 $\{2 \sim p - 2\}$ 的一个排列，那么 $\prod_{i = 2}^{p - 2}i \equiv 1(\mod p)$，那么再乘上 $1$ 和 $p - 1$，最后有 $\prod_{i = 1}^{p - 1}i \equiv -1(\mod p)$。

## 数论函数与求和

### 前置知识

数论函数：定义域为正整数的函数。陪域（值域可取的范围）一般认为是复数，在复杂的问题中也代以幂级数等。

完全积性函数：若数论函数 $f$ 满足 $f(xy) = f(x)f(y)$，则称为完全积性函数。

积性函数：若数论函数 $f$ 满足 $x \perp y \Rightarrow f(xy) = f(x)f(y)$，则称为完全积性函数。

积性分解：对于积性函数 $f$，给出质因数分解 $n = p_1^{c_1}...p_m^{c_m}$，则有

$$
    f(n) = \prod_{i = 1}^m f(p_i^{c_i})
$$

狄利克雷卷积：

$$
    (f*g)(n) \sum_{x \times y = n} f(x)g(y) = \sum_{d \mid n}f(d)g(n / d)
$$


### 莫比乌斯反演



### 整除

## 习题


## 参考资料

[OI-Note Chapter4.1 整除与同余](https://zhuanlan.zhihu.com/p/662127559)