# Decision Trees

Let us consider the case when each of the leaf node decides on a binary variable for a decision tree $T$.
The decision boundary should only be considered under the node, $N$ that decides
the variable we condition, $X$ on. We can do a DFS on the children of $N$ to calculate all the following quantities:

$A_1, A_2, ..., A_k$ where $A_i$ is a set that only contains necessary conditions
for the output to be true, given that $X = 0$. $k$ is the number of terminating nodes
that end with output true given $X = 0$. We define $B_1, B_2, ..., B_k$ in a
similar fashion given that $X = 1$.

The decision boundary is the set of conditions such that the output $Y$ is different
given different $X$. Let $A$, $B$ be the set of all inputs that the decision tree outputs
true given $X=0$, $X=1$, respectively. Then the decision boundary $D = A \bigtriangleup B$
In other words, $\bigcup{A_i} \bigtriangleup \bigcup{B_i}$. We can calculate this explicitly.

## Time complexity

We perform DFS on the decision tree and then calculate the symmetric difference.

Let $N$ be the number of nodes in the tree. DFS takes $O(N)$ time then.

[https://arxiv.org/pdf/1301.3388](https://arxiv.org/pdf/1301.3388) has a method to quickly
calculate set operations. Using the paper's result, the total time complexity is

$O(N + p \min(A, B, A \bigtriangleup B)\log(\frac{A + B}{\min(A, B, A \bigtriangleup B)}))$.

But $A$ and $B$ could be large $O(2^p)$, so the algorithm takes exponential time.

## Pitfalls

-   The case when a variable is quantitative could be more complicated.
-   Computationally unfeasible on large $p$.
