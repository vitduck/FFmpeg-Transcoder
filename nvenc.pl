#!/usr/bin/env perl 

use strict; 
use warnings; 

use FFmpeg::Transcoder;

my $job = FFmpeg::Transcoder->new_with_options(); 

$job->getopt_usage( exit => 1 ) if @ARGV == 0;

$job->show_debug if $job->debug; 
$job->run; 
