//#####################################################################
// Copyright 2012.
// This file is part of PhysBAM whose distribution is governed by the license contained in the accompanying file PHYSBAM_COPYRIGHT.txt.
//#####################################################################

#include "svd-test.h"
#include <cstdio>

random_type rnd;

double eps=1e-6;

typedef double T;
typedef vec<double,3> V;
typedef mat<double,3> M;

V compute_diag(const V& sig,M& dA,V& div)
{
    V E=exp(sig);
    T s=sum(E);
    V S=sin(sig);
    V A=s*S;

    V C=cos(sig);
    dA=outer(S,E)+s*diag(C);

    for(int i=0;i<3;i++)
    {
        int j=(i+1)%3;
        int k=(i+2)%3;
        div[i]=(A[j]-A[k])/(sig[j]-sig[k]);
    }

    return A;
}

// ddE = dA : dF;
M compute(const V& sig, const M& UU, const M& dF, M& dE)
{
    diff_helper<T,3> h;
    V A = compute_diag(sig,h.H,h.A);
    h.B = h.A;
    h.flip=false;
    dE = UU * h.apply(UU.t() * dF * UU) * UU.t();
    return UU * diag(A) * UU.t();
}

int main(int argc, char* argv[])
{
    random_type rand;
    M UU=random_rotation(rand,M_PI);
    V Sig;
    fill_random(rand,Sig,-1.,1.);

    M dUU=random_rotation(rand,eps);
    V dSig;
    fill_random(rand,dSig,-eps,eps);

    M UU1=UU*dUU;
    V Sig1=Sig+dSig;

    M F=UU*diag(Sig)*UU.t();
    M F1=UU1*diag(Sig1)*UU1.t();
    M dF=F1-F;

    M dA0,dA1;
    M ddA0,ddA1;

    M A0=compute(Sig,UU,dF,dA0);
    M A1=compute(Sig1,UU1,dF,dA1);

    M u=A1-A0,v=(dA0+dA1)/2;

    T e0=u.frobenius_norm()/eps;
    T e1=v.frobenius_norm()/eps;
    T e2=(v-u).frobenius_norm()/eps;
    printf("%g %g %g\n",e0,e1,e2/std::max(std::max(e0,e1),1e-30));

    return 0;
}