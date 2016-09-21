package FFmpeg::Transcoder; 

use File::Basename;
use Moose; 
use namespace::autoclean; 
use experimental qw/signatures/; 

with qw/FFmpeg::FFprobe FFmpeg::x264 FFmpeg::Audio FFmpeg::Subtitle/; 

has 'input', (
    is       => 'ro', 
    isa      => 'Str',   
    required => 1, 
    trigger  => \&_print_input
); 

has 'help', ( 
    is       => 'ro', 
    isa      => 'Int', 
    lazy     => 1, 
    default  => 0 
); 

has 'output', ( 
    is       => 'ro', 
    isa      => 'Str', 
    lazy     => 1, 
    init_arg => undef, 
    builder  => '_build_output' 
); 

sub BUILD ( $self, @ ) { 
    $self->video_id;  
    $self->audio_id; 

    if ( $self->has_subtitle ) { 
        $self->subtitle_id; 
        $self->extract_sub; 
        $self->modify_sub
    }
} 

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

sub _print_input ( $self, @ ) { 
    printf "\n-> File: %s\n", $self->input 
} 

sub _build_output ( $self ) { 
    return basename( $self->input ) =~ s/(.*)\..+?$/$1.mkv/r 
}  

__PACKAGE__->meta->make_immutable;

1
