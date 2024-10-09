# 数学

## 数论

### 整除和同余

#### 逆元

**逆元唯一性定理**

逆元若存在，则总是是唯一的。

**逆元存在性定理**

在模 $m$ 下，当且仅当 $a \perp m$ 时，$a$ 有乘法逆元。

**裴蜀定理**

不定方程 $ax + by = c$ 当且仅当 $\text{gcd}(a, b) | c$ 时有解。

**费马小定理**

对于质数 $p$，任意正整数 $a$ 满足 $a^{p - 1} \equiv 1(\mod p)$。

**欧拉定理**

当 $a \perp m$ 时，$a^{\varphi (m)} \equiv 1(\mod m)$。

**线性求前缀逆元**

对于质数 $p$，存在 $n^{-1} \equiv -\left \lfloor p / n  \right \rfloor(p\mod n)^{-1} (\mod p)$。

**批量求逆元**

对于 $A_{1 \sim n}$，$S = (\prod_{i = 1}^n A_i)^{-1}$，则有 $A_i^{-1} = SL_{i - 1}R_{i + 1}$。


#### 线性同余方程组

**中国剩余定理**

满足模数两两互质，先看两个方程组的情况，

\begin{eqnarray}
\left\{\begin{matrix}
x \equiv c_1(\mod m_1) \\
x \equiv c_2(\mod m_2)
\end{matrix}\right.
\end{eqnarray}

求解出答案是 $x \equiv c_1m_2\text{Inv}_{m_1}(m_2) + c_2m_1\text{Inv}_{m_2}(m_1)(\mod m_1m_2)$。
对于 $n$ 个方程组，两两合并即可。

**拓展中国剩余定理**

不保证模数两两互质。

相当于解方程 $am_1 + bm_2 = c_2 - c_1$，先判断有无解，然后再利用扩欧求解。新方程相当于变成了

\begin{eqnarray}
\left\{\begin{matrix}
x \equiv x_0(\mod \text{lcm}(m_1, m_2)) \\
x \equiv c_3(\mod m_3)
\end{matrix}\right.
\end{eqnarray}

然后不断两两合并即可。

#### 组合数取模

**求阶乘逆元小技巧**

先算 $n!$ 逆元，然后不断从后往前乘，依次算逆元。

**卢卡斯定理**

$$
\binom{n}{m} \equiv \binom{\left \lfloor n/p \right \rfloor}{\left \lfloor m/p \right \rfloor}\binom{n\mod p}{m\mod p}(\mod p)
$$

**库默尔定理**

$\binom{n + m}{m}$ 中素因子 $p$ 个数等于 $n, m$ 在 $p$ 进制下相加的进位次数。


**拓展卢卡斯定理**



#### 杂项

**威尔逊定理**

当且仅当 $p$ 是质数时，$(p - 1)! \equiv -1(\mod p)$。

### 数论函数与求和



## 线性代数



## 博弈论

### 相关知识

**SG 函数**

定义 SG 函数为 $\operatorname{SG}(x)=\operatorname{mex}\{\operatorname{SG}(y_1), \operatorname{SG}(y_2), \ldots, \operatorname{SG}(y_k)\}$。

而对于由 n 个有向图游戏组成的组合游戏，设它们的起点分别为 $s_1, s_2, \ldots, s_n$，则有定理：当且仅当 $\operatorname{SG}(s_1) \oplus \operatorname{SG}(s_2) \oplus \ldots \oplus \operatorname{SG}(s_n) \neq 0$ 时，这个游戏是先手必胜的。同时，这是这一个组合游戏的游戏状态 x 的 SG 值。


**巴什博奕（Bash Game）**

A 和 B 一块报数，每人每次报最少 1 个，最多报 4 个，看谁先报到 30。这是最古老的关于巴什博奕的游戏了。

那么如果我们要报 n 个数，每次最少报一个，最多报 m 个，我们可以找到这么一个整数 k 和 r，使 $n = k(m + 1) + r$，代入上面的例子我们就可以知道，如果 $r = 0$，那么先手必败；否则，先手必胜。

**威佐夫博弈（Wythoff Game）**

有两堆各若干的物品，两人轮流从其中一堆取至少一件物品，至多不限，或从两堆中同时取相同件物品，规定最后取完者胜利。

结论：若两堆物品的初始值为 (x，y)，且 x < y，则另 z = y - x；

记 `w = (int) [((sqrt(5) + 1) / 2) * z]`；

若 `w == x`，则先手必败，否则先手必胜。

??? success "Proof"
    我们观察前几个必败局面（奇异局势）
    ```
    0: (0, 0) 
    1: (1, 2) 
    2: (3, 5) 
    3: (4, 7) 
    4: (6, 10) 
    5: (8, 13) 
    ```
    第 $i$ 个奇异局势形如 $(x, x + i)$，我们发现每次最后一个奇异局势的最小值一定是前面所有数的 $\text{mex}$，并且还有相邻奇异局势，最小值只增加 1 或 2。可以近似表示为 $\left \lfloor  na \right \rfloor$，那么第二个值就是 $\left \lfloor (a + 1)n \right \rfloor$。

    这里还有一个引理，**beatty 定理**。
    > 对于两个无理数 $x, y$，若其满足 $\dfrac{1}{x} + \dfrac{1}{y} = 1$，令 $P = \{p | p = \left \lfloor  nx \right \rfloor, n \in N^+\}, Q = \{q | q = \left \lfloor  mx \right \rfloor, m \in N^+\}$。
    > 那么则有 $P \cap Q = \emptyset, P \cup Q = N^+$。

    其实就是说明了自然数能按某一规则被恰好划分成 $P, Q$ 两个集合。

    和这里的奇异局势有点像，其实感性理解一下，不难发现自然数也被每个局势第一，二个数恰好划分两半。

    故由 beatty 定理，我们有 $\dfrac{1}{a} + \dfrac{1}{a + 1} = 1$，求出 $a = \dfrac{\sqrt{5} + 1}{2}$。故当 $\left \lfloor \dfrac{\sqrt{5} + 1}{2}\right \rfloor \times (b - a) = a$ 时，为奇异局势，先手必败。



**尼姆博弈（Nimm Game）**

尼姆博弈指的是这样一个博弈游戏：有任意堆物品，每堆物品的个数是任意的，双方轮流从中取物品，每一次只能从一堆物品中取部分或全部物品，最少取一件，取到最后一件物品的人获胜。

结论就是：把每堆物品数全部异或起来，如果得到的值为 0，那么先手必败，否则先手必胜。

**斐波那契博弈**

有一堆物品，两人轮流取物品，先手最少取一个，至多无上限，但不能把物品取完，之后每次取的物品数不能超过上一次取的物品数的二倍且至少为一件，取走最后一件物品的人获胜。

结论是：先手胜当且仅当 n 不是斐波那契数（n 为物品总数）。

### 习题

[**P2252 [SHOI2002] 取石子游戏|【模板】威佐夫博弈**](https://www.luogu.com.cn/problem/P2252)

**Solution**

结论和证明见上。

唯一要注意的是要用 `sqrtl` 而不是 `sqrt`，不然会有精度问题。




## 参考资料

[博弈论（巴什博奕，威佐夫博弈，尼姆博弈，斐波那契博弈）](https://blog.csdn.net/ac_gibson/article/details/41624623)

[OI-Note Chapter4.1 整除与同余](https://zhuanlan.zhihu.com/p/662127559)