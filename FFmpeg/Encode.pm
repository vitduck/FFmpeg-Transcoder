package FFmpeg::Encode; 

# cpan
use Moose; 
use namespace::autoclean; 

# pragma
use autodie; 
use warnings FATAL => 'all'; 
use experimental qw(signatures); 

with 'FFmpeg::FFprobe', 
     'FFmpeg::Video', 
     'FFmpeg::Audio', 
     'FFmpeg::Subtitle'; 

has 'name', (
    is       => 'ro', 
    isa      => 'Str', 
    required => 1, 
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

    default  => sub ( $self ) { 
        return int($self->scaled_height * $self->width / $self->height);   
    },  
); 

has 'font_name', ( 
    is       => 'ro', 
    isa      => 'Str', 
    required => 1, 
); 

sub modify_sub ( $self ) { 
    if ( not $self->has_sub ) { return } 
    
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
            my $font_size  = Int($self->scaled_height * $+{font_size} / $self->height);  

            # replace font 
            s/^Style.*$/Style: $font_style,${\$self->font_name},$font_size,$properties/; 
        }

        # write to file 
        print; 
    }  

    # remove backup subtitle 
    unlink ${\$self->ass}.$^I; 
} 

sub BUILD ( $self, @args ) { 
    $self->ffprobe; 
} 

# speed-up object construction 
__PACKAGE__->meta->make_immutable;

1; 
