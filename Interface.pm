package Interface;

use warnings;
use strict;

use Tk;
use Carp;
use Elevator;

our $WIDTH = 300;
our $HEIGHT = 600;
our $E_WIDTH = 25;
our $E_HEIGHT = 30;

our $F_HEIGHT = $E_HEIGHT+10;

our $F_INDENT = 90;
our $T_INDENT = 10;

our $interval = 400;


sub new
{
    if (@_ != 2)
        { croak "Wrong number argument of for ". __PACKAGE__ ."\n"; }
    my $class = shift;
    my $self = {};
    bless ($self, $class);
    $self->{elevator} = shift;
    
    my $cur_floor = ${$self->{elevator}}->get_current_floor();
    
=comment
draws elevator at the center of the canvas

    $self->{el_coords} = [int(($WIDTH/2))-(int($E_WIDTH/2)), 
                          ((Elevator::TOP_FLOOR+1)-$cur_floor)*$F_HEIGHT-$E_HEIGHT,
                          int(($WIDTH/2))+(int($E_WIDTH/2)),
                          ((Elevator::TOP_FLOOR+1)-$cur_floor)*$F_HEIGHT];
=cut

    $self->{el_coords} = [int($WIDTH/2), 
                      ((Elevator::TOP_FLOOR+1)-$cur_floor)*$F_HEIGHT-$E_HEIGHT,
                      int($WIDTH/2)+$E_WIDTH,
                      ((Elevator::TOP_FLOOR+1)-$cur_floor)*$F_HEIGHT];
                      

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
    
    for (my $i = 1; $i <= Elevator::TOP_FLOOR; $i++)
    {
        $self->{canvas}->createText($T_INDENT, $i*$F_HEIGHT,
                                    '-fill' => '#000000',
                                    '-text' => (Elevator::TOP_FLOOR+1)-$i,
                                    '-anchor' => 'sw');
        $self->{canvas}->createLine($F_INDENT, $i*$F_HEIGHT, $WIDTH, $i*$F_HEIGHT,
                                    '-fill' => 'white',
                                    '-tags' => 'floor');
                                    
    }
    $self->{canvas}->Button('-text' => 'Call here', '-command' => sub{})->place('-relx' => 0.17, '-rely' => 0.048, '-anchor' => 'center');
    $self->{canvas}->Button('-text' => 'Call here', '-command' => sub{})->place('-relx' => 0.17, '-rely' => 0.048+0.065, '-anchor' => 'center');
    $self->{main_window}->Entry('-textvariable' => 'Enter floor number')->pack();
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
    $self->{canvas}->createRectangle($self->{el_coords}[0], 
                                        $self->{el_coords}[1], 
                                        $self->{el_coords}[2],
                                        $self->{el_coords}[3], 
                                        '-fill' => $color,
                                        '-outline' => '#0000FF',
                                        '-tags' => 'elevator');
    $self->draw_floors();
}

sub move_elevator
{
    my $self = shift;
    if($self->{el_coords}[3] > ((Elevator::TOP_FLOOR+1)-7)*$F_HEIGHT)
    {
        $self->{canvas}->move('elevator', 0, -10);
        $self->{el_coords}[1] -= 10;
        $self->{el_coords}[3] -= 10;
    }
}

sub tick
{
    my $self = shift;
    $self->move_elevator();
    $self->{main_window}->after($interval, sub{$self->tick()});
}


1;