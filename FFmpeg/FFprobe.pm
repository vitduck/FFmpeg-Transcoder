package FFmpeg::FFprobe; 

# cpan
use Moose::Role; 
use namespace::autoclean; 

# pragma
use autodie; 
use warnings FATAL => 'all'; 
use experimental qw(signatures); 

has 'ffprobe', ( 
    is       => 'ro', 
    traits   => ['Hash'], 
    lazy     => 1, 
    init_arg => undef, 

    default  => sub ( $self ) { 
        my $ffprobe = {}; 

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

    # currying delegation 
    handles => { 
        # accessor 
        ( map { $_ => [ get => $_ ] } qw/video audio subtitle/ ), 

        # predicate 
        ( map { 'has_'.$_ => [ exists => $_ ] } qw/video audio subtitle/ ), 
    },  
); 

sub select_stream ( $self, $stream, $table ) {  
    if ( not $table->%* ) { return }  

    while (1) { 
        print "\n$stream:\n"; 
        for my $id ( sort keys $table->%* ) { 
            print "[$id] $table->{$id}\n"; 
        } 
        print "-> "; 
        chomp ( my $choice = <STDIN> ); 
        
        if ( exists $table->{$choice} ) { return $choice }  
    } 
} 

1; 
