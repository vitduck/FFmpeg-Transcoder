package FFmpeg::Filter; 

use Moose::Role; 
use MooseX::Types::Moose qw( Str );  
use namespace::autoclean; 
use experimental qw( signatures ); 

requires qw( get_scaled_width get_scaled_height get_ass );  

has 'filter', ( 
    is        => 'ro', 
    isa       => Str, 
    lazy      => 1, 
    init_arg  => undef, 
    reader    => 'get_filter',
    builder   => '_build_filter'
); 

sub _build_filter ( $self ) { 
    my $width    = $self->get_scaled_width; 
    my $height   = $self->get_scaled_height; 
    my $subtitle = $self->get_ass; 

    # filter 
    my $scale_filter = "scale=${width}x${height}"; 
    my $ass_filter   = "ass=$subtitle"; 

    return  
        $self->has_subtitle 
        ? join( ',', $scale_filter, $ass_filter ) 
        : $scale_filter 

} 

1
