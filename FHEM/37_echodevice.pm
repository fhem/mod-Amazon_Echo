# $Id: 37_echodevice.pm 15724 2017-12-29 22:59:44Z michael.winkler $
##############################################
#
# 2018-03-13 v0.0.29
#
# v0.0.29
# - FEATURE: Zwei Faktor Authentifizierung (set login2FACode) Danke Benutzer JoWiedmann https://forum.fhem.de/index.php/topic,82631.msg780848.html#msg780848
#
# v0.0.28
# - CHANGE:  get "Conversations" auf nonBlocking
#            get "tunein" auf nonBlocking & move to Echo Device & play link
#            get "tracks" auf nonBlocking
#            get "devices" auf nonBlocking
#            set "autocreat_devices" auf nonBlocking
#            httpversion = "1.1"
# - FEATURE: get "actions"
#            get "primeplayeigene_albums"
#            get "primeplayeigene_tracks"
#            get "primeplayeigene_artists"
#            get "primeplayeigeneplaylist"
#            get "help"
#            Multiroom add get settings & tunein
# - BUGFIX:  primeplayeigene 
#
# v0.0.27
# - BUGFIX:  Not an ARRAY reference at ./FHEM/37_echodevice.pm line 1610
#
# v0.0.26
# - BUGFIX:  read readings if amazon device is connected
#
# v0.0.25
# - BUGFIX:  set reminder_normal
#            Attribut disable
#            no Internet connect
# - FEATURE: Attribut browser_useragent_random (Standard=1)
#            Attribut intervallogin (Standard=60)
#
# v0.0.24
# - BUGFIX:  Timer Readings
#
# v0.0.23
# - BUGFIX:  Nested quantifiers in regex
# - CHANGE:  Reading version
#
# v0.0.22
# - FEATURE: Attribut browser_useragent https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/#Attribute
#
# v0.0.21
# - CHANGE:  Header
#
# v0.0.20
# - CHANGE:  Cookie erstellen auf nonBlocking
#            Cookie erstellen Timeout 10 sekunden
# - BUGFIX:  div.
#
# v0.0.19
# - BUGFIX:  Fehlt bei "get" der Punkt "conversations"
#            Fehlt bei "set" der Punkt "textmessage"
#
# v0.0.18
# - FEATURE: autocreate Standard Raum "Amazon"
# - CHANGE:  COOKIE wird nicht mehr erneuert!
#
# v0.0.17
# - FEATURE: refresh ECHO devices (Attribut autocreate_refresh)
#            define icon to echo
# - CHANGE:  Header
#
# v0.0.16
# - FEATURE: autocreate ECHO Spot
#
# v0.0.15
# - CHANGE:  deletereading auf FHEM Command umgestellt
# - BUGFIX:  MausicAlarm
#
# v0.0.14
# - FEATURE: autocreate ECHO Multiroom
#            autocreate Sonos One
#            autocreate Reverb
# - CHANGE:  model im Klartext z.B. Echo Dot
#
# v0.0.13
# - BUGFIX:  Cookie
#
# v0.0.12
# - FEATURE: Support Musicalarm
#
# v0.0.11.2
# - FEATURE: neue Readings timer_XX, reminder_X und alarm_xx
#            neue Readings deviceAddress, timeZoneId
#            Zeigt den Status für Mikrofon Reading = microphone
#            Zeigt den Status ob der ECHO online ist. Reading = online
# - BUGFIX:  Reading voice leer
#            Div. Logeinträge wenn Variablen leer sind
# - CHANGE : Reading active entfernt
#
# v0.0.10
# - BUGFIX:  Einkaufsliste und ToDo Liste (Fehler beim hinzufügen und entfernen von Einträgen)
#
# v0.0.9
# - BUGFIX:  ECHO Devices Readings wurden nicht aktualisiert
#
# v0.0.8
# - FEATURE: Attribut tuneid_default (Hier kann ein Standard TuneIn Sender angegeben werden)
#            set notifications_delete (löschen von Erinnerungen, Timer und Wecker)
#            autocreate ECHO Show Geräte
#            löschen und hinzufügen von Einkauflisten- und Task Einträgen
#
# v0.0.7
# - FEATURE: Interval Anpassung beim abspielen eines Songs
# - CHANGE:  set reminder_normal ohne Datumsangabe (Reminder sofort ausgeführt))
#
# v0.0.6
# - CHANGE : Log Einträge reduziert
#            Reading "voice" zum Echo Device verschoben
# - BUGFIX:  set reminder_normal Text (Reminder sofort ausgeführt))
#            ACCOUNT DEVICE macht jetzt die abfragen für wakeword, volume_alarm, dnd, active, bluetooth
#            Standard Interval 60 Sekunden
#
# v0.0.5
# - CHANGE : set reminder_normal (durch weglassen der Uhrzeit wird der Reminder sofort ausgeführt)
# - FEATURE: Attribut reminder_delay (wird für reminder_normal benötigt. Standardwert = 10 sekunden)
#
# v0.0.4
# - CHANGE:  set reminder vom ACCOUNT DEVICE entfernt
#            set reminder zum Echo DEVICE hinzugefügt
# - FEATURE: set reminder_normal
#            set reminder_repeat
#
# v0.0.3
# - BUGFIX:  Anzeige set befehle primeplayeigene,primeplayeigeneplaylist,primeplaylist und primeplaysender
#
# v0.0.2
# - FEATURE: set primeplayeigene
#            set primeplayeigeneplaylist
#            set primeplaylist
#            set primeplaysender
#
# v.0.0.1
# - BUGFIX:  blocking restart fhem
#            readings
#
#  Copyright by Michael Winkler
#  e-mail: michael.winkler at online.de
#
#  This file is part of fhem.
#
#  Fhem is free software: you can redistribute it andor modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  Fhem is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with fhem.  If not, see <http://www.gnu.org/licenses/>.
#
#  https://forum.fhem.de/index.php/topic,82631.0.html
#
##############################################################################

package main;

use strict;
use Time::Local;
use Encode;
use URI::Escape;
use Data::Dumper;
use JSON;
use utf8;
use Date::Parse;
use Time::Piece;

my $ModulVersion = "0.0.28";

##############################################################################

# dnd schedule: https://layla.amazon.de/api/dnd/schedule?deviceType=AB72C64C86AW2&deviceSerialNumber=ECHOSERIALNUMBER&_=1506940081763
# wifi settings: https://layla.amazon.de/api/device-wifi-details?deviceSerialNumber=ECHOSERIALNUMBER&deviceType=AB72C64C86AW2&_=1506940081768
# /api/todos?startTime=&endTime=&completed=&type=TASK&size=100&offset=-1&_=1507577670365
# /api/todos?startTime=&endTime=&completed=&type=SHOPPING_ITEM&size=100&offset=-1&_=1507577670355
# https://alexa-comms-mobile-service.amazon.com/homegroups/amzn1.comms.id.hg.amzn1~HOMEGROUP/devices?target=false
# my $url="https://".$hash->{helper}{SERVER}."/api/cards?limit=10&beforeCreationTime=".int(time)."000&_=".int(time); #Übersichtsseite Darstellung einzelner Einträge

sub echodevice_Initialize($) {
	my ($hash) = @_;
	my $name = $hash->{NAME};

	$hash->{DefFn}        = "echodevice_Define";
	$hash->{UndefFn}      = "echodevice_Undefine";
	$hash->{NOTIFYDEV}    = "global";
	$hash->{NotifyFn}     = "echodevice_Notify";
	$hash->{GetFn}        = "echodevice_Get";
	$hash->{SetFn}        = "echodevice_Set";
	$hash->{AttrFn}       = "echodevice_Attr";
	$hash->{AttrList}     = "disable:0,1 ".
							"IODev ".
							"intervalsettings ".
							"intervallogin ".
							"server ".
							"cookie ".
							"reminder_delay ".
							"tunein_default ".
							"autocreate_refresh:0,1 ".
							"browser_useragent ".
							"browser_useragent_random:0,1 ".
							$readingFnAttributes;
}

sub echodevice_Define($$$) {
	my ($hash, $def) = @_;
	my @a = split("[ \t][ \t]*", $def);
	my ($found, $dummy);

	return "syntax: define <name> echodevice <account> <password>" if(int(@a) != 4 );
	my $name = $hash->{NAME};

	$attr{$name}{server} = "layla.amazon.de" if( defined($attr{$name}) && !defined($attr{$name}{server}) );

	RemoveInternalTimer($hash);

	if($a[2] =~ /crypt/ || $a[2] =~ /@/ || $a[2] =~ /^\+/) {
    
		$hash->{model} = "ACCOUNT";
		
		my $user = $a[2];
		my $pass = $a[3];
		
		my $username = echodevice_encrypt($user);
		my $password = echodevice_encrypt($pass);
		$hash->{DEF} = "$username $password";

		$hash->{helper}{USER}     = $username;
		$hash->{helper}{PASSWORD} = $password;
		$hash->{helper}{TWOFA}      = "";
		$hash->{helper}{SERVER}   = $attr{$name}{server};
		$hash->{helper}{SERVER}   = "layla.amazon.de" if(!defined($hash->{helper}{SERVER}));
		$hash->{helper}{RUNLOGIN} = 0;
		$modules{$hash->{TYPE}}{defptr}{"account"} = $hash;
		
		$hash->{STATE} = "INITIALIZED";

		# set default settings on first define
		if ($init_done) {
			$attr{$name}{icon} = 'echo';
			$attr{$name}{room} = 'Amazon';
		}
		
		InternalTimer(gettimeofday() + 5  , "echodevice_FirstStart" , $hash, 0);
		InternalTimer(gettimeofday() + 10 , "echodevice_GetSettings", $hash, 0);
    
	}
	else {
  
		$hash->{STATE} = "INITIALIZED";

		$hash->{model} = echodevice_getModel($a[2]);#$a[2];
		
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "model", $hash->{model}, 1);
		readingsBulkUpdateIfChanged($hash, "state", "INITIALIZED", 1);
		readingsEndUpdate($hash,1);
		
		$hash->{helper}{DEVICETYPE} = $a[2];
		$hash->{helper}{SERIAL} = $a[3];

		$modules{$hash->{TYPE}}{defptr}{$a[3]} = $hash;

		my $account = $modules{$hash->{TYPE}}{defptr}{"account"};
		$hash->{IODev} = $account;
		$attr{$name}{IODev} = $account->{NAME} if( !defined($attr{$name}{IODev}) && $account);
		
		if ($hash->{model} ne "THIRD_PARTY_AVS_MEDIA_DISPLAY") {
			InternalTimer(gettimeofday() + 1, "echodevice_GetSettings", $hash, 0);
		}

	}
  
	Log3 $name, 4, "[$name] Getting auth URL return";
	return undef;
}

sub echodevice_Undefine($$) {
	my ($hash, $arg) = @_;
	my $name = $hash->{NAME};
	RemoveInternalTimer($hash);
	delete( $modules{$hash->{TYPE}}{defptr}{"ACCOUNT"} ) if($hash->{model} eq "ACCOUNT");
	delete( $modules{$hash->{TYPE}}{defptr}{"$hash->{helper}{SERIAL}"} ) if($hash->{model} ne "ACCOUNT");
	return undef;
}

sub echodevice_Notify($$) {
	my ($hash,$dev) = @_;
	my $name = $hash->{NAME};
	return if($dev->{NAME} ne "global");
	return if(!grep(m/^INITIALIZED|REREADCFG$/, @{$dev->{CHANGED}}));
	
	Log3 "echodevice", 4, "[$name] echodevice: notify reload";

	return undef;
}

sub echodevice_Get($@) {
	my ($hash, @a) = @_;
	shift @a;
	my $command = shift @a;
	my $parameter = join(' ',@a);
	my $name = $hash->{NAME};

	my $usage = "Unknown argument $command, choose one of ";

	return $usage if ($hash->{model} eq 'unbekannt');
	return $usage if ($hash->{model} eq 'Sonos One');
	
	#$usage .= "conversations:noArg " if(defined($hash->{helper}{COMMSID}));
	
	if ($hash->{model} eq "Reverb") {
		$usage .= "help:noArg  " ;
	}
	elsif ($hash->{model} eq "ACCOUNT") {
		$usage .= "settings:noArg devices:noArg actions:noArg tracks:noArg help:noArg conversations:noArg ";
	}
	else {
		$usage .= "tunein settings:noArg primeplayeigene_albums primeplayeigene_tracks primeplayeigene_artists primeplayeigeneplaylist:noArg help:noArg ";
	}
	
	#return "no get" if ($hash->{model} eq "Echo Multiroom");
	return $usage if $command eq '?';
	
	if(IsDisabled($name) && $command ne "help") {
		$hash->{STATE} = "disabled";
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "state", "disabled", 1);
		readingsEndUpdate($hash,1);
		return "$name is disabled. Aborting...";
	}
	
	my $ConnectState = "";
	if($hash->{model} eq "ACCOUNT") {$ConnectState = $hash->{STATE}} else {$ConnectState = $hash->{IODev}->{STATE}}
	
	if ($ConnectState ne "connected" && $command ne "help") {
		return "$name is not connected. Aborting...";
	}

	if($command eq "settings") {
		echodevice_GetSettings($hash);
		return "OK" if($hash->{model} ne "ACCOUNT");
	}
     
	elsif($command eq "actions") {
		echodevice_SendCommand($hash,"getcards","");
	} 
	
	elsif($command eq "devices") {
		echodevice_SendCommand($hash,"devices","");
	}
	
	elsif($command eq "conversations") {
		echodevice_SendCommand($hash,"conversations","");
	} 
  
	elsif($command eq "tunein") {
		echodevice_SendCommand($hash,"searchtunein",$parameter);
	}
	elsif($command eq "tracks") {
		echodevice_SendCommand($hash,"searchtracks",$parameter);
	}
	elsif($command eq "primeplayeigene_albums") {
		echodevice_SendCommand($hash,"primeplayeigene_Albums",$parameter);
	}
	elsif($command eq "primeplayeigene_tracks") {
		echodevice_SendCommand($hash,"primeplayeigene_Tracks",$parameter);
	}
	elsif($command eq "primeplayeigene_artists") {
		echodevice_SendCommand($hash,"primeplayeigene_Artists",$parameter);
	}
	elsif($command eq "primeplayeigeneplaylist") {
		echodevice_SendCommand($hash,"getprimeplayeigeneplaylist","");
	}	
	elsif($command eq "help") {

		my $return = '<html><table align="" border="0" cellspacing="0" cellpadding="3" width="100%" height="100%" class="mceEditable"><tbody>';
		$return   .= "<p><strong>Hilfe:</strong></p>";
		$return   .= "<tr><td><strong>Dokumentation&nbsp;&nbsp;&nbsp</strong></td><td><strong>Link&nbsp;&nbsp;&nbsp</strong></td></tr>";			
	
		$return .= "<tr><td>"."Beschreibung"."&nbsp;&nbsp;&nbsp;</td><td><a target=" . "_blank" . " href=" .'"' . 'https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/#Beschreibung' .'"'. "</a>https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/#Beschreibung</td></tr>";
		$return .= "<tr><td>"."Definition in FHEM"."&nbsp;&nbsp;&nbsp;</td><td><a target=" . "_blank" . " href=" .'"' . 'https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/#Definition in FHEM' .'"'. "</a>https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/#Definition in FHEM</td></tr>";
		$return .= "<tr><td>"."Readings"."&nbsp;&nbsp;&nbsp;</td><td><a target=" . "_blank" . " href=" .'"' . 'https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/#Readings' .'"'. "</a>https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/#Readings</td></tr>";
		$return .= "<tr><td>"."Attribute"."&nbsp;&nbsp;&nbsp;</td><td><a target=" . "_blank" . " href=" .'"' . 'https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/#Attribute' .'"'. "</a>https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/#Attribute</td></tr>";
		$return .= "<tr><td>"."Set"."&nbsp;&nbsp;&nbsp;</td><td><a target=" . "_blank" . " href=" .'"' . 'https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/#Set' .'"'. "</a>https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/#Set</td></tr>";
		$return .= "<tr><td>"."Get"."&nbsp;&nbsp;&nbsp;</td><td><a target=" . "_blank" . " href=" .'"' . 'https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/#Get' .'"'. "</a>https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/#Get</td></tr>";
		$return .= "<tr><td>"."Medieninformationen ermitteln"."&nbsp;&nbsp;&nbsp;</td><td><a target=" . "_blank" . " href=" .'"' . 'https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/#Medieninformationen_ermitteln' .'"'. "</a>https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/#Medieninformationen_ermitteln</td></tr>";
		$return .= "<tr><td>"."Cookie_ermitteln"."&nbsp;&nbsp;&nbsp;</td><td><a target=" . "_blank" . " href=" .'"' . 'https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/#Cookie_ermitteln' .'"'. "</a>https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/#Cookie_ermitteln</td></tr>";
		$return .= "<tr><td>&nbsp</td><td> </td></tr>";
		$return .= "<tr><td><strong>Forum</strong></td><td></td></tr>";
		$return .= "<tr><td></td><td></td></tr>";

		$return .= "<tr><td>"."Forums Thread"."&nbsp;&nbsp;&nbsp;</td><td><a target=" . "_blank" . " href=" .'"' . 'https://forum.fhem.de/index.php/topic,82631.0.html' .'"'. "</a>https://forum.fhem.de/index.php/topic,82631.0.html</td></tr>";
		
		$return .= "</tbody></table></html>";

		return $return;
	}	
	
  return undef;
}

sub echodevice_Set($@) {
	my ($hash, @a) = @_;

	shift @a;
	my $command       = shift @a;
	my $parameter     = join(' ',@a);
	my $name          = $hash->{NAME};
	my $ShoppingListe = ReadingsVal($name, "list_SHOPPING_ITEM", "");
	my $TaskListe     = ReadingsVal($name, "list_TASK", "");
	my $tracks        = AttrVal($name, 'tracks', AttrVal(AttrVal($name, 'IODev', $name), 'tracks', undef));
	my $usage         = 'Unknown argument $command, choose one of ';

	return $usage if ($hash->{model} eq 'unbekannt');
	
	if($hash->{model} eq "ACCOUNT") {
		$usage .= 'login:noArg autocreate_devices:noArg item_shopping_add item_task_add login2FACode ';
		$usage .= 'textmessage ' if(defined($hash->{helper}{COMMSID}));
		
		# Einkaufsliste
		my $ShoppingListe = ReadingsVal($name, "list_SHOPPING_ITEM", "");
		my $TaskListe = ReadingsVal($name, "list_TASK", "");
		$ShoppingListe =~ s/ /&nbsp;/g;
		$TaskListe =~ s/ /&nbsp;/g;
		$usage .= ' item_shopping_delete:'.$ShoppingListe;
		$usage .= ' item_task_delete:'.$TaskListe;
	}
	elsif ($hash->{model} eq "Echo Multiroom" || $hash->{model} eq "Sonos Display") {
		$usage .= 'volume:slider,0,1,100 play:noArg pause:noArg next:noArg previous:noArg forward:noArg rewind:noArg shuffle:on,off repeat:on,off ';
		$usage .= 'tunein primeplaylist primeplaysender primeplayeigene primeplayeigeneplaylist ';
		
		if(defined($tracks)) {
				$tracks =~ s/ /_/g;
				$tracks =~ s/:/,/g;
				$usage .= 'track:'.$tracks.' ';
			} 
			else {
				$usage .= 'track ';
		}
	}
	else {
	
		if ($hash->{model} eq "Reverb" || $hash->{model} eq "Sonos One") {
			$usage .= 'reminder_normal reminder_repeat ';
		}
		else {
			$usage .= 'volume:slider,0,1,100 play:noArg pause:noArg next:noArg previous:noArg forward:noArg rewind:noArg shuffle:on,off repeat:on,off dnd:on,off volume_alarm:slider,0,1,100 ';
			$usage .= 'tunein primeplaylist primeplaysender primeplayeigene primeplayeigeneplaylist reminder_normal reminder_repeat ';
			
			if(defined($tracks)) {
				$tracks =~ s/ /_/g;
				$tracks =~ s/:/,/g;
				$usage .= 'track:'.$tracks.' ';
			} 
			else {
				$usage .= 'track ';
			}
			$usage .= 'bluetooth_connect:'.$hash->{helper}{bluetooth}.' bluetooth_disconnect:'.$hash->{helper}{bluetooth}.' ' if(defined($hash->{helper}{bluetooth}));
		}
		
		# Reminder auslesen
		my @ncstrings = ();

		my $NotifiResult ;
		foreach my $NotifiID (sort keys %{$hash->{IODev}->{helper}{"notifications"}{$hash->{helper}{SERIAL}}}) {
				if ($hash->{IODev}->{helper}{"notifications"}{$hash->{helper}{SERIAL}}{$NotifiID} ne "") {
					$NotifiResult = $hash->{IODev}->{helper}{"notifications"}{$hash->{helper}{SERIAL}}{$NotifiID} ;
					$NotifiResult =~s/ /_/g;
					$NotifiResult =~s/,/_/g;
					$NotifiResult =~s/@/_/g;
					$NotifiResult .= "@" . $NotifiID ;
					
					push @ncstrings, $NotifiResult;				
				}
		}
		if (@ncstrings) {
			@ncstrings = sort @ncstrings;
			$usage .= 'notifications_delete:' . join(",", @ncstrings). ' ';
		}

	}

	return $usage if $command eq '?';

	if(IsDisabled($name)) {
		$hash->{STATE} = "disabled";
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "state", "disabled", 1);
		readingsEndUpdate($hash,1);
		return "$name is disabled. Aborting...";
	}
	
	return echodevice_SendLoginCommand($hash,"cookielogin1","") if($command eq "login");

	my $ConnectState = "";
	if($hash->{model} eq "ACCOUNT") {$ConnectState = $hash->{STATE}} else {$ConnectState = $hash->{IODev}->{STATE}}
	
	if ($ConnectState ne "connected" && $command ne "login" && $command ne "login2FACode") {
		return "$name is not connected. Aborting...";
	}
	
	# Allgemeine Einstellungen
	if($command eq "bluetooth_connect"){
		return "No argument given." if ( !defined($a[0]) );

		my @parameters = split("/",$a[0]);
		$parameters[0] =~ s/-/:/g;
  
		my $json = encode_json( { bluetoothDeviceAddress => $parameters[0] } );
		
		echodevice_SendCommand($hash,"bluetooth_connect",$json);
	}

	elsif ($command eq "autocreate_devices") {
		readingsSingleUpdate ( $hash, "autocreate_devices", "running", 0 );
		echodevice_SendCommand($hash,"autocreate_devices","");
	}
	
	elsif($command eq "bluetooth_disconnect"){
		return "No argument given." if ( !defined($a[0]) );

		my @parameters = split("/",$a[0]);
		$parameters[0] =~ s/-/:/g;
  
		my $json = encode_json( { bluetoothDeviceAddress => $parameters[0] } );
		
		echodevice_SendCommand($hash,"bluetooth_disconnect",$json);
	}
	
	elsif($command eq "dnd"){
		return "No argument given." if ( !defined($a[0]) );
		
		my $json = encode_json( { deviceSerialNumber => $hash->{helper}{SERIAL},
                                          deviceType => $hash->{helper}{DEVICETYPE},
                                             enabled => ($a[0] eq "on")?"true":"false" } );
  
		$json =~s/\"true\"/true/g;
		$json =~s/\"false\"/false/g;
	
		echodevice_SendCommand($hash,"dnd",$json);
	}
	
	elsif($command eq "volume") {
		return "No argument given" if ( !defined( $a[0] ) );
	
		# Voluemeangabe prüfen
		if ($a[0] >= 0 && $a[0] <= 100 ) {
			readingsBeginUpdate($hash);
			readingsBulkUpdateIfChanged($hash, "volume", $a[0], 1);
			readingsEndUpdate($hash,1);
			echodevice_SendMessage($hash,"volume",$a[0]);
   		}
		else {
			return "Argument $a[0] does not seem to be a valid integer between 0 and 100";
		}
	}

	elsif($command eq "volume_alarm") {
		return "No argument given" if ( !defined( $a[0] ) );
		# Voluemeangabe prüfen
		if ($a[0] >= 0 && $a[0] <= 100 ) {
		
			my $json = encode_json( { deviceSerialNumber => $hash->{helper}{SERIAL},
											  deviceType => $hash->{helper}{DEVICETYPE},
										 softwareVersion => $hash->{helper}{VERSION},
											 volumeLevel => int($a[0]) } );
			readingsBeginUpdate($hash);
			readingsBulkUpdateIfChanged($hash, "volume_alarm", $a[0], 1);
			readingsEndUpdate($hash,1);
			echodevice_SendCommand($hash,"volume_alarm",$json);
   		}
		else {
			return "Argument $a[0] does not seem to be a valid integer between 0 and 100";
		}
	} 
	
	# Listen
	elsif($command eq "item_task_delete" ) {
		return "No argument given." if ( !defined($parameter) );
		
		my $json = JSON->new->utf8(1)->encode( { 'type' => "TASK",
												 'text' => decode_utf8($parameter),
										  'createdDate' => int(time),
											   'itemId' => $hash->{helper}{"ITEMS"}{"TASK"}{"$parameter"},
											 'complete' => "true",
											 'deleted' => "true" } );

		$json =~ s/\"true\"/true/g;
		$json =~ s/\"false\"/false/g;
		
		my @TaskList = split(",",$TaskListe);
		my $Result;
		foreach my $TaskName (@TaskList) {if ($TaskName ne $parameter) {
				if ($Result eq "" ){$Result = $TaskName;} else {$Result .= "," .$TaskName;}}
		}
		readingsBeginUpdate($hash);
		
		if ($Result eq "") {readingsBulkUpdateIfChanged($hash, "list_SHOPPING_ITEM", "" , 1);}
		else {readingsBulkUpdateIfChanged($hash, "list_TASK", $Result , 1);}

		readingsEndUpdate($hash,1);
		
		echodevice_SendCommand($hash,"item_task_delete",$json)
	} 

	elsif($command eq "item_shopping_delete" ) {
		return "No argument given." if ( !defined($parameter) );

		my $json = JSON->new->utf8(1)->encode( { 'type' => "SHOPPING_ITEM",
												 'text' => decode_utf8($parameter),
										  'createdDate' => int(time),
											   'itemId' => $hash->{helper}{"ITEMS"}{"SHOPPING_ITEM"}{"$parameter"},
											 'complete' => "true",
											 'deleted' => "true" } );

		$json =~ s/\"true\"/true/g;
		$json =~ s/\"false\"/false/g;
		
		my @ShoppList = split(",",$ShoppingListe);
		my $Result;
		foreach my $ShopName (@ShoppList) {
			if ($ShopName ne $parameter) {if ($Result eq "" ){$Result = $ShopName;} else {$Result .= "," .$ShopName;}}
		}

		readingsBeginUpdate($hash);
		
		if ($Result eq "") {readingsBulkUpdateIfChanged($hash, "list_SHOPPING_ITEM", "" , 1);}
		else {readingsBulkUpdateIfChanged($hash, "list_SHOPPING_ITEM", $Result , 1);}

		readingsEndUpdate($hash,1);
		
		echodevice_SendCommand($hash,"item_shopping_delete",$json)
	} 

	elsif($command eq "item_task_add" ) {
		return "No argument given." if ( !defined($a[0]) );
		my $json = JSON->new->utf8(1)->encode( { 'type' => "TASK",
												 'text' => decode_utf8($parameter),
										  'createdDate' => int(time),
											   'itemId' => $hash->{helper}{"ITEMS"}{"TASK"}{"$parameter"},
											 'complete' => "false",
											 'deleted' => "false" } );

		$json =~ s/\"true\"/true/g;
		$json =~ s/\"false\"/false/g;
		
		$parameter =~ s/ /_/g;
		
		readingsBeginUpdate($hash);
		if ($TaskListe eq "") {readingsBulkUpdateIfChanged($hash, "list_TASK", $parameter , 1);}
		else {readingsBulkUpdateIfChanged($hash, "list_TASK", $parameter . "," . $TaskListe , 1); }
		readingsEndUpdate($hash,1);
		
		echodevice_SendCommand($hash,"item_task_add",$json)
	} 

	elsif($command eq "item_shopping_add" ) {
		return "No argument given." if ( !defined($parameter) );

		my $json = JSON->new->utf8(1)->encode( { 'type' => "SHOPPING_ITEM",
												 'text' => decode_utf8($parameter),
										  'createdDate' => int(time),
											   'itemId' => $hash->{helper}{"ITEMS"}{"SHOPPING_ITEM"}{"$parameter"},
											 'complete' => "false",
											 'deleted' => "false" } );

		$json =~ s/\"true\"/true/g;
		$json =~ s/\"false\"/false/g;

		$parameter =~ s/ /_/g;
		
		readingsBeginUpdate($hash);
		if ($ShoppingListe eq "") {readingsBulkUpdateIfChanged($hash, "list_SHOPPING_ITEM", $parameter , 1);}
		else {readingsBulkUpdateIfChanged($hash, "list_SHOPPING_ITEM", $parameter . "," . $ShoppingListe , 1); }
		readingsEndUpdate($hash,1);
		
		echodevice_SendCommand($hash,"item_shopping_add",$json)
	} 
		
	# Erinnerungen
	elsif($command eq "reminder_normal") {
		return "No argument given." if ( !defined($a[0]) );
		
		my $reminder_delay = AttrVal($name, "reminder_delay", 10);
		my $ReminderText ;
		my $ReminderDate ;

		# Reading festhalten
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "reminder_normal", join(' ',@a), 1);
		readingsEndUpdate($hash,1);
	
		my ($Tsec, $Tmin, $Thour, $Tmday, $Tmon, $Tyear, $Twday, $Tyday, $Tisdst) = localtime();
	
		# Prüfen es sich um ein Datum handelt
		if (index($a[0], "-") != -1){
			$ReminderDate = str2time($a[0] . " " . $a[1]);
			splice @a, 0, 1;
			splice @a, 0, 1;
			$ReminderText = join(' ',@a);

		}
		elsif (index($a[0], ":") != -1){
			$ReminderDate = str2time(sprintf("%04d",$Tyear+1900)."-".sprintf("%02d",$Tmon+1)."-".sprintf("%02d",$Tmday)." ". $a[0]);
			splice @a, 0, 1;
			$ReminderText = join(' ',@a);
		}
		else {
			$ReminderText = $parameter;
			$ReminderDate = time + $reminder_delay;
		}
		
		my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime($ReminderDate);
		
		my $json = encode_json( { alarmTime => $ReminderDate*1000,	
								  createdDate => int(time)*1000,
								  deviceSerialNumber => $hash->{helper}{SERIAL},
								  deviceType => $hash->{helper}{DEVICETYPE},							  
								  id => "createReminder",
								  isRecurring => "false",
								  isSaveInFlight => "true",
								  originalDate => sprintf("%04d",$year+1900)."-".sprintf("%02d",$mon+1)."-".sprintf("%02d",$mday),
								  originalTime => sprintf("%02d",$hour).":".sprintf("%02d",$min).":".sprintf("%02d",$sec).".000",
								  reminderLabel => decode_utf8($ReminderText),
								  status => "ON",
								  type => "Reminder"});	
								  
		$json =~ s/\"true\"/true/g;
		$json =~ s/\"false\"/false/g;		

		echodevice_SendCommand($hash,"reminderitem",$json);
		
	} 
  
	elsif($command eq "reminder_repeat") {
		return "There are some arguments missing. [Zeitangabe] [Wiederholumgsmode] nachrichtentext " if ( !defined($a[0]) );
		return "There are some arguments missing. [Zeitangabe] [Wiederholumgsmode] nachrichtentext " if ( !defined($a[0]) );
		return "There are some arguments missing. [Zeitangabe] [Wiederholumgsmode] nachrichtentext " if ( !defined($a[0]) );
		
		# Reading festhalten
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "reminder_repeat", join(' ',@a), 1);
		readingsEndUpdate($hash,1);
		
		# Vorbereitungen
		my @parameters = split(":",$a[0]);
		my $ReminderRecc = $a[1];
		splice @a, 0, 1;
		splice @a, 0, 1;
		my $ReminderText = join(' ',@a);
		my $recurringPattern = "";

		if    ($ReminderRecc eq "1")  {$recurringPattern = "P1D";}
		elsif ($ReminderRecc eq "2")  {$recurringPattern = "XXXX-WD";}
		elsif ($ReminderRecc eq "3")  {$recurringPattern = "XXXX-WE";}
		elsif ($ReminderRecc eq "4")  {$recurringPattern = "XXXX-WXX-1";}
		elsif ($ReminderRecc eq "5")  {$recurringPattern = "XXXX-WXX-2";}
		elsif ($ReminderRecc eq "6")  {$recurringPattern = "XXXX-WXX-3";}
		elsif ($ReminderRecc eq "7")  {$recurringPattern = "XXXX-WXX-4";}
		elsif ($ReminderRecc eq "8")  {$recurringPattern = "XXXX-WXX-5";}
		elsif ($ReminderRecc eq "9")  {$recurringPattern = "XXXX-WXX-6";}
		elsif ($ReminderRecc eq "10") {$recurringPattern = "XXXX-WXX-7";}
		else  {$recurringPattern = "P1D";}

		my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime();
	 
		my $json = encode_json( { alarmTime => int(time)*1000,	
								  createdDate => int(time)*1000 ,
								  deviceSerialNumber => $hash->{helper}{SERIAL},
								  deviceType => $hash->{helper}{DEVICETYPE},							  
								  id => "createReminder",
								  isRecurring => "true",
								  isSaveInFlight => "true",
								  recurringPattern => $recurringPattern,
								  originalDate => sprintf("%04d",$year+1900)."-".sprintf("%02d",$mon+1)."-".sprintf("%02d",$mday),
								  originalTime => sprintf("%02d",$parameters[0]).":".sprintf("%02d",$parameters[1]).":00.000",
								  status => "ON",
								  reminderLabel => decode_utf8($ReminderText),
								  type => "Reminder"});	
								  
		$json =~ s/\"true\"/true/g;
		$json =~ s/\"false\"/false/g;
		
		Log3( $name, 5, "[$name] set reminder_repeat $parameters[0]:$parameters[1] $ReminderRecc Message = $ReminderText");
		
		echodevice_SendCommand($hash,"reminderitem",$json);
		
	} 
    
	elsif($command eq "notifications_delete"){

		return "No argument given" if ( !defined($a[0]));

		my @parameters = split("@",$parameter);
		
		# Reminder aus dem hash entfernen
		$hash->{IODev}->{helper}{"notifications"}{$hash->{helper}{SERIAL}}{$parameters[1]} = "";
		
		echodevice_SendCommand($hash,"notifications_delete",$parameters[1]);
	}
	
	# Nachrichten
	elsif($command eq "textmessage"){
		return "No argument given." if ( !defined($a[0]) );
		return "There are some arguments missing. [conversationId] nachrichtentext " if ( !defined($a[1]) );
	
		echodevice_SendCommand($hash,$command,join(' ',@a));
	} 
 
	elsif($command eq "message_delete"){

		#return "No argument given" if ( !defined($a[0]));

		#my @parameters = split("@",$parameter);
		
		# Reminder aus dem hash entfernen
		#$hash->{IODev}->{helper}{"notifications"}{$hash->{helper}{SERIAL}}{$parameters[1]} = "";
	
	
		echodevice_SendCommand($hash,"message_delete","");
	}

	# Medien
	elsif($command eq "tunein"){

		my $tuneinID ;
		if ( !defined($a[0]) && AttrVal($name,"tunein_default","none") eq "none" ) {
			return "No argument given. You can set attribut tunein_default!";
		}
		elsif (!defined($a[0]))	{$tuneinID = AttrVal($name,"tunein_default","none");}
		else 					{$tuneinID = $a[0];}
	
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "tunein", $tuneinID, 1);
		echodevice_SendCommand($hash,"tunein",$tuneinID);
		
		# Player aktualisieren
		readingsBulkUpdateIfChanged($hash, "playStatus", "playing", 1);
		readingsEndUpdate($hash,1);
		InternalTimer( gettimeofday() + 10, "echodevice_GetSettings", $hash, 0);
	}
  
	elsif($command eq "primeplaylist"){
		return "No argument given." if ( !defined($a[0]) );
		
		# Reading festhalten
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "primeplaylist", $a[0], 1);
		
		my $json = encode_json( {  asin => $a[0] } );
		
		echodevice_SendCommand($hash,$command,$json);
		
		# Player aktualisieren
		
		readingsBulkUpdateIfChanged($hash, "playStatus", "playing", 1);
		readingsEndUpdate($hash,1);
		InternalTimer( gettimeofday() + 5, "echodevice_GetSettings", $hash, 0);
	}
	
	elsif($command eq "primeplayeigeneplaylist"){
		return "No argument given." if ( !defined($a[0]) );
		
		# Reading festhalten
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "primeplayeigeneplaylist", $a[0], 1);
		
		my $json = encode_json( {  playlistId => $a[0] } );
		
		echodevice_SendCommand($hash,$command,$json);
		
		# Player aktualisieren
		readingsBulkUpdateIfChanged($hash, "playStatus", "playing", 1);
		readingsEndUpdate($hash,1);
		InternalTimer( gettimeofday() + 3, "echodevice_GetSettings", $hash, 0);
	} 

	elsif($command eq "primeplaysender"){
		return "No argument given." if ( !defined($a[0]) );
		
		# Reading festhalten
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "primeplaysender", $a[0], 1);
		
		my $json = encode_json( {  seed => '{"type":"KEY","seedId":"' . $a[0] .'"}' ,stationName => $a[0],seedType => "KEY" } );
		
		echodevice_SendCommand($hash,$command,$json);
		
		# Player aktualisieren
		readingsBulkUpdateIfChanged($hash, "playStatus", "playing", 1);
		readingsEndUpdate($hash,1);
		InternalTimer( gettimeofday() + 3, "echodevice_GetSettings", $hash, 0);
	} 
	
	elsif($command eq "primeplayeigene"){
		return "No argument given." if ( !defined($a[0]) );
	
		# Reading festhalten
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "primeplayeigene", $a[0], 1);

		my @PlayItem = split (/@/s, $parameter);
		my $json = encode_json( {  albumArtistName => $PlayItem[0],albumName => $PlayItem[1]} );
		 
		echodevice_SendCommand($hash,$command,$json);
		
		# Player aktualisieren
		readingsBulkUpdateIfChanged($hash, "playStatus", "playing", 1);
		readingsEndUpdate($hash,1);
		InternalTimer( gettimeofday() + 3, "echodevice_GetSettings", $hash, 0);
	} 

	elsif($command eq "track"){
		
		return "No argument given." if ( !defined($a[0]) );
		
		# Reading festhalten
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "track", $a[0], 1);
		
		my $json = encode_json( { trackId => $a[0],
                            playQueuePrime => "false"} );

		$json =~s/\"true\"/true/g;
		$json =~s/\"false\"/false/g;
		
		echodevice_SendCommand($hash,$command,$json);

		# Player aktualisieren
		readingsBulkUpdateIfChanged($hash, "playStatus", "playing", 1);
		readingsEndUpdate($hash,1);
		InternalTimer( gettimeofday() + 3, "echodevice_GetSettings", $hash, 0);
	}
 	
	elsif($command eq "login2FACode"){
		
		return "No argument given." if ( !defined($a[0]) );
		
		$hash->{helper}{TWOFA} = $a[0];
		
        echodevice_SendLoginCommand($hash,"cookielogin4","");		
	}
	
	else {
		echodevice_SendMessage($hash,$command,$parameter);
				
		# Player aktualisieren
		InternalTimer( gettimeofday() + 2, "echodevice_GetSettings", $hash, 0);
	}

  return ;
}

#########################
sub echodevice_SendMessage($$$) {
	my ($hash,$command,$value) = @_;
	my $name = $hash->{NAME};

	my $json = encode_json( {} );
	
	if($command eq "volume") {
		$json = encode_json( {  type => 'VolumeLevelCommand',
                         volumeLevel => 0+$value,
                contentFocusClientId => undef } );
	} 
	elsif ($command eq "play") {
		$json = encode_json( {  type => 'PlayCommand',
                contentFocusClientId => undef } );
	}

	elsif ($command eq "pause") {
		$json = encode_json( {  type => 'PauseCommand',
                contentFocusClientId => undef } );
	} 
  
	elsif ($command eq "next") {
		$json = encode_json( {  type => 'NextCommand',
                contentFocusClientId => undef } );
	}
	
	elsif ($command eq "previous") {
		$json = encode_json( {  type => 'PreviousCommand',
                contentFocusClientId => undef } );
	} 
	
	elsif ($command eq "forward") {
		$json = encode_json( {  type => 'ForwardCommand',
                contentFocusClientId => undef } );
	} 
  
	elsif ($command eq "rewind") {
		$json = encode_json( {  type => 'RewindCommand',
                contentFocusClientId => undef } );
	}

	elsif ($command eq "shuffle") {
		$json = encode_json( {  type => 'ShuffleCommand',
							 shuffle => ($value eq "on"?"true":"false"),
                contentFocusClientId => undef } );
	}

	elsif ($command eq "repeat") {
		$json = encode_json( {  type => 'RepeatCommand',
                              repeat => ($value eq "on"?"true":"false"),
                contentFocusClientId => undef } );
	}
	
	else {
		Log3 ($name, 4, "[$name] [echodevice_SendMessage] Unknown command $command $value");
		return ;
	}

	$json =~s/\"true\"/true/g;
	$json =~s/\"false\"/false/g;

	echodevice_SendCommand($hash,"command",$json);

}

sub echodevice_SendCommand($$$) {
    my ( $hash, $type, $SendData ) = @_;
	my $name = $hash->{NAME};
	my $SendUrl;
		
	Log3 $name, 4, "[$name] [echodevice_SendCommand]    - type " .$type;
	
	if($hash->{model} eq "ACCOUNT") {
		return undef if(!defined($hash->{helper}{SERVER}));
		$SendUrl = "https://".$hash->{helper}{SERVER};
	}
	else {
		return undef if(!defined($hash->{IODev}->{helper}{SERVER}));
		$SendUrl = "https://".$hash->{IODev}->{helper}{SERVER};
	}

	my $SendParam ;
	my $SendMetode = "GET" ;
	
	# Ohne JSON
	if ($type eq "bluetoothstate") {
        $SendUrl   .= "/api/bluetooth?cached=true&_=".int(time);
	}
	elsif ($type eq "notifications") {
        $SendUrl   .= "/api/notifications?cached=true&_=".int(time);
	}
	elsif ($type eq "getdnd") {
        $SendUrl   .= "/api/dnd/device-status-list?_=".int(time);
	}
	elsif ($type eq "getdevicesettings") {
        $SendUrl   .= "/api/device-preferences";
	}	
	elsif ($type eq "getisonline") {
        $SendUrl   .= "/api/devices-v2/device?cached=true&_=".int(time);
	}	
	elsif ($type eq "wakeword") {
        $SendUrl   .= "/api/wake-word?_=".int(time);
	}
	elsif ($type eq "alarmvolume") {
        $SendUrl   .= "/api/device-notification-state?_=".int(time);
	}
	elsif ($type eq "activities") {
        $SendUrl   .= "/api/activities?startTime=&size=50&offset=1&_=".int(time);
	}	
	elsif ($type eq "player") {
        $SendUrl   .= "/api/np/player?deviceSerialNumber=".$hash->{helper}{SERIAL}."&deviceType=".$hash->{helper}{DEVICETYPE}."&screenWidth=1392&_=".int(time);
	}	
	elsif ($type eq "media") {
        $SendUrl   .= "/api/media/state?deviceSerialNumber=".$hash->{helper}{SERIAL}."&deviceType=".$hash->{helper}{DEVICETYPE}."&screenWidth=1392&_=".int(time);
	}
	elsif ($type eq "reminderitem") {
        $SendUrl   .= "/api/notifications/createReminder";
		$SendMetode = "PUT";
	}
	elsif ($type eq "command" || $type eq "volume") {
        $SendUrl   .= "/api/np/command?deviceSerialNumber=".$hash->{helper}{SERIAL}."&deviceType=".$hash->{helper}{DEVICETYPE};
		$SendMetode = "POST";
	}
	elsif ($type eq "tunein" ) {
        $SendUrl   .= "/api/tunein/queue-and-play?deviceSerialNumber=".$hash->{helper}{SERIAL}."&deviceType=".$hash->{helper}{DEVICETYPE}."&guideId=".$SendData."&contentType=station&callSign=&mediaOwnerCustomerId=".$hash->{IODev}->{helper}{CUSTOMER};
		$SendData   = "";
		$SendMetode = "POST";		
	}
	elsif ($type eq "getnotifications" ) {
        $SendUrl   .= "/api/notifications";
		$SendData   = "";
	}
	elsif ($type eq "notifications_delete" ) {
        $SendUrl   .= "/api/notifications/".$hash->{helper}{DEVICETYPE}."-".$hash->{helper}{SERIAL}."-".$SendData;
		$SendMetode = "DELETE";		
		$SendData   = "";
	}
	elsif ($type eq "message_delete" ) {
		$SendUrl   .= "/api/device-preferences/G090L90964350E96";
		$SendMetode = "PUT";		
	}
	elsif ($type eq "track" ) {
        $SendUrl   .= "/api/cloudplayer/queue-and-play?deviceSerialNumber=".$hash->{helper}{SERIAL}."&deviceType=".$hash->{helper}{DEVICETYPE}."&mediaOwnerCustomerId=".$hash->{IODev}->{helper}{CUSTOMER};
		$SendMetode = "POST";		
	}	
	elsif ($type eq "primeplaylist" ) {
        $SendUrl   .= "/api/prime/prime-playlist-queue-and-play?deviceSerialNumber=".$hash->{helper}{SERIAL}."&deviceType=".$hash->{helper}{DEVICETYPE}."&mediaOwnerCustomerId=".$hash->{IODev}->{helper}{CUSTOMER};
		$SendMetode = "POST";		
	}		
	elsif ($type eq "primeplayeigeneplaylist" ) {
        $SendUrl   .= "/api/cloudplayer/queue-and-play?deviceSerialNumber=".$hash->{helper}{SERIAL}."&deviceType=".$hash->{helper}{DEVICETYPE}."&mediaOwnerCustomerId=".$hash->{IODev}->{helper}{CUSTOMER};
		$SendMetode = "POST";		
	}		
	elsif ($type eq "primeplaysender" ) {
        $SendUrl   .= "/api/gotham/queue-and-play?deviceSerialNumber=".$hash->{helper}{SERIAL}."&deviceType=".$hash->{helper}{DEVICETYPE}."&mediaOwnerCustomerId=".$hash->{IODev}->{helper}{CUSTOMER};
		$SendMetode = "POST";		
	}		
	elsif ($type eq "primeplayeigene" ) {
        $SendUrl   .= "/api/cloudplayer/queue-and-play?deviceSerialNumber=".$hash->{helper}{SERIAL}."&deviceType=".$hash->{helper}{DEVICETYPE}."&mediaOwnerCustomerId=".$hash->{IODev}->{helper}{CUSTOMER};	
		$SendMetode = "POST";		
	}
	elsif ($type eq "textmessage" ) {
        
		my @parameters = split(" ",$SendData);
		my $conversationid = shift @parameters;
		my $parameter = join(" ",@parameters);
		
		$SendUrl    = "https://alexa-comms-mobile-service.amazon.com/users/".$hash->{helper}{COMMSID}."/conversations/".$conversationid."/messages";
		$SendMetode = "POST";
		$SendData   = JSON->new->pretty(1)->utf8(1)->encode([{ "type" => "message/text",
											     "payload" => {"text" => decode_utf8($parameter)} }] );

		$SendData =~s/\//\\\//;
		
	}
	elsif ($type eq "volume_alarm" ) {
        $SendUrl   .= "/api/device-notification-state/".$hash->{helper}{DEVICETYPE}."/".$hash->{helper}{VERSION}."/".$hash->{helper}{SERIAL};
		$SendMetode = "PUT";		
	}
	elsif ($type eq "dnd" ) {
        $SendUrl   .= "/api/dnd/status";
		$SendMetode = "PUT";		
	}	
	elsif ($type eq "bluetooth_connect" ) {
        $SendUrl   .= "/api/bluetooth/pair-sink/".$hash->{helper}{DEVICETYPE}."/".$hash->{helper}{SERIAL};
		$SendMetode = "POST";		
	}	
	elsif ($type eq "bluetooth_disconnect" ) {
        $SendUrl   .= "/api/bluetooth/disconnect-sink/".$hash->{helper}{DEVICETYPE}."/".$hash->{helper}{SERIAL};
		$SendMetode = "POST";		
	}
	elsif ($type eq "listitems_task" || $type eq "listitems_shopping" ) {
        $SendUrl   .= "/api/todos?size=100&startTime=&endTime=&completed=false&type=".$SendData."&deviceSerialNumber=&deviceType=&_=".int(time);
		$SendData   = "";
	}
	elsif ($type eq "item_shopping_delete" || $type eq "item_task_delete" || $type eq "item_task_add" || $type eq "item_shopping_add" ) {
        $SendUrl   .= "/api/todos/" . $hash->{helper}{CUSTOMER};
		$SendMetode = "PUT";		
	}
	elsif ($type eq "account" ) {
        $SendUrl    = "https://alexa-comms-mobile-service.amazon.com/accounts";
		$SendMetode = "GET";		
	}
	elsif ($type eq "homegroup" ) {
        $SendUrl    = "https://alexa-comms-mobile-service.amazon.com/users/".$hash->{helper}{COMMSID}."/identities?includeUserName=true";
		$SendMetode = "GET";		
	}
	elsif ($type eq "conversations" ) {
        $SendUrl    = "https://alexa-comms-mobile-service.amazon.com/users/".$hash->{helper}{COMMSID}."/conversations?latest=true&includeHomegroup=true&unread=false&modifiedSinceDate=1970-01-01T00:00:00.000Z&includeUserName=true";
	}
	elsif ($type eq "devices" || $type eq "autocreate_devices" ) {
        $SendUrl   .= "/api/devices-v2/device?cached=true&_=".int(time);
	}
	elsif ($type eq "searchtunein" ) {
        $SendUrl   .= "/api/tunein/search?query=".uri_escape_utf8(decode_utf8($SendData))."&mediaOwnerCustomerId=".$hash->{IODev}->{helper}{CUSTOMER}."&_=".int(time);
		$SendData   = "";
	}	
	elsif ($type eq "searchtracks" ) {
        $SendUrl    .= "/api/cloudplayer/playlists/IMPORTED-V0-OBJECTID?deviceSerialNumber=".$hash->{helper}{SERIAL}."&deviceType=".$hash->{helper}{DEVICETYPE}."&size=50&offset=&mediaOwnerCustomerId=".$hash->{helper}{CUSTOMER}."&_=".int(time);
	}
	elsif ($type eq "getcards" ) {
        $SendUrl    .= "/api/cards?limit=50&beforeCreationTime=".int(time)."000&_=".int(time);
	}
	elsif ($type eq "primeplayeigene_Albums" || $type eq "primeplayeigene_Tracks") {
		my $querytype =  substr($type,16);
		$SendData =~ s/ /+/g;
        $SendUrl   .= "/api/cloudplayer/search?deviceSerialNumber=".$hash->{helper}{SERIAL}."&deviceType=".$hash->{helper}{DEVICETYPE}. "&size=50&category=$querytype&query=". $SendData . "&offset=0" .   "&mediaOwnerCustomerId=".$hash->{IODev}->{helper}{CUSTOMER}."&_=".int(time);	
		$SendData   = "";
	}
	elsif ($type eq "primeplayeigene_Artists" ) {
		$SendData =~ s/ /+/g;
        $SendUrl   .= "/api/cloudplayer/albums?deviceSerialNumber=".$hash->{helper}{SERIAL}."&deviceType=".$hash->{helper}{DEVICETYPE}. "&size=50&artistName=". $SendData ."&mediaOwnerCustomerId=".$hash->{IODev}->{helper}{CUSTOMER}."&_=".int(time);	
		$SendData   = "";
	}
	elsif ($type eq "getprimeplayeigeneplaylist" ) {
        $SendUrl   .= "/api/cloudplayer/playlists?deviceSerialNumber=".$hash->{helper}{SERIAL}."&deviceType=".$hash->{helper}{DEVICETYPE}. "&mediaOwnerCustomerId=".$hash->{IODev}->{helper}{CUSTOMER}."&_=".int(time);	
	}
	else {
		return;
	}
	
	# Log 
	Log3 $name, 4, "[$name] [echodevice_SendCommand]    - PushToCmdQueue " .echodevice_anonymize($hash, $SendUrl);
	Log3 $name, 4, "[$name] [echodevice_SendCommand]    - PushToCmdQueue " .$SendData;
		
	#2018.01.14 - Übergabe SendCommandQuery
	$SendParam = {
		url             => $SendUrl,
		hash            => $hash,
		data            => $SendData,
		method          => $SendMetode,
		CL              => $hash->{CL},
		httpversion     => "1.1",
		type            => $type
	};
	
	#2018.01.14 - PushToCmdQueue
	push @{$hash->{helper}{CMD_QUEUE}}, $SendParam;  
	echodevice_HandleCmdQueue($hash);
	
	return;
}

sub echodevice_HandleCmdQueue($) {
    my ($hash, $param)  = @_;
    my $name            = $hash->{NAME};
	
	return undef if(!defined($hash->{helper}{CMD_QUEUE})); 
	$hash->{helper}{RUNNING_REQUEST} = 0 if(!defined($hash->{helper}{RUNNING_REQUEST})); 
	
	#Header auslesen
	my $AmazonHeader;

	
	if($hash->{model} eq "ACCOUNT") {$AmazonHeader = "Cookie: ".$hash->{helper}{COOKIE}."\r\ncsrf: ".$hash->{helper}{CSRF}."\r\nContent-Type: application/json; charset=UTF-8";}
	else 							{$AmazonHeader = "Cookie: ".$hash->{IODev}->{helper}{COOKIE}."\r\ncsrf: ".$hash->{IODev}->{helper}{CSRF}."\r\nContent-Type: application/json; charset=UTF-8";}
		
	
    if(not($hash->{helper}{RUNNING_REQUEST}) and @{$hash->{helper}{CMD_QUEUE}})
    {
  
		my $params =  {
                       url             => $param->{url},
					   header          => $AmazonHeader,
                       timeout         => 10,
                       noshutdown      => 1,
                       keepalive       => 0,
					   method          => $param->{method},
					   data            => $param->{data},
					   CL              => $param->{CL},
                       hash            => $hash,
					   type            => $param->{type},
					   httpversion     => $param->{httpversion},
                       callback        => \&echodevice_Parse
                      };
  
        my $request = pop @{$hash->{helper}{CMD_QUEUE}};

        map {$hash->{helper}{HTTP_CONNECTION}{$_} = $params->{$_}} keys %{$params};
        map {$hash->{helper}{HTTP_CONNECTION}{$_} = $request->{$_}} keys %{$request};
        
        $hash->{helper}{RUNNING_REQUEST} = 1;
        Log3 $name, 4, "[$name] [echodevice_HandleCmdQueue] - send command " .echodevice_anonymize($hash, $hash->{helper}{HTTP_CONNECTION}{url});
        HttpUtils_NonblockingGet($hash->{helper}{HTTP_CONNECTION});
    }
}

sub echodevice_SendLoginCommand($$$) {
    my ( $hash, $type, $SendData ) = @_;
	my $name = $hash->{NAME};
	my $SendUrl;
	my $param;
	
	# Browser User Agent
	my $UserAgent = AttrVal($name,"browser_useragent","Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:60.0) Gecko/20100101 Firefox/58.0"); 
	
	if (AttrVal($name,"browser_useragent_random",1) == 1) {
		$UserAgent = join('', map{('a'..'z','A'..'Z',0..9)[rand 62]} 0..20);
	}

	readingsSingleUpdate ($hash, "BrowserUserAgent", $UserAgent ,0);
	
	# COOKIE LOGIN
	if ($type eq "cookielogin1" ) {
		$param->{url} = "https://".$hash->{helper}{SERVER}."/";
		$param->{method} = "GET";
		$param->{ignoreredirects} = 1;
		$param->{header} = "User-Agent: ".$UserAgent."\r\nAccept-Language: de,en\r\nDNT: 1\r\nConnection: keep-alive\r\nUpgrade-Insecure-Requests: 1";
		$param->{callback} = \&echodevice_Parse;
		$param->{type} = $type;
		$param->{hash} = $hash;
		$param->{timeout} = 10;
		$param->{httpversion} = "1.1";
		
		#Daten zurücksetzen
		$hash->{helper}{"login_postdata"}     = "";
		$hash->{helper}{"login_location"}     = "";
		$hash->{helper}{"login_sessionid"}    = "";
		$hash->{helper}{"login_cookiestring"} = "";
		
		readingsSingleUpdate ($hash, "COOKIE", "" ,0);
		readingsSingleUpdate ($hash, "COOKIE_TYPE",  "NEW" ,0);
		readingsSingleUpdate ($hash, "COOKIE_STATE", "START" ,0);
	}

	if ($type eq "cookielogin2" ) {
		$param->{url} = "https://".$hash->{helper}{SERVER}."/";
		$param->{method} = "GET";
		$param->{header} = "User-Agent: ".$UserAgent."\r\nAccept-Language: de,en\r\nDNT: 1\r\nConnection: keep-alive\r\nUpgrade-Insecure-Requests: 1";
		$param->{callback} = \&echodevice_Parse;
		$param->{type} = $type;
		$param->{hash} = $hash;
		$param->{timeout} = 10;
		$param->{httpversion} = "1.1";
	}

	if ($type eq "cookielogin3" ) {
	
		my $location     = $hash->{helper}{"login_location"};
		my $cookiestring = $hash->{helper}{"login_cookiestring"};
		my $postdata     = $hash->{helper}{"login_postdata"};
	
		$param->{url} = "https://www.amazon.de/ap/signin";
		$param->{method} = "POST";
		$param->{header} = "User-Agent: ".$UserAgent."\r\nAccept-Language: de,en\r\nDNT: 1\r\nConnection: keep-alive\r\nUpgrade-Insecure-Requests: 1\r\nReferer: $location\r\nCookie: $cookiestring";
		$param->{callback} = \&echodevice_Parse;
		$param->{data} = $postdata;
		$param->{type} = $type;
		$param->{hash} = $hash;
		$param->{timeout} = 10;
		$param->{httpversion} = "1.1";
	}

	if ($type eq "cookielogin4" ) {
	
		my $location     = $hash->{helper}{"login_location"};
		my $cookiestring = $hash->{helper}{"login_cookiestring"};
		my $postdata     = $hash->{helper}{"login_postdata"};
		my $sessionid    = $hash->{helper}{"login_sessionid"};
		my $zweiFA       = $hash->{helper}{TWOFA};
	
		if ($hash->{helper}{TWOFA} eq "") {
			readingsSingleUpdate ($hash, "2FACode", "not used" ,0);
		}
		else {
			readingsSingleUpdate ($hash, "2FACode", "used " .$hash->{helper}{TWOFA} ,0);
		}
	
		$param->{url}    = "https://www.amazon.de/ap/signin";
		$param->{method} = "POST";
		$param->{header} = "User-Agent: ".$UserAgent."\r\nAccept-Language: de,en\r\nDNT: 1\r\nConnection: keep-alive\r\nUpgrade-Insecure-Requests: 1\r\nReferer: https://www.amazon.de/ap/signin/$sessionid\r\nCookie: $cookiestring";
		$param->{callback} = \&echodevice_Parse;
		$param->{data}   = $postdata."email=".uri_escape(echodevice_decrypt($hash->{helper}{USER}))."&password=".uri_escape(echodevice_decrypt($hash->{helper}{PASSWORD})).$zweiFA;
		$param->{ignoreredirects} = 1;
		$param->{type}   = $type;
		$param->{hash}   = $hash;
		$param->{timeout} = 10;
		$param->{httpversion} = "1.1";
		$hash->{helper}{TWOFA} = "";
	}

	if ($type eq "cookielogin5" ) {

		my $cookiestring = $hash->{helper}{"login_cookiestring"};
	
		$param->{url}    = "https://".$hash->{helper}{SERVER}."/api/bootstrap?version=0&_=".int(time);
		$param->{header} = "User-Agent: ".$UserAgent."\r\nAccept-Language: de,en\r\nDNT: 1\r\nConnection: keep-alive\r\nUpgrade-Insecure-Requests: 1\r\nReferer: https://".$hash->{helper}{SERVER}."/spa/index.html\r\nOrigin: https://".$hash->{helper}{SERVER}."\r\nCookie: $cookiestring";
		$param->{callback} = \&echodevice_Parse;
		$param->{type}   = $type;
		$param->{hash}   = $hash;
		$param->{httpversion} = "1.1";
	}
	
	if ($type eq "cookielogin6" ) {
		$param->{url}        = "https://".$hash->{helper}{SERVER}."/api/bootstrap";
		$param->{header}     = 'Cookie: '.$hash->{helper}{COOKIE};
		$param->{callback}   = \&echodevice_ParseAuth;
		$param->{noshutdown} = 1;
		$param->{type}       = $type;
		$param->{hash}       = $hash;
		$param->{timeout} = 10;
		$param->{httpversion} = "1.1";
	}	
	
    HttpUtils_NonblockingGet($param);
	
}

sub echodevice_Parse($$$) {
	my ($param, $err, $data) = @_;
	my $hash = $param->{hash};
	my $name = $hash->{NAME};
	my $msgtype = $param->{type};
  
	Log3 $name, 5, "[$name] [$msgtype]" . Dumper(echodevice_anonymize($hash, $data));

	$hash->{helper}{RUNNING_REQUEST} = 0;
	
	# COOKIE LOGIN Part
	if($msgtype eq "cookielogin1") {

		my $location = $param->{httpheader};
		$location =~ /Location: (.+?)\s/;
		$location = $1;
	
		$hash->{helper}{"login_location"} = $location;
		echodevice_SendLoginCommand($hash,"cookielogin2","");
		return;
	}

	if($msgtype eq "cookielogin2") {

		my (@cookies) = ($param->{httpheader} =~ /Set-Cookie: (.*)\s/g);

		my $cookiestring = "";
		foreach my $cookie (@cookies){
			next if($cookie =~ /1970/);
			$cookie =~ /(.*) (expires=|Version=|Domain)/;
			$cookiestring .= $1." ";
		} 

		my @formparams = ('appActionToken', 'appAction', 'showRmrMe', 'openid.return_to', 'prevRID', 'openid.identity', 'openid.assoc_handle', 'openid.mode', 'failedSignInCount', 'openid.claimed_id', 'pageId', 'openid.ns', 'showPasswordChecked');
		my $postdata = "";
		foreach my $formparam (@formparams){
			my $value = ($data =~ /type="hidden" name="$formparam" value="(.*)"/);
			$value = $1;
			$value =~ /^(.*?)"/;
    		$postdata .= $formparam."=".$1."&"
		} 
	
		$hash->{helper}{"login_postdata"}     = $postdata;
		$hash->{helper}{"login_cookiestring"} = $cookiestring;
		echodevice_SendLoginCommand($hash,"cookielogin3","");
		return;
	}

	if($msgtype eq "cookielogin3") {

		my @formparams = ('appActionToken', 'appAction', 'showRmrMe', 'openid.return_to', 'prevRID', 'openid.identity', 'openid.assoc_handle', 'openid.mode', 'failedSignInCount', 'openid.claimed_id', 'pageId', 'openid.ns', 'showPasswordChecked');
		my $postdata = "";
		foreach my $formparam (@formparams){
			my $value = ($data =~ /type="hidden" name="$formparam" value="(.*)"/);
			$value = $1;
			$value =~ /^(.*?)"/;
			$postdata .= $formparam."=".$1."&"
		} 

		my (@cookies2) = ($param->{httpheader} =~ /Set-Cookie: (.*)\s/g);
  
		my $sessionid = "";
		my $cookiestring2 = "";
		foreach my $cookie (@cookies2){
			next if($cookie =~ /1970/);
			$cookie =~ /(.*) (expires|Version|Domain)/;
			$cookiestring2 .= $1." ";
			$cookiestring2 =~ /ubid-acbde=(.*);/;
			$sessionid = $1;
		} 
	
		$hash->{helper}{"login_postdata"}     = $postdata;
		$hash->{helper}{"login_sessionid"}    = $sessionid;
		$hash->{helper}{"login_cookiestring"}.= $cookiestring2;
		echodevice_SendLoginCommand($hash,"cookielogin4","");
		return;
	}	

	if($msgtype eq "cookielogin4") {

		my (@cookies3) = ($param->{httpheader} =~ /Set-Cookie: (.*)\s/g);
  
		my $cookiestring3 = "";
		my $cookiestring  = $hash->{helper}{"login_cookiestring"};
		
		foreach my $cookie (@cookies3){
			#Log3 $name, 5, "Cookie: ".$cookie;
			next if($cookie =~ /1970/);
			$cookie =~ s/Version=1; //g;
			$cookie =~ /(.*) (expires|Version|Domain)/;
			$cookie = $1;
			next if($cookiestring =~ /\Q$cookie\E/);
			$cookiestring3 .= $cookie." ";
		} 

		$hash->{helper}{"login_cookiestring"}.= $cookiestring3;
		echodevice_SendLoginCommand($hash,"cookielogin5","");
		return;
	}		

	if($msgtype eq "cookielogin5") {

		my (@cookies4) = ($param->{httpheader} =~ /Set-Cookie: (.*)\s/g);
		my $cookiestring4 = "";
		my $cookiestring  = $hash->{helper}{"login_cookiestring"};
		
		foreach my $cookie (@cookies4){
			#Log3 $name, 5, "Cookie: ".$cookie;
			next if($cookie =~ /1970/);
			$cookie =~ s/Version=1; //g;
			$cookie =~ /(.*) (expires|Version)/;
			$cookie = $1;
			next if($cookiestring =~ /\Q$cookie\E/);
			$cookiestring4 .= $cookie." ";
		} 
		$cookiestring .= $cookiestring4;

		$hash->{helper}{"login_cookiestring"}.= $cookiestring4;
		
		if($cookiestring =~ /doctype html/) {
			RemoveInternalTimer($hash);
			Log3 $name, 4, "[$name] Login failed";
			readingsBeginUpdate($hash);
			readingsBulkUpdateIfChanged($hash, "state", "unauthorized", 1);
			readingsEndUpdate($hash,1);
			$hash->{STATE} = "LOGIN ERROR";
			return undef;
		}
	
		$hash->{helper}{COOKIE} = $cookiestring;
		$hash->{helper}{COOKIE} =~ /csrf=([-\w]+)[;\s]?(.*)?$/ if(defined($hash->{helper}{COOKIE}));
		$hash->{helper}{CSRF} = $1  if(defined($hash->{helper}{COOKIE}));

		if(defined($hash->{helper}{COOKIE})){
			readingsSingleUpdate ($hash, "COOKIE", $hash->{helper}{COOKIE} ,0); # Cookie als READING festhalten!
			readingsSingleUpdate ($hash, "COOKIE_TYPE", "NEW" ,0);
			echodevice_SendCommand($hash,"devices","");
		}
		echodevice_SendLoginCommand($hash,"cookielogin6","");
		return;
	}	

	if($msgtype eq "cookielogin6") {
		readingsSingleUpdate ($hash, "COOKIE_STATE", "OK" ,0);
		return;
	}
	
	if($msgtype eq "notifications_delete" || $msgtype eq "reminderitem") {
		
		my $IODev = $hash->{IODev}->{NAME};
		Log3 $name, 5, "[$name] sendToFHEM get $IODev settings";
		print (fhem( "get $IODev settings" )) ;
		
		echodevice_HandleCmdQueue($hash);
		return;
	}
    
	if($data =~ /doctype html/ || $data =~ /cookie is missing/){
		RemoveInternalTimer($hash);
		Log3 $name, 4, "[$name] Invalid cookie";
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "state", "unauthorized", 1);
		readingsEndUpdate($hash,1);
		$hash->{STATE} = "COOKIE ERROR";
		#InternalTimer( gettimeofday() + 10, "echodevice_CheckAuth", $hash, 0) if($hash->{model} eq "ACCOUNT");
		echodevice_HandleCmdQueue($hash);
		return undef;
	}

	if($err){
		if($hash->{model} eq "ACCOUNT") {
			echodevice_setState($hash,"disconnected");
			if ($hash->{helper}{RUNLOGIN} == 0) {
				InternalTimer(gettimeofday() + 10 , "echodevice_LoginStart" , $hash, 0);
				$hash->{helper}{RUNLOGIN} = 1;
			}
		}
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "state", "disconnected", 1);
		readingsEndUpdate($hash,1);
		Log3 $name, 4, "[$name] [$msgtype] connection error $msgtype $err";
		echodevice_HandleCmdQueue($hash);
		return undef;
	}
  
	if($data =~ /No routes found/){

		# Spezial set Volume
		if ($msgtype eq "command") {}
		else {
			Log3 $name, 4, "[$name] No routes found $msgtype";
			readingsBeginUpdate($hash);
			readingsBulkUpdateIfChanged($hash, "state", "timeout", 1);	
			readingsEndUpdate($hash,1);
		}

		echodevice_HandleCmdQueue($hash);
		return undef;
	}
	
	if($data =~ /UnknownOperationException/){
		Log3 $name, 4, "[$name] Unknown Operation";
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "state", "unknown", 1);
		readingsEndUpdate($hash,1);
		echodevice_HandleCmdQueue($hash);
		return undef;
	}

	if($msgtype eq "null"){
		echodevice_HandleCmdQueue($hash);
		return undef;
	}
	
	elsif($msgtype eq "setting") {
		InternalTimer( gettimeofday() + 3, "echodevice_GetSettings", $hash, 0);
		echodevice_HandleCmdQueue($hash);
		return undef;
	}
	
	elsif($msgtype eq "command") {
		InternalTimer( gettimeofday() + 3, "echodevice_GetSettings", $hash, 0);
		echodevice_HandleCmdQueue($hash);
		return undef;
	}
	
	elsif($msgtype eq "primeplaylist") {
		echodevice_HandleCmdQueue($hash);
		return undef;
	}
	
	elsif($msgtype eq "track") {
		echodevice_HandleCmdQueue($hash);
		return undef;
	}
	
	elsif($msgtype eq "primeplayeigeneplaylist" || $msgtype eq "primeplayeigene" || $msgtype eq "primeplaysender") {
		echodevice_HandleCmdQueue($hash);
		return undef;
	}
	
	elsif($msgtype eq "textmessage") {
		echodevice_HandleCmdQueue($hash);
		return undef;
	}
	
	elsif($msgtype eq "volume_alarm") {
		echodevice_HandleCmdQueue($hash);
		return undef;
	}
	
	elsif($msgtype eq "bluetooth_disconnect") {
		echodevice_HandleCmdQueue($hash);
		return undef;
	}
	
	elsif($msgtype eq "bluetooth_connect") {
		echodevice_HandleCmdQueue($hash);
		return undef;
	}
	
	elsif($msgtype eq "dnd") {
		echodevice_HandleCmdQueue($hash);
		return undef;
	}

	elsif($msgtype eq "list") {
		echodevice_HandleCmdQueue($hash);
		return undef;
	}	

	elsif($msgtype eq "item_task_delete" || $msgtype eq "item_task_add") {
		echodevice_HandleCmdQueue($hash);
		echodevice_SendCommand($hash,"listitems_task","TASK");
		return undef;
	}		

	elsif($msgtype eq "item_shopping_delete" || $msgtype eq "item_shopping_add") {
		echodevice_HandleCmdQueue($hash);
		echodevice_SendCommand($hash,"listitems_shopping","SHOPPING_ITEM");
		return undef;
	}	

	if($@) {
		if($data =~ /doctype html/ || $data =~ /cookie is missing/){
			RemoveInternalTimer($hash);
			Log3 $name, 4, "[$name] Invalid cookie";
			readingsBeginUpdate($hash);
			readingsBulkUpdateIfChanged($hash, "state", "unauthorized", 1);
			readingsEndUpdate($hash,1);
			$hash->{STATE} = "COOKIE ERROR";
			#InternalTimer( gettimeofday() + 10, "echodevice_CheckAuth", $hash, 0) if($hash->{model} eq "ACCOUNT");
			echodevice_HandleCmdQueue($hash);
			return undef;
		}
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "state", "error", 1);
		readingsEndUpdate($hash,1);
		Log3 $name, 4, "[$name] json evaluation error ".$@."\n".Dumper(echodevice_anonymize($hash, $data));
		echodevice_HandleCmdQueue($hash);
		return undef;
	}

	readingsBeginUpdate($hash);
	readingsBulkUpdateIfChanged($hash, "state", "connected", 1);
	readingsEndUpdate($hash,1);

	# Prüfen ob es sich um ein json String handelt!
	if (index($data, '{') == -1) {$data = '{"data": "nodata"}';}
	
	my $json = eval { JSON->new->utf8(0)->decode($data) };
		
	if($msgtype eq "activities") {

		if(defined($json->{activities}) && ref($json->{activities}) eq "ARRAY") {
			foreach my $card (@{$json->{activities}}) {
				# Device ID herausfiltern
				my $sourceDeviceIds = ""; 
				foreach my $cards (@{$card->{sourceDeviceIds}}) {
					next if (echodevice_getModel($cards->{deviceType}) eq "Echo Multiroom");
					next if (echodevice_getModel($cards->{deviceType}) eq "Sonos Display");
					next if (echodevice_getModel($cards->{deviceType}) eq "unbekannt");
					$sourceDeviceIds = $cards->{serialNumber};
				}
			
				# Informationen in das ECHO Device eintragen
				if(defined($hash->{helper}{"ECHODEVICES"}{$sourceDeviceIds})) {
					
					my $echohash = $hash->{helper}{"ECHODEVICES"}{$sourceDeviceIds};
					my $timestamp = int(time - ReadingsAge($echohash->{NAME},'voice',time));
					
					next if($timestamp >= int($card->{creationTimestamp}/1000));
					next if($card->{description} !~ /firstUtteranceId/);
				  
					my $textjson = $card->{description};
					$textjson =~ s/\\//g;
					my $cardjson = eval { JSON->new->utf8(0)->decode($textjson) };

					next if($@);
					next if(!defined($cardjson->{summary}));
					next if($cardjson->{summary} eq "");
					
					$echohash->{".updateTimestamp"} = FmtDateTime(int($card->{creationTimestamp}/1000));
					readingsBeginUpdate($echohash);
					readingsBulkUpdateIfChanged($echohash, "voice", $cardjson->{summary}, 1);
					readingsEndUpdate($echohash,1);
					$echohash->{CHANGETIME}[0] = FmtDateTime(int($card->{creationTimestamp}/1000));
				}	
			}
		}
	} 
  
  	elsif($msgtype eq "account") {
		my $i=1;

		if ($data eq '{"data": "nodata"}') {
			Log3 $name, 3, "[$name] [$msgtype] Invalid authentication token! Generate new COOKIE!" ;
			echodevice_SendLoginCommand($hash,"cookielogin1","");
		}
		else {
			if(ref($json) eq 'ARRAY') {
				foreach my $account (@{$json}) {
				  $hash->{helper}{COMMSID}  = $account->{commsId} if(defined($account->{commsId}));
				  $hash->{helper}{DIRECTID} = $account->{directedId} if(defined($account->{directedId}));
				  last if(1<$i++);
				}			
			}
			else {
				Log3 $name, 3, "[$name] [$msgtype] Invalid DATA! = $data / Generate new COOKIE!" ;
				echodevice_SendLoginCommand($hash,"cookielogin1","");
			}
		}
	}
	
	elsif($msgtype eq "cards") {
		my $timestamp = int(time - ReadingsAge($name,'voice',time));
		return undef if(!defined($json->{cards}));
		return undef if(ref($json->{cards}) ne "ARRAY");
		foreach my $card (reverse(@{$json->{cards}})) {
			#next if($card->{cardType} ne "TextCard");
			#next if($card->{sourceDevice}{serialNumber} ne $hash->{helper}{SERIAL});
			next if($timestamp >= int($card->{creationTimestamp}/1000));
			next if(!defined($card->{playbackAudioAction}{mainText}));
			readingsBeginUpdate($hash);
			$hash->{".updateTimestamp"} = FmtDateTime(int($card->{creationTimestamp}/1000));
			readingsBulkUpdateIfChanged( $hash, "voice", $card->{playbackAudioAction}{mainText}, 1 );
			$hash->{CHANGETIME}[0] = FmtDateTime(int($card->{creationTimestamp}/1000));
			readingsEndUpdate($hash,1);
		}
		return undef;
	} 
  
	elsif($msgtype eq "media") {

		readingsBeginUpdate($hash);
		
		if (defined($json->{currentState} )) {
			if ($json->{currentState} ne "IDLE") {
				echodevice_SendCommand($hash,"player",""); # Player läuft! Daten abfragen!
			}
			else {
				readingsBulkUpdateIfChanged($hash, "progress", "0", 1);
				readingsBulkUpdateIfChanged($hash, "progresslen", "0", 1);
				readingsBulkUpdateIfChanged($hash, "shuffle", $json->{shuffling}?"on":"off", 1) if(defined($json->{shuffling}));
				readingsBulkUpdateIfChanged($hash, "repeat", $json->{looping}?"on":"off", 1) if(defined($json->{looping}));
				readingsBulkUpdateIfChanged($hash, "volume", $json->{volume}, 1) if(defined($json->{volume}));
				readingsBulkUpdateIfChanged($hash, "mute", $json->{muted}?"on":"off", 1) if(defined($json->{muted}));		
			}
		}

		readingsEndUpdate($hash,1);
	} 
  
	elsif($msgtype eq "player") {
	
		# Beenden wenn keine Daten vorhanden!
		if(defined($json->{playerInfo})){
			readingsBeginUpdate($hash);

			# Play Status
			if(!defined($json->{playerInfo}{state}) || $json->{playerInfo}{state} eq "IDLE" ){
				readingsBulkUpdateIfChanged($hash, "playStatus", "stopped", 1);
				readingsBulkUpdateIfChanged($hash, "currentArtwork", "-", 1);
				readingsBulkUpdateIfChanged($hash, "currentTitle", "-", 1);
				readingsBulkUpdateIfChanged($hash, "currentArtist", "-", 1);
				readingsBulkUpdateIfChanged($hash, "currentAlbum", "-", 1);
				readingsBulkUpdateIfChanged($hash, "channel", "-", 1);
				readingsBulkUpdateIfChanged($hash, "progress", 0, 1);
				readingsBulkUpdateIfChanged($hash, "progresslen", 0, 1);
			}
			else {
				
				readingsBulkUpdateIfChanged($hash, "playStatus",  lc($json->{playerInfo}{state}), 1);
				
				if(defined($json->{playerInfo}{infoText})) {
					readingsBulkUpdateIfChanged($hash, "currentTitle", $json->{playerInfo}{infoText}{title}, 1) if(defined($json->{playerInfo}{infoText}{title}));
					readingsBulkUpdateIfChanged($hash, "currentArtist", $json->{playerInfo}{infoText}{subText1}, 1) if(defined($json->{playerInfo}{infoText}{subText1}));
					readingsBulkUpdateIfChanged($hash, "currentAlbum", $json->{playerInfo}{infoText}{subText2}, 1) if(defined($json->{playerInfo}{infoText}{subText2}));
					readingsBulkUpdateIfChanged($hash, "currentTitle", "-", 1) if(!defined($json->{playerInfo}{infoText}{title}));
					readingsBulkUpdateIfChanged($hash, "currentArtist", "-", 1) if(!defined($json->{playerInfo}{infoText}{subText1}));
					readingsBulkUpdateIfChanged($hash, "currentAlbum", "-", 1) if(!defined($json->{playerInfo}{infoText}{subText2}));
				}
				
				if(defined($json->{playerInfo}{provider})) {
					readingsBulkUpdateIfChanged($hash, "channel", $json->{playerInfo}{provider}{providerName}, 1) if(defined($json->{playerInfo}{provider}{providerName}));
				} else {
					readingsBulkUpdateIfChanged($hash, "channel", "-", 1);
				}
				
				if(defined($json->{playerInfo}{mainArt})) {
					if(defined($json->{playerInfo}{mainArt}{url})){
						readingsBulkUpdateIfChanged($hash, "currentArtwork", $json->{playerInfo}{mainArt}{url}, 1)
					}
					else{
						readingsBulkUpdateIfChanged($hash, "currentArtwork", "-", 1);
					}
				}
				
				if(defined($json->{playerInfo}{progress})) {
					readingsBulkUpdateIfChanged($hash, "progress", $json->{playerInfo}{progress}{mediaProgress}, 1) if(defined($json->{playerInfo}{progress}{mediaProgress}));
					readingsBulkUpdateIfChanged($hash, "progress", 0, 1) if(!defined($json->{playerInfo}{progress}{mediaProgress}));
					readingsBulkUpdateIfChanged($hash, "progresslen", $json->{playerInfo}{progress}{mediaLength}, 1) if(defined($json->{playerInfo}{progress}{mediaLength}));
					readingsBulkUpdateIfChanged($hash, "progresslen", 0, 1) if(!defined($json->{playerInfo}{progress}{mediaLength}));
				}
				
				if(defined($json->{playerInfo}{volume})) {
					readingsBulkUpdateIfChanged($hash, "volume", $json->{playerInfo}{volume}{volume}, 1) if(defined($json->{playerInfo}{volume}{volume}));
					readingsBulkUpdateIfChanged($hash, "mute", $json->{playerInfo}{volume}{muted}?"on":"off", 1) if(defined($json->{playerInfo}{volume}{muted}));
				}
				
				if(defined($json->{playerInfo}{transport}{shuffle})) {
					if($json->{playerInfo}{transport}{shuffle} eq "SELECTED") {readingsBulkUpdateIfChanged($hash, "shuffle", "true", 1);}
					else{readingsBulkUpdateIfChanged($hash, "shuffle", "false", 1);}
				}
				
				if(defined($json->{playerInfo}{transport}{repeat})) {
					if($json->{playerInfo}{transport}{repeat} eq "SELECTED") {readingsBulkUpdateIfChanged($hash, "repeat", "true", 1);}
					else{readingsBulkUpdateIfChanged($hash, "repeat", "false", 1);}
				}
			}
			readingsEndUpdate($hash,1);
		}
	} 
  
	elsif($msgtype eq "listitems_task" || $msgtype eq "listitems_shopping" ) {
		my $listtype ;#= $param->{listtype};
		my @listitems;
		my $Firststart = "1";
		my $Text ;
		
		$listtype = "TASK" if ($msgtype eq "listitems_task");
		$listtype = "SHOPPING_ITEM" if ($msgtype eq "listitems_shopping");
		
		foreach my $item ( @{ $json->{values} } ) {
		  
			if ($Firststart eq "1"){
				$hash->{helper}{"ITEMS"}{$item->{type}} = ();
				$Firststart = "0";
			}
		  
			next if ($item->{complete});
			$item->{text} =~ s/,/;/g;
			$item->{text} =~ s/ /_/g;		  
			$Text = $item->{text};
			push @listitems, $item->{text};

			$hash->{helper}{"ITEMS"}{$item->{type}}{$item->{text}} = $item->{itemId};
		  		  
		}
		readingsBeginUpdate($hash);
		
		if (@listitems) {
			readingsBulkUpdateIfChanged( $hash, "list_".$listtype, join(",", @listitems),  1 );
		} else {
			readingsBulkUpdateIfChanged( $hash, "list_".$listtype, "",  1 );
		}
		
		readingsEndUpdate($hash,1);
	} 

	elsif($msgtype eq "getnotifications") {
		my @ncstrings;
		@ncstrings = ();
		$hash->{helper}{"notifications"} = ();
		my $RunningID = time();
		my $NotifiCount ;
		my $NotifiReTime = 99999999;
		my $TimerReTime = 99999999 ;
		my $iFrom ;
		
		foreach my $device (@{$json->{notifications}}) {
			
			next if ($device->{status} eq "OFF" && (lc($device->{type}) ne "reminder" || lc($device->{type}) ne "timer"));

			my $ncstring ;
				
			if(lc($device->{type}) eq "reminder") {
				$ncstring  = $device->{type} . "_" . FmtDateTime($device->{alarmTime}/1000) . "_";
				$ncstring .= $device->{recurringPattern} . "_" if (defined($device->{recurringPattern}));
				$ncstring .= $device->{reminderLabel} ;
			}
			elsif(lc($device->{type}) eq "timer") {
				$ncstring = $device->{type} . "_" . $device->{remainingTime}
			}
			else {
				$ncstring = $device->{type} . "_" . $device->{originalTime} ;			
			}
			$hash->{helper}{"notifications"}{$device->{deviceSerialNumber}}{$device->{notificationIndex}} = $ncstring;
			
			#Reading anlegen
			my $echohash = $hash->{helper}{"ECHODEVICES"}{$device->{deviceSerialNumber}};
			
			if (!defined($hash->{helper}{"notifications"}{"_".$device->{deviceSerialNumber}}{"count_" . $device->{type}})) {
				$NotifiCount = 1;
			}
			else {
				$NotifiCount = int($hash->{helper}{"notifications"}{"_".$device->{deviceSerialNumber}}{"count_" . $device->{type}}) + 1
			}
			
			next if(!defined($echohash));
			
			readingsBeginUpdate($echohash);
			
			if(lc($device->{type}) eq "reminder") {
				readingsBulkUpdateIfChanged( $echohash, lc($device->{type}) . "_" . sprintf("%02d",$NotifiCount) . "_alarmtime"  , FmtDateTime($device->{alarmTime}/1000), 1 );
				readingsBulkUpdateIfChanged( $echohash, lc($device->{type}) . "_" . sprintf("%02d",$NotifiCount) . "_alarmticks"  , $device->{alarmTime}/1000, 1 );
				readingsBulkUpdateIfChanged( $echohash, lc($device->{type}) . "_" . sprintf("%02d",$NotifiCount) . "_id"  , $device->{notificationIndex},1);
				readingsBulkUpdateIfChanged( $echohash, lc($device->{type}) . "_" . sprintf("%02d",$NotifiCount) . "_recurring"  , $device->{recurringPattern},1) if (defined($device->{recurringPattern}));
				readingsBulkUpdateIfChanged( $echohash, lc($device->{type}) . "_" . sprintf("%02d",$NotifiCount) . "_recurring"  , 0,1) if (!defined($device->{recurringPattern}));
			}
			elsif(lc($device->{type}) eq "timer") {
				readingsBulkUpdateIfChanged( $echohash, lc($device->{type}) . "_" . sprintf("%02d",$NotifiCount) . "_remainingtime"  , int($device->{remainingTime} / 1000), 1 );
				readingsBulkUpdateIfChanged( $echohash, lc($device->{type}) . "_" . sprintf("%02d",$NotifiCount) . "_id"  , $device->{notificationIndex},1);
				
				if (int($device->{remainingTime} / 1000) < $TimerReTime) {
					$TimerReTime = int($device->{remainingTime} / 1000);
					readingsBulkUpdateIfChanged( $echohash, lc($device->{type}) . "_remainingtime"  , int($device->{remainingTime} / 1000), 1 );
					readingsBulkUpdateIfChanged( $echohash, lc($device->{type}) . "_id"  , $device->{notificationIndex},1);
				}
				
				if ($TimerReTime <$NotifiReTime) {$NotifiReTime = $TimerReTime;}
			}
			else {
				readingsBulkUpdateIfChanged( $echohash, lc($device->{type}) . "_" . sprintf("%02d",$NotifiCount) . "_originalTime"  , $device->{originalTime}, 1 );
				readingsBulkUpdateIfChanged( $echohash, lc($device->{type}) . "_" . sprintf("%02d",$NotifiCount) . "_id"  , $device->{notificationIndex},1);
				readingsBulkUpdateIfChanged( $echohash, lc($device->{type}) . "_" . sprintf("%02d",$NotifiCount) . "_status"  , lc($device->{status}),1);
			}

			# Infos im Hash hinterlegen
			$hash->{helper}{"notifications"}{"_".$device->{deviceSerialNumber}}{"count_" . $device->{type}} = $NotifiCount;
			$hash->{helper}{"notifications"}{"_".$device->{deviceSerialNumber}}{lc($device->{type})."_aktiv"} = 1;

			readingsBulkUpdateIfChanged( $echohash, lc($device->{type}) . "_count"  , $NotifiCount,1);
			
			readingsEndUpdate($echohash,1);
			
		}

		# Timer neu setzen wenn der Timer gleich abläuft
		if ($NotifiReTime < 60 && $NotifiReTime > 0) {InternalTimer(gettimeofday() + $NotifiReTime , "echodevice_GetSettings", $hash, 0);}
		
		# Readings bereinigen
		my $nextupdate = int(AttrVal($name,"intervalsettings",60));
		
		foreach my $DeviceID (sort keys %{$hash->{helper}{"ECHODEVICES"}}) {

			next if (echodevice_getModel($hash->{helper}{"ECHODEVICES"}{$DeviceID}{model}) eq "Echo Multiroom");
			next if (echodevice_getModel($hash->{helper}{"ECHODEVICES"}{$DeviceID}{model}) eq "Sonos Display");
			next if (echodevice_getModel($hash->{helper}{"ECHODEVICES"}{$DeviceID}{model}) eq "unbekannt");

			my $DeviceName = $hash->{helper}{"ECHODEVICES"}{$DeviceID}{NAME};
			my $echohash   = $hash->{helper}{"ECHODEVICES"}{$DeviceID};
			readingsBeginUpdate($echohash);

			# Timer auswerten
			my $TimerAktiv = 0;
			foreach my $i (1..20) {
				my $ReadingAge = int(ReadingsAge($DeviceName, "timer_" . sprintf("%02d",$i) . "_remainingtime", 2000));
				
				if ($ReadingAge == 2000){last;} 
				elsif ($ReadingAge > $nextupdate) {
					readingsDelete($echohash, "timer_" . sprintf("%02d",$i) . "_id") ;
					readingsDelete($echohash, "timer_" . sprintf("%02d",$i) . "_remainingtime") ;
				}
				else {$TimerAktiv=1;}
			}
			
			if ($TimerAktiv == 0) {
				readingsBulkUpdateIfChanged( $echohash, "timer_count"  , 0,1);
				readingsBulkUpdateIfChanged( $echohash, "timer_id"  , "-",1);
				readingsBulkUpdateIfChanged( $echohash, "timer_remainingtime"  , 0,1);
			}

			# Erinnerungen auswerten			
			my $ReminderAktiv = 0;
			$ReminderAktiv = $hash->{helper}{"notifications"}{"_".$DeviceID}{"reminder_aktiv"} if (defined($hash->{helper}{"notifications"}{"_".$DeviceID}{"reminder_aktiv"}));
		
			if ($ReminderAktiv eq "0") {
				readingsBulkUpdateIfChanged( $echohash, "reminder_count"  , 0,1);
			}
			else {
				$hash->{helper}{"notifications"}{"_".$DeviceID}{"reminder_aktiv"} = 0
			}

			$iFrom = int(ReadingsVal($DeviceName, "reminder_count", 0)) +1 ;
			
			foreach my $i ($iFrom..20) {
				
				if (ReadingsVal($DeviceName, "reminder_" . sprintf("%02d",$i) . "_alarmticks", "none") ne "none"){
					readingsDelete($echohash, "reminder_" . sprintf("%02d",$i) . "_id") ;
					readingsDelete($echohash, "reminder_" . sprintf("%02d",$i) . "_alarmticks") ;
					readingsDelete($echohash, "reminder_" . sprintf("%02d",$i) . "_alarmtime") ;
					readingsDelete($echohash, "reminder_" . sprintf("%02d",$i) . "_recurring") ;
				}
				else {last;}
			}
			
			# Alarm auswerten
			my $AlarmAktiv = 0;
			$AlarmAktiv = $hash->{helper}{"notifications"}{"_".$DeviceID}{"alarm_aktiv"} if (defined($hash->{helper}{"notifications"}{"_".$DeviceID}{"alarm_aktiv"}));
		
			if ($AlarmAktiv eq "0") {
				readingsBulkUpdateIfChanged( $echohash, "alarm_count"  , 0,1);
			}
			else {
				$hash->{helper}{"notifications"}{"_".$DeviceID}{"alarm_aktiv"} = 0
			}

			$iFrom = int(ReadingsVal($DeviceName, "alarm_count", 0)) +1 ;
			
			foreach my $i ($iFrom..20) {
				
				if (ReadingsVal($DeviceName, "alarm_" . sprintf("%02d",$i) . "_id", "none") ne "none"){
					readingsDelete($echohash, "alarm_" . sprintf("%02d",$i) . "_id") ;
					readingsDelete($echohash, "alarm_" . sprintf("%02d",$i) . "_originalTime") ;
					readingsDelete($echohash, "alarm_" . sprintf("%02d",$i) . "_status") ;
				}
				else {last;}
			}
			
			# Musikalarm auswerten
			my $MusikAlarmAktiv = 0;
			$MusikAlarmAktiv = $hash->{helper}{"notifications"}{"_".$DeviceID}{"musikalarm_aktiv"} if (defined($hash->{helper}{"notifications"}{"_".$DeviceID}{"musicalarm_aktiv"}));
		
			if ($MusikAlarmAktiv eq "0") {
				readingsBulkUpdateIfChanged( $echohash, "musicalarm_count"  , 0,1);
			}
			else {
				$hash->{helper}{"notifications"}{"_".$DeviceID}{"musicalarm_aktiv"} = 0
			}

			$iFrom = int(ReadingsVal($DeviceName, "musicalarm_count", 0)) +1 ;
			
			foreach my $i ($iFrom..20) {
				
				if (ReadingsVal($DeviceName, "musicalarm_" . sprintf("%02d",$i) . "_id", "none") ne "none"){
					readingsDelete($echohash, "musicalarm_" . sprintf("%02d",$i) . "_id") ;
					readingsDelete($echohash, "musicalarm_" . sprintf("%02d",$i) . "_originalTime") ;
					readingsDelete($echohash, "musicalarm_" . sprintf("%02d",$i) . "_status") ;
				}
				else {last;}
			}
			
			readingsEndUpdate($echohash,1);
		}
	} 
		
	elsif($msgtype eq "homegroup") {
		$hash->{helper}{HOMEGROUP} = $json->{homeGroupId} if(defined($json->{homeGroupId}));
		$hash->{helper}{SIPS} = $json->{aor} if(defined($json->{aor}));
	} 
	
	elsif($msgtype eq "bluetoothstate") {
		my @btstrings;
		
		foreach my $device (@{$json->{bluetoothStates}}) {
			@btstrings = ();
			if(defined($hash->{helper}{"ECHODEVICES"}{$device->{deviceSerialNumber}})) {
				foreach my $btdevice (@{$device->{pairedDeviceList}}) {
					next if(!defined($btdevice->{friendlyName}));
					next if (echodevice_getModel($btdevice->{deviceType}) eq "Reverb");
					next if (echodevice_getModel($btdevice->{deviceType}) eq "unbekannt");
					
					$btdevice->{address} =~ s/:/-/g;
					$btdevice->{friendlyName} =~ s/ /_/g;
					$btdevice->{friendlyName} =~ s/,/./g;
					my $btstring .= $btdevice->{address}."/".$btdevice->{friendlyName};
					push @btstrings, $btstring;
				}
				$hash->{helper}{"ECHODEVICES"}{$device->{deviceSerialNumber}}->{helper}{bluetooth} = join(",", @btstrings) if (@btstrings);
				$hash->{helper}{"ECHODEVICES"}{$device->{deviceSerialNumber}}->{helper}{bluetooth} = "-" if(!defined($hash->{helper}{"ECHODEVICES"}{$device->{deviceSerialNumber}}->{helper}{bluetooth}));
			}
		}
	} 
  
 	elsif($msgtype eq "getdnd") {
		foreach my $device (@{$json->{doNotDisturbDeviceStatusList}}) {
			if(defined($hash->{helper}{"ECHODEVICES"}{$device->{deviceSerialNumber}})) {
				next if (echodevice_getModel($device->{deviceType}) eq "Reverb");
				next if (echodevice_getModel($device->{deviceType}) eq "Echo Multiroom");
				next if (echodevice_getModel($device->{deviceType}) eq "Sonos Display");
				next if (echodevice_getModel($device->{deviceType}) eq "Sonos One");
				next if (echodevice_getModel($device->{deviceType}) eq "unbekannt");
				my $echohash = $hash->{helper}{"ECHODEVICES"}{$device->{deviceSerialNumber}};
				readingsBeginUpdate($echohash);
				readingsBulkUpdateIfChanged($echohash, "dnd", $device->{enabled}?"on":"off", 1);
				readingsEndUpdate($echohash,1);
			}
		}
	} 
	
	elsif($msgtype eq "alarmvolume") {
		foreach my $device (@{$json->{deviceNotificationStates}}) {
			if(defined($hash->{helper}{"ECHODEVICES"}{$device->{deviceSerialNumber}})) {
				next if (echodevice_getModel($device->{deviceType}) eq "Reverb");
				next if (echodevice_getModel($device->{deviceType}) eq "Echo Multiroom");
				next if (echodevice_getModel($device->{deviceType}) eq "Sonos Display");
				next if (echodevice_getModel($device->{deviceType}) eq "unbekannt");
				my $echohash = $hash->{helper}{"ECHODEVICES"}{$device->{deviceSerialNumber}};
				readingsBeginUpdate($echohash);
				readingsBulkUpdateIfChanged($echohash, "volume_alarm", $device->{volumeLevel}, 1)if(defined($device->{volumeLevel}));
				readingsEndUpdate($echohash,1);
			}
		}
	} 
	
	elsif($msgtype eq "dndset") {
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "dnd", $json->{enabled}?"on":"off", 1) if(defined($json->{enabled}));
		readingsEndUpdate($hash,1);
	} 
  
	elsif($msgtype eq "tunein") {
	}
	
	elsif($msgtype eq "wakeword") {
		foreach my $device (@{$json->{wakeWords}}) {
			if(defined($hash->{helper}{"ECHODEVICES"}{$device->{deviceSerialNumber}})) {
				my $echohash = $hash->{helper}{"ECHODEVICES"}{$device->{deviceSerialNumber}};
				readingsBeginUpdate($echohash);
				#readingsBulkUpdateIfChanged($echohash, "active", $device->{active}?"true":"false", 1) if(defined($device->{active}));
				readingsBulkUpdateIfChanged($echohash, "wakeword", $device->{wakeWord}, 1) if(defined($device->{wakeWord}));
				#readingsBulkUpdateIfChanged($echohash, "midfield", $device->{midFieldState}, 1) if(defined($device->{midFieldState}));
				readingsEndUpdate($echohash,1);
			}
		}
	}
	
	elsif($msgtype eq "getdevicesettings") {
		foreach my $device (@{$json->{devicePreferences}}) {
			if(defined($hash->{helper}{"ECHODEVICES"}{$device->{deviceSerialNumber}})) {
				my $echohash = $hash->{helper}{"ECHODEVICES"}{$device->{deviceSerialNumber}};
				next if (echodevice_getModel($device->{deviceType}) eq "Echo Multiroom");
				next if (echodevice_getModel($device->{deviceType}) eq "unbekannt");
				readingsBeginUpdate($echohash);
				readingsBulkUpdateIfChanged($echohash, "microphone", $device->{notificationEarconEnabled}?"false":"true", 1) if(defined($device->{notificationEarconEnabled}));
				readingsBulkUpdateIfChanged($echohash, "deviceAddress", $device->{deviceAddress}, 1) if(defined($device->{deviceAddress}));
				readingsBulkUpdateIfChanged($echohash, "timeZoneId", $device->{timeZoneId}, 1) if(defined($device->{timeZoneId}));
				readingsEndUpdate($echohash,1);
			}
		}
	}

	elsif($msgtype eq "getisonline") {
		foreach my $device (@{$json->{devices}}) {
			if(defined($hash->{helper}{"ECHODEVICES"}{$device->{serialNumber}})) {
				my $echohash = $hash->{helper}{"ECHODEVICES"}{$device->{serialNumber}};
				next if (echodevice_getModel($device->{deviceType}) eq "Echo Multiroom");
				next if (echodevice_getModel($device->{deviceType}) eq "Sonos Display");
				next if (echodevice_getModel($device->{deviceType}) eq "unbekannt");
				readingsBeginUpdate($echohash);
				readingsBulkUpdateIfChanged($echohash, "online", $device->{online}?"true":"false", 1) if(defined($device->{online}));
				readingsEndUpdate($echohash,1);
			}
		}
	}

	elsif($msgtype eq "conversations") {
	
		my $return = '<html><table align="" border="0" cellspacing="0" cellpadding="3" width="100%" height="100%" class="mceEditable"><tbody>';
		$return   .= "<p>Conversations:</p>";
		$return   .= "<tr><td><strong>ID</strong></td><td><strong>Date</strong></td><td><strong>Message</strong></td></tr>";
		my $conversations_date = "";
		my $conversations_msg  = "";
		
		if(!defined($json->{conversations})) {}
		elsif(ref($json->{conversations}) ne "ARRAY") {}
		else{
			foreach my $conversation (@{$json->{conversations}}) {
				if(defined($conversation->{lastMessage}{payload}{text})){
				  $conversations_date = $conversation->{lastMessage}{time};
				  $conversations_msg  = substr($conversation->{lastMessage}{payload}{text},0,32);
				} else {
				  $conversations_msg  = "no previous messages";
				  $conversations_date = "no date";
				}
				$return .= "<tr><td>".$conversation->{conversationId}."&nbsp;&nbsp;&nbsp;</td><td>".$conversations_date."&nbsp;&nbsp;&nbsp;</td><td>".$conversations_msg."&nbsp;&nbsp;&nbsp;</td></tr>";
			}

		}
		$return .= "</tbody></table></html>";
		asyncOutput( $param->{CL}, $return );
	}
	
	elsif($msgtype eq "devices" || $msgtype eq "autocreate_devices") {
	
		my $autocreated   = 0;
		my $autocreate    = 0;
		my $isautocreated = 0;
		$autocreate=1 if($msgtype eq "autocreate_devices");

		my $return = '<html><table align="" border="0" cellspacing="0" cellpadding="3" width="100%" height="100%" class="mceEditable"><tbody>';
		$return .= "<p>Devices:</p>";
		$return .= "<tr><td><strong>Serial</strong></td><td><strong>Family</strong></td><td><strong>Devicetype</strong></td><td><strong>Name</strong></td></tr>";
		
		if(!defined($json->{devices})) {}
		elsif (ref($json->{devices}) ne "ARRAY") {}
		else {
			foreach my $device (@{$json->{devices}}) {
				next if($device->{deviceFamily} eq "UNKNOWN");
				next if($device->{deviceFamily} eq "FIRE_TV");
				next if($device->{deviceFamily} =~ /AMAZON/);
				$isautocreated = 0;
				if($autocreate && ($device->{deviceFamily} eq "ECHO" || $device->{deviceFamily} eq "KNIGHT" || $device->{deviceFamily} eq "THIRD_PARTY_AVS_MEDIA_DISPLAY"  || $device->{deviceFamily} eq "WHA" || $device->{deviceFamily} eq "ROOK" )) {
					if( defined($modules{$hash->{TYPE}}{defptr}{"$device->{serialNumber}"}) ) {
						Log3 $name, 4, "$name: device '$device->{serialNumber}' already defined";
						if (AttrVal($name, "autocreate_refresh", 0) == 1) {
							my $devicehash = $modules{$hash->{TYPE}}{defptr}{"$device->{serialNumber}"};
							print (fhem( "attr " . $devicehash->{NAME} ." alias " .$device->{accountName}  )) if( defined($device->{accountName}) );
							print (fhem( "attr " . $devicehash->{NAME} ." icon echo"  ))if (-e "././www/images/fhemSVG/echo.svg");
						}
					}
					else {
						$isautocreated = 1;
						my $devname = "ECHO_".$device->{serialNumber};
						my $define= "$devname echodevice ".$device->{deviceType}." ".$device->{serialNumber};

						Log3 $name, 3, "[$name] create new device '$devname'";
						my $cmdret= CommandDefine(undef,$define);
						if($cmdret) {
							Log3 $name, 1, "[$name] Autocreate: An error occurred while creating device for serial '$device->{serialNumber}': $cmdret";
						} 
						else {
							$cmdret= CommandAttr(undef,"$devname alias ".$device->{accountName}) if( defined($device->{accountName}) );
							$cmdret= CommandAttr(undef,"$devname icon echo" )if (-e "././www/images/fhemSVG/echo.svg");
							$cmdret= CommandAttr(undef,"$devname IODev $name");
							$cmdret= CommandAttr(undef,"$devname room Amazon");
							$autocreated++;
						}
					  
						$hash->{helper}{VERSION} = $device->{softwareVersion} if(!defined($hash->{helper}{VERSION}));
						$hash->{helper}{CUSTOMER} = $device->{deviceOwnerCustomerId} if(!defined($hash->{helper}{CUSTOMER}));
						$hash->{helper}{SERIAL} = $device->{serialNumber} if(!defined($hash->{helper}{SERIAL}));
						$hash->{helper}{DEVICETYPE} = $device->{deviceType} if(!defined($hash->{helper}{DEVICETYPE}));
					}

				}
				elsif($device->{deviceFamily} eq "ECHO") {
					$hash->{helper}{VERSION} = $device->{softwareVersion} if(!defined($hash->{helper}{VERSION}));
					$hash->{helper}{CUSTOMER} = $device->{deviceOwnerCustomerId} if(!defined($hash->{helper}{CUSTOMER}));
					$hash->{helper}{SERIAL} = $device->{serialNumber} if(!defined($hash->{helper}{SERIAL}));
					$hash->{helper}{DEVICETYPE} = $device->{deviceType} if(!defined($hash->{helper}{DEVICETYPE}));
					if( defined($modules{$hash->{TYPE}}{defptr}{"$device->{serialNumber}"}) ) {
						my $devicehash = $modules{$hash->{TYPE}}{defptr}{"$device->{serialNumber}"};
					}
				}
				if ($isautocreated == 0) {
					$return .= "<tr><td>".$device->{serialNumber}."&nbsp;&nbsp;&nbsp;</td><td>".$device->{deviceFamily}."&nbsp;&nbsp;&nbsp;</td><td>".$device->{deviceType}."&nbsp;&nbsp;&nbsp;</td><td>".$device->{accountName}."&nbsp;&nbsp;&nbsp;</td></tr>";
				}
				else {
					$return .= "<tr><td><strong>*".$device->{serialNumber}."&nbsp;&nbsp;&nbsp;</strong></td><td><strong>".$device->{deviceFamily}."&nbsp;&nbsp;&nbsp;</strong></td><td><strong>".$device->{deviceType}."&nbsp;&nbsp;&nbsp;</strong></td><td><strong>".$device->{accountName}."&nbsp;&nbsp;&nbsp;</strong></td></tr>";
				}
				
			}
	
			foreach my $device (@{$json->{devices}}) {
				next if($device->{deviceFamily} ne "ECHO");
				my $devicehash = $modules{$hash->{TYPE}}{defptr}{"$device->{serialNumber}"};
				next if( !defined($devicehash) );
				
				
				$devicehash->{model} = echodevice_getModel($device->{deviceType});#$device->{deviceType};
				
				readingsBeginUpdate($devicehash);
				readingsBulkUpdateIfChanged($devicehash, "model", $devicehash->{model}, 1);
				readingsBulkUpdateIfChanged($devicehash, "presence", ($device->{online}?"present":"absent"), 1);
				readingsBulkUpdateIfChanged($devicehash, "state", "absent", 1) if(!$device->{online});
				readingsBulkUpdateIfChanged($devicehash, "version", $device->{softwareVersion}, 1);
				readingsEndUpdate($devicehash,1);
				
				$hash->{helper}{SERIAL} = $device->{serialNumber};
				$hash->{helper}{DEVICETYPE} = $device->{deviceType};
				$devicehash->{helper}{SERIAL} = $device->{serialNumber};
				$devicehash->{helper}{DEVICETYPE} = $device->{deviceType};
				$devicehash->{helper}{NAME} = $device->{accountName};
				$devicehash->{helper}{FAMILY} = $device->{deviceFamily};
				$devicehash->{helper}{VERSION} = $device->{softwareVersion};
				$devicehash->{helper}{CUSTOMER} = $device->{deviceOwnerCustomerId};

			}
			
			readingsSingleUpdate ($hash, "autocreate_devices", "found: ".$autocreated, 0 ) if($msgtype eq "autocreate_devices");
			
			$return .= "</tbody></table>";
			$return .= "<p><strong>* ".$autocreated." devices created</strong></p>" if($msgtype eq "autocreate_devices");
			$return .= "</html>";
		}
		asyncOutput( $param->{CL}, $return );
	}
	
	elsif($msgtype eq "searchtunein") {
		my $tuneincount = 0;
	
		my $return = '<html><table align="" border="0" cellspacing="0" cellpadding="3" width="100%" height="100%" class="mceEditable"><tbody>';
		$return   .= "<p>TuneIn:</p>";
		$return   .= "<tr><td><strong>ID</strong></td><td><strong>Name</strong></td><td><strong>Start</strong></td></tr>";			
	
		if (!defined($json->{browseList})) {}
		elsif (ref($json->{browseList}) ne "ARRAY") {}
		else {
			# Play on Device
			foreach my $result (@{$json->{browseList}}) {
				next if(!$result->{available});
				next if($result->{contentType} ne "station");
				$tuneincount ++;
				$return .= "<tr><td>".$result->{id}."&nbsp;&nbsp;&nbsp;</td><td>".$result->{name}."&nbsp;&nbsp;&nbsp;</td><td><a href=" . '/fhem?cmd.Test=set%20' .$name .'%20tunein%20'.$result->{id}.'>play&nbsp;&nbsp;&nbsp;' . "</a></td></tr>";
			}
		}
		
		$return .= "</tbody></table>";
		$return .= "<p><strong>".$tuneincount. " tunein IDs found</strong></p>";
		$return .= "</html>";
			
		asyncOutput( $param->{CL}, $return );
	}
	
	elsif($msgtype eq "searchtracks") {
			my $trackcount = 0;
			my $return     = '<html><table align="" border="0" cellspacing="0" cellpadding="3" width="100%" height="100%" class="mceEditable"><tbody>';
			my $tracktitle = "";
			$return .= "<p>Tracks:</p>";
			$return .= "<tr><td><strong>ID</strong></td><td><strong>Title</strong></td></tr>";
	
			if (!defined($json->{playlist}{entryList})) {}
			elsif (ref($json->{playlist}{entryList}) ne "ARRAY") {}
			else {
				foreach my $track (@{$json->{playlist}{entryList}}) {
					if(defined($track->{metadata}{title})){$tracktitle = $track->{metadata}{title};} 
					else {$tracktitle= "unknown title";}
					$trackcount ++;
					$return .= "<tr><td>".$track->{trackId}."&nbsp;&nbsp;&nbsp;</td><td>".$tracktitle."&nbsp;&nbsp;&nbsp;</td></tr>";
				}
			}
		
			$return .= "</tbody></table>";
			$return .= "<p><strong>".$trackcount." track IDs found</strong></p>";
			$return .= "</html>";
			
			asyncOutput( $param->{CL}, $return );	
	}

	elsif($msgtype eq "primeplayeigene_Albums" || $msgtype eq "primeplayeigene_Tracks" || $msgtype eq "primeplayeigene_Artists" ) {
		my $querytype =  substr($msgtype,16);
		my $albumcount = 0;

		my $artistcolum  = "";
		$artistcolum     = "<td><strong>Title&nbsp;&nbsp;&nbsp</strong></td><td><strong>ID&nbsp;&nbsp;&nbsp</strong></td>" if ($msgtype eq "primeplayeigene_Tracks" ) ;
		
		my $return = '<html><table align="" border="0" cellspacing="0" cellpadding="3" width="100%" height="100%" class="mceEditable"><tbody>';
		$return   .= "<p>$querytype:</p>";
		$return   .= "<tr><td><strong>Artist&nbsp;&nbsp;&nbsp</strong></td><td><strong>Albumname&nbsp;&nbsp;&nbsp</strong></td>$artistcolum<td><strong>Tracks&nbsp;&nbsp;&nbsp</strong></td><td><strong>Start</strong></td></tr>";			
	
		if (!defined($json->{selectItemList})) {}
		elsif (ref($json->{selectItemList}) ne "ARRAY") {}
		else {
			# Play on Device
			foreach my $result (@{$json->{selectItemList}}) {
				#next if(!$result->{available});
				#next if($result->{contentType} ne "station");
				$albumcount ++;
				if ($msgtype eq "primeplayeigene_Tracks" ) {
					$return .= "<tr><td>".$result->{metadata}{albumArtistName}."&nbsp;&nbsp;&nbsp;</td><td>".$result->{metadata}{albumName}."&nbsp;&nbsp;&nbsp;</td><td>".$result->{metadata}{title}."&nbsp;&nbsp;&nbsp;</td><td>".$result->{metadata}{objectId}."&nbsp;&nbsp;&nbsp;</td><td>1&nbsp;&nbsp;&nbsp;</td><td><a href=" . '/fhem?cmd.Test=set%20' .$name .'%20track%20'.$result->{metadata}{objectId}.'>play&nbsp;&nbsp;&nbsp;' . "</a></td></tr>";
				}
				else {
					$return .= "<tr><td>".$result->{metadata}{albumArtistName}."&nbsp;&nbsp;&nbsp;</td><td>".$result->{metadata}{albumName}."&nbsp;&nbsp;&nbsp;</td><td>".$result->{numTracks}."&nbsp;&nbsp;&nbsp;</td><td><a href=" . '/fhem?cmd.Test=set%20' .$name .'%20primeplayeigene%20'.urlEncode($result->{metadata}{albumArtistName})."@".urlEncode($result->{metadata}{albumName}).'>play&nbsp;&nbsp;&nbsp;' . "</a></td></tr>";
				}
			}
		}
		
		$return .= "</tbody></table>";
		$return .= "<p><strong>".$albumcount. " ". lc($querytype) ." IDs found</strong></p>";
		$return .= "</html>";
		$return =~ s/'/&#x0027/g;

		asyncOutput( $param->{CL}, $return );	
	}

	elsif($msgtype eq "getprimeplayeigeneplaylist" ) {

		my $playlistcount = 0;
		
		my $return = '<html><table align="" border="0" cellspacing="0" cellpadding="3" width="100%" height="100%" class="mceEditable"><tbody>';
		$return   .= "<p>Playlists:</p>";
		$return   .= "<tr><td><strong>Name&nbsp;&nbsp;&nbsp</strong></td><td><strong>ID&nbsp;&nbsp;&nbsp</strong></td><td><strong>Tracks&nbsp;&nbsp;&nbsp</strong></td><td><strong>Start</strong></td></tr>";			
		if (!defined($json->{playlists})) {}
		elsif (ref($json->{playlists}) ne "HASH") {}
		else {
			foreach my $result (sort keys %{$json->{playlists}}) {
				$playlistcount ++;
				$return .= "<tr><td>".$result."&nbsp;&nbsp;&nbsp;</td><td>".$json->{playlists}{"$result"}[0]{playlistId}."&nbsp;&nbsp;&nbsp;</td><td>".$json->{playlists}{"$result"}[0]{trackCount}."&nbsp;&nbsp;&nbsp;</td><td><a href=" . '/fhem?cmd.Test=set%20' .$name .'%20primeplayeigeneplaylist%20'.$json->{playlists}{"$result"}[0]{playlistId}.'>play&nbsp;&nbsp;&nbsp;' . "</a></td></tr>";
			}
		}
		
		$return .= "</tbody></table>";
		$return .= "<p><strong>".$playlistcount. " playlist IDs found</strong></p>";
		$return .= "</html>";
		$return =~ s/'/&#x0027/g;

		asyncOutput( $param->{CL}, $return );	
	}
	
	elsif($msgtype eq "getcards") {

			my $return     = '<html><table align="" border="0" cellspacing="0" cellpadding="3" width="100%" height="100%" class="mceEditable"><tbody>';

			$return .= "<p>Actions:</p>";
			$return .= "<tr><td><strong>Title</strong></td><td><strong>Subtitle</strong></td><td><strong>Voice</strong></td><td><strong>Device</strong></td></tr>";
	
			if (!defined($json->{cards})) {}
			elsif (ref($json->{cards}) ne "ARRAY") {}
			else {
				foreach my $cards (@{$json->{cards}}) {
					my $devicehash = $modules{$hash->{TYPE}}{defptr}{"$cards->{sourceDevice}{serialNumber}"};
					my $devicename = $devicehash->{NAME};
					
					if (AttrVal( $devicename, "alias", "none" ) ne "none") {$devicename = AttrVal( $devicename, "alias", "none" );}
					
				
					$return .= "<tr><td>".$cards->{title}."&nbsp;&nbsp;&nbsp;</td><td>".$cards->{subtitle}."&nbsp;&nbsp;&nbsp;</td><td>".$cards->{playbackAudioAction}{mainText}."&nbsp;&nbsp;&nbsp;</td><td>".$devicename."&nbsp;&nbsp;&nbsp;</td></tr>";
				}
			}
		
			$return .= "</tbody></table>";
			$return .= "</html>";
			
			asyncOutput( $param->{CL}, $return );	
	}
	
	else {
		Log3 $name, 4, "[$name] json for unknown message type $msgtype\n".Dumper(echodevice_anonymize($hash, $json));
	}
  
	echodevice_HandleCmdQueue($hash);

	return undef;
}

##########################
sub echodevice_GetSettings($) {

	my ($hash)       = @_;
	my $name         = $hash->{NAME};
	my $nextupdate   = int(AttrVal($name,"intervalsettings",60));
	my $ConnectState = "";
	
	return if($hash->{model} eq "unbekannt");
	
	# ECHO am Account registrierern
	if($hash->{model} ne "ACCOUNT") {

		$hash->{IODev}->{helper}{"ECHODEVICES"} = () if( !defined($hash->{IODev}->{helper}{"ECHODEVICES"}));
			
		if (!defined($hash->{IODev}->{helper}{"ECHODEVICES"}{$hash->{helper}{"SERIAL"}})) {
			$hash->{IODev}->{helper}{"ECHODEVICES"}{$hash->{helper}{"SERIAL"}} = $hash ;
			$hash->{IODev}->{helper}{"DEVICETYPE"} = $hash->{helper}{"DEVICETYPE"} ;
			$hash->{IODev}->{helper}{"SERIAL"}     = $hash->{helper}{"SERIAL"};
			$hash->{IODev}->{helper}{"VERSION"}    = $hash->{helper}{"VERSION"};		
		}
	}

	if($hash->{model} eq "ACCOUNT") {$ConnectState = $hash->{STATE}} else {$ConnectState = $hash->{IODev}->{STATE}}
	
	if ($ConnectState eq "connected" && AttrVal($name,"disable",0) == 0) {

		if($hash->{model} eq "ACCOUNT") {
			echodevice_SendCommand($hash,"getnotifications","");
			echodevice_SendCommand($hash,"alarmvolume","");
			echodevice_SendCommand($hash,"bluetoothstate","");
			echodevice_SendCommand($hash,"getdnd","");
			echodevice_SendCommand($hash,"wakeword","");
			echodevice_SendCommand($hash,"activities","");
			echodevice_SendCommand($hash,"listitems_task","TASK");
			echodevice_SendCommand($hash,"listitems_shopping","SHOPPING_ITEM");
			echodevice_SendCommand($hash,"getdevicesettings","");
			echodevice_SendCommand($hash,"getisonline","");
			echodevice_SendCommand($hash,"account","");
			#echodevice_SendCommand($hash,"homegroup","") if(defined($hash->{helper}{COMMSID}));	
		}else {
		
			if ($hash->{model} eq "Reverb" || $hash->{model} eq "Sonos One") {
				if ($hash->{IODev}{STATE} eq "connected") {
					readingsBeginUpdate($hash);
					readingsBulkUpdateIfChanged($hash, "state", $hash->{IODev}{STATE}, 1);
					readingsEndUpdate($hash,1);
				}
				else {$nextupdate = 10;}
			}
			else
			{
				if (ReadingsVal($name, "playStatus", "off") ne "paused") {
					my $CalcInterval = int(ReadingsVal($name, "progresslen", 0)) - (int(ReadingsVal($name, "progress", 0)) + $nextupdate);
					if ($CalcInterval < 0) {}
					elsif ($CalcInterval < ($nextupdate -1) ){$nextupdate = $CalcInterval + 4;}
						
					Log3( $name, 4, "[$name] [echodevice_GetSettings] Timer CNTERVAL = " . $CalcInterval);			
				}
				if ($hash->{IODev}{STATE} eq "connected") {echodevice_SendCommand($hash,"player","");}
				else {$nextupdate = 10;}
			}
		}

		# Readings Bereinigung
		print (fhem( "deletereading $name active" )) if (ReadingsVal($name , "active", "none") ne "none");
		
		Log3( $name, 4, "[$name] [echodevice_GetSettings] Timer INTERVAL = " . $nextupdate);	
	}

	RemoveInternalTimer($hash, "echodevice_GetSettings");
	InternalTimer(gettimeofday() + $nextupdate, "echodevice_GetSettings", $hash, 0);
	return undef;
}

##########################
sub echodevice_FirstStart($) {

	my ($hash) = @_;
	my $name = $hash->{NAME};
	my $CookieDevice = "";
	
	readingsSingleUpdate ($hash, "version", $ModulVersion ,0);
	readingsSingleUpdate ($hash, "autocreate_devices", "stop", 0 );
	
	if(AttrVal( $name, "timeout", "none" ) ne "none") {
		readingsSingleUpdate ($hash, "COOKIE_TYPE", "ATTRIBUTE" ,0);
		$hash->{helper}{COOKIE} = AttrVal( $name, "timeout", "none" );
		$hash->{helper}{COOKIE} =~ s/Cookie: //g;
		$hash->{helper}{COOKIE} =~ /csrf=([-\w]+)[;\s]?(.*)?$/;
		$hash->{helper}{CSRF} = $1;
		readingsSingleUpdate ($hash, "COOKIE", $hash->{helper}{COOKIE} ,0); # Cookie als READING festhalten!
    }
	elsif (ReadingsVal( $name, "COOKIE", "none" ) ne "none") {
		readingsSingleUpdate ($hash, "COOKIE_TYPE", "READING" ,0);
		$hash->{helper}{COOKIE} = ReadingsVal( $name, "COOKIE", "none" );
		$hash->{helper}{COOKIE} =~ s/Cookie: //g;
		$hash->{helper}{COOKIE} =~ /csrf=([-\w]+)[;\s]?(.*)?$/;
		$hash->{helper}{CSRF} = $1;
	}
	else {
		readingsSingleUpdate ($hash, "COOKIE_TYPE", "NEW" ,0);
	}

	Log3 $name, 4, "[$name] COOKIE      = " . $hash->{helper}{COOKIE};
	Log3 $name, 4, "[$name] COOKIE_TYPE = " . ReadingsVal( $name, "COOKIE_TYPE", "none" );
	
    $hash->{STATE} = "INITIALIZED";
    echodevice_CheckAuth($hash);
	
	if(defined($hash->{helper}{COOKIE})) {
		echodevice_SendCommand($hash,"devices","");
		echodevice_SendCommand($hash,"account","");
	}

}

sub echodevice_LoginStart($) {

	my ($hash) = @_;
	my $name = $hash->{NAME};
	Log3 $name, 4, "[$name] [echodevice_LoginStart] start....";

	$hash->{helper}{RUNLOGIN} = 0;
	echodevice_SendLoginCommand($hash,"cookielogin1","") if(!defined($attr{$name}{cookie}));
}

sub echodevice_CheckAuth($) {
	my ($hash) = @_;
	my $name = $hash->{NAME};
	return undef if($hash->{model} ne "ACCOUNT");
  
	# Erneut Login ausführen wenn Cookie nicht gesetzt wurde!
	if(!defined($hash->{helper}{COOKIE})) {echodevice_SendLoginCommand($hash,"cookielogin1","");}
	else {echodevice_SendLoginCommand($hash,"cookielogin6","");}

	return undef;
}

sub echodevice_ParseAuth($$$) {
	my ($param, $err, $data) = @_;
	my $hash = $param->{hash};
	my $name = $hash->{NAME};
	my $nextupdate = int(AttrVal($name,"intervallogin",60));

	if($err){
		echodevice_setState($hash,"connection error");
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "state", "connection error", 1);
		readingsEndUpdate($hash,1);
		if ($hash->{helper}{RUNLOGIN} == 0) {
			readingsSingleUpdate ($hash, "COOKIE_STATE", "ERROR" ,0);
			InternalTimer(gettimeofday() + $nextupdate  , "echodevice_LoginStart" , $hash, 0);
			$hash->{helper}{RUNLOGIN} = 1;
		}	
		Log3 $name, 4, "[$name] [echodevice_ParseAuth] connection error $err";
		return undef;
	}
  
	if($data =~ /cookie is missing/) {
		echodevice_setState($hash,"disconnected");
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "state", "disconnected", 1);
		readingsEndUpdate($hash,1);
		if ($hash->{helper}{RUNLOGIN} == 0) {
			readingsSingleUpdate ($hash, "COOKIE_STATE", "ERROR" ,0);
			InternalTimer(gettimeofday() + $nextupdate  , "echodevice_LoginStart" , $hash, 0);
			$hash->{helper}{RUNLOGIN} = 1;
		}	
		return undef;
	}
  
	my $json = eval { JSON->new->utf8(0)->decode($data) };
	if($@) {
		echodevice_setState($hash,"disconnected");
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "state", "disconnected", 1);
		readingsEndUpdate($hash,1);
		if ($hash->{helper}{RUNLOGIN} == 0) {
			readingsSingleUpdate ($hash, "COOKIE_STATE", "ERROR" ,0);
			InternalTimer(gettimeofday() + $nextupdate  , "echodevice_LoginStart" , $hash, 0);
			$hash->{helper}{RUNLOGIN} = 1;
		}
		return undef;
	}
  
	Log3 $name, 4, "[$name] [echodevice_ParseAuth] DATA=$data";

	if($json->{authentication}{authenticated}){
		echodevice_setState($hash,"connected");
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "state", "connected", 1);
		readingsBulkUpdateIfChanged($hash, "COOKIE_STATE", "OK", 1);
		readingsEndUpdate($hash,1);
		$hash->{helper}{CUSTOMER} = $json->{authentication}{customerId};
	} 
	
	elsif($json->{authentication}) {
		echodevice_setState($hash,"disconnected");
		readingsBeginUpdate($hash);
		readingsBulkUpdateIfChanged($hash, "state", "disconnected", 1);
		readingsEndUpdate($hash,1);
		
		if ($hash->{helper}{RUNLOGIN} == 0) {
			readingsSingleUpdate ($hash, "COOKIE_STATE", "ERROR" ,0);
			InternalTimer(gettimeofday() + $nextupdate  , "echodevice_LoginStart" , $hash, 0);
			$hash->{helper}{RUNLOGIN} = 1;
		}
		
		
	}
	return undef;
}

##########################
sub echodevice_getModel($){
	my ($ModelNumber) = @_;
	
	if   ($ModelNumber eq "AB72C64C86AW2"  || $ModelNumber eq "Echo")          {return "Echo";}
	elsif($ModelNumber eq "A3S5BH2HU6VAYF" || $ModelNumber eq "Echo Dot")      {return "Echo Dot";}
	elsif($ModelNumber eq "A10A33FOX2NUBK" || $ModelNumber eq "Echo Spot")     {return "Echo Spot";}
	elsif($ModelNumber eq "A1NL4BVLQ4L3N3" || $ModelNumber eq "Echo Show")     {return "Echo Show";}
	elsif($ModelNumber eq "A2M35JJZWCQOMZ" || $ModelNumber eq "Echo Plus")     {return "Echo Plus";}
	elsif($ModelNumber eq "AILBSA2LNTOYL"  || $ModelNumber eq "Reverb")        {return "Reverb";}
	elsif($ModelNumber eq "A15ERDAKK5HQQG" || $ModelNumber eq "Sonos Display") {return "Sonos Display";}
	elsif($ModelNumber eq "A2OSP3UA4VC85F" || $ModelNumber eq "Sonos One")     {return "Sonos One";}
	elsif($ModelNumber eq "A7WXQPH584YP"   || $ModelNumber eq "Echo Gen2")     {return "Echo Gen2";}
	elsif($ModelNumber eq "A3C9PE6TNYLTCH" || $ModelNumber eq "Echo Multiroom"){return "Echo Multiroom";}
	elsif($ModelNumber eq "")               {return "";}
	elsif($ModelNumber eq "ACCOUNT")        {return "ACCOUNT";}
	else {return "unbekannt";}

}

sub echodevice_Attr($$$) {
  
	my ($cmd, $name, $attrName, $attrVal) = @_;

	if( $attrName eq "cookie" ) {
		my $hash = $defs{$name};
		if( $cmd eq "set" ) {
			$attrVal =~ s/Cookie: //g;
			$hash->{helper}{COOKIE} = $attrVal;
			$hash->{helper}{COOKIE} =~ /csrf=([-\w]+)[;\s]?(.*)?$/;
			$hash->{helper}{CSRF} = $1;
			$hash->{STATE} = "INITIALIZED";
		}
	}
	
	if( $attrName eq "server" ) {
		my $hash = $defs{$name};
		if( $cmd eq "set" ) {
		  $hash->{helper}{SERVER} = $attrVal;
		}
	}
	
	$attr{$name}{$attrName} = $attrVal;
	
	return;  
}

sub echodevice_anonymize($$) {
	my ($hash, $string) = @_;
	my $s1 = $hash->{helper}{SERIAL};
	my $s2 = $hash->{helper}{CUSTOMER};
	my $s3 = $hash->{helper}{HOMEGROUP};
	my $s4 = $hash->{helper}{COMMSID};
	my $s5;
	$s5 = echodevice_decrypt($hash->{helper}{USER}) if(defined($hash->{helper}{USER}));
	$s5 = echodevice_decrypt($hash->{IODev}->{helper}{USER}) if(defined($hash->{IODev}->{helper}{USER}));;
	$s1 = "SERIAL" if(!defined($s1));
	$s2 = "CUSTOMER" if(!defined($s2));
	$s3 = "HOMEGROUP" if(!defined($s3));
	$s4 = "COMMSID" if(!defined($s4));
	$s5 = "USER" if(!defined($s5));
	$string =~ s/$s1/SERIAL/g;
	$string =~ s/$s2/CUSTOMER/g;
	$string =~ s/$s3/HOMEGROUP/g;
	$string =~ s/$s4/COMMSID/g;
	$string =~ s/$s5/USER/g;
	return $string;
}

sub echodevice_encrypt($) {
  my ($decoded) = @_;
  my $key = getUniqueId();
  my $encoded;

  return $decoded if( $decoded =~ /\Qcrypt:\E/ );

  for my $char (split //, $decoded) {
    my $encode = chop($key);
    $encoded .= sprintf("%.2x",ord($char)^ord($encode));
    $key = $encode.$key;
  }

  return 'crypt:'.$encoded;
}

sub echodevice_decrypt($) {
  my ($encoded) = @_;
  my $key = getUniqueId();
  my $decoded;

  return $encoded if( $encoded !~ /crypt:/ );
  
  $encoded = $1 if( $encoded =~ /crypt:(.*)/ );

  for my $char (map { pack('C', hex($_)) } ($encoded =~ /(..)/g)) {
    my $decode = chop($key);
    $decoded .= chr(ord($char)^ord($decode));
    $key = $decode.$key;
  }

  return $decoded;
}

sub echodevice_setState($$) {
	my ($hash,$State) = @_;
	my $name = $hash->{NAME};
	
	Log3 $name, 3, "[$name] [echodevice_setState] to $State"  if($hash->{STATE} ne $State) ;
	
	foreach my $DeviceID (sort keys %{$hash->{helper}{"ECHODEVICES"}}) {
		my $echohash   = $hash->{helper}{"ECHODEVICES"}{$DeviceID};
		readingsBeginUpdate($echohash);
		readingsBulkUpdateIfChanged( $echohash, "state"  , $State,1);		
		readingsEndUpdate($echohash,1);
	}
	return;
}

1;

=pod
=item device
=item summary Amazon Echo remote control
=begin html

<a name="echodevice"></a>
<h3>echodevice</h3>
<ul>
  Basic remote control for Amazon Echo devices. You can find the complete documentation here. 
  <br/><br/><a href="https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/" target="_blank"><b><font size=4 color="blue">https://mwinkler.jimdo.com/smarthome/eigene-module/echodevice/</font></b></a>
  
  <br/><br/>
  <b>Define</b>
  <ul>
    <code>define &lt;name&gt; echodevice &lt;DeviceID&gt; [DeviceType]</code>
    <br>
    Example: <code>define &lt;Name&gt; echodevice &lt;Amazon account&gt; &lt;Amazon Kennwort&gt</code>
    <br>
    Example: <code>define &lt;Name&gt; echodevice </code>
  </ul>
  <br>
  <b>Set</b>
   <ul>
      <li><code>...</code>
      <br>
      ...
      </li><br>
  </ul>
  <b>Get</b>
   <ul>
      <li><code>settings</code>
      <br>
      Manually reload setings (dnd, bluetooth, wakeword)
      </li><br>
      <li><code>devices</code>
      <br>
      Displays a list of Amazon devices connected to your account
      </li>
  </ul>
  <br>
  <b>Readings</b>
   <ul>
      <li><code>...</code>
      <br>
      ...
      </li><br>
  </ul>
  <br>
   <b>Attributes</b>
   <ul>
      <li><code>interval</code>
         <br>
         Poll interval in seconds (300)
      </li><br>
      <li><code>cookie</code>
         <br>
         Amazon access cookie, has to be entered for the module to work
      </li><br>
      <li><code>server</code>
         <br>
         Amazon server used for controlling the Echo
      </li><br>
  </ul>
</ul>

=end html
=cut