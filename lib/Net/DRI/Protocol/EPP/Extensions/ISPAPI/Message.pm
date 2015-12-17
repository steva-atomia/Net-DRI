## Domain Registry Interface, .ISPAPI message extensions
##
## Copyright (c) 2008-2010 UNINETT Norid AS, E<lt>http://www.norid.noE<gt>,
##                    Trond Haugen E<lt>info@norid.noE<gt>
##                    All rights reserved.
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

package Net::DRI::Protocol::EPP::Extensions::ISPAPI::Message;

use strict;

use Net::DRI::Util;
use Net::DRI::Exception;

our $VERSION=do { my @r=(q$Revision: 1.4 $=~/\d+/g); sprintf("%d".".%02d" x $#r, @r); };

=pod

=head1 NAME

Net::DRI::Protocol::EPP::Extensions::ISPAPI::Message - EPP extension for Net::DRI

=head1 DESCRIPTION

Please see the README file for details.

=head1 SUPPORT

For now, support questions should be sent to:

E<lt>support@hexonet.netE<gt>

Please also see the SUPPORT file in the distribution.

=head1 SEE ALSO

E<lt>http://www.dotandco.com/services/software/Net-DRI/E<gt>

=head1 AUTHOR

Alexander Biehl, E<lt>abiehl@hexonet.netE<gt>
Jens Wagner, E<lt>jwagner@hexonet.netE<gt>

=head1 COPYRIGHT

Copyright (c) 2010 HEXONET GmbH, E<lt>http://www.hexonet.netE<gt>,
Alexander Biehl <abiehl@hexonet.net>,
Jens Wagner <jwagner@hexonet.net>
All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

See the LICENSE file that comes with this distribution for more details.

=cut

####################################################################################################

sub register_commands {
    my ( $class, $version ) = @_;

    my %tmp = (
        ispapiretrieve => [ \&Net::DRI::Protocol::EPP::Core::RegistryMessage::pollreq, \&parse_poll ],
		delete   => [ \&Net::DRI::Protocol::EPP::Core::RegistryMessage::pollack ],
    );

    return { 'message' => \%tmp };
}

sub parse_poll {
 my ($po,$otype,$oaction,$oname,$rinfo)=@_;
 my $mes=$po->message();
 return unless $mes->is_success();

 my $msgid=$mes->msg_id();
 return unless (defined($msgid) && $msgid);
 $rinfo->{message}->{session}->{last_id}=$msgid; ## needed here and not lower below, in case of pure text registry message

 ## Was there really a registry message with some content ?
 return unless ($mes->result_code() == 1301 && (defined($mes->node_resdata()) || defined($mes->node_extension()) || defined($mes->node_msg())));

 my $rd=$rinfo->{message}->{$msgid}; ## already partially filled by Message::parse()
 my $totype = 'account';
 my $toaction = 'list';
 my $toname = 'messages';
 my %info;
 
 Net::DRI::Protocol::EPP::Extensions::ISPAPI::KeyValue::parse_keyvalue($po,$totype,$toaction,$toname,\%info);
 my @tmp=keys %info;
 Net::DRI::Exception::err_assert('EPP::parse_poll can not handle multiple types !') unless @tmp==1;
 $totype=$tmp[0];
 @tmp=keys %{$info{$totype}};
 Net::DRI::Exception::err_assert('EPP::parse_poll can not handle multiple names !') unless @tmp==1; ## this may happen for check_multi !
 $toname=$tmp[0];
 $info{$totype}->{$toname}->{name}=$toname;

 ## If message not completely in the <msg> node, we have to parse something !
 Net::DRI::Exception::err_assert('EPP::parse_poll was not able to parse anything, please report !') if ((defined($mes->node_resdata()) || defined($mes->node_extension())) && ! defined $toname);

 $rd->{object_type}=$totype;
 $rd->{object_id}=$info{$totype}->{$toname}->{keyvalue}->{OBJECTID};
 while(my ($k,$v)=each(%{$info{$totype}->{$toname}}))
 {
  $rd->{$k}=$v;
 }
 ## Also update data about the queried object, for easier access
 while(my ($k,$v)=each(%$rd))
 {
  $rinfo->{$totype}->{$toname}->{$k}=$v;
 }
 
}

####################################################################################################
1;
