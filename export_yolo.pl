#!/usr/bin/perl
#
$dstfile = "/tmp/results_yolo.tar.bz2";
$auxdir = "/tmp/results_yolo/";
$dirname="./dataset";
opendir(DIR, $dirname);
@files = readdir(DIR);
closedir DIR;
system("rm -rf $auxdir");
mkdir $auxdir;
foreach $key (@files) {
	next if($key eq "." || $key eq "..");
	next if(! -d "$dirname/$key");
	print "$key\n";
	opendir(DIR2, "$dirname/$key");
	@files2 = readdir(DIR2);
	closedir DIR2;
	foreach $key2 (@files2) { #Estoy en el subdir del caso
		next if($key2 eq "." || $key2 eq "..");
		next if(! -d "$dirname/$key/$key2");
		print "$key2\n";
		$dirpath = "$dirname/$key/$key2/input/yolo";  #For input
		$cmd='cp --parents'.$dirpath.'/*.jpg '.$auxdir;
		#print "$cmd\n";
		#exit 0;
		system($cmd);
	}
}
