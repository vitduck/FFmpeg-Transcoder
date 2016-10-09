package FFmpeg::Subtitle; 

use Moose::Role;  
use MooseX::Types::Moose qw( Str Int HashRef );
use File::Basename; 
use namespace::autoclean; 
use experimental qw( signatures );  

requires qw( has_subtitle _build_subtitle _select_id );  

has 'subtitle', ( 
    is        => 'ro', 
    isa       => HashRef, 
    traits    => [ 'Hash' ], 
    lazy      => 1, 
    init_arg  => undef, 
    default   => sub { $_[0]->_build_subtitle }, 
);   

has 'subtitle_id', ( 
    is        => 'ro', 
    isa       => Str, 
    lazy      => 1, 
    init_arg  => undef, 
    reader    => 'get_subtitle_id', 
    default   => sub { $_[0]->_select_id( 'subtitle' ) }, 
);   

has 'min_font_size', ( 
    is        => 'ro', 
    isa       => Int, 
    lazy      => 1, 
    init_arg  => undef,
    reader    => 'get_min_font_size', 
    default   => 24, 
); 

has 'max_font_size',  ( 
    is        => 'ro', 
    isa       => Int, 
    lazy      => 1, 
    init_arg  => undef,
    reader    => 'get_max_font_size', 
    default   => 28, 
); 

has 'ass', ( 
    is        => 'ro', 
    isa       => Str, 
    lazy      => 1, 
    init_arg  => undef, 
    reader    => 'get_ass', 
    default   => sub { basename( $_[0]->get_input ) =~ s/(.*)\..+?$/$1.ass/r }
); 

sub modify_sub ( $self ) { 
    return if not $self->has_subtitle; 
    
    # inplace editting 
    local ( $^I, @ARGV ) = ( '~', $self->get_ass ); 

    while ( <<>> ) { 
        # removign annoying ^M 
        s/\r//g; 

        # remove intrinsic res and replaced with scaled one
        s/PlayResX.+?(?<ResX>\d+)/PlayResX: ${ \$self->get_scaled_width }/; 
        s/PlayResY.+?(?<ResY>\d+)/PlayResY: ${ \$self->get_scaled_height }/; 

        if ( /^Style: (?<style>.+?),(?<font_name>.+?),(?<font_size>.+?),(?<properties>.*)$/ ) { 
            my $font_style = $+{ style }; 
            my $properties = $+{ properties }; 

            # font rescaling 
            my $font_size = int( 
                $self->get_scaled_height * $+{ font_size } / $self->get_video_height 
            );  
           
            # adjust based on min, max_font_size
            $font_size = ( 
                $font_size < $self->get_min_font_size ? $self->get_min_font_size : 
                $font_size > $self->get_max_font_size ? $self->get_max_font_size : 
                $font_size
            ); 

            # replace with default font 
            s/^Style.*$/Style: $font_style,${ \$self->get_font_name },$font_size,$properties/; 

            # lower the vmargin (the next to last number in style definition )
            s/^(Style:.+?),(\d+),(\d+)$/$1,10,$2/; 
        }

        # write to file 
        print; 
    }  

    # remove backup subtitle 
    unlink ${ \$self->get_ass }.$^I; 
} 

sub clean_sub ( $self ) { 
    unlink $self->get_ass if $self->has_subtitle 
} 

1  
