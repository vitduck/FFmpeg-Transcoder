package FFmpeg::Subtitle; 

use strict; 
use warnings FATAL => 'all'; 

use Moose::Role;  
use MooseX::Types::Moose qw( Undef Str HashRef ); 
use File::Basename; 

use namespace::autoclean; 
use experimental qw(signatures); 

requires 'select_id'; 

has 'subtitle', ( 
    is       => 'ro', 
    isa      => HashRef, 
    traits   => [ 'Hash' ], 
    lazy     => 1, 
    init_arg => undef, 

    default  => sub ( $self ) { 
        return $self->probe( 'subtitle' )  
    },  

    handles  => { 
        get_subtitle_ids => 'keys' 
    }
);   

has 'subtitle_id', ( 
    is        => 'ro', 
    isa       => Str, 
    lazy      => 1, 
    init_arg  => undef, 

    default  => sub ( $self ) { 
        return $self->select_id( Subtitle => $self->subtitle )
    }
);   

has 'ass', ( 
    is       => 'ro', 
    isa      => Str, 
    lazy     => 1, 
    init_arg => undef, 

    default  => sub ( $self ) { 
        return basename($self->input) =~ s/(.*)\..+?$/$1.ass/r;  
    },  
); 

sub extract_sub ( $self ) { 
    system 
        'ffmpeg', 
        '-y', '-loglevel', 'fatal', 
        '-i', $self->input, 
        '-map', $self->subtitle_id, 
        $self->ass; 
} 

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
            my $font_size  = int($self->scaled_height * $+{font_size} / $self->get_video_height);  
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

sub clean_sub ( $self ) { 
    if ( $self->has_subtitle ) { 
        unlink $self->ass; 
    }
} 

1;  
