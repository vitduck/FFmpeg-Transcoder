package FFmpeg::x264; 

use Moose::Role; 
use MooseX::Types::Moose qw( Str Int ); 
use FFmpeg::Types qw( Profile Preset Tune ); 

use namespace::autoclean; 

requires qw( _build_filter ); 

has 'profile', ( 
    is       => 'ro', 
    isa      => Profile, 
    lazy     => 1, 
    default  => 'main', 
); 

has 'preset', ( 
    is       => 'ro',
    isa      => Preset,  
    lazy     => 1, 
    default  => 'fast', 
); 

has 'tune', ( 
    is       => 'ro', 
    isa      => Tune, 
    lazy     => 1, 
    default  => 'film', 
); 

has 'crf', ( 
    is       => 'ro', 
    isa      => Int, 
    lazy     => 1, 
    default  => '25', 
); 

has 'filter', ( 
    is       => 'ro', 
    isa      => Str, 
    lazy     => 1, 
    init_arg => undef, 
    builder  => '_build_filter', 
); 

1
