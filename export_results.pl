#!/usr/bin/perl
#

$dstfile = "/tmp/results.tar.bz2";
$auxdir = "/tmp/results_aux/";
$dirname="./results";
opendir(DIR, $dirname);
@files = readdir(DIR);
closedir DIR;
system("rm -rf $auxdir");
mkdir $auxdir;
foreach $key (@files) {
	next if($key eq "." || $key eq "..");
	if(-d "$dirname/$key") {
		print "$key\n";
	}
	$stats_file = "$dirname/$key/stats.txt";
	system("sed -i '/^cm/d' $stats_file");
	system("sed -i '/^#/d' $stats_file");
	system("sed -i '/^\$/d' $stats_file");

	close $info;
	system("cp $dirname/$key/stats.txt $auxdir/".$key."_stats.txt");
}
system("tar cjvf $dstfile $auxdir");
print("Resultados escritos en $dstfile\n");
