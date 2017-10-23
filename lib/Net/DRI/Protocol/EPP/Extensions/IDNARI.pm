package Net::DRI::Protocol::EPP::Extensions::IDNARI;

use strict;
use warnings;

use Net::DRI::Util;
use Net::DRI::Exception;

our $VERSION=do { my @r=(q$Revision: 1.7 $=~/\d+/g); sprintf("%d".".%02d" x $#r, @r); };
our $NS='urn:ar:params:xml:ns:idn-1.0';

####################################################################################################

sub register_commands
{
 my ($class,$version)=@_;
 my %tmp=(
           create => [ \&create, undef ],
         );

 return { 'domain' => \%tmp };
}

####################################################################################################

sub add_language
{
 my ($tag,$epp,$domain,$rd)=@_;
 my $mes=$epp->message();

 if (Net::DRI::Util::has_key($rd,'language'))
 {
  Net::DRI::Exception::usererr_invalid_parameters('IDN language tag must be of type XML schema language') unless Net::DRI::Util::xml_is_language($rd->{language});
  my $eid=$mes->command_extension_register($tag,sprintf('xmlns:idn="%s" xsi:schemaLocation="%s idn-1.0.xsd"',$NS,$NS));
  $mes->command_extension($eid,['idn:languageTag', $rd->{language}]);
 }
}

sub create
{
 return add_language('idn:create',@_);
}

####################################################################################################
1;
