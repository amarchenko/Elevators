#!/usr/bin/perl

use Elevator;
use Interface;
use Tk;

$el = Elevator->new();

#map {print "$_\n"} keys (%{$el->get_state()});

#$face = Interface->new(Elevator::TOP_FLOOR);
$face = Interface->new(\$el);

#$el->set_state({'passenger' => Elevator::PS_OUT, 'doors' => Elevator::DR_OPEN});


#$face->draw_floors();
$face->draw_elevator($el->get_state());

$face->tick();
Interface::MainLoop();