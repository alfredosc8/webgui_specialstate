package WebGUI::User::SpecialState;

use strict;
use warnings;
use Carp;

use base 'WebGUI::User';

sub create {
    my $class   = shift;
    my $session = shift;

    my $self  = $class->SUPER::create( $session, @_ );
    $self->disable;
    $self->username( $self->getId );

    # WebGUI::User->create always returns an object of class WebGUI::User, so we must instanciate again.
    return $class->new( $session, $self->getId );
}

sub addSpecialState {
    my $self    = shift;
    my $state   = shift || croak 'state is required';
    my $id      = shift;
    my $db      = $self->session->db;

    $db->write( 'delete from users_specialState where userId=? and specialState=?', [
        $self->getId,
        $state,
    ] );

    $db->write( 'insert into users_specialState (userId, specialState) values (?,?)', [
        $self->getId,
        $state,
    ] );

    return;
}

sub isAdHocUser {
    my $class   = shift;
    my $user    = shift;

    return 
           $user->username eq $user->getId 
        && !$user->isEnabled;
}


sub removeSpecialState {
    my $self    = shift;
    my $state   = shift || croak 'state is required';
    my $id      = shift;
    my $db      = $self->session->db;

    $db->write( 'delete from users_specialState where userId=? and specialState=?', [
        $self->getId,
        $state,
    ] );
    
    return;
}

1;

