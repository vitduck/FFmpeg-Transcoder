package FFmpeg::Output; 

use Moose::Role;  
use MooseX::Types::Moose 'Str'; 
use File::Basename; 

use namespace::autoclean; 
use experimental 'signatures';  

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
        my $format  = $self->container; 
        my $input   = basename( ( split' ', $self->input )[1] ); 
        my $outfile = $input =~ s/(.*)\.(.+?)$/$1.$format/r; 

        return join( '/', $self->outdir, $outfile ); 
    } 
); 

1
