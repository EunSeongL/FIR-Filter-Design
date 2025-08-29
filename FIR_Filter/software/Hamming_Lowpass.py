import numpy as np
import matplotlib.pyplot as plt
from scipy import signal
from scipy.signal import chirp
from chap07_module import *

# Filter Spec.
Omega_p=0.2*np.pi; Omega_s=0.3*np.pi     # 통과대역 에지 주파수, 저지대역 에지 주파수
tr_width=Omega_s-Omega_p                 # 천이대역폭
Omega_c=(Omega_s+Omega_p)/2              # 차단주파수

print("1st stage ---------------- ")
# high-level modeling
# floating point precision

M=int(np.ceil(6.6*np.pi/tr_width))+1; print("M=",M)  # 창 길이
nt=np.arange(0,M)               # 시퀀스 축

hd=ideal_lp(Omega_c,M)          # 이상적인 LPF 임펄스응답
wn=signal.windows.hamming(M)    # 해밍 창 함수  ## 수정
hn=hd*wn                        # 유한 임펄스응답

print("hn = ", hn)
print("length of hn = ", len(hn))

nf,H=signal.freqz(hn)        # 주파수축, 주파수응답
H_dB=20*np.log10(abs(H))     # 주파수응답(dB)

t=np.linspace(0,1,5000)
xn=chirp(t,f0=10, t1=0.2, f1=500, method="linear") #처프신호 생성
#print("xn = ", xn)
yn=np.convolve(hn,xn) #컨볼루션으로 출력생성
#print("length of yn = ", len(yn))
plt.figure(1)
plt.subplot(2,1,1); plt.plot(xn, "b")

plt.figure(2)
plt.subplot(3,3,1); plt.stem(nt,hn,"b"); plt.grid()
plt.ylabel("h(n)"); plt.xlabel("n"); plt.xlim(0,M-1)
plt.title("Impulse response, Frequency response, Frequency filtering result")

plt.subplot(3,3,4); plt.plot(nf/np.pi,H_dB,"b"); plt.grid(); plt.xlim(0,1); plt.ylim(-120,5)
plt.xlabel("Frequency in pi radians"); plt.ylabel("Magnitude [dB]")

plt.subplot(3,3,7); plt.plot(yn,"b"); plt.xlim(0,5000)
plt.xlabel("Samples(Frequency(0~500[Hz]))"); plt.grid()


print("2nd stage ---------------- ")

f_len = 19  # 필터 길이 : 홀수!!!
center = int(len(hn)/2)+1
half = int(f_len/2)

hn_short = hn[center-half-1:center+half]
del(hn)
hn = hn_short
print("hn length = ",len(hn))
del(nt)
nt=np.arange(0,f_len)

nf,H=signal.freqz(hn)     #주파수축, 주파수응답
H_dB=20*np.log10(abs(H))     #주파수응답(dB)

plt.subplot(3,3,2); plt.stem(nt,hn,"b"); plt.grid()
plt.xlabel("n");
plt.xlim(0,2*half-1)

plt.subplot(3,3,5); plt.plot(nf/np.pi,H_dB,"b"); plt.grid(); plt.xlim(0,1); plt.ylim(-120,5)
plt.xlabel("Frequency in pi radians"); #plt.ylabel("Magnitude [dB]")

del(yn)
yn=np.convolve(hn,xn) #컨볼루션으로 출력생성
print("length of yn = ", len(yn))
plt.subplot(3,3,8); plt.plot(yn,"b"); plt.xlim(0,5000)
plt.xlabel("Samples(Frequency(0~500[Hz]))"); plt.grid()


print("3rd stage ---------------- ")

# data : 8 bits

bit_size = 8
# 8-bit filter coefficient
# sign : 1 bit
# magnitude : max b111_1111  = (2^7) -1 = 127

hn_max = max(hn)
print("hn_max = ", hn_max)
# hn_max = 0.25 => b0.01

for i in  range(len(hn)) :
    hn[i] = int(hn[i] / hn_max * (pow(2, bit_size - 1) - 1))

print("hn : fixed : ", hn)

nf,H=signal.freqz(hn)     #주파수축, 주파수응답
#H_dB=20*np.log10(abs(H))     #주파수응답(dB)
H_dB=20*np.log10(abs(H)*(hn_max) / (pow(2, bit_size - 1) - 1))     #주파수응답(dB)

xn_max = max(xn)
print("xnmax = ", xn_max)
# 8-bit input data
# sign : 1 bit
# magnitude : max b111_1111
for i in  range(len(xn)) :
    xn[i] = int(xn[i]/xn_max * (pow(2,bit_size - 1)-1))
print("xn = ", xn)

plt.figure(1)
plt.subplot(2,1,2); plt.plot(xn, "b")

plt.figure(2)
yn=np.convolve(hn,xn) #컨볼루션으로 출력생성
print("yn = ", yn)
print("max of yn = ", max(yn))
for i in  range(len(yn)) :
    yn[i] = int(yn[i]/(pow(2,7))*hn_max)
    if yn[i] > (pow(2, bit_size - 1) - 1) :
        print("overflow +, y[",i,"] = ", yn[i])
        yn[i] = (pow(2, bit_size - 1) - 1)
    elif yn[i] < (-1)*(pow(2, bit_size - 1) - 1) :
        print("overflow -, y[", i, "] = ", yn[i])
        yn[i] = (-1)*(pow(2, bit_size - 1) - 1)

print("yn = ", yn)
print("max of yn = ", max(yn))

plt.subplot(3,3,3); plt.stem(nt,hn,"b"); plt.grid()
plt.xlabel("n");
plt.xlim(0,2*half-1)

plt.subplot(3,3,6); plt.plot(nf/np.pi,H_dB,"b"); plt.grid(); plt.xlim(0,1); plt.ylim(-120,5)
plt.xlabel("Frequency in pi radians"); #plt.ylabel("Magnitude [dB]")

plt.subplot(3,3,9); plt.plot(yn,"b"); plt.xlim(0,5000)
plt.xlabel("Samples(Frequency(0~500[Hz]))"); plt.grid()

plt.show()