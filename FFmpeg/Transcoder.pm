package FFmpeg::Transcoder; 

use Moose; 
use File::Basename;
use namespace::autoclean; 
use experimental qw( signatures smartmatch );  

with qw( 
    FFmpeg::FFprobe 
    FFmpeg::Video FFmpeg::x264
    FFmpeg::Audio 
    FFmpeg::Subtitle 
);  

has 'input', (
    is       => 'ro', 
    isa      => 'Str',   
    required => 1, 
); 

has 'output', ( 
    is       => 'ro', 
    isa      => 'Str', 
    lazy     => 1, 
    init_arg => undef, 
    builder  => '_build_output' 
); 

has 'help', ( 
    is       => 'ro', 
    isa      => 'Int', 
    lazy     => 1, 
    default  => 0 
); 

sub BUILD ( $self, @ ) { 
    printf "\n=> File: %s\n", $self->input; 

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

sub extract_sub ( $self ) { 
    system 
        'ffmpeg', 
        '-y', '-loglevel', 'fatal', 
        '-i', $self->input, 
        '-map', $self->subtitle_id, 
        $self->ass; 
} 

sub clean_sub ( $self ) { 
    unlink $self->ass if $self->has_subtitle;  
} 

sub modify_sub ( $self ) { 
    return if not $self->has_subtitle; 
    
    # inplace editting 
    local ( $^I, @ARGV ) = ( '~', $self->ass ); 
    while ( <<>> ) { 
        # removign annoying ^M 
        s/\r//g; 

        # remove intrinsic res and replaced with scaled one
        s/PlayResX.+?(?<ResX>\d+)/PlayResX: ${\$self->scaled_width}/; 
        s/PlayResY.+?(?<ResY>\d+)/PlayResY: ${\$self->scaled_height}/; 

        if ( /^Style: (?<style>.+?),(?<font_name>.+?),(?<font_size>.+?),(?<properties>.*)$/ ) { 
            my $font_style = $+{style}; 
            my $properties = $+{properties}; 
            my $font_size  = int($self->scaled_height * $+{font_size} / $self->get_video_height);  
            
            # rescaled the font 
            $font_size = 
                $font_size < $self->min_font_size ? 
                $self->min_font_size : 
                $font_size > $self->max_font_size ? 
                $self->max_font_size : 
                $font_size; 

            # replace font 
            s/^Style.*$/Style: $font_style,${\$self->font_name},$font_size,$properties/; 

            # lower the vmargin (the next to last number in style definition )
            s/^(Style:.+?),(\d+),(\d+)$/$1,10,$2/; 
        }
        # write to file 
        print; 
    }  
    # remove backup subtitle 
    unlink ${\$self->ass}.$^I; 
} 

sub select_id ( $self, $header, $stream ) {  
    my @ids = sort keys $stream->%*; 

    # short-circuit
    return shift @ids if @ids == 1; 
    
    printf "-> %s:\n", $header;  
    while (1) { 
        # list of stream id 
        for my $id ( @ids ) { 
            printf "[%s]\t%s\n", $id, $stream->{$id}
        } 
        # prompt user for selection  
        print "-> "; 
        chomp ( my $choice = <STDIN> ); 
       
        return $choice if $choice ~~ @ids 
    } 
} 

sub _build_output ( $self ) { 
    return basename( $self->input ) =~ s/(.*)\..+?$/$1.mkv/r 
}  

sub _build_video ( $self ) { 
    return $self->probe( 'video' ) 
} 

sub _build_video_id  ( $self ) { 
    return ( $self->get_video_ids )[0] 
} 

sub _build_video_size ( $self ) { 
    return $self->get_video_size( $self->video_id ) 
} 

sub _build_audio ( $self ) { 
    return $self->probe( 'audio' ) 
}

sub _build_audio_id ( $self ) { 
    return $self->select_id( Audio => $self->audio ) 
} 

sub _build_subtitle ( $self ) {
    return $self->probe( 'subtitle' ) 
}

sub _build_subtitle_id ( $self ) { 
    return $self->select_id( Subtitle => $self->subtitle) 
}

sub _build_ass ( $self ) { 
    return basename( $self->input ) =~ s/(.*)\..+?$/$1.ass/r 
} 

sub _build_scaled_width ( $self ) { 
    my $width  = $self->get_video_width; 
    my $height = $self->get_video_height; 

    return 16 * int( $self->scaled_height * $width / $height / 16 ) 
} 

sub _build_filter ( $self ) { 
    my $scale_filter = "scale=${\$self->scaled_width}x${\$self->scaled_height}"; 
    my $ass_filter   = "ass=${\$self->ass}"; 

    return ( 
        $self->has_subtitle ? 
        join(',', $scale_filter, $ass_filter) : 
        $scale_filter 
    )
} 

__PACKAGE__->meta->make_immutable;

1
