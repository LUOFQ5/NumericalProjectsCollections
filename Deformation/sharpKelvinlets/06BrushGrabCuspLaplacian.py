import numpy as np

axis_element = 100
num_element = axis_element * axis_element
axis_nodes = axis_element + 1
num_nodes = axis_nodes * axis_nodes
L = 10
dx = L / axis_element

nodePos = np.zeros((num_nodes,3)) # 假的，实际上是二维的
for i in range(num_nodes):
    x = int(i % axis_nodes)
    y = int(i / axis_nodes)
    nodePos[i,0] = x * dx - L / 2
    nodePos[i,1] = y * dx - L / 2
    
eps = 4
nu = 0.45
mu = 5
force = np.zeros((3))
_a = 1 / 4 / np.pi / mu
_b = _a / (1 - nu) / 4

def EvalA(r):
    if r < 1e-8 * eps:
        return 10 * (3 * _a - 2 * _b) / eps / eps /eps
    
    e2 = eps * eps
    e4 = e2 * e2
    e6 = e2 * e4
    
    r2 = r * r
    r4 = r2 * r2
    r6 = r4 * r2
    
    re2 = r2 + e2
    re = np.sqrt(re2)
    re5 = re2 * re2 * re
    A = (15 * _a - 10 * _b) * e6
    A += (90 * _a - 88 * _b) * e4 * r2
    A += 120 * e2 * r4 * (_a - _b)
    A += 48 * r6 * (_a - _b)
    A += 48 * r * re5 * (_b - _a)
    A *= 2 / (e4 * re5)
    return A
    


def EvalB(r):
    if r < 1e-8 * eps:
        return 0
    
    e2 = eps * eps
    e4 = e2 * e2
    
    r2 = r * r
    r4 = r2 * r2
    
    re2 = r2 + e2
    re = np.sqrt(re2)
    re5 = re2 * re2 * re
    
    B = 2 * e2 * r2 * (4 * re - 5 * r)
    B += 4 * r4 * (re - r)
    B += e4 * (4 * re - 7 * r)
    B *= -(12 * _b) / (e4 * r * re5)
    return B
    

force[1] = 1 / EvalA(0)

for i in range(num_nodes):
    temp = np.zeros((3))
    x = nodePos[i,:]
    r = np.sqrt(x[0]*x[0] + x[1]*x[1] + x[2]*x[2])
    u = EvalA(r) * force
    if r < 1e-4:
        temp = u.copy()
    else:
        dotres = force[0]*x[0] + force[1]*x[1] + force[2]*x[2]
        u += EvalB(r) * dotres * x
        temp = u.copy()
    nodePos[i,:] += temp

