#!/usr/bin/env perl 

use strict; 
use warnings FATAL => 'all'; 

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

Height of transcoded file 

=item B<-f, --font_name> 

Font name for hardcoded subtititle

=item B<-t, --tune> 

x264 tune ( film, animation, etc )

=item B<-c, --crt>

x264 crt 

=item B<--profile>

x264 profile ( baseline, main, hight, etc ) 

=item B<--preset>

x264 preset ( fast, medium, slow, etc )

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
