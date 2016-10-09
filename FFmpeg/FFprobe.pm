package FFmpeg::FFprobe; 

use Moose::Role; 
use MooseX::Types::Moose qw( HashRef );  
use autodie; 
use namespace::autoclean; 
use experimental qw( signatures smartmatch ); 

requires qw( get_input );  

has 'ffprobe', ( 
    is        => 'ro', 
    isa       => HashRef, 
    traits    => [ 'Hash' ], 
    lazy      => 1, 
    init_arg  => undef, 
    builder   => '_build_ffprobe', 
    handles   => { 
        _build_audio    => [ get    => 'audio'    ], 
        _build_video    => [ get    => 'video'    ], 
        _build_subtitle => [ get    => 'subtitle' ], 
        has_subtitle    => [ exists => 'subtitle' ]
    }
); 

sub _build_ffprobe ( $self ) { 
    my %ffprobe = ();  

    # redirect STDERR to STDOUT ? 
    open my $pipe, "-|", "ffprobe ${ \$self->get_input } 2>&1"; 

    while ( <$pipe> ) {  
        # video stream, width and height  
        if ( /Stream #(\d:\d)(\(.+?\))?: Video:.+?(?<width>\d{3,})x(?<height>\d{3,})/ ) { 
            $ffprobe{ video }{ $1 }->@{ qw( width height) } = ( $+{ width }, $+{ height } ); 
        } 

        # audio/subtitle stream
        if ( /Stream #(\d:\d)(?:\((.+?)\))?: (?<stream>audio|subtitle)/i ) {  
            my ( $id, $lang ) = ( $1, $2 ); 
            my $stream        = $+{ stream } ;  
            
            # set default lang 
            $lang //= 'eng'; 

            $ffprobe{ lc( $stream ) }{ $id } = $lang; 
        } 
    }            

    close $pipe; 

    return \%ffprobe; 
} 

1 
