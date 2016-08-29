#!/bin/bash

v_base=/u01/install
v_weblogic_user=weblogic
v_weblogic_password=weblogic01
v_java=/u01/java/bin/java
v_template=/u01/middleware1221/wlserver/common/templates/wls/wls.jar
v_ruta_dominio=/u01/domains
v_nou_template=/tmp/$$_nou_template.jar
v_nombre_dominio=mydomain
v_cookie=/tmp/$$_cookie

v_ruta_binarios=/u01/middleware1221
v_software=fmw_12.2.1.1.0_wls.jar
v_software_java=jdk-8u92-linux-x64.tar.gz

if [ -f $v_base/local/$v_software ] && [ -f $v_base/local/$v_software_java ]
then
  echo "Software en local"
  v_base=$v_base"/local"
fi

cd $v_base

#Instalacion JVM
tar -xzvf $v_base/$v_software_java -C $v_base
mv $v_base/jdk1* /u01/java

$v_java -Djava.security.egd=file:/dev/./urandom -jar $v_base/$v_software -silent -responseFile $v_base/response_file -invPtrLoc $v_base/oraInst.loc

source $v_ruta_binarios/wlserver/server/bin/setWLSEnv.sh

$v_java weblogic.WLST <<EOF
readTemplate('$v_template')
set('Name','$v_nombre_dominio')
writeTemplate('$v_nou_template')
closeTemplate()
createDomain('$v_nou_template','$v_ruta_dominio/$v_nombre_dominio','$v_weblogic_user','$v_weblogic_password')
exit()
EOF
