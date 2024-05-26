# Linear Control

## 3x01. Linearization

Linear System: $x = Ax + Bu$

Nonlinear System: $\ddot{x} = f(x, u)$

$$
\begin{align*}
    \dot{x} &= f(x_d, u_d) + \dfrac{\partial f}{\partial x}(x_d, u_d)(x - x_d)+ \dfrac{\partial f}{\partial u}(x_d, u_d)(u - u_d) \\
    \dot{x} - \dot{x_d} &= A(x - x_d) + B(u - u_d) \\
    \delta \dot{x} &= A\delta x + Bu
\end{align*}
$$

Linear Control:

$$
\begin{align*}
\delta u &= -k\delta x\\
\to \delta x &= (A - Bk) \delta x \\
         &= A_{CL} x
\end{align*}
$$

**CL: Closed Loop**

Methods of judging the stability of the system: 

1. All eigenvalues of $A_{CL}$ is negative.
2. Lyapunov Analysis

    Lyapunov function: $V(x) = x^TPx$

    Lyapunov equation: $A_{CL}^T \dot P + P \dot A_{CL} = -Q$

    **Theorem**: If a system satisfies the conditions below,
    
      1. $V(x)$ is positive-definite matrix.
      2. $\dot V(x)$ is positive-definite matrix.
      3. $x \to \infty, V(x) \to \infty$

    the system is stable.

!!! tip "Generalization of Lyapunov theorem"
    1. For a given positive-definite matrix $P$, there exits a positive-definite matrix $Q$ which satisfies $A_{CL}^T \dot P + P \dot A_{CL} = -Q$, then the system is stable.
    2. In the linear system, for all positive-definite system $P$, there is only one positive-definite matrix $Q$, which satisfies $A_{CL}^T \dot P + P \dot A_{CL} = -Q$, then the system is stable.

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
\begin{align*} 
    \delta x[k + 1] &= Adt \delta x[k + 1] + Bdt \delta u[k] + \delta x[k] \\
    \to \delta x[k + 1] &= (Adt + I) \delta x[k + 1] + Bdt \delta u[k] \\
    \to \delta x[k + 1] &= A_k \delta x[k + 1] + B_k \delta u[k] 
\end{align*}
$$

Procedures:

- measure current state $x[k]$
- optimal control based on $u_k, u_{k + 1}, ... u_{k + n - 1}$
- get the optimal $x^*$
- only get $u[k]$ as the next input


## 3x05. Stability Judgment



