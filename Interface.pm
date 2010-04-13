package Interface;

use warnings;
use strict;

use Tk;
use Carp;

our $WIDTH = 300;
our $HEIGHT = 600;
our $E_WIDTH = 25;
our $E_HEIGHT = 30;

our $F_HEIGHT = $E_HEIGHT+10;

our $F_INDENT = 20;
our $T_INDENT = 10;

our $interval = 400;


sub new
{
    if (@_ != 2)
        { croak "Wrong number argument of for ". __PACKAGE__ ."\n"; }
    my $class = shift;
    my $self = {};
    bless ($self, $class);
    $self->{top_floor} = shift;
    #if ()
    $self->{main_window} = MainWindow->new('-title' => 'Elevators');
    $self->{canvas} = $self->{main_window}->Canvas('-width' => $WIDTH,
                                                  '-height' => $HEIGHT,
                                                  '-border' => 1,
                                                  '-relief' => 'ridge');
    $self->{canvas}->pack();
    return $self;
}

sub draw_floors
{
    my $self = shift;
    
    for (my $i = 1; $i <= $self->{top_floor}; $i++)
    {
        $self->{canvas}->createText($T_INDENT, $i*$F_HEIGHT, 
                                    '-fill' => '#000000', 
                                    '-text' => ($self->{top_floor}+1)-$i, 
                                    '-anchor' => 'sw');
        $self->{canvas}->createLine($F_INDENT, $i*$F_HEIGHT, $WIDTH, $i*$F_HEIGHT, 
                                    '-fill' => 'white',
                                    '-tags' => 'floor');
    }
    
}

sub draw_elevator
{
    if (@_ != 2)
        { croak "Wrong number argument of for ". __PACKAGE__ ."\n"; }
    my ($self, $st) = @_;
    my $color;
    if ($st->{doors})
    {
        $color = '#FF0000';
    }
    elsif (!$st->{doors})
    {
        $color = '#FFD700';
    }
    $self->{canvas}->createRectangle(int(($WIDTH/2))-(int($E_WIDTH/2)), 
                                        ($HEIGHT-$E_HEIGHT), 
                                        int(($WIDTH/2))+(int($E_WIDTH/2)),
                                        $HEIGHT, 
                                        '-fill' => $color,
                                        '-outline' => '#0000FF',
                                        '-tags' => 'elevator');
}

sub move_elevator
{
    my $self = shift;
    $self->{canvas}->move('elevator', 0, -10);    
}

sub tick
{
    my $self = shift;
    $self->move_elevator();
    #my $r = \&$self->tick;
    #print $r."\n";
    $self->{main_window}->after($interval, sub{$self->tick()});
    #sleep 1;
}


1;