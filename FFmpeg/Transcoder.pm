package FFmpeg::Transcoder; 

use Moose; 
use MooseX::Types::Moose qw( Str Int ); 
use File::Basename;

use strictures 2; 
use namespace::autoclean; 
use experimental qw/signatures/; 

with qw( FFmpeg::FFprobe FFmpeg::Select ),  
     qw( FFmpeg::Video FFmpeg::Audio FFmpeg::Subtitle FFmpeg::Font ),  
     qw( FFmpeg::x264 );  

has 'input', (
    is       => 'ro', 
    isa      => Str,   
    required => 1, 
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
    if ( $self->has_subtitle ) {  
        $self->extract_sub 
    }
} 

__PACKAGE__->meta->make_immutable;

1; 
