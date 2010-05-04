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

our $BTN_WIDTH = 3; # button width is in TEXT CHARACTERS

our $interval = 300;
our $pace = 5;
our $close_doors_interval = 5000;
our $close_doors_timer = 0;

our $debug = 0;

sub new
{
    if (@_ != 2)
        { croak "Wrong number argument of for ". __PACKAGE__ ."\n"; }
    my $class = shift;
    my $self = {};
    bless ($self, $class);
    $self->{elevator} = shift;
    $self->{buttons} = [];
    
    my $cur_floor = ${$self->{elevator}}->get_current_floor();

    $self->{el_coords} = [int($WIDTH/2), 
                      ((Elevator::TOP_FLOOR+1)-$cur_floor)*$F_HEIGHT-$E_HEIGHT,
                      int($WIDTH/2)+$E_WIDTH,
                      ((Elevator::TOP_FLOOR+1)-$cur_floor)*$F_HEIGHT];
                      
    $self->{main_window} = MainWindow->new('-title' => 'Elevators');
    $self->{canvas} = $self->{main_window}->Canvas('-width' => $WIDTH,
                                                  '-height' => $HEIGHT,
                                                  '-border' => 1,
                                                  '-relief' => 'ridge');
    $self->{selection_dialog} = 0;
    $self->{canvas}->pack();
    return $self;
}

sub draw_floors
{
    my $self = shift;
    
    my ($btn_relx, $btn_rely) = (0.2, 0.048);
    
    for (my $i = 1; $i <= Elevator::TOP_FLOOR; $i++)
    {
        my $f = Elevator::TOP_FLOOR+1-$i;
        $self->{canvas}->createText($T_INDENT, $i*$F_HEIGHT,
                                    '-fill' => '#000000',
                                    '-text' => 'Floor',
                                    '-anchor' => 'sw');
        $self->{canvas}->createLine($F_INDENT, $i*$F_HEIGHT, $WIDTH, $i*$F_HEIGHT,
                                    '-fill' => 'black',
                                    '-tags' => 'floor');

        $self->{buttons}[$f] = $self->{canvas}->Button('-text' => $f,
                                    '-width' => $BTN_WIDTH,
                                    '-command' => sub{$self->floor_button_pressed($f)})->place('-relx' => $btn_relx,
                                                                                        '-rely' => $btn_rely, 
                                                                                        '-anchor' => 'center');

        $btn_rely += 0.066;
    }
    #print $self->{buttons}[1]->cget('-text');
    #$b = 
    #foreach (@{$b->configure()})
    #    {print $_->[0]."\n";}
    #print $b->cget('-text');
     
    #$self->{canvas}->Button('-text' => 'Call here', '-command' => sub{})->place('-relx' => 0.17, '-rely' => 0.048+0.065, '-anchor' => 'center');
    #$self->{main_window}->Entry('-textvariable' => 'Enter floor number')->pack();
}

sub draw_elevator
{
    if (@_ != 2)
        { croak "Wrong number argument of for ". __PACKAGE__ ."\n"; }
    my ($self, $st) = @_;
    my $color;
    
    if (${$self->{elevator}}->get_state()->{'doors'})
    {
        $color = '#7A7A7A';
    }
    elsif (!${$self->{elevator}}->get_state()->{'doors'})
    {
        $color = '#FFD700';
    }
    $self->{canvas}->createRectangle($self->{el_coords}[0], 
                                        $self->{el_coords}[1], 
                                        $self->{el_coords}[2],
                                        $self->{el_coords}[3], 
                                        '-fill' => $color,
                                        '-outline' => '#000000',
                                        '-tags' => 'elevator');
                                        
    my $cur_floor = ${$self->{elevator}}->get_current_floor();                                                
    $self->{canvas}->createLine(int($WIDTH/2)+int($E_WIDTH/2),
                                ((Elevator::TOP_FLOOR+1)-$cur_floor)*$F_HEIGHT-$E_HEIGHT,
                                int($WIDTH/2)+int($E_WIDTH/2),
                                ((Elevator::TOP_FLOOR+1)-$cur_floor)*$F_HEIGHT,
                                '-fill' => '#000000',
                                '-tags' => 'elevator');
    #$self->draw_floors();
    $self->{canvas}->raise('floor');
}

sub draw_selection_dialog
{
    my $self = shift;
    
    ${$self->{elevator}}->set_state({'general' => Elevator::ST_FREE, 'doors' => Elevator::DR_OPEN, 'passenger' => Elevator::PS_NO});
    $self->{buttons}[${$self->{elevator}}->get_current_floor()]->configure('-state' => 'normal');
    
    #$self->draw_elevator(${$self->{elevator}}->get_state());
    
    #my $dialog = $self->{main_window}->Toplevel('-height' => 200, '-width' => 200);
    $self->{selection_dialog} = $self->{main_window}->Toplevel();
    
    #$self->{selection_dialog}->resizable( 0, 0 );
    #$self->{selection_dialog}->transient($self->{selection_dialog}->Parent->toplevel);
    #$self->{selection_dialog}->protocol('WM_DELETE_WINDOW' => sub {});   
    $self->{selection_dialog}->grab;
    
    
    #$self->{selection_dialog}->destroy();

    my %relcoords;
    my $stepy = 1/Elevator::TOP_FLOOR;
    $stepy += $stepy/2;
    $relcoords{'-rely'} = 1 - $stepy;
    for (my $i = 1; $i <= Elevator::TOP_FLOOR; $i++)
    {
        if ($i % 2) 
        { $relcoords{'-relx'} = 0.3; $relcoords{'-rely'} -= $stepy}
        else 
        { $relcoords{'-relx'} = 0.6; }
        my $f = $i;
        $self->{selection_dialog}->Button('-text' => $i, 
                                        '-width' => $BTN_WIDTH,
                                        '-command' => sub{$self->selection_button_pressed($f)})->place(%relcoords);
    }
    $self->{selection_dialog}->Button('-text' => 'Cancel', 
                                        '-command' => sub{$self->close_doors()})->place('-relx' => 0.42,
                                                                                                        '-rely' => 0.88);
}

sub move_elevator
{
    my $self = shift;
    #if (@_ != 1)
    #    { croak "Wrong number argument of for ". __PACKAGE__ ."\n"; }
    #my $fl = shift;
    #print "Moving to $fl\n";
    
    # moving up
    if (${$self->{elevator}}->get_current_floor() < ${$self->{elevator}}->get_finish_floor())
    {      
        if($self->{el_coords}[3] > ((Elevator::TOP_FLOOR+1)-${$self->{elevator}}->get_finish_floor())*$F_HEIGHT)
        {
            $self->{canvas}->move('elevator', 0, -$pace);
            $self->{el_coords}[1] -= $pace;
            $self->{el_coords}[3] -= $pace;
            
            if ($debug) { print "Comparing ". $self->{el_coords}[3] .
                " vs ". ((Elevator::TOP_FLOOR+1)-${$self->{elevator}}->get_current_floor()-1)*$F_HEIGHT ."\n"; }

            if ($self->{el_coords}[3] == ((Elevator::TOP_FLOOR+1)-${$self->{elevator}}->get_current_floor()-1)*$F_HEIGHT)
                { ${$self->{elevator}}->set_current_floor(${$self->{elevator}}->get_current_floor() + 1); }
            
            if (${$self->{elevator}}->get_current_floor() == ${$self->{elevator}}->get_finish_floor())
            {
                $self->draw_selection_dialog();
            }
        }
        if ($debug) { print "We at the ". ${$self->{elevator}}->get_current_floor() ." floor\n"; }
    }
    # moving down
    elsif (${$self->{elevator}}->get_current_floor() > ${$self->{elevator}}->get_finish_floor())
    {      
        if($self->{el_coords}[3] < ((Elevator::TOP_FLOOR+1)-${$self->{elevator}}->get_finish_floor())*$F_HEIGHT)
        {
            $self->{canvas}->move('elevator', 0, $pace);
            $self->{el_coords}[1] += $pace;
            $self->{el_coords}[3] += $pace;
            
            if ($debug) { print "Comparing ". $self->{el_coords}[3] .
                " vs ". ((Elevator::TOP_FLOOR+1)-${$self->{elevator}}->get_current_floor()+1)*$F_HEIGHT ."\n"; }
                
            if ($self->{el_coords}[3] == ((Elevator::TOP_FLOOR+1)-${$self->{elevator}}->get_current_floor()+1)*$F_HEIGHT)
                { ${$self->{elevator}}->set_current_floor(${$self->{elevator}}->get_current_floor() - 1); }
                
            if (${$self->{elevator}}->get_current_floor() == ${$self->{elevator}}->get_finish_floor())
            { 
                $self->draw_selection_dialog();
            }
        }
        if ($debug) { print "We at the ". ${$self->{elevator}}->get_current_floor() ." floor\n"; }
    }

}

sub floor_button_pressed
{
    my ($self, $f) = @_;
    if (${$self->{elevator}}->get_state()->{'general'} == Elevator::ST_FREE &&
        ($f != ${$self->{elevator}}->get_current_floor()))
    {
        $self->{buttons}[$f]->configure('-state' => 'disabled');
        ${$self->{elevator}}->set_finish_floor($f);
    }
    elsif (${$self->{elevator}}->get_state()->{'general'} == Elevator::ST_FREE &&
        ($f == ${$self->{elevator}}->get_current_floor()))
    {
        $self->draw_selection_dialog();
    }
}

sub selection_button_pressed
{
    my ($self, $f) = @_;
    if (${$self->{elevator}}->get_state()->{'general'} == Elevator::ST_FREE &&
        ($f != ${$self->{elevator}}->get_current_floor()))
    {
        ${$self->{elevator}}->set_finish_floor($f);
        $self->close_doors();
    }
}

sub close_doors
{
    my $self = shift;
    $self->{selection_dialog}->destroy();
    $self->{selection_dialog} = 0;
    $close_doors_timer = 0;
    ${$self->{elevator}}->set_state({'general' => ${$self->{elevator}}->get_state()->{'general'},
        'doors' => Elevator::DR_CLOSED,
        'passenger' => ${$self->{elevator}}->get_state()->{'passenger'}});
}

sub tick
{
    my $self = shift;
    
    print "close_doors_time $close_doors_timer\n";
    
    if ($self->{selection_dialog} && ($close_doors_timer > $close_doors_interval))
    {
        $self->close_doors();
    }
    elsif ($self->{selection_dialog})
    {
        $close_doors_timer += $interval;
    }
    
    #$self->draw_elevator(${$self->{elevator}}->get_state());
    $self->move_elevator();
    $self->{main_window}->after($interval, sub{$self->tick()});
}


1;