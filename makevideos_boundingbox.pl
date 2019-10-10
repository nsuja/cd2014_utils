#!/usr/bin/perl
#
#ffmpeg -pattern_type glob -i '*.png' -c:v libx264 -vf "fps=25,format=yuv420p" out.mp4
#
#/home/ubuntu/datasets/CD2014/results/PAWCS_result/badWeather/wetSnow//boundingbox
#
use File::Copy;
use File::Path qw(mkpath);

$dstfile = "/tmp/results.tar.bz2";
$auxdir = "/tmp/results_aux/";
$dirname="./results/PAWCS_result/";
opendir(DIR, $dirname);
@files = readdir(DIR);
closedir DIR;
system("rm -rf $auxdir");
mkdir $auxdir;
foreach $key (@files) {
	next if($key eq "." || $key eq "..");
	next if(! -d "$dirname/$key");
	#print "$key\n";
	opendir(DIR2, "$dirname/$key");
	@files2 = readdir(DIR2);
	closedir DIR2;
	foreach $key2 (@files2) { #Estoy en el subdir del algoritmo, me tengo que meter en los casos
		next if($key2 eq "." || $key2 eq "..");
		next if(! -d "$dirname/$key/$key2");
		#print "$key2\n";
		opendir(DIR3, "$dirname/$key/$key2");
		@files3 = readdir(DIR3);
		closedir DIR3;

		$dirpath = "$dirname/$key/$key2/boundingbox/";
		next if(! -d $dirpath);
		#print "$dirpath\n";
		$cmd='ffmpeg -y -pattern_type glob -i \''.$dirpath.'*.png\' -c:v libx264 -vf "fps=25,format=yuv420p" '.$dirpath.'out.mp4';
		#'./dataset/turbulence/turbulence3/input/yolo/*.jpg'
		print $cmd;
		system($cmd);
#
		mkpath($auxdir.$key."/".$key2);
		copy($dirpath.'out.mp4', $auxdir.$key."/".$key2);
	}
}
my $filename = $auxdir.'/algorithm.txt';
open(my $fh, '>', $filename) or die "Could not open file '$filename' $!";
print $fh "$dirname\n";
close $fh;
print "Done\n";
