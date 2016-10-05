package FFmpeg::Transcoder; 

use Moose; 
use MooseX::Types::Moose qw( Str Int ); 
use FFmpeg::Types qw( Profile Preset Tune ); 
use File::Basename;
use namespace::autoclean; 
use experimental qw( signatures smartmatch );  

with qw( MooseX::Getopt::Usage ); 
with qw( FFmpeg::Prompt FFmpeg::FFprobe ); 
with qw( FFmpeg::Video FFmpeg::Audio FFmpeg::Subtitle FFmpeg::x264 ); 

has 'input', (
    is        => 'ro', 
    isa       => Str,   
    required  => 1, 

    documentation => 'Source file' 
); 

has 'scaled_height', ( 
    is        => 'ro', 
    isa       => Int, 
    lazy      => 1, 
    default   => 304, 

    documentation => 'Rescaled height'
); 

has 'font_name', ( 
    is        => 'ro', 
    isa       => Str, 
    lazy      => 1, 
    default   => 'PF Armonia', 

    documentation => 'Font of subtitle'
); 

has 'profile', ( 
    is        => 'ro', 
    isa       => Profile, 
    lazy      => 1, 
    default   => 'main', 
    
    documentation => 'x264 profile'
); 

has 'preset', ( 
    is        => 'ro',
    isa       => Preset,  
    lazy      => 1, 
    default   => 'fast', 
    
    documentation => 'x264 preset'
); 

has 'tune', ( 
    is        => 'ro', 
    isa       => Tune, 
    lazy      => 1, 
    default   => 'film', 
    
    documentation => 'x264 tune'
); 

has 'crf', ( 
    is        => 'ro', 
    isa       => Int, 
    lazy      => 1, 
    default   => '25', 
    
    documentation => 'x264 crt'
); 

has 'output', ( 
    is        => 'ro', 
    isa       => Str, 
    lazy      => 1, 
    init_arg  => undef, 
    default   => sub { basename( shift->input ) =~ s/(.*)\..+?$/$1.mkv/r }
); 

has 'ass', ( 
    is        => 'ro', 
    isa       => Str, 
    lazy      => 1, 
    init_arg  => undef, 
    default   => sub { basename( shift->input ) =~ s/(.*)\..+?$/$1.ass/r }
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
    system 'ffmpeg', 
        '-stats', '-y', '-threads', 0, 
        '-i', $self->input,  
        '-map', $self->video_id, '-c:v', 'libx264', 
        '-profile:v', $self->profile, '-preset', $self->preset, '-tune', $self->tune, 
        '-crf', $self->crf,
        '-map', $self->audio_id, '-c:a', 'libfdk_aac', '-b:a', '128K', 
        '-vf', $self->filter, 
        $self->output; 
} 

sub extract_sub ( $self ) { 
    system 'ffmpeg', 
        '-y', '-loglevel', 'fatal', 
        '-i', $self->input, 
        '-map', $self->subtitle_id, 
        $self->ass; 
} 

sub modify_sub ( $self ) { 
    return if not $self->has_subtitle; 
    
    # inplace editting 
    local ( $^I, @ARGV ) = ( '~', $self->ass ); 

    while ( <<>> ) { 
        # removign annoying ^M 
        s/\r//g; 

        # remove intrinsic res and replaced with scaled one
        s/PlayResX.+?(?<ResX>\d+)/PlayResX: ${ \$self->scaled_width }/; 
        s/PlayResY.+?(?<ResY>\d+)/PlayResY: ${ \$self->scaled_height }/; 

        if ( /^Style: (?<style>.+?),(?<font_name>.+?),(?<font_size>.+?),(?<properties>.*)$/ ) { 
            my $font_style = $+{ style }; 
            my $properties = $+{ properties }; 

            # font rescaling 
            my $font_size  = int( 
                $self->scaled_height * $+{ font_size } / $self->get_video_height 
            );  
            
            $font_size = 
                $font_size < $self->min_font_size ? $self->min_font_size : 
                $font_size > $self->max_font_size ? $self->max_font_size : 
                $font_size; 

            # replace font 
            s/^Style.*$/Style: $font_style,${ \$self->font_name },$font_size,$properties/; 

            # lower the vmargin (the next to last number in style definition )
            s/^(Style:.+?),(\d+),(\d+)$/$1,10,$2/; 
        }

        # write to file 
        print; 
    }  

    # remove backup subtitle 
    unlink ${ \$self->ass }.$^I; 
} 

sub _build_ffprobe ( $self ) { 
    my %ffprobe = ();  

    # redirect STDERR to STDOUT ? 
    open my $pipe, "-|", "ffprobe ${ \$self->input } 2>&1"; 

    while ( <$pipe> ) {  
        # video stream, width and height  
        if ( /Stream #(\d:\d)(\(.+?\))?: Video:.+?(?<width>\d{3,})x(?<height>\d{3,})/ ) { 
            $ffprobe{ video }{ $1 }->@{ qw( width height) } = ( $+{ width }, $+{ height } ); 
        } 

        # audio/subtitle stream
        if ( /Stream #(\d:\d)(?:\((.+?)\))?: (?<stream>audio|subtitle)/i ) {  
            my ( $id, $lang ) = ( $1, $2 ); 
            my $stream        = $+{ stream } ;  
            
            # set default lang 
            $lang //= 'eng'; 

            $ffprobe{ lc( $stream ) }{ $id } = $lang; 
        } 
    }            

    close $pipe; 

    return \%ffprobe; 
} 

__PACKAGE__->meta->make_immutable;

1
