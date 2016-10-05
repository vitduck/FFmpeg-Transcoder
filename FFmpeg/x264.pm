package FFmpeg::x264; 

use Moose::Role; 
use MooseX::Types::Moose qw( Str ); 
use namespace::autoclean; 
use experimental qw( signatures ); 

has 'filter', ( 
    is        => 'ro', 
    isa       => Str, 
    lazy      => 1, 
    init_arg  => undef, 
    default   => sub ( $self ) { 
        my $scale_filter = "scale=${ \$self->scaled_width }x${ \$self->scaled_height }"; 
        my $ass_filter   = "ass=${ \$self->ass }"; 
        
        return  
            $self->has_subtitle 
            ? join( ',', $scale_filter, $ass_filter ) 
            : $scale_filter 
    } 
); 

1
