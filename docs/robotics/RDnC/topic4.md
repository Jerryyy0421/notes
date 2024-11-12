# Nonlinear Control

## 0x01. Input-Output Linearization

For a nonlinear system:

$$
    \dot{x} = f(x, u)
$$

we can translate it into

$$
    \dot{x} = f(x) + g(x) u 
$$

Note: nonlinear affine system

and we have an output function:

$$
    y = h(x)
$$

!!! note
  $x \in $

Lie Derivative:

$$
\left.\begin{matrix} 
y = h(x) \\
\dot x = f(x) + g(x)u
\end{matrix}\eight\} \to \dot y = \dfrac{\partial h}{\partial x}(f(x) + g(x)u)
$$

Linearized dynamics:
$$
    \dot{\eta} = F\eta + G\mu
$$


## 0x02. CLF-QP controller



## 0x03. CLF-QP + input saturation




