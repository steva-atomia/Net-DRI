## Domain Registry Interface, EURid EPP extensions
##
## Copyright (c) 2005,2007,2008,2009 Patrick Mevzek <netdri@dotandco.com>. All rights reserved.
##
## This file is part of Net::DRI
##
## Net::DRI is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
##
## See the LICENSE file that comes with this distribution for more details.
#
# 
#
####################################################################################################

package Net::DRI::Protocol::EPP::Extensions::EURid;

use strict;
use warnings;

use base qw/Net::DRI::Protocol::EPP/;

use Net::DRI::Data::Contact::EURid;
use Net::DRI::Protocol::EPP::Extensions::EURid::Message;

our $VERSION=do { my @r=(q$Revision: 1.7 $=~/\d+/g); sprintf("%d".".%02d" x $#r, @r); };

=pod

=head1 NAME

Net::DRI::Protocol::EPP::Extensions::EURid - EURid (.EU) EPP extensions (release 5.6) for Net::DRI

=head1 DESCRIPTION

Please see the README file for details.

=head1 SUPPORT

For now, support questions should be sent to:

E<lt>netdri@dotandco.comE<gt>

Please also see the SUPPORT file in the distribution.

=head1 SEE ALSO

E<lt>http://www.dotandco.com/services/software/Net-DRI/E<gt>

=head1 AUTHOR

Patrick Mevzek, E<lt>netdri@dotandco.comE<gt>

=head1 COPYRIGHT

Copyright (c) 2005,2007,2008,2009 Patrick Mevzek <netdri@dotandco.com>.
All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

See the LICENSE file that comes with this distribution for more details.

=cut

####################################################################################################

sub setup
{
 my ($self,$rp,$params)=@_;
 my $version=$self->version();

 my $default_ns_versions = {
		'domain-ext_version' => '2.4',
		'domain-ext_version_xsd' => '2.4',
		'contact-ext_version' => '1.3',
		'contact-ext_version_xsd' => '1.3',
		'nsgroup_version' => '1.1',
		'nsgroup_version_xsd' => '1.1',
		'registrar_version' => '1.0',
		'registrar_version_xsd' => '1.1',
		'poll_version' => '1.2',
		'poll_version_xsd' => '1.2'
	};
 foreach my $w (qw/contact-ext nsgroup domain-ext registrar poll/)
 {
	my $v = (defined($params) && ref($params) eq "HASH" && defined($params->{$w."_version"})) ? $params->{$w."_version"} : $default_ns_versions->{$w."_version"};
	my $v_xsd = (defined($params) && ref($params) eq "HASH" && defined($params->{$w."_version_xsd"})) ? $params->{$w."_version_xsd"} : $default_ns_versions->{$w."_version_xsd"};
	$self->ns({ $w => ['http://www.eurid.eu/xml/epp/'.$w.'-'.$v,$w.'-'.$v_xsd.'.xsd'] });
 }

 $self->capabilities('contact_update','status',undef); ## No changes in status possible for .EU domains/contacts
 $self->capabilities('domain_update','status',undef);
 $self->capabilities('domain_update','nsgroup',[ 'add','del']);
 $self->factories('contact',sub { return Net::DRI::Data::Contact::EURid->new(); });
 $self->factories('message',sub { my $m=Net::DRI::Protocol::EPP::Extensions::EURid::Message->new(@_); $m->ns($self->{ns}); $m->version($version); return $m;} );
 $self->default_parameters({domain_create => { auth => { pw => '' } } });
 return;
}

sub default_extensions { return qw/EURid::Domain EURid::Contact EURid::Registrar EURid::Notifications NSgroup SecDNS11/; } ## Sunrise should be added when calling, as it is not mandatory

####################################################################################################
1;
