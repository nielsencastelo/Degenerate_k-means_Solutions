clear; clc; close all;
x = load('ruspini.dat');
k = 4;
method = 1;
epsilon = 1e-6;
type = 1;
[classes,center,it,mssc] = dkmeans(x,k,method,epsilon,type);