# Linear Regression

Suppose a linear regression model for $p$ predictors is represented by coefficients $B_0, B_1, ..., B_p = \vec{B}$.

Then $\vec{B}^T x = y$.

Assume the threshold is set at $y = 0$.

Then $\vec{B}^T x = 0$ is our equation that represents the hyperplane where the
decision changes.

This equation has $p - 1$ free variables. Explicitly,

$x_{p} = -\frac{1}{B_{p}} (B_0 + B_1 x_1 + B_2 x_2 + ... + B_{p-1} x_{p-1})$

where $x_1, x_2, ..., x_{p-1}$ are free variables.

If the threshold is set at $b$, then the equation becomes

$x_{p} = -\frac{1}{B_{p}} ((B_0 - b) + B_1 x_1 + B_2 x_2 + ... + B_{p-1} x_{p-1})$.

## Visual

[https://www.desmos.com/3d/midyhrtelk](https://www.desmos.com/3d/midyhrtelk)

The red plane represents the linear regression. The green plane represents the threshold value.
The blue line represents the decision boundary if the linear regression had a threshold value of 0
while the purple line represents the decision boundary at the threshold value.
