#!/usr/bin/env perl 

use strict; 
use warnings; 

use Getopt::Long; 
use Pod::Usage; 
use FFmpeg::Transcoder; 

# POD 
my @usages = qw( NAME SYSNOPSIS OPTIONS );  

=head1 NAME 

transcoder.pl -- ffmpeg wrapper for x264 transcoding 

=head1 SYNOPSIS

transcoder.pl -s 304 -f 'PF Armonia' -t animation --preset fast <files>

=head1 OPTIONS

=over 24

=item B<-h, --help>

Print the help message and exit.

=item B<-s, --scaled_height> 

Rescaled height ( default: 304 ) 

=item B<-f, --font_name> 

Subtitle's font

=item B<-t, --tune> 

x264 tune ( default: film  )

=item B<-c, --crt>

x264 crt ( default: 25 ) 

=item B<--profile>

x264 profile ( default: main ) 

=item B<--preset>

x264 preset ( default: fast )

=back 

=cut

# parse @ARGV
GetOptions(
    \ my %option, 
    'help', 'scaled_height=i', 'font_name=s', 'tune=s', 'profile=s', 'preset=s', 'crt=i'
) or pod2usage(-verbose => 1); 

# help message 
if ( exists $option{help} ) { pod2usage(-verbose => 99, -section => \@usages) }  

my @fo = map { FFmpeg::Transcoder->new( input => $_, %option ) } @ARGV; 

for my $ffmpeg ( @fo ) { 
    $ffmpeg->transcode; 
    $ffmpeg->clean_sub; 
} 
