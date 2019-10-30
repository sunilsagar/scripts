#!/bin/bash
# Author : Sunil Sagar
# Purpose : To check NodeJS Diskspace , Process and logs post deployment
# Date : 19 Aug 2018

## Color Coding
RED='\033[1;31m'
GREEN='\033[1;32m'
Cyan='\033[0;36m'
NC='\033[0m'

## Variables
hostFile="conf/ProdServers-Gold.txt"
tmpServer=tmpServer

singleSeparator="--------------------------------"

function usage {
echo ""
echo "provide correct parameter"
echo "-p or --pool to provide pool member eg. -p pool1 , --pool pool2"
echo "-t or --tech to provide technology e.g. -t was, --tool ihs, -t nodejs"
echo "--pre to check diskspace before activity"
echo ""
}

## Collecting User input
#set -- `getopt -n$0 -u -a --longoptions="help: crq: pool tech:" "h c p t" "$@"` || usage
OPTIONS=`getopt -o hc:p:t: --long help,crq:,pool:,tech:,pre -n 'script.sh' -- "$@"`

eval set -- "$OPTIONS"

while true; do 
	case "$1" in 
		-h | --help) usage ; exit ; shift ;;
		-c | --crq) crq=$2 ; shift 2;;
		-p | --pool) pool=$2 ; shift 2;;
		-t | --tech) tech=$2 ; shift 2;;
		--pre) pre=pre ; shift ;;
		--) shift ; break ;;
		*) echo "Internal error" ; exit 1 ;
	esac
done

#echo "$crq , $pool , $tech"


##Verifying the input
#if [[ -z "$1" ]]; then 
#usage;
#exit 1
#fi

if [[ "$pool" != [Pp][Oo][Oo][Ll][12] ]]; then
usage;
echo "$pool is not vaild, Provide correct Pool member: pool1 , pool2"
exit 1
fi

if [[ "$tech" != [Ww][AaCc][Ss] ]] && [[ "$tech" != [Ii][Hh][Ss] ]] && [[ "$tech" != [Nn][Oo][Dd][Ee][Jj][Ss] ]]; then
usage;
echo "$tech is not valid , Provide correct technology : was, wcs , ihs , nodejs"
exit 1;
else 
tech=$(echo "$tech" | tr '[:upper:]' '[:lower:]')
#echo "$tech"
fi

## Collecting hosts to check for NodeJS , WAS and IHS
rm -f tmpServer IHSHostName NodeJSHostName WASJSHostName;
grep 'IHS' $hostFile | grep -i $pool >> $tmpServer
grep 'NodeJS' $hostFile | grep -i $pool >> $tmpServer
grep 'WAS' $hostFile | grep -i $pool >> $tmpServer


## Adding all the functions
function DisplayHostName {
echo "--------------------------------";
CurrentHostPool=$(grep $i ${hostFile} | awk '{print $1, $2, $3}')
printf "${Cyan}${CurrentHostPool}${NC}\n"
echo "--------------------------------";
}

function toContinue {
read -n 1 -s -r -p "Press any key to continue...." ; echo ""
}

function IHSCheck {
grep IHS $tmpServer | awk '{print $3}' > IHSHostName
if [[ "$pre" == "pre" ]]; then
	CommandToRun="df -Ph"
else
	CommandToRun="df -Ph ; echo $singleSeparator;  cd /opt/IBM/HTTPServer70/conf/tcpinst2/web/static/ ; /bin/pwd ; ls -lrt "
fi

for i in $(cat IHSHostName); do
        DisplayHostName;
        sshadmin $i -q -t "$CommandToRun";
	toContinue;
done
}

function nodeJSCheck {
grep 'NodeJS' $tmpServer | awk '{print $3}' > NodeJSHostName
#commandToRun="/usr/bin/whoami ; df -Ph; ls -lrt /usr/nodeapp/dtx-webserver; ps -ef|grep node ; pm2 status ; pm2 logs "
if [[ "$pre" == "pre" ]]; then
        CommandToRun="df -Ph"
else
	CommandToRun="/usr/bin/whoami; echo $singleSeparator ; df -Ph; echo $singleSeparator; cd /usr/nodeapp/dtx-webserver; /bin/pwd; ls -lrt ; echo $singleSeparator; ps -ef|grep node| grep -v root  ; echo $singleSeparator; pm2 status "
fi

for i in $(cat NodeJSHostName); do
        DisplayHostName;
        sshadmin $i -q -t 'sudo su - nodeuser -c '\' "$CommandToRun" \'' ';
	toContinue;
done
}

function wasCheck {
grep WAS $tmpServer | awk '{print $3}' > WASJSHostName
if [[ "$pre" == "pre" ]]; then
        CommandToRun="df -Ph"
else
	CommandToRun="df -Ph; echo $singleSeparator; cd /opt/IBM/WebSphere/AppServer/profiles/tcpinst2/installedApps/WC_tcpinst2_cell; /bin/pwd;  ls -lrt" 
fi

for i in $(cat WASJSHostName); do
	DisplayHostName;
	sshadmin $i -q -t "$CommandToRun";
	toContinue;
done
}


function CleaningTempFile {
rm -f tmpServer IHSHostName NodeJSHostName WASJSHostName;
}


## Calling all the functions

if [[ "$tech" == "ihs" ]] ; then 
IHSCheck
elif [[ "$tech" == "nodejs" ]]; then
nodeJSCheck
elif [[ "$tech" == "was" ]]; then
wasCheck
fi


# Clean temp Files
CleaningTempFile
