FROM oraclelinux:7.2
MAINTAINER Jose Legido "jose@legido.com"

ARG ORACLE_USER
ARG ORACLE_PASSWORD

# USUARIS
RUN groupadd -g 1001 weblogic && useradd -u 1001 -g weblogic weblogic
RUN mkdir -p /u01/install && mkdir -p /u01/scripts

# EINES
RUN yum install -y tar && yum install -y unzip

COPY scrics/download_weblogic1221.sh /u01/install/download_weblogic1221.sh
COPY scrics/install_weblogic.sh /u01/install/install_weblogic.sh
COPY scrics/oraInst.loc /u01/install/oraInst.loc
COPY scrics/response_file /u01/install/response_file

COPY scrics/create_domain.ini /u01/install/create_domain.ini
COPY scrics/start_AdminServer.sh /u01/scripts/start_AdminServer.sh
COPY scrics/start_nodemanager.sh /u01/scripts/start_nodemanager.sh
COPY scrics/start_ALL.sh /u01/scripts/start_ALL.sh
ADD https://raw.githubusercontent.com/iwanttobefreak/weblogic/master/scrics/install/create_domain.sh /u01/install/create_domain.sh
ADD https://raw.githubusercontent.com/iwanttobefreak/weblogic/master/scrics/install/create_domain.py /u01/install/create_domain.py 
RUN chown -R weblogic. /u01
RUN chmod +x /u01/install/install_weblogic.sh
RUN chmod +x /u01/install/create_domain.sh
RUN chmod +x /u01/scripts/start_nodemanager.sh
RUN chmod +x /u01/scripts/start_AdminServer.sh
RUN chmod +x /u01/scripts/start_ALL.sh

USER weblogic

ENV USER_MEM_ARGS="-Djava.security.egd=file:/dev/./urandom"

RUN cd /u01/install && /u01/install/download_weblogic1221.sh $ORACLE_USER $ORACLE_PASSWORD && unzip fmw_12.2.1.1.0_wls_Disk1_1of1.zip

RUN cd /u01/install && /u01/install/install_weblogic.sh

RUN cd /u01/install && /u01/scripts/start_AdminServer.sh && ./create_domain.sh create_domain.ini

#Esborrem programari d'instalacio
RUN rm -f /u01/install/*

CMD ["/u01/scripts/start_ALL.sh"]
