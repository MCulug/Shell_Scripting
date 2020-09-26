#!/bin/bash

i=1

header= `top -bn 1 | grep "^[0-9 ]" | awk '{ printf("%-8s %-8s %-8s \n", $12, $9, $10); }' | head -1`

$header > metrics.txt     # top 3 cpu intensive process

while i le 3;                 # top tree resource intensive command
do

Data_CPU_Sorted= `top -bn 1 | grep "^[0-9 ]" | awk '{ printf("%-8s %-8s %-8s \n", $12, $9); }' | head -$i | tail -n 1`

Data_Mem_Sorted= `top -bn 1 | grep "^[0-9 ]" | awk '{ printf("%-8s %-8s %-8s \n", $12, $10); }' | head -$i | tail -n 1`

$Data_CPU_Sorted >> metrics.txt 
$Data_Mem_Sorted >> metrics.txt 


sleep 3                                                                  # sleep interval                
Done
