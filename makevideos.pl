#!/usr/bin/perl
#
#ffmpeg -pattern_type glob -i '*.png' -c:v libx264 -vf "fps=25,format=yuv420p" out.mp4
#
$dstfile = "/tmp/results.tar.bz2";
$auxdir = "/tmp/results_aux/";
$dirname="../results";
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
	foreach $key2 (@files2) { #Estoy en el subdir del algoritmo, me tengo que meter en los casos
		next if($key2 eq "." || $key2 eq "..");
		next if(! -d "$dirname/$key/$key2");
		print "$key2\n";
		opendir(DIR3, "$dirname/$key/$key2");
		@files3 = readdir(DIR3);
		closedir DIR3;
		foreach $key3 (@files3) { #Estoy en el subdir del casos, me meto en cada video
			next if($key3 eq "." || $key3 eq "..");
			next if(! -d "$dirname/$key/$key2/$key3");
			print "$dirname/$key/$key2/$key3\n";
			next if ($key3 ne "wetSnow");
			$dirpath = "$dirname/$key/$key2/$key3/boundingbox/";
			$cmd='yes n | ffmpeg -pattern_type glob -i \''.$dirpath.'*.png\' -c:v libx264 -vf "fps=25,format=yuv420p" -pix_fmt yuv420p -vf "pad=ceil\(iw/2\)*2:ceil\(ih/2\)*2" '.$dirpath.'out.mp4';
			print $cmd;
			system($cmd);
		}
	}
}
