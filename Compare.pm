#!/usr/bin/perl
package Hash::Compare;

use Moose;
use Data::Dumper;

# --------------------------------------------
# ATTRIBUTES
has "hash1" => (
	is => "ro",
	isa => "HashRef"
	);

has "hash2" => (
	is => "ro",
	isa => "HashRef"
	);


# --------------------------------------------
# METHODS

sub get_unique {
	my $self  		= shift;
	my $which 		= shift;
	my $other 		= "";
	my %unique_hash = ();

	if ($which eq "hash1") {
		$other = "hash2";
	} elsif ($which eq "hash2") {
		$other = "hash1";
	} else {
		die "You have to tell me which hash you want me to work on!\n" .
		"\tExample:\n" .
		"\tmy \$new_hash = \$obj->get_unique(hash1)\n";
	}
	
	my @filtered_keys = grep { !exists $self->$other->{$_} } 
							 keys %{ $self->$which };  
	@filtered_keys = grep exists $self->$which->{$_}, @filtered_keys;

	if (@filtered_keys == 0) {
		print STDERR "\n###########################\n" . 
					 "All keys in $which exist in $other.\n";
	} else {
		print STDERR "\n###########################\n" . 
					 "- " . scalar(@filtered_keys), " unique keys in $which\n\n";

		%unique_hash = map { $_ => $self->$which->{$_} } @filtered_keys;
	}

	return(\%unique_hash);
}

# --------------------------------------------
sub count {
	my $self 	   = shift;
	my $total_keys = 0;

	print STDERR "\n###########################\n" .
				 "- " . scalar(keys %{ $self->hash1 }) . " keys in hash 1\n" .
				 "- " . scalar(keys %{ $self->hash2 }) . " keys in hash 2\n" ;

	for my $i (1..2) {
		$total_keys += keys %{ $self->get_unique("hash" . $i) };
	}

	print STDERR "\n###########################\n" .
				 "- " . $total_keys . " total (unique) keys in both hashes\n";

	return;
}


sub merge {
	my $self = shift;


}

no Moose;
__PACKAGE__->meta->make_immutable