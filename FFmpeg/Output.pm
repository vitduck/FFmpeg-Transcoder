package FFmpeg::Output; 

use Moose::Role;  
use MooseX::Types::Moose qw( Str ); 
use File::Basename; 

use namespace::autoclean; 
use experimental qw( signatures );  

has container => ( 
    is        => 'rw', 
    isa       => Str, 
    predicate => '_has_container',
    default   => 'mp4'
); 

has outdir => ( 
    is        => 'rw', 
    isa       => Str,
    predicate => '_has_output_dir', 
    default   => 'outdir',  
); 

has outfile => ( 
    is        => 'rw', 
    isa       => Str, 
    predicate => '_has_outfile', 
    lazy      => 1, 
    default   => sub ( $self ) { 
        join( 
            '/', 
            $self->outdir, 
            basename((split' ', $self->input)[1]) =~ s/(.*)\.(.+?)$/$1.${\$self->container}/r 
        )
    } 
); 

1
