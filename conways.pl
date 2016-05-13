#!/usr/bin/perl
######################################################################
# Conways game of life, silly plain implementation.
######################################################################
use strict;
use POSIX "ceil";
use Getopt::Std;
use Pod::Usage;
use Data::Dumper;
use Term::ANSIColor;

my %opts = ();
getopts('x:y:g:dh',\%opts);

my $grid_x  = $opts{x} || 25;
my $grid_y  = $opts{y} || 100;
my $row     = $grid_y;
my $generations     = $opts{g} || 200;
my $debug           = $opts{d} || 0;
my $clear_screen    = `clear`;
my $vivo    = 'green on_green';
my $muerto  = 'black on_black';


if ($opts{h}){
    ayudas();
    exit 0;
}

=pod

=head1 SYNOPSIS

Script para Conwaydear como un loco.

=head2 Forma de uso:

=over

=item x [nro] -- Tamaño eje X

=item y [nro] -- Tamaño eje Y

=item g [nro] -- Generaciones

=item d -- Debug

=item h -- Ayuda

=back

=cut

my %grid = ();
foreach my $nn (1 .. $grid_x * $grid_y){
    $grid{$nn} = int(rand(2));
    print "grid{$nn} ======= $grid{$nn}\n" if $debug;
    print "================\n" if $debug;
}

######################################################################
# M A I N
######################################################################
for my $gen (1 .. $generations){
    draw();
    #separador();
    new_gen();
    #sleep 1;
    select (undef, undef, undef, 0.25);
}
######################################################################
# S U B S
######################################################################
sub draw {
    print $clear_screen;
    my $nro = 1;
    for my $x (1 .. $grid_x){
        for my $y (1 .. $grid_y){
            if ($grid{$nro} == 1){
                print colored(" ",$vivo);    
            } else {
                print colored(" ",$muerto);    
            }
            $nro++;
        }
        print "\n";
    }
}

sub new_gen {
    my %grid_new = ();
    foreach my $pos (1..$grid_x * $grid_y){
        my $suma = 0;
        
        #vecino de la izquierda, misma fila.
        $suma += $grid{$pos-1} ; 
        $suma += $grid{$pos+1} ;
        #vecinos de una fila abajo.
            $suma += $grid{$pos+$row};
            $suma += $grid{$pos+$row-1};
            $suma += $grid{$pos+$row+1};
        #vecinos de una fila arriba.
            $suma += $grid{$pos-$row};
            $suma += $grid{$pos-$row-1} ;
            $suma += $grid{$pos-$row+1} ;

        if ( $grid{$pos} == 0 ) {
            if ( $suma == 3 ) {
                $grid_new{$pos} = 1;    # Nacio!
            } else {
                $grid_new{$pos} = 0;
            }
        } else {
            if ( $suma == 2 || $suma == 3 ) {
                $grid_new{$pos} = 1;    # Sigue igual!
            } else {
                $grid_new{$pos} = 0;    # Murió por soledad o superpoblación.
            }
        }
    }
    # Actualizacion del hash
    foreach my $key (1..$grid_x * $grid_y){
        unless (exists $grid_new{$key}){
            $grid_new{$key} = $grid{$key};    
        }
    }
    %grid = %grid_new;
}

sub separador {
    print "----------------------------------\n";
}

sub ayudas {
    pod2usage(-verbose=>3);
}

=pod

=head1 Autor y Licencia.

Programado por B<Marxbro> aka B<Gstv>, distribuir solo bajo la licencia
WTFPL: I<Do What the Fuck You Want To Public License>.

=cut
