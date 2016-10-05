#!/usr/bin/env perl 

use strict; 
use warnings; 

use FFmpeg::Transcoder; 

my $ffmpeg = FFmpeg::Transcoder->new_with_options; 

$ffmpeg->getopt_usage( exit => 1 ) if @ARGV == 0; 

$ffmpeg->transcode; 
$ffmpeg->clean_sub; 
