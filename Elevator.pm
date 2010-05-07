package Elevator;

use warnings;
use strict;

use constant TOP_FLOOR => 11;

use constant ST_FREE   => 1;
use constant ST_BUSY   => 0;
use constant DR_CLOSED => 1;
use constant DR_OPEN   => 0;
use constant PS_YES    => 1;
use constant PS_NO     => 0;
use constant EL_BASE_SPEED => 0.125;

sub new
{
   my $class = shift;
   my $self = {};
   bless($self, $class);
   $self->{current_floor} = 1;
   $self->{finish_floor} = 1;
   $self->{state} = {'general' => ST_FREE, 'doors' => DR_CLOSED, 'passenger' => PS_NO};
   $self->{speed} = EL_BASE_SPEED;
   return $self;
}

sub get_speed
{
    my $self = shift;
    return $self->{speed};
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

sub set_current_floor
{
    my ($self, $f) = @_;
    $self->{current_floor} = $f if ($f > 0 && $f <= TOP_FLOOR);
    if ($self->{current_floor} == $f)
        { return 1; }
    else
        { return 0; }
}

sub set_finish_floor
{
    my ($self, $f) = @_;
    #if ($self->get_state()->{'general'} == ST_FREE)
    #{
        $self->{finish_floor} = $f if ($f > 0 && $f <= TOP_FLOOR);
        if ($self->{finish_floor} == $f)
        {
            $self->set_state({'general' => ST_BUSY, 'doors' => DR_CLOSED, 'passenger' => PS_NO});
            return 1; 
        }
        #else
        #{ return 0; }
    #}
    #else
    #    { return 0; }
    return 0;
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