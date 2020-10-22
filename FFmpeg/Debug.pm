package FFmpeg::Debug; 

use Moose::Role; 
use MooseX::Types::Moose 'Bool'; 
use Data::Printer { 
    class => {
        internals    => 1,
        parents      => 0,
        expand       => 2,
        show_methods => 'none' 
    }, 
    scalar_quotes => '' 
};

use experimental 'signatures'; 

has 'debug' => ( 
    is        => 'rw', 
    isa       => Bool, 
    lazy      => 1, 
    default   => 0
); 

sub show_debug ( $self ) {  
    p $self;  

    exit
} 

1
