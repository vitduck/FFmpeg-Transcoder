#!/usr/bin/env perl 

use strict; 
use warnings; 

use Data::Printer; 
use Getopt::Long; 
use Parallel::ForkManager;
use Pod::Usage;

use FFmpeg::Transcoder; 

my %queue; 

# options
my $input_dir; 
my @inputs; 
my $outdir   = './outdir';  
my $debug    = 0; 
my $nthread  = 3;  
my @ndevices = $ENV{CUDA_VISIBLE_DEVICES}
               ? split( /,/, $ENV{CUDA_VISIBLE_DEVICES} )
               : (0,1); 

GetOptions( 
    'debug'       => \$debug,
    'nthread=i'   => \$nthread, 
    'outdir=s'    => \$outdir, 
    'input=s{1,}' => \@inputs, 
    'input_dir=s' => sub{ @inputs = <$_[1]/*> } 
);  

if ( @inputs ) { 
    build_queue(); 
    
    if ( $debug ) {
        p %queue; 
        exit 
    } 

    transcode(); 
}

sub build_queue { 
    while ( @inputs ) { 
        for my $gpu ( @ndevices ) { 
            @inputs  
            ? push $queue{$gpu}->@*, 
                FFmpeg::Transcoder->new( 
                    input     => shift @inputs,
                    device    => $gpu, 
                    outdir    => $outdir, 
                    log_level => 0,
                    stats     => 0, 
                    overwrite => 1 
                )->cmd 
            : next
        }
    } 
} 

sub transcode { 
    mkdir $outdir unless -d $outdir;  

    my $ngpus  = keys %queue; 
    my $device = Parallel::ForkManager->new( $ngpus );

    DEVICE:
    for my $gpu ( sort keys %queue ) {
        $device->start and next DEVICE;

        my $ffmpeg = Parallel::ForkManager->new($nthread);

    CUDA:
        for my $cmd ( $queue{$gpu}->@* ) { 
           $ffmpeg->start and next CUDA;  

           system($cmd); 

           $ffmpeg->finish;  
        } 
        $ffmpeg->wait_all_children; 

        $device->finish; 
    }
    $device->wait_all_children; 
}
