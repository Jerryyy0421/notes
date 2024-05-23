# Linear Control

## 3x01. Linearization

Linear System: $x = Ax + Bu$

Nonlinear System: $\ddot{x} = Ax + Bu$



## 3x02. PD Control

$$
    u = k_p(x_d - x) + k_d(\dot{x_d} - \dot{x})
$$

## 3x03. LQR Control
> Linear Quadratic Regulator Control

We can't minimize the energy consumption and don't know when to reach optimality.
So we have the optimal control, by using it we can:

- Minimize the energy consumption. $J = U^TRU$
- Follow a path with minimum error. $J = X^TQX$

LQR is both linear control and optimal control. So it both satisfies $\dot{x} = Ax + Bu$ and has a cost function.

$$
\begin{align*}
   J &= \int_0^{\infty}(X^TQX + U^TRU)dt  \newline
   U &= -K_{LQR}X
\end{align*}
$$

Linear Control: $U = -K_{LQR}X$

$k_{LQR} = R^{-1}B^TP$ (LQR gain)

These coefficients satisfy that $A^TP + PA - PBR^{-1}B^TP + Q = 0$

A, B: coefficient matrix of state-space model 

Q, R: coefficient matrix of cost-function

!!! note "Difference between PD and LQR"
    - **PD**: $x \to x_d$, $u \to u_d$ while
      **LQR**: $x \to 0$, $u \to 0$
    - Whether it has a cost function.


Lyapunov function: $V(x) = x^TPx$

!!! tip "References"


## 3x04. QP Control
> Quadratic Program Control

Linear Control: $u = -kx$ without constraints

$$
    U^* = \text{argmin}_U ( \dfrac{1}{2}U^THY + f^TU )
$$


## 3x05. MPC Control
> Modern Predictive Control

Discrete-time dynamics:
$$
    \delta x[k + 1] = A_k \delta x[k + 1] + B_k \delta u[k]
$$

Procedures:

- measure current state $x[k]$
- optimal control based on $u_k, u_{k + 1}, ... u_{k + n - 1}$
- get the optimal $x^*$
- only get $u[k]$ as the next input

## 3x04. Control Simulation



## 3x05. Stability Judgment



