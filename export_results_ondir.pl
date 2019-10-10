#!/usr/bin/perl
#

$dirname="./results/";
#$algorithm="DPTexture";
$algorithm="LBP_MRF";
$dstfile = "/tmp/result_".$algorithm.".tar.bz2";
$auxdir = "/tmp/result_".$algorithm."_aux/";

$path=$dirname.$algorithm."_result";

system("rm -rf $auxdir");
mkdir $auxdir;

$stats_file = "$path/stats.txt";
system("sed -i '/^cm/d' $stats_file");
system("sed -i '/^#/d' $stats_file");
system("sed -i '/^\$/d' $stats_file");

system("cp $stats_file $auxdir/".$algorithm."_stats.txt");

system("tar cjvf $dstfile $auxdir");
print("Resultados escritos en $dstfile\n");
