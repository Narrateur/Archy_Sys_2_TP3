#!/bin/bash

ghdl -a -fsynopsys tb_processeur.vhd 
ghdl -a -fsynopsys control_unit.vhd
ghdl -a -fsynopsys datapath2.vhd
ghdl -a -fsynopsys processeur.vhd
ghdl -e -fsynopsys tb_processeur
ghdl -r -fsynopsys tb_processeur --stop-time=500ns --wave=tb.ghw