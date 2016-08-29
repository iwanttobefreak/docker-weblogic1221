#!/bin/bash
if [ -z "$ORACLE_USER" ]
then
  exit 0
fi

v_usuario_oracle="$ORACLE_USER"
v_contrasenya_oracle="$ORACLE_PASSWORD"

v_base=/u01/install
v_cookie=/tmp/$$_cookie
v_download=http://download.oracle.com/otn/nt/middleware/12c/122110/fmw_12.2.1.1.0_wls_Disk1_1of1.zip
#          http://download.oracle.com/otn/nt/middleware/11g/wls/1036/wls1036_generic.jar
v_software=wls1036_generic.jar
v_download_java=http://download.oracle.com/otn-pub/java/jdk/8u92-b14/jdk-8u92-linux-x64.tar.gz
#v_download_java=http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.tar.gz
v_software_java=jdk-8u92-linux-x64.tar.gz


if [ -f $v_base/local/$v_software ] && [ -f $v_base/local/$v_software_java ]
then
  echo "Software en local"
  exit 0
fi


cd $v_base

# Descarga de JVM
curl -A "Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101 Firefox/38.0 Iceweasel/38.6.0" \
-b 'oraclelicense=accept-dbindex-cookie' \
-OL $v_download_java

# Descarga de Weblogic
v_Site2pstoreToken=`curl -s -A "Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101 Firefox/45.0" -L $v_download | grep site2pstoretoken | awk -Fsite2pstoretoken {'print $2'}|awk -F\= {'print  $2'}|awk -F\" {'print $2'}`

curl -s -A "Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101 Firefox/38.0 Iceweasel/38.6.0"  \
-d 'ssousername='$v_usuario_oracle'&password='$v_contrasenya_oracle'&site2pstoretoken='$v_Site2pstoreToken \
-o /dev/null \
https://login.oracle.com/sso/auth -c $v_cookie

echo '.oracle.com	TRUE	/	FALSE	0	oraclelicense	accept-dbindex-cookie' >> $v_cookie

curl -A "Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101 Firefox/38.0 Iceweasel/38.6.0" \
-b $v_cookie \
-OL $v_download
