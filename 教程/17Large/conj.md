共轭梯度(Conjugate Gradient)经常用于解线性方程组。在物理模拟中主要是流体力学中的压力泊松方程，以及有限元中的刚度矩阵。但是共轭梯度本身缺陷诸多，因此有很多变种，常用的包括预处理共轭梯度(Precondition Conjugate Gradient)，稳定的双共轭梯度法(Bi Conjugate Gradient Stable)等。

很多教程解释共轭梯度都很棒，所以我接下来只会写写自己对于残差正交的理解。

古人说“山路十八弯”。乡间小路大多弯弯绕绕。在乡间为了由起点到达终点，需要转过数不清的弯。

这种方法与解线性方程组的普通迭代法很相似，为了找出解，需要走一点点就重新计算斜率，选其中最大的作为解的方向。因此很费时。

我说的就是jacobi迭代法和GaussSeidel法。对于稍微大的点的矩阵，不迭代个几万几十万次，误差会非常大。如果模拟过程中出现能量不守恒，多半也就是这两种迭代法的锅。

然而如果是理想城市道路，假设道路都是是正交的。那么想从城市的一个地方到另一个方向，最多转一次弯就够了。思考一下，在城市的道路上，转弯前你在想什么？肯定是先把这个方向的道路走完，然后再走了另一个方向的道路对吧？

共轭梯度法也是这么想的。不过用的词高大上一点。比如这个方向的道路剩下的距离，叫做“残差”。而城市中道路相互正交，在共轭梯度中则是每次迭代的残差，必定会和下一次迭代的残差正交。写成公式如下。
$$
(\bold r^{(k+1)})^T(\bold r^{(k)}) = 0
$$
我还想到一个自认为很形象的比喻。比如一架无人机在城市上空沿着街道飞行，比如它要从[0,0]飞到[1,1]，如果天空中没有大风，那么直接沿着[1,1]这个方向飞一个单位的距离就可以了。
$$
\begin{bmatrix} 1 & 0 \\ 0 & 1\end{bmatrix}\begin{bmatrix} 1 \\ 1\end{bmatrix} = \begin{bmatrix} 1 \\ 1\end{bmatrix}
$$
只要飞一次，步长就是一个单位。但是如果有大风，无人机就会被吹到别的地方去。比如大风的矩阵形式如下
$$
\begin{bmatrix} 2 & 1 \\ 1 & 4\end{bmatrix}\begin{bmatrix} 1 \\ 1\end{bmatrix} = \begin{bmatrix} 3 \\ 5\end{bmatrix}
$$
如果无人机向从[0,0]向[1,1]飞一个单位，那么最终会被大风吹到[3,5]去。因此使用共轭梯度的解法时，每当当前残差与上一次残差正交时，就重新计算位置。也可以理解为飞到城市道路正上方的时候重新计算方向。

比如无人机最终想飞到[4,9]，那我们就要解下面这个方程
$$
\begin{bmatrix} 2 & 1 \\ 1 & 4\end{bmatrix}\begin{bmatrix} x_1 \\ x_2\end{bmatrix} = \begin{bmatrix} 4 \\ 9\end{bmatrix}
$$
那么第0次残差就是[4,9]。下一次残差应该就是[9,-4]乘一个常数。我们先设定个初始方向，一般设定为和第一次残差相等，也是[4,9]，就是我们应该向方向d = [4,9]走一段距离alpha，但不能走满一个单位，否则就和因为矩阵干扰而偏得很远。最终实际走的路程为
$$
\alpha \bold A \bold d = \alpha \begin{bmatrix} 2 & 1 \\ 1 & 4\end{bmatrix}\begin{bmatrix} 4 \\ 9\end{bmatrix}
$$
那么下一次残差即为
$$
\bold r^{(1)} = \bold r^{(0)} - \alpha \bold A \bold d  = \begin{bmatrix} 4 \\ 9\end{bmatrix} - \alpha\begin{bmatrix} 17 \\ 40\end{bmatrix} = constant \begin{bmatrix} 9 \\ -4\end{bmatrix}
$$
那么可以算出来alpha = 0.2266，而新的残差是
$$
\bold r^{(1)} = \begin{bmatrix} 0.1472 \\ -0.0654\end{bmatrix}
$$
我们接下来需要重新选择方向，消除剩下的残差。虽然上面的推导并不严谨，并且跳过了很多步骤，但是我觉得这算是比较直观地理解残差。

最后，共轭梯度法用python可实现如下

```
import numpy as np
A = np.array([[2,1],[1,4]],dtype = float)
b = np.array([4,9],dtype = float)
nmax = 2

x = np.zeros((nmax)) # 待求解的值
p = np.zeros((nmax)) # 方向
res = b - np.dot(A,x) # 残差
bnrm2 = np.linalg.norm(b)
rho1 = 1
tmax = 1000
xt = np.zeros((tmax,nmax))
for t in range(0,tmax):
    rho = np.dot(np.transpose(res),res)
    beta = 0
    if t > 0:
        beta = rho / rho1
    p = res + beta*p
    Ap = np.dot(A,p)
    alpha = rho / np.dot(np.transpose(p),Ap)
    xt[t,:] = x
    x = x + alpha * p
    res = res - alpha * Ap
    error = np.linalg.norm(res) / bnrm2
    if error < 1e-8:
        break
    rho1 = rho
```

共轭梯度法的基本要求是，矩阵A是对称正定的，否则收敛很慢甚至无法收敛。但是巧了，压力泊松方程所要解的矩阵和刚度矩阵也都是对称正定的。所以共轭梯度法的变种经常可以在各种各样的库中见到。

### 受欢迎的共轭梯度法

共轭梯度法的变种在物理仿真中很常见。比如

Chartty Bridson 教授的开源库所使用的不完全Cholesky预处理共轭梯度https://github.com/christopherbatty/FluidRigidCoupling2D/blob/master/pcgsolver/pcg_solver.h。

Chartty Bridson 教授开源的多重预处理共轭梯度(Multi-Preconditioned Conjugate Gradients)https://www.cs.ubc.ca/~rbridson/mpcg/

论文“Synthetic Turbulence using Artificial Boundary Layers” http://graphics.ethz.ch/Downloads/Publications/Papers/2009/Pfa09/Pfa09_code.tar.gz开源的代码中页使用了不完全Cholesky预处理共轭梯度。论文“Narrow Band FLIP for Liquid Simulations”的开源代码也是如此http://www.thuerey.de/ntoken/download/nbflip.tar.gz

一个用taichi语言实现的三维有限元中的共轭梯度https://github.com/YuCrazing/Taichi/blob/master/fem_3d_imp/fem-3d-implicit.py

有限元开源库delfem2中使用了预处理共轭梯度https://github.com/nobuyuki83/delfem2/blob/master/include/delfem2/lsitrsol.h

有限元开源库vegafem中使用了预处理共轭梯度算稀疏矩阵https://github.com/starseeker/VegaFEM/blob/master/libraries/sparseSolver/CGSolver.cpp#L138

数学计算库Eigen使用了稳定双共轭梯度 https://gitlab.com/libeigen/eigen/-/blob/master/Eigen/src/IterativeLinearSolvers/BiCGSTAB.h

物理模拟库bullet3中的预处理共轭梯度https://github.com/bulletphysics/bullet3/blob/master/src/BulletSoftBody/btConjugateResidual.h 以及共轭残差https://github.com/bulletphysics/bullet3/blob/master/src/BulletSoftBody/btConjugateResidual.h

在见识了共轭梯度法在物理模拟中有多么受欢迎之后，我们再看看共轭梯度法的变种，他主要包括，稳定的双共轭梯度法，共轭残差法，稳定的双共轭残差法之类的，互相之间的改动并不大，照着公式就能写出来。我也将其中的一些方法用python实现，放在库中https://github.com/clatterrr/MathCollections/tree/master/ConjugateGradient，其中包括

| 算法名称                                            | 文件                              |
| --------------------------------------------------- | --------------------------------- |
| 稳定的双共轭梯度法(Bi Conjugate Gradient Stable)    | BiCGSTAB.py                       |
| 双共轭梯度法(Bi Conjugate Gradient)                 | BiCG.py                           |
| 双共轭残差法(Bi Conjugate Gradient Stable)          | BiConjugateGradient Stable.py     |
| 共轭梯度误差法(Conjuagate Gradient Normal Error)    | CGNE.py                           |
| 共轭梯度残差法(Conjuagate Gradient Normal Residual) | CGNR.py                           |
| 平方共轭梯度法(Conjuagate Gradient Square)          | Conjuagate Gradient Square.py     |
| 共轭残差法(Conjuagate Residual)                     | Conjuagate Residual.py            |
| 广义共轭残差法(General Conjuagate Residual)         | General Conjuagate Residual.py    |
| 残差范数最速下降(Residual Norm Steepest Descent)    | Residual Norm Steepest Descent.py |

至于这些千奇百怪的方法的原理，很容易搜到各种讲义和书籍，比如参考[1]，这里就不再赘述了。不过，你也看到了，目前我们的正宫是预处理共轭梯度。

### 预处理共轭梯度

虽然我们可以用普通的共轭梯度法解以下方程
$$
Ax = b
$$
但是如果A的性质不那么好，是病态的(ill-conditioned)，或者主对角线上的元素很小，或者特征值很小，那么收敛起来就会非常慢。因此我们可以先给A乘上一个预处理矩阵M^{-1}，再解这个方程如下
$$
M^{-1}A x = M^{-1}b
$$
![cab](https://github.com/clatterrr/MathCollections/blob/master/images/image-20210814100004969.png?raw=true)

预处理矩阵中一种非常简单的是Jacobi preconditioning。首先把矩阵A分为严格下三角，对角，以及严格上三角矩阵
$$
A = L + D + L^T
$$
那么jacobi 预处理矩阵就是A的对角矩阵
$$
M = D
$$
Eigen库中的jacobi Preconditioning 的代码如下https://gitlab.com/libeigen/eigen/-/blob/master/Eigen/src/IterativeLinearSolvers/BasicPreconditioners.h#L64

```
    template<typename MatType>
    DiagonalPreconditioner& factorize(const MatType& mat)
    {
      m_invdiag.resize(mat.cols());
      for(int j=0; j<mat.outerSize(); ++j)
      {
        typename MatType::InnerIterator it(mat,j);
        while(it && it.index()!=j) ++it;
        if(it && it.index()==j && it.value()!=Scalar(0))
          m_invdiag(j) = Scalar(1)/it.value();
        else
          m_invdiag(j) = Scalar(1);
      }
      m_isInitialized = true;
      return *this;
    }
```

完整的jacobi预处理共轭梯度如下

```
import numpy as np
import random
# 4.2.5 Preconditioned Conjuagate Gradient
# 参考 《迭代方法和预处理技术》谷同祥 等 编著 科技出版社
# 个人水平有限，程序可能有错，仅供参考
n = 128
A = np.zeros((n,n))
b = np.zeros((n))
for i in range(n):
    A[i,i] = 1
    b[i] = random.random()
    for j in range(i+1,n):
        A[i,j] = random.random()
        A[j,i] = A[i,j]


Minv = np.zeros((n,n))# 预处理矩阵
for i in range(n):
    Minv[i,i] = 1 / A[i,i] #最简单的预处理矩阵，就是A的对角的逆
x = np.zeros((n)) # 待求解的值
p = np.zeros((n)) # 方向
r = b - np.dot(A,x) # 残差
z = np.dot(Minv,r)
d = z.copy() # 方向
tmax = 1000
for t in range(0,tmax):
    Ad = np.dot(A,d)
    rz_old = np.dot(np.transpose(r),z)
    if abs(rz_old) < 1e-10:
        break
    alpha = rz_old / np.dot(np.transpose(d),Ad)
    x = x + alpha * d
    r = r - alpha * Ad
    z = np.dot(Minv,r)
    beta = np.dot(np.transpose(r),z) / rz_old
    d = z + beta * d

error = abs(np.dot(A,x) - b)
```

vegafem中也实现了jacobi preconditioninghttps://github.com/starseeker/VegaFEM/blob/master/libraries/sparseSolver/CGSolver.cpp#L196。另外两种比较简单的预处理矩阵分别是GaussSeidel以及SOR，好熟悉的名字
$$
M = L + D \qquad M = \frac{1}{\omega}(D + \omega L)
$$
关于这些预处理矩阵的介绍请看参考[2]。

接下来介绍不完全Cholesky预处理矩阵。在此之前先介绍Cholesky分解

### Cholesky分解

我们的矩阵A太大了，有n行n列，其中n是结点数。如果A是稠密矩阵的话，我们可以使用Cholesky分解将需要的存储空间从n^2 减少到n^2/2。也就是将A分解为L和L^T
$$
A = LL^T
$$

其中L是下三角矩阵。先把代码写出来

```python
import numpy as np
A = np.array([[4,2,4],[2,13,23],[4,23,77]])
n = 3
lower = np.zeros((n,n))
upper = np.zeros((n,n))
v = np.zeros((n))
for j in range(0,n):
    for i in range(j,n):
        v[i] = A[i,j]
        for k in range(0,j):
            # A 矩阵的形式是上三角
            v[i] -= lower[j,k]*upper[k,i]
        lower[i,j] = v[i] / np.sqrt(v[j])
        upper[j,i] = lower[i,j]
```

代码中我把矩阵L存储在lower中，L的转置存储在upper中。虽然完全没有必要，但是这么写能让算法更加清楚一些。

由于A是对称矩阵，因此我们可以仅关注A上三角部分，

首先计算L中第一行第一列，很显然
$$
L_{i=1,j=1}L^T_{i=1,j=1} = A_{i=1,j=1}
$$
那么这个数字就是A第一行第一列开平方了。然后看看A的第一行[1,2,4]，与矩阵L的关系是怎么样呢？答案很明显
$$
\bold A_{row1} = [4,2,4] = L_{i=1,j=1}\bold L^T_{i=1}
$$
那么很显然，L[1,1]已经计算出来是2了，那么L的转置后的第一行，也就是L的第一列就是[2,1,2]。

然后看看A其它对角线上的元素，就是第二行第二列的13，它会被两个乘法影响
$$
A_{i=2,j=2} = L_{i=2,j=1}L^T_{i=1,j=2} + L_{i=2,j=2}L^T_{i=2,j=2}
$$
上式右边第一项可以轻松算出来，第二项继续开平方，算得L的第二行第二列是3.46。

然后看看A此行其它元素，也就是第二行第三列的23，它也会被两个乘法影响
$$
A_{i=2,j=3} = L_{i=2,j=1}L^T_{i=1,j=3} + L_{i=2,j=2}L^T_{i=2,j=3}
$$
同样等式右边第一项已经算出来了，第二项的第一个因子刚才也算出来，这样就得到L的第二行第三列是6.06。接下去也是一样的计算方法。

而A第三行第三列的元素，会被三个乘法影响，依次将这些影响消去也很容易算出来。

上面就是完全Cholesky分解，分解出来的L通常是稠密矩阵。吐个槽，我经常会把这个算法看成ChcoleteSky。

### 不完全Cholesky分解

对于稀疏矩阵A来说，则会经常用不完全Cholesky分解。稀疏矩阵中元素大部分是零，我们希望分解之后的矩阵仍然能保持稀疏的性质。

所以如果某处元素是零，那么就默认这个元素不影响其它元素也不会被其它元素影响了，继续让这个元素在分解后仍然为零。如下

```python
import numpy as np
a = np.array([[1,2,4],[2,13,23],[4,23,77]])
n = 3
for k in range(n):
    a[k,k] = np.sqrt(a[k,k])
    for i in range(k+1,n):
        if a[i,k] != 0:
            a[i,k] = a[i,k] / a[k,k]
    for j in range(k+1,n):
        for i in range(j,n):
            if a[i,j] != 0:
                a[i,j] = a[i,j] - a[i,k] * a[j,k]
for i in range(n):
    for j in range(i+1,n):
        a[i,j] = 0
```

### 不完全Cholesky分解预处理共轭梯度

这个方法的名字很长。这个方法首先算矩阵A的不完全Cholesky分解，然后计算其预处理矩阵
$$
\hat A  = \hat L \hat L^T \qquad M = \hat A ^{-1}
$$
然后每次计算的时候z的时候，我们不再需要n行n列的预处理矩阵M，只需要分解后的下三角矩阵L就行了
$$
Mz = \hat L ^{-T}\hat L^{-1}z
$$


最终，不完全Cholesky分解预处理共轭梯度(Imcomplete Cholesky Factorization Preconditioned Conjugate Gradient)写成python代码结果如下

```
import numpy as np
import random
# 初始化矩阵
n = 256
A = np.zeros((n,n))
b = np.zeros((n))
for i in range(n):
    for j in range(i+1,n):
        ran = random.random()
         # 稀疏矩阵，矩阵越稀疏，越适合用不完全Cholesky分解
        if ran < 0.9:
            continue
        A[i,j] = random.random()
        # 共轭梯度只能处理对称正定矩阵
        A[j,i] = A[i,j]
    A[i,i] = 4 # 对角占优越多，求解越快
    b[i] = random.random()

# 不完全Cholesky分解
L = A.copy()
for k in range(n):
    if L[k,k] < 0:
        L[k,k] = np.sqrt(A[k,k])
    else:
        L[k,k] = np.sqrt(L[k,k])
    for i in range(k+1,n):
        if L[i,k] != 0:
            L[i,k] = L[i,k] / L[k,k]
    for j in range(k+1,n):
        for i in range(j,n):
            if L[i,j] != 0:
                L[i,j] = L[i,j] - L[i,k] * L[j,k]
for i in range(n):
    for j in range(i+1,n):
        L[i,j] = 0

# 函数，预处理子
def preconditioner():
    global L
    global r
    # 求解 L * result = rhs，即 result = L^-1 rhs
    # forward subtitution 前向替换
    resultTemp = np.zeros((n))
    for i in range(n):
        resultTemp[i] = r[i] / L[i,i]
        for j in range(i):
            resultTemp[i] -= L[i,j] / L[i,i] * resultTemp[j]
    # 求解 L^T * result = rhs 即 result = L^T^-1 rhs
    # backward subtitution 后向替换
    result = np.zeros((n))
    for i in range(n-1,-1,-1):
        result[i] = resultTemp[i] / L[i,i]
        for j in range(i+1,n):
            result[i] -= L[j,i] / L[i,i] * result[j]
            
    return result

# 预处理共轭梯度
x = np.zeros((n)) # 待求解的值
p = np.zeros((n)) # 方向
r = b - np.dot(A,x) # 残差
z = preconditioner()
d = z.copy() # 方向
tmax = 1000
for t in range(0,tmax):
    Ad = np.dot(A,d)
    rz_old = np.dot(np.transpose(r),z)
    if abs(rz_old) < 1e-10:
        break
    alpha = rz_old / np.dot(np.transpose(d),Ad)
    x = x + alpha * d
    r = r - alpha * Ad
    z = preconditioner()
    beta = np.dot(np.transpose(r),z) / rz_old
    d = z + beta * d
```

上面的代码参考自https://github.com/christopherbatty/FluidRigidCoupling2D/blob/master/pcgsolver/pcg_solver.h。

除了不完全Cholesky分解外，也可以使用不完全LU分解，比如delfem2就是这样的https://github.com/nobuyuki83/delfem2/blob/master/include/delfem2/eigen/ls_ilu_sparse.h#L154。

### 稀疏矩阵存储

如果未知量有n个，那么矩阵A就有n行n列，存稠密矩阵太费劲，所以一般都存稀疏矩阵。例如https://github.com/christopherbatty/FluidRigidCoupling2D/blob/master/pcgsolver/pcg_solver.h用了稀疏矩阵，即压缩稀疏行格式(CSR:compressed sparse row)。参考[1]的1.3节介绍了不同的稀疏矩阵格式

![image-20210910125256152](https://raw.githubusercontent.com/clatterrr/MathCollections/master/images/image-20210910125256152.png?raw=true)

![image-20210910125256152](https://github.com/clatterrr/MathCollections/blob/master/images/image-20210910125213859.png?raw=true)

Eigen库中的不完全Cholesky分解也是稀疏矩阵格式下的https://gitlab.com/libeigen/eigen/-/blob/master/Eigen/src/IterativeLinearSolvers/IncompleteCholesky.h

又例如taichi库中解压力泊松方程的例子https://github.com/taichi-dev/taichi/blob/master/examples/simulation/cg_possion.py，矩阵A直接消失不见，甚至连稀疏矩阵都不需要了，因为最简单的情况下，A矩阵就是由一些1相加而成，比如二维4x4网格的，一共16行16列的矩阵A
$$
\begin{bmatrix} 2 & -1 & 0 & 0 & -1 & 0 &0 &0 &0 &0 &0 &0 &0 &0 & 0 & 0 \\ 
-1 & 3 & -1 & 0 & 0 & -1 &0 &0 &0 &0 &0 &0 &0 &0 & 0 & 0\\
0 &-1 & 3 & -1 & 0 & 0 & -1 &0 &0 &0 &0 &0 &0 &0 &0 &  0\\
0 & 0 &-1 & 2 & 0 & 0 & 0 & -1 &0 &0 &0 &0 &0 &0 &0 & 0\\
-1 & 0 & 0 &0 & 3 & -1 & 0 & 0 & -1 & 0 & 0 & 0 & 0 & 0 &0 & 0\\
0 & -1 & 0 & 0 & -1 & 4 & -1  & 0 & 0 & -1 & 0 & 0 & 0 & 0 & 0 & 0\\
0 &0 & -1 & 0 & 0 & -1 & 4 & -1  & 0 & 0 & -1 & 0 & 0 & 0 & 0 &  0\\
0 & 0 &0 &-1 & 0 & 0 & -1 & 3 & 0 &0 &0 &-1 & 0  & 0 & 0  & 0 \\
0  & 0 & 0 & 0 & -1 & 0 &0 & 0  & 3 & -1 & 0 & 0 & -1 & 0 & 0 & 0\\
0 & 0 & 0 & 0 &0 & -1 & 0 & 0 & -1 & 4 & -1  & 0 & 0 & -1 & 0 &  0\\
0 & 0 & 0 & 0 &0 &0 & -1 & 0 & 0 & -1 & 4 & -1  & 0 & 0 & -1 &  0 \\
0 & 0 & 0 & 0 & 0 & 0 & 0 & -1 & 0 & 0 & -1 & 3 & 0 &0 & 0 & -1 \\
0 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & -1 & 0 & 0 & 0 & 2 & -1 & 0 & 0 \\
0 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & -1 & 0 & 0 & -1 & 3 & -1 & 0 \\
0 & 0 & 0 &0 & 0 & 0 &0 & 0 & 0 &0  & -1 & 0 & 0 & -1 & 3 & -1 \\
0 & 0 &0 & 0 &0 & 0 &0 & 0 &0 & 0 &0 & -1 & 0 & 0 & -1 & 2

\end{bmatrix}
$$
第一行第一列为2是因为左边和下边是墙壁。第二行第二列为3是因为下边为墙壁。所以只要在计算Ax的时候，判断上下左右是否是墙壁，或者是否越界，就能直接得出A矩阵中的值了。

不过又因为物理模拟中，物体一般由网格组成，每个顶点会被哪个顶点影响都是固定的，所以我们也可以预先算出A最多有多少列不为零。比如二维压力泊松方程，用二阶精度中心差分的话，一个点最多被自己加上下左右一共5个点影响，那么A最多五列不为零，到时候直接开五列的空间而不是n列就行了。三维压力泊松则是最多七个点。又比如有限元的刚度矩阵中，单元一般包括三角形，四边形，四面体。一个点在只会受到与自己同在一个单元的点上的影响，数量也有限。

最后，我自己写的一些有关各种共轭梯度算法的文件在https://github.com/clatterrr/MathCollections/tree/master/ConjugateGradient。

### 参考

[1]谷同祥等，迭代方法和预处理技术http://book.ucdrs.superlib.net/views/specific/2929/bookDetail.jsp?dxNumber=000015772005&d=03D7D48994C3AE35D8A227187AA7CEA2&fenlei=1301160106

[2]http://www.math.iit.edu/~fass/477577_Chapter_16.pdf