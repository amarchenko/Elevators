package Elevator;

use warnings;
use strict;

use constant TOP_FLOOR => 9;

use constant PS_YES    => 1;
use constant PS_NO   => 0;
use constant DR_CLOSED => 1;
use constant DR_OPEN   => 0;

sub new
{
   my $class = shift;
   my $self = {};
   bless($self, $class);
   $self->{current_floor} = 1;
   $self->{finish_floor} = 0;
   $self->{state} = {'passenger' => PS_NO, 'doors' => DR_CLOSED};
   return $self;
}

sub get_state
{
    my $self = shift;
    return $self->{state};
}

sub set_state
{
    my ($self, $st) = @_;
    if (ref($st) eq 'HASH')
    { 
        $self->{state} = $st;
        return 1;
    }    
    else
        { return 0; }
}

sub get_current_floor
{
    my $self = shift;
    return $self->{current_floor};
}

sub get_finish_floor
{
    my $self = shift;
    return $self->{finish_floor};
}

sub set_finish
{
    my ($self, $f) = @_;
    $self->{finish_floor} = $f if ($f > 0 && $f <= TOP_FLOOR);
    if ($self->{finish_floor} == $f)
        { return 1; }
    else
        { return 0; }
}

sub _move_to_finish
{
    my $self = shift;
    
    if ($self->{finish_floor} != $self->{current_floor})
    {
        $self->{current_floor} = $self->{finish_floor};
    }
}
1;