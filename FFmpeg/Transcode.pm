package FFmpeg::Transcode; 

# core 
use File::Basename;

# cpan
use Moose; 
use namespace::autoclean; 

# pragma
use autodie; 
use warnings FATAL => 'all'; 
use experimental qw(signatures); 

# Moose roles 
with 'FFmpeg::FFprobe', 
     'FFmpeg::Video', 
     'FFmpeg::Audio', 
     'FFmpeg::Subtitle', 
     'FFmpeg::x264'; 

# Moose attributes 
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
    
    default  => sub ( $self ) { 
        return my $output = basename($self->input) =~ s/(.*)\..+?$/$1.mkv/r; 
    },  
); 

has 'scaled_height', ( 
    is       => 'ro', 
    isa      => 'Int', 
    required => 1, 
); 

has 'scaled_width', ( 
    is       => 'ro', 
    isa      => 'Int', 
    lazy     => 1, 
    init_arg => undef, 

    # Error: not divisible by 2 (!?)
    default  => sub ( $self ) { 
        return 16 * int($self->scaled_height * $self->width / $self->height / 16);   
    },  
); 

has 'font_name', ( 
    is       => 'ro', 
    isa      => 'Str', 
    required => 1, 
); 

has 'min_font_size', ( 
    is       => 'ro', 
    isa      => 'Int', 
    init_arg => undef,
    default  => 28, 
); 

has 'max_font_size',  ( 
    is       => 'ro', 
    isa      => 'Int', 
    init_arg => undef,
    default  => 36, 
); 

has 'x264', ( 
    is       => 'ro', 
    isa      => 'Str', 
    lazy     => 1, 
    init_arg => undef, 

    default  => sub ( $self ) { 
        return "-c:v libx264 -profile:v ${\$self->profile} -preset ${\$self->preset} -tune ${\$self->tune} -crf ${\$self->crf}"; 
    }, 
); 

has 'faac', ( 
    is       => 'ro', 
    isa      => 'Str', 
    lazy     => 1, 
    init_arg => undef, 

    default  => '-c:a libfdk_aac -b:a 128K'
); 

has 'filter', ( 
    is       => 'ro', 
    isa      => 'Str', 
    lazy     => 1, 
    init_arg => undef, 

    default  => sub ( $self ) { 
        my $scale_filter = "scale=${\$self->scaled_width}x${\$self->scaled_height}"; 
        my $ass_filter   = "ass=${\$self->ass}"; 
        return $self->has_subtitle ? join(',', $scale_filter, $ass_filter) : $scale_filter; 
    } 
); 

# Moose methods 
sub modify_sub ( $self ) { 
    if ( not $self->has_subtitle ) { return } 
    
    # inplace editting 
    local ( $^I, @ARGV ) = ( '~', $self->ass ); 

    # parse ass file 
    while ( <<>> ) { 
        # removign annoying ^M 
        s/\r//g; 

        # remove intrinsic res and replaced with scaled one
        s/PlayResX.+?(?<ResX>\d+)/PlayResX: ${\$self->scaled_width}/; 
        s/PlayResY.+?(?<ResY>\d+)/PlayResY: ${\$self->scaled_height}/; 

        # rescaled the font 
        if ( /^Style: (?<style>.+?),(?<font_name>.+?),(?<font_size>.+?),(?<properties>.*)$/ ) { 
            my $font_style = $+{style}; 
            my $properties = $+{properties}; 

            # fontsize 
            my $font_size  = int($self->scaled_height * $+{font_size} / $self->height);  
            $font_size = $font_size < $self->min_font_size ? 
                         $self->min_font_size : 
                         $font_size > $self->max_font_size ? 
                         $self->max_font_size : 
                         $font_size; 

            # replace font 
            s/^Style.*$/Style: $font_style,${\$self->font_name},$font_size,$properties/; 
        }

        # write to file 
        print; 
    }  

    # remove backup subtitle 
    unlink ${\$self->ass}.$^I; 
} 

sub transcode ( $self ) { 
    my $opts = "-stats -y -threads 0"; 
    my $video_opt  = "-map ${\$self->video_id} ${\$self->x264}"; 
    my $audio_opt  = "-map ${\$self->audio_id} ${\$self->faac}";  
    my $filter_opt = "-vf ${\$self->filter}"; 

    system "ffmpeg $opts -i ${\$self->input} $video_opt $audio_opt $filter_opt ${\$self->output}"; 
}

sub clean ( $self ) { 
    if ( $self->has_subtitle ) { 
        unlink $self->ass; 
    }
} 

sub BUILD ( $self, @args ) { 
    $self->ffprobe; 
    $self->video_id; 
    $self->audio_id; 
    $self->sub_id; 

    if ( $self->has_subtitle ) { 
        $self->extract_sub; 
        $self->modify_sub; 
    } 
} 

# speed-up object construction 
__PACKAGE__->meta->make_immutable;

1; 
