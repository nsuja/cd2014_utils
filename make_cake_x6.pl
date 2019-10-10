#!/usr/bin/perl
#ffmpeg
#	-i 1.avi -i 2.avi -i 3.avi -i 4.avi
#		-filter_complex "
#				nullsrc=size=640x480 [base];
#						[0:v] setpts=PTS-STARTPTS, scale=320x240 [upperleft];
#								[1:v] setpts=PTS-STARTPTS, scale=320x240 [upperright];
#										[2:v] setpts=PTS-STARTPTS, scale=320x240 [lowerleft];
#												[3:v] setpts=PTS-STARTPTS, scale=320x240 [lowerright];
#														[base][upperleft] overlay=shortest=1 [tmp1];
#																[tmp1][upperright] overlay=shortest=1:x=320 [tmp2];
#																		[tmp2][lowerleft] overlay=shortest=1:y=240 [tmp3];
#																				[tmp3][lowerright] overlay=shortest=1:x=320:y=240
#																					"
#																						-c:v libx264 output.mkv

$algo1="SuBSENSE"; #Best overall
$algo2="PAWCS";
$algo3="IUTIS_5";
$algo4="WisenetMD";


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
			$dirpath = "$dirname/$key/$key2/input/";
			print "key1 $key key2 $key2\n";
			$video0 = "$dirname/$key/$key2/input/out.mp4";
			$video1 = "$dirname/$key/$key2/groundtruth/out.mp4";
			$video2 = "results/".$algo1."_result/$key/$key2/out.mp4";
			$video3 = "results/".$algo2."_result/$key/$key2/out.mp4";
			$video4 = "results/".$algo3."_result/$key/$key2/out.mp4";
			$video5 = "results/".$algo4."_result/$key/$key2/out.mp4";
			$cmd = "yes | ffmpeg -i $video0 -i $video1 -i $video2 -i $video3 -i $video4 -i $video5 -filter_complex \" nullsrc=size=720x480 [base]; [0:v] setpts=PTS-STARTPTS, scale=240x240 [upperleft]; [1:v] setpts=PTS-STARTPTS, scale=240x240 [uppermiddle]; [2:v] setpts=PTS-STARTPTS, scale=240x240 [upperright]; [3:v] setpts=PTS-STARTPTS, scale=240x240 [lowerleft]; [4:v] setpts=PTS-STARTPTS, scale=240x240 [lowermiddle]; [5:v] setpts=PTS-STARTPTS, scale=240x240 [lowerright]; [base][upperleft] overlay=shortest=1 [tmp1]; [tmp1][uppermiddle] overlay=shortest=1:x=240 [tmp2]; [tmp2][upperright] overlay=shortest=1:x=480 [tmp3]; [tmp3][lowerleft] overlay=shortest=1:y=240 [tmp4]; [tmp4][lowermiddle] overlay=shortest=1:x=240:y=240 [tmp5]; [tmp5][lowerright] overlay=shortest=1:x=480:y=240  \" -c:v libx264 $dirpath/torta.mp4";
			print "$cmd\n";
			system($cmd);
	}
}
