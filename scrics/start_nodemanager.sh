#!/bin/bash
/u01/middleware1221/wlserver/common/bin/wlst.sh << EOF
startNodeManager(NodeManagerHome='/u01/domains/mydomain/nodemanager',SecureListener="false")
exit()
EOF
