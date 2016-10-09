package FFmpeg::Transcoder; 

use Moose; 
use MooseX::Types::Moose qw( Str ); 
use File::Basename; 
use namespace::autoclean; 
use experimental qw( signatures smartmatch );  

extends qw( FFmpeg::Getopt );  

with qw( FFmpeg::Prompt FFmpeg::FFprobe );  
with qw( FFmpeg::Video FFmpeg::Audio );  
with qw( FFmpeg::Subtitle );  
with qw( FFmpeg::Filter );  

has 'output', ( 
    is        => 'ro', 
    isa       => Str, 
    lazy      => 1, 
    init_arg  => undef, 
    reader    => 'get_output', 
    default   => sub { basename( $_[0]->get_input ) =~ s/(.*)\..+?$/$1.mkv/r }
); 

sub BUILD ( $self, @ ) { 
    # cache output ffrobe
    $self->ffprobe; 

    # subtitle
    if ( $self->has_subtitle ) { 
        $self->extract_sub; 
        $self->modify_sub
    }
} 

sub transcode ( $self ) { 
    system 
        'ffmpeg', 
        '-stats', '-y', '-threads', 0, 
        '-i', $self->get_input, 
        '-map', $self->get_video_id, '-c:v', 'libx264', 
        '-profile:v', $self->get_profile, '-preset', $self->get_preset, 
        '-tune', $self->get_tune, '-crf', $self->get_crf,
        '-map', $self->get_audio_id, '-c:a', 'libfdk_aac', '-b:a', '128K', 
        '-vf', $self->get_filter, 
        $self->get_output; 
} 

sub extract_sub ( $self ) { 
    system 
        'ffmpeg', 
        '-y', '-loglevel', 'fatal', 
        '-i', $self->get_input, 
        '-map', $self->get_subtitle_id, 
        $self->get_ass; 
} 

__PACKAGE__->meta->make_immutable;

1
