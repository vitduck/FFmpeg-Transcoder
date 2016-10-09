package FFmpeg::Prompt; 

use Moose::Role; 
use namespace::autoclean; 
use experimental qw( signatures smartmatch ); 

sub _select_id ( $self, $stream ) {  
    my @ids = sort keys $self->$stream->%*; 

    # short-circuit
    return shift @ids if @ids == 1; 
    
    printf "-> %s:\n", $stream; 
    
    while (1) { 
        # list of stream id 
        printf "[%s]\t%s\n", $_, $self->$stream->{ $_ } for @ids; 
        
        print "-> "; 
        chomp ( my $choice = <STDIN> ); 
       
        return $choice if $choice ~~ @ids 
    } 
} 

1
