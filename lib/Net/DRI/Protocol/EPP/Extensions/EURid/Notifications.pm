## Domain Registry Interface, EURid Registrar EPP extension notifications
## (introduced in release 5.6 october 2008)
##
## Copyright (c) 2009 Patrick Mevzek <netdri@dotandco.com>. All rights reserved.
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

package Net::DRI::Protocol::EPP::Extensions::EURid::Notifications;

use strict;
use warnings;

use Net::DRI::Util;

our $VERSION=do { my @r=(q$Revision: 1.1 $=~/\d+/g); sprintf("%d".".%02d" x $#r, @r); };

=pod

=head1 NAME

Net::DRI::Protocol::EPP::Extensions::EURid::Notifications - EURid EPP Notifications Handling for Net::DRI

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

Copyright (c) 2009 Patrick Mevzek <netdri@dotandco.com>.
All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

See the LICENSE file that comes with this distribution for more details.

=cut

####################################################################################################

sub register_commands
{
 my ($class,$version)=@_;
 my %tmp=( 
          euretrieve => [ \&pollreq, \&parse_poll ],
          eudelete => [ \&pollack, undef ],
         );

 return { 'message' => \%tmp };
}

####################################################################################################
sub pollack
{
 my ($epp,$msgid)=@_;
 my $mes=$epp->message();
 $mes->command([['poll',{op=>'ack',msgID=>$msgid}]]);
}

sub pollreq
{
 my ($epp,$msgid)=@_;
 Net::DRI::Exception::usererr_invalid_parameters('In EPP, you can not specify the message id you want to retrieve') if defined($msgid);
 my $mes=$epp->message();
 $mes->command([['poll',{op=>'req'}]]);
}

sub parse_poll
{
 my ($po,$otype,$oaction,$oname,$rinfo)=@_;
 my $mes=$po->message();
 return unless $mes->is_success();

 my $msgid=$mes->msg_id();
 my $poll=$mes->get_response('poll','pollData');
 return unless defined $poll;

 my %n;
 foreach my $el (Net::DRI::Util::xml_list_children($poll))
 {
  my ($name,$c)=@$el;
  if ($name=~m/^(context|object|action|code|detail|objectType|objectUnicode|registrar)$/)
  {
   $n{$1}=$c->textContent();
  }
 }

 if ($n{context}=~m/^(?:DOMAIN|TRANSFER|DYNUPDATE|RESERVED_ACTIVATION|LEGAL|REGISTRY_LOCK|OBJECT_CLEANUP|REGISTRATION_LIMIT)$/)
 {
  $rinfo->{message}->{$msgid}->{context}=$n{context};
  $rinfo->{message}->{$msgid}->{notification_code}=$n{code};
  $rinfo->{message}->{$msgid}->{action}=$n{action};
  $rinfo->{message}->{$msgid}->{detail}=$n{detail} if exists $n{detail};
  $rinfo->{message}->{$msgid}->{object_type}=$n{objectType};
  $rinfo->{message}->{$msgid}->{object_id}=$n{object} if exists $n{object};
  $rinfo->{message}->{$msgid}->{object_unicode}=$n{objectUnicode} if exists $n{objectUnicode};
  $rinfo->{message}->{$msgid}->{registrar}=$n{registrar} if exists $n{registrar};
  $rinfo->{message}->{session}->{last_id}=$msgid;
 } else
 {
  $n{level} = $n{object} if $n{context} eq 'WATERMARK'; # it used to be called level, so this is for backwards compat
  $rinfo->{session}->{notification}=\%n;
 }

 return;
}

####################################################################################################
1;
