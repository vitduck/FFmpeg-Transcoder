#!/usr/bin/env perl 

use strict; 
use warnings; 

use Data::Printer { class => {
                        internals    => 1,
                        parents      => 0,
                        expand       => 2,
                        show_methods => 'none' }, 
                    scalar_quotes => '' };

use FFmpeg::Transcoder;

my $job = FFmpeg::Transcoder->new_with_options(); 

$job->getopt_usage( exit => 1 ) if @ARGV == 0;

$job->run; 
