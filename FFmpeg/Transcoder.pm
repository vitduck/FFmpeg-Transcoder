package FFmpeg::Transcoder; 

use strict; 
use warnings FATAL => 'all'; 
use namespace::autoclean; 

use Moose; 
use MooseX::Types::Moose qw( Str Int ); 
use File::Basename;

use experimental qw/signatures/; 

with qw( FFmpeg::FFprobe FFmpeg::Select ),  
     qw( FFmpeg::Video FFmpeg::Audio FFmpeg::Subtitle FFmpeg::Font ),  
     qw( FFmpeg::x264 );  

has 'input', (
    is       => 'ro', 
    isa      => Str,   
    required => 1, 

    trigger  => sub ( $self, @args ) { 
        printf "\n-> File: %s\n", $self->input 
    } 
); 

has 'output', ( 
    is       => 'ro', 
    isa      => Str, 
    lazy     => 1, 
    init_arg => undef, 
    
    default  => sub ( $self ) { 
        return basename($self->input) =~ s/(.*)\..+?$/$1.mkv/r 
    },  
); 

sub transcode ( $self ) { 
    system 
        'ffmpeg', 
        '-stats', '-y', '-threads', 0, 
        '-i', $self->input,  
        '-map', $self->video_id, '-c:v', 'libx264', 
        '-profile:v', $self->profile, '-preset', $self->preset, '-tune', $self->tune, 
        '-crf', $self->crf,
        '-map', $self->audio_id, '-c:a', 'libfdk_aac', '-b:a', '128K', 
        '-vf', $self->filter, 
        $self->output; 
} 

sub BUILD ( $self, @args ) { 
    $self->video_id;  
    $self->audio_id; 

    if ( $self->has_subtitle ) { 
        $self->subtitle_id; 
        $self->extract_sub; 
        $self->modify_sub
    }
} 

__PACKAGE__->meta->make_immutable;

1
