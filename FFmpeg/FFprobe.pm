package FFmpeg::FFprobe; 

use autodie; 
use strict; 
use warnings FATAL => 'all'; 
use namespace::autoclean; 

use Moose::Role; 
use MooseX::Types::Moose qw( HashRef ); 

use experimental qw( signatures smartmatch ); 

has 'ffprobe', ( 
    is       => 'ro', 
    isa      => HashRef, 
    traits   => ['Hash'], 
    lazy     => 1, 
    init_arg => undef, 

    default  => sub ( $self ) { 
        my $ffprobe = { }; 

        open my $pipe, "-|", "ffprobe ${\$self->input} 2>&1"; 
        while ( <$pipe> ) {  
            # video stream, width and height  
            if ( /Stream #(\d:\d)(\(.+?\))?: Video:.+?(?<width>\d{3,})x(?<height>\d{3,})/ ) { 
                $ffprobe->{video}{$1}->@{qw/width height/} = ( $+{width}, $+{height} ); 
            } 

            # audio/subtitle stream
            if ( /Stream #(\d:\d)(?:\((.+?)\))?: (?<stream>audio|subtitle)/i ) {  
                my ( $id, $lang ) = ( $1, $2); 
                my $stream         = $+{stream};  
            
                # default lang 
                $lang //= 'eng'; 

                $ffprobe->{lc($stream)}{$id} = $lang; 
            } 
        }            

        close $pipe; 

        return $ffprobe; 
    },  

    handles   => { 
        probe        => 'get', 
        has_subtitle => [ exists => 'subtitle' ]
    }
); 

1; 
