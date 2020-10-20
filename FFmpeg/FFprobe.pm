package FFmpeg::FFprobe; 

use Moose::Role; 
use MooseX::Types::Moose qw( HashRef );  
use String::Util 'trim'; 

use FFmpeg::Types qw(Input); 

use namespace::autoclean; 
use experimental qw( signatures smartmatch ); 

has input => (
    is        => 'rw', 
    isa       => Input,   
    predicate => '_has_input',
    coerce   => 1,
); 

has '_ffprobe', ( 
    is        => 'ro', 
    isa       => HashRef, 
    init_arg  => undef, 
    traits    => [ 'Hash' ], 
    lazy      => 1, 
    builder   => '_build_ffprobe', 
    handles   => { 
        decoder => [ get => 'video' ], 
    }
); 

sub _build_ffprobe ( $self ) { 
    my %ffprobe = ();  

    my $input = (split ' ', $self->input)[1]; 

    open my $pipe, "-|", "ffprobe  -hide_banner $input 2>&1"; 

    while ( <$pipe> ) {  
        #print; 

        if ( /Duration: (.+?), start: (.+?), bitrate: (\d+ kb\/s)/ ) { 
            @ffprobe{qw(duration overall_bitrate)} = ($1, $3); 
        }

        # video stream
        if ( /Stream #\d:\d.+?Video:(.*)/ ) { 
            @ffprobe{qw(video pix_fmt resolution video_bitrate)} = map { trim $_ } (split /,/, $1)[0,1,2,3];
            @ffprobe{qw(video video_profile)} = ($1, $2) if $ffprobe{video} =~ /^(.+?) \((.+?)\)/; 
        }

        # audio stream
        if ( /Stream #\d:\d.+?Audio:(.*)/ ) { 
            @ffprobe{qw(audio audio_bitrate)} = map { trim $_ } (split /,/, $1)[0,-1];
            @ffprobe{qw(audio audio_profile)} = ($1, $2) if $ffprobe{audio} =~ /^(.+?) \((.+?)\)/; 
        } 
    }            

    close $pipe; 

    return \%ffprobe; 
} 

1 
