#!/usr/bin/env octave

clear all
close all
clc

TOMO = load('../backup/proc000000_rho_vp_vs.dat.serial');

NGLLX = 5;
NGLLZ = NGLLX;

%TOMO = TOMO(round((1+NGLLX*NGLLZ)/2):NGLLX*NGLLZ:end,:);

save('-ascii', '../backup/TOMO.xyz','TOMO');

