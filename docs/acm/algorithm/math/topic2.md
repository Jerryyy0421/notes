# 组合数学

## 重要结论 && 模型

- 现有 $n$ 个 **完全相同** 的元素，要求将其分为 $k$ 组，保证每组至少有一个元素，一共有多少种分法？

!!! success "Solution"

    用 $k - 1$ 个板子来插板，答案就是 $\dbinom{n - 1}{k - 1}$。

- 如果问题变化一下，每组允许为空呢？

!!! success "Solution"
    
    先借 $k$ 个再插板，答案为
    
    $$
    \binom{n + k - 1}{k - 1} = \binom{n + k - 1}{n}
    $$

- 如果再扩展一步，要求对于第 $i$ 组，至少要分到 $a_i,\sum a_i \le n$ 个元素呢？

!!! success "Solution"

    第 $i$ 组借来 $a_i$ 个，然后问题三就转化成了问题二，直接用插板法公式得到答案为

    $$
    \binom{n - \sum a_i + k - 1}{n - \sum a_i}
    $$

- 不相邻的排列

!!! success "Solution"
    $1 \sim n$ 这 $n$ 个自然数中选 $k$ 个，这 $k$ 个数中任何两个数都不相邻的组合有 $\dbinom {n-k+1}{k}$ 种。

## 习题

[**CF2025E Card Game**](https://codeforces.com/contest/2025/problem/E)

**Solution**

计数好题，卡特兰数相关。

我们首先要明白一点，对于 $1$ 号卡片，玩家1 的数量不少于玩家2 的数量。对于其他种类的卡片，玩家1 的数量不多于玩家2 的数量。

先仅考虑 $n = 1$ 的情况，相当于两人各选 $\dfrac{n}{2}$ 个数，保证玩家2 的每一张牌都有一张比它大的牌在玩家1 那里一一对应。玩家1 的牌相当于左括号，玩家2的牌相当于右括号，则是看作长度为 $n$ 的合法括号种数。

对于 $n > 1$ 的情况，玩家1 可以多拿一些 $1$ 号牌，抵消玩家2 多出来的其他种类的牌。

我们设 $F_k$ 为有 $k$ 个右括号未被匹配的方案数。类比于卡特兰数的推导方式，这相当于走到 $\left ( \dfrac{m - k}{2}, \dfrac{m + k}{2}\right )$ 且不穿过直线 $y = x + k$ 的方案数。由于总方案数是 $\binom{m}{\frac{m - k}{2}}$，不合法的部分相当于沿 $y = x + k + 1$ 翻折成走到 $\left(\dfrac{m - k}{2} - 1, \dfrac{m + k}{2} + 1\right)$ 的方案数，是 $\binom{m}{\frac{m - k}{2} - 1}$。所以总方案数是

\begin{eqnarray}
F_k = \binom{m}{\frac{m - k}{2}} - \binom{m}{\frac{m - k}{2} - 1}
\end{eqnarray}

我们接着再设 $f_{i, j}$ 为到第 $i$ 种卡片为止，还有 $j$ 张 $1$ 号卡片没用的方案数。这些多的卡片可以和玩家2 别的种类卡片来抵消，故有转移方程：

\begin{eqnarray}
\begin{cases}
 f_{1, j} = F_j & ((m - j)\mod 2 \equiv 0) \\
 f_{i, k} = \sum f_{i - 1, j} \times F_{j - k}& ((m + j - k)\mod 2 \equiv 0)
\end{cases}
\end{eqnarray}

答案是 $F_{n, 0}$，时间复杂度为 $O(nm^2)$。




