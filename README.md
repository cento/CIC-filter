## Cascaded Integrator–Comb (CIC) in VHDL

In digital signal processing, a cascaded integrator–comb (CIC) is an optimized class of finite impulse response (FIR) filter combined with an interpolator or decimator.

A CIC filter consists of one or more integrator and comb filter pairs. In the case of a decimating CIC, the input signal is fed through one or more cascaded integrators, then a down-sampler, followed by one or more comb sections (equal in number to the number of integrators). An interpolating CIC is simply the reverse of this architecture, with the down-sampler replaced with a zero-stuffer (up-sampler).

(source: [Wikipedia](https://en.wikipedia.org/wiki/Cascaded_integrator–comb_filter))


### Design Specifications
* Interpolation ratio
`R = 4`
* Number of samples per stage
`M = 1`
* Number of stages in filter
`N = 4`
* Comb to Integrator states
`Zero-Insertion`
* Input and Output rappresentation
`16 bit`

###Contents (attach. pdf)
* Intruduction
* Architecture description
* Block Diagram
* VHDL code
* Testbench
* Conclutions

---
©2010
