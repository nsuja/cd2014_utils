#!/usr/bin/perl
#
#ffmpeg -pattern_type glob -i '*.png' -c:v libx264 -vf "fps=25,format=yuv420p" out.mp4
# dataset/baseline/office/input/
#
$dstfile = "/tmp/results.tar.bz2";
$auxdir = "/tmp/results_aux/";
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
		#$dirpath = "$dirname/$key/$key2/input/";  #For input
		$dirpath = "$dirname/$key/$key2/groundtruth/"; #For groundtruth
		#print "$dirname/$key/$key2/$key3\n";
		#dataset/baseline/highway/groundtruth/gt00
		$cmd='yes n | ffmpeg -pattern_type glob -i \''.$dirpath.'*.png\' -c:v libx264 -vf "fps=25,format=yuv420p" -pix_fmt yuv420p -vf "pad=ceil\(iw/2\)*2:ceil\(ih/2\)*2" '.$dirpath.'out.mp4';
		#print "$cmd\n";
		#exit 0;
		system($cmd);
	}
}
