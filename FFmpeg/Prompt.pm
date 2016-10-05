package FFmpeg::Prompt; 

use Moose::Role; 
use namespace::autoclean; 
use experimental qw( signatures smartmatch );  

sub select_id ( $self, $stream ) {  
    my @ids = sort keys $self->$stream->%*; 

    # short-circuit
    return shift @ids if @ids == 1; 
    
    printf "-> %s:\n", $stream; 
    
    while (1) { 
        # list of stream id 
        for my $id ( @ids ) { 
            printf "[%s]\t%s\n", $id, $self->$stream->{ $id }
        } 
        # prompt user for selection  
        print "-> "; 
        chomp ( my $choice = <STDIN> ); 
       
        return $choice if $choice ~~ @ids 
    } 
} 

1
