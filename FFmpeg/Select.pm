package FFmpeg::Select; 

use Moose::Role; 

use strictures 2; 
use namespace::autoclean; 
use experimental qw( signatures smartmatch ); 

sub select_id ( $self, $header, $stream ) {  
    my @ids = sort keys $stream->%*; 

    # single id 
    return shift @ids if @ids == 1; 
    
    printf "-> %s:\n", $header;  
    while (1) { 
        # list of stream id 
        for my $id ( @ids ) { 
            printf "[%s]\t%s\n", $id, $stream->{$id}
        } 

        # prompt user for selection  
        print "-> "; 
        chomp ( my $choice = <STDIN> ); 
       
        return $choice if $choice ~~ @ids 
    } 
} 

1; 
