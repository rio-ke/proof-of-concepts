```bash

#!/bin/bash
set -E -u -o pipefail -e

if [[ ! -f /home/webuser/initialized ]]
then
  echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) entrypoint.sh: First time starting container writing file to call out initialization at /home/webuser/initialized"
  touch /home/webuser/initialized
else
  echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) entrypoint.sh: Container restart detected /home/webuser/initialized file found"
  echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) entrypoint.sh: sleeping for 60 seconds to allow administrators time to fix any restart loops"
  sleep 60
fi

echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) entrypoint.sh: Writing environment variables to files"

sed -i "s^GRID_BILLINGCENTER_INTERNAL_URL^$GRID_BILLINGCENTER_INTERNAL_URL^" $CATALINA_HOME/webapps/bc/modules/configuration/config/suite/suite-config.xml
sed -i "s^GRID_CONTACTMANAGER_INTERNAL_URL^$GRID_CONTACTMANAGER_INTERNAL_URL^" $CATALINA_HOME/webapps/bc/modules/configuration/config/suite/suite-config.xml
sed -i "s^GRID_POLICYCENTER_INTERNAL_URL^$GRID_POLICYCENTER_INTERNAL_URL^" $CATALINA_HOME/webapps/bc/modules/configuration/config/suite/suite-config.xml
sed -i "s^GRID_POLICYCENTER_EXTERNAL_URL^$GRID_POLICYCENTER_EXTERNAL_URL^" $CATALINA_HOME/webapps/bc/modules/configuration/config/suite/suite-config.xml

sed -i "s^GRID_DB_AUTOUPGRADE^$GRID_DB_AUTOUPGRADE^" $CATALINA_HOME/webapps/bc/modules/configuration/config/database-config.xml
sed -i "s^GRID_DB_TYPE^$GRID_DB_TYPE^" $CATALINA_HOME/webapps/bc/modules/configuration/config/database-config.xml
if [[ $GRID_DB_DROP_DEFERRABLE_INDEXES = true ]]
then
  if grep -q "drop-deferrable-indexes" $CATALINA_HOME/webapps/bc/modules/configuration/config/database-config.xml
  then
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) entrypoint.sh: drop deferrable indexes line exists. not adding it"
  else
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) entrypoint.sh: no drop deferrable indexes line. adding it"
    sed -i '/^.*<\/database>.*/i <loader drop-deferrable-indexes="enable_all"\/>' $CATALINA_HOME/webapps/bc/modules/configuration/config/database-config.xml
  fi
fi

sed -i "s^GRID_JDBC_URL^$GRID_JDBC_URL^" $CATALINA_HOME/webapps/bc/modules/configuration/config/database-config.xml

sed -i "s^GRID_TIMEADVANCING_OFFSETTESTINGCLOCK_DISABLED^$GRID_TIMEADVANCING_OFFSETTESTINGCLOCK_DISABLED^" $CATALINA_HOME/webapps/bc/modules/configuration/config/plugin/registry/ITestingClock.gwp

sed -i "s^GRID_CLUSTERING_ENABLED^$GRID_CLUSTERING_ENABLED^" $CATALINA_HOME/webapps/bc/modules/configuration/config/config.xml
sed -i "s^GRID_SCHEDULER_ENABLED^$GRID_SCHEDULER_ENABLED^" $CATALINA_HOME/webapps/bc/modules/configuration/config/config.xml

sed -i "s^GRID_WORKQUEUETHREADPOOLMAXSIZE^$GRID_WORKQUEUETHREADPOOLMAXSIZE^" $CATALINA_HOME/webapps/bc/modules/configuration/config/config.xml
sed -i "s^GRID_WORKQUEUETHREADSKEEPALIVETIME^$GRID_WORKQUEUETHREADSKEEPALIVETIME^" $CATALINA_HOME/webapps/bc/modules/configuration/config/config.xml
sed -i "s^GRID_GUIDEWIRE_USER_PASSWORD_MINIMUM_LENGTH^$GRID_GUIDEWIRE_USER_PASSWORD_MINIMUM_LENGTH^" $CATALINA_HOME/webapps/bc/modules/configuration/config/config.xml


sed -i "s^GRID_TOMCAT_GMCCADMIN_USERS_PASSWORD^$GRID_TOMCAT_GMCCADMIN_USERS_PASSWORD^" $CATALINA_HOME/conf/tomcat-users.xml
sed -i "s^GRID_TOMCAT_HOME_REDIRECT_URL^$GRID_TOMCAT_HOME_REDIRECT_URL^"  $CATALINA_HOME/webapps/ROOT/index.jsp
sed -i "s^GRID_TOMCAT_JMX_REMOTE_PASSWORD_CONTROL_ROLE^$GRID_TOMCAT_JMX_REMOTE_PASSWORD_CONTROL_ROLE^" $CATALINA_HOME/conf/jmxremote.password
sed -i "s^GRID_TOMCAT_JMX_REMOTE_PASSWORD_MONITOR_ROLE^$GRID_TOMCAT_JMX_REMOTE_PASSWORD_MONITOR_ROLE^" $CATALINA_HOME/conf/jmxremote.password

sed -i "s^GRID_TOMCAT_CONNECTIONTIMEOUT^$GRID_TOMCAT_CONNECTIONTIMEOUT^" $CATALINA_HOME/conf/server.xml
sed -i "s^GRID_TOMCAT_MAXCONNECTIONS^$GRID_TOMCAT_MAXCONNECTIONS^" $CATALINA_HOME/conf/server.xml
sed -i "s^GRID_TOMCAT_MAXPOSTSIZE^$GRID_TOMCAT_MAXPOSTSIZE^" $CATALINA_HOME/conf/server.xml
sed -i "s^GRID_TOMCAT_MAXTHREADS^$GRID_TOMCAT_MAXTHREADS^" $CATALINA_HOME/conf/server.xml
sed -i "s^GRID_TOMCAT_MINSPARETHREADS^$GRID_TOMCAT_MINSPARETHREADS^" $CATALINA_HOME/conf/server.xml
sed -i "s^GRID_TOMCAT_PORT^$GRID_TOMCAT_PORT^" $CATALINA_HOME/conf/server.xml
sed -i "s^GRID_TOMCAT_PROCESSORCACHE^$GRID_TOMCAT_PROCESSORCACHE^" $CATALINA_HOME/conf/server.xml
sed -i "s^GRID_TOMCAT_PROXYNAME^$GRID_TOMCAT_PROXYNAME^" $CATALINA_HOME/conf/server.xml
sed -i "s^GRID_TOMCAT_PROXYPORT^$GRID_TOMCAT_PROXYPORT^" $CATALINA_HOME/conf/server.xml
sed -i "s^GRID_TOMCAT_REDIRECTPORT^$GRID_TOMCAT_REDIRECTPORT^" $CATALINA_HOME/conf/server.xml
sed -i "s^GRID_TOMCAT_SCHEME^$GRID_TOMCAT_SCHEME^" $CATALINA_HOME/conf/server.xml

sed -i "s^GRID_TOMCAT_CACHEMAXSIZE^$GRID_TOMCAT_CACHEMAXSIZE^" $CATALINA_HOME/conf/context.xml

sed -i "s^GRID_SSO_ENABLED^$GRID_SSO_ENABLED^" $CATALINA_HOME/webapps/bc/modules/configuration/config/resources/ScriptParameters.xml

sed -i "s^GRID_COMMON_AB_INTEGRATION_PASSWORD^$GRID_COMMON_AB_INTEGRATION_PASSWORD^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/common.properties
sed -i "s^GRID_COMMON_AB_INTEGRATION_USERNAME^$GRID_COMMON_AB_INTEGRATION_USERNAME^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/common.properties
sed -i "s^GRID_COMMON_BC_INTEGRATION_PASSWORD^$GRID_COMMON_BC_INTEGRATION_PASSWORD^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/common.properties
sed -i "s^GRID_COMMON_BC_INTEGRATION_USERNAME^$GRID_COMMON_BC_INTEGRATION_USERNAME^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/common.properties
sed -i "s^GRID_COMMON_CC_INTEGRATION_PASSWORD^$GRID_COMMON_CC_INTEGRATION_PASSWORD^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/common.properties
sed -i "s^GRID_COMMON_CC_INTEGRATION_USERNAME^$GRID_COMMON_CC_INTEGRATION_USERNAME^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/common.properties
sed -i "s^GRID_COMMON_INTEGRATION_USER^$GRID_COMMON_INTEGRATION_USER^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/common.properties
sed -i "s^GRID_COMMON_OOTB_DEFAULT_PASSWORD^$GRID_COMMON_OOTB_DEFAULT_PASSWORD^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/common.properties
sed -i "s^GRID_COMMON_OOTB_DEFAULT_USERNAME^$GRID_COMMON_OOTB_DEFAULT_USERNAME^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/common.properties
sed -i "s^GRID_COMMON_PC_INTEGRATION_PASSWORD^$GRID_COMMON_PC_INTEGRATION_PASSWORD^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/common.properties
sed -i "s^GRID_COMMON_PC_INTEGRATION_USERNAME^$GRID_COMMON_PC_INTEGRATION_USERNAME^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/common.properties

sed -i "s^GRID_COMMISSIONSTATEMENTS_PARSER_FILEDROPLOCATION^$GRID_COMMISSIONSTATEMENTS_PARSER_FILEDROPLOCATION^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_COMMISSIONSTATEMENTS_PARSER_FILEEXTRACTLOCATION^$GRID_COMMISSIONSTATEMENTS_PARSER_FILEEXTRACTLOCATION^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_CUSTOMERNOTIFICATION_BILLISREADY_PARSER_FILEDROPLOCATION^$GRID_CUSTOMERNOTIFICATION_BILLISREADY_PARSER_FILEDROPLOCATION^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_CUSTOMERNOTIFICATION_CANCELDATE_PARSER_FILEDROPLOCATION^$GRID_CUSTOMERNOTIFICATION_CANCELDATE_PARSER_FILEDROPLOCATION^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_CUSTOMERNOTIFICATION_DUEDATE_PARSER_FILEDROPLOCATION^$GRID_CUSTOMERNOTIFICATION_DUEDATE_PARSER_FILEDROPLOCATION^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_CUSTOMERNOTIFICATION_PARSER_FILEEXTRACTLOCATION^$GRID_CUSTOMERNOTIFICATION_PARSER_FILEEXTRACTLOCATION^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_CUSTOMERNOTIFICATION_PAYMENTCONFIRMATION_PARSER_FILEDROPLOCATION^$GRID_CUSTOMERNOTIFICATION_PAYMENTCONFIRMATION_PARSER_FILEDROPLOCATION^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_EXTERNAL_BILLINGCENTER_URL^$GRID_EXTERNAL_BILLINGCENTER_URL^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_ADDRESSSTANDARDIZATION_ENDPOINT^$GRID_INTEGRATION_ADDRESSSTANDARDIZATION_ENDPOINT^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_CDS_AUDIT_BATCH_DATAFILE_LOCATION^$GRID_INTEGRATION_CDS_AUDIT_BATCH_DATAFILE_LOCATION^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_CDS_AUDIT_BATCH_DATAFILE_LOCATION^$GRID_INTEGRATION_CDS_AUDIT_BATCH_DATAFILE_LOCATION^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_CDS_AUDIT_BATCH_EXTRACT_LOCATION^$GRID_INTEGRATION_CDS_AUDIT_BATCH_EXTRACT_LOCATION^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_CDS_AUDIT_BATCH_EXTRACT_LOCATION^$GRID_INTEGRATION_CDS_AUDIT_BATCH_EXTRACT_LOCATION^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_CDS_AUDIT_BATCH_PROCESSED_LOCATION^$GRID_INTEGRATION_CDS_AUDIT_BATCH_PROCESSED_LOCATION^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_CDS_AUDIT_BATCH_PROCESSED_LOCATION^$GRID_INTEGRATION_CDS_AUDIT_BATCH_PROCESSED_LOCATION^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_CDS_NOTIFICATION_EMAILTO^$GRID_INTEGRATION_CDS_NOTIFICATION_EMAILTO^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_CDS_NOTIFICATION_EMAIL_SUBJECT_PREFIX^$GRID_INTEGRATION_CDS_NOTIFICATION_EMAIL_SUBJECT_PREFIX^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_CONTENTMANAGER_BILLINGDOCUMENTSURL^$GRID_INTEGRATION_CONTENTMANAGER_BILLINGDOCUMENTSURL^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_CONTENTMANAGER_DOWNLOAD_ENDPOINT^$GRID_INTEGRATION_CONTENTMANAGER_DOWNLOAD_ENDPOINT^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_CONTENTMANAGER_EFTDOCUMENTSURL^$GRID_INTEGRATION_CONTENTMANAGER_EFTDOCUMENTSURL^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_CONTENTMANAGER_UPLOAD_ENDPOINT^$GRID_INTEGRATION_CONTENTMANAGER_UPLOAD_ENDPOINT^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_CONTENTMANAGER_UPLOAD_RESTRICTED_ENDPOINT^$GRID_INTEGRATION_CONTENTMANAGER_UPLOAD_RESTRICTED_ENDPOINT^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_CONTENTMANAGER_UPLOAD_UNRESTRICTED_ENDPOINT^$GRID_INTEGRATION_CONTENTMANAGER_UPLOAD_UNRESTRICTED_ENDPOINT^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_EFT_AUDIT_BATCH_DATAFILE_LOCATION^$GRID_INTEGRATION_EFT_AUDIT_BATCH_DATAFILE_LOCATION^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_EFT_AUDIT_BATCH_DATAFILE_LOCATION^$GRID_INTEGRATION_EFT_AUDIT_BATCH_DATAFILE_LOCATION^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_EFT_AUDIT_BATCH_EXTRACT_LOCATION^$GRID_INTEGRATION_EFT_AUDIT_BATCH_EXTRACT_LOCATION^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_EFT_AUDIT_BATCH_EXTRACT_LOCATION^$GRID_INTEGRATION_EFT_AUDIT_BATCH_EXTRACT_LOCATION^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_EFT_AUDIT_BATCH_PROCESSED_LOCATION^$GRID_INTEGRATION_EFT_AUDIT_BATCH_PROCESSED_LOCATION^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_EFT_AUDIT_BATCH_PROCESSED_LOCATION^$GRID_INTEGRATION_EFT_AUDIT_BATCH_PROCESSED_LOCATION^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_EPAY_ENCRYPTION_KEY^$GRID_INTEGRATION_EPAY_ENCRYPTION_KEY^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_EPAY_LOGIN_URL^$GRID_INTEGRATION_EPAY_LOGIN_URL^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_ESB_AGENCYSWEEP_ENDPOINT^$GRID_INTEGRATION_ESB_AGENCYSWEEP_ENDPOINT^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_ESB_AGENCYSWEEP_PASSWORD^$GRID_INTEGRATION_ESB_AGENCYSWEEP_PASSWORD^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_ESB_AGENCYSWEEP_USERNAME^$GRID_INTEGRATION_ESB_AGENCYSWEEP_USERNAME^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_ESB_CIF_ENDPOINT^$GRID_INTEGRATION_ESB_CIF_ENDPOINT^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_ESB_CIF_GETPAPERLESS_ACCOUNT_ENDPOINT^$GRID_INTEGRATION_ESB_CIF_GETPAPERLESS_ACCOUNT_ENDPOINT^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_ESB_CIF_GETPAPERLESS_POLICY_ENDPOINT^$GRID_INTEGRATION_ESB_CIF_GETPAPERLESS_POLICY_ENDPOINT^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_ESB_CIF_PASSWORD^$GRID_INTEGRATION_ESB_CIF_PASSWORD^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_ESB_CIF_SETPAPERLESS_ACCOUNT_ENDPOINT^$GRID_INTEGRATION_ESB_CIF_SETPAPERLESS_ACCOUNT_ENDPOINT^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_ESB_CIF_SETPAPERLESS_POLICY_ENDPOINT^$GRID_INTEGRATION_ESB_CIF_SETPAPERLESS_POLICY_ENDPOINT^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_ESB_CIF_USERNAME^$GRID_INTEGRATION_ESB_CIF_USERNAME^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_ESB_COLLECTIONAGENCY_ENDPOINT^$GRID_INTEGRATION_ESB_COLLECTIONAGENCY_ENDPOINT^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_ESB_COLLECTIONAGENCY_PASSWORD^$GRID_INTEGRATION_ESB_COLLECTIONAGENCY_PASSWORD^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_ESB_COLLECTIONAGENCY_USERNAME^$GRID_INTEGRATION_ESB_COLLECTIONAGENCY_USERNAME^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_ESB_CONTENTMANAGER_LOCATION^$GRID_INTEGRATION_ESB_CONTENTMANAGER_LOCATION^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_ESB_CONTENTMANAGER_PASSWORD^$GRID_INTEGRATION_ESB_CONTENTMANAGER_PASSWORD^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_ESB_CONTENTMANAGER_USERNAME^$GRID_INTEGRATION_ESB_CONTENTMANAGER_USERNAME^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_ESB_EMAIL2_EMAILWITHATTACHMENT_ENDPOINT^$GRID_INTEGRATION_ESB_EMAIL2_EMAILWITHATTACHMENT_ENDPOINT^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_ESB_EMAIL2_MESSAGEFAILURE_NOTIFY_FROM_BC_ADDRESS^$GRID_INTEGRATION_ESB_EMAIL2_MESSAGEFAILURE_NOTIFY_FROM_BC_ADDRESS^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_ESB_EMAIL2_PASSWORD^$GRID_INTEGRATION_ESB_EMAIL2_PASSWORD^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_ESB_EMAIL2_PLAINEMAIL_ENDPOINT^$GRID_INTEGRATION_ESB_EMAIL2_PLAINEMAIL_ENDPOINT^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_ESB_EMAIL2_USERNAME^$GRID_INTEGRATION_ESB_EMAIL2_USERNAME^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_ESB_EMAIL_ENDPOINT^$GRID_INTEGRATION_ESB_EMAIL_ENDPOINT^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_ESB_EMAIL_PASSWORD^$GRID_INTEGRATION_ESB_EMAIL_PASSWORD^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_ESB_EMAIL_USERNAME^$GRID_INTEGRATION_ESB_EMAIL_USERNAME^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_ESB_EPAY_ENDPOINT^$GRID_INTEGRATION_ESB_EPAY_ENDPOINT^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_ESB_EPAY_PASSWORD^$GRID_INTEGRATION_ESB_EPAY_PASSWORD^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_ESB_EPAY_USERNAME^$GRID_INTEGRATION_ESB_EPAY_USERNAME^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_ESB_NOTIFICATION_ENDPOINT^$GRID_INTEGRATION_ESB_NOTIFICATION_ENDPOINT^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_ESB_NOTIFICATION_PASSWORD^$GRID_INTEGRATION_ESB_NOTIFICATION_PASSWORD^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_ESB_NOTIFICATION_USERNAME^$GRID_INTEGRATION_ESB_NOTIFICATION_USERNAME^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_ESB_PASSWORD^$GRID_INTEGRATION_ESB_PASSWORD^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_ESB_PMS_ENDPOINT^$GRID_INTEGRATION_ESB_PMS_ENDPOINT^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_ESB_PMS_PASSWORD^$GRID_INTEGRATION_ESB_PMS_PASSWORD^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_ESB_PMS_USERNAME^$GRID_INTEGRATION_ESB_PMS_USERNAME^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_ESB_USERNAME^$GRID_INTEGRATION_ESB_USERNAME^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_INSUREPAYMENT_ENDPOINT^$GRID_INTEGRATION_INSUREPAYMENT_ENDPOINT^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_LDAP_AUTHENTICATION_TYPE^$GRID_INTEGRATION_LDAP_AUTHENTICATION_TYPE^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_LDAP_CONTEXT_FACTORY^$GRID_INTEGRATION_LDAP_CONTEXT_FACTORY^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_LDAP_PORT^$GRID_INTEGRATION_LDAP_PORT^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_LDAP_URL^$GRID_INTEGRATION_LDAP_URL^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_OFAC_ENDPOINT^$GRID_INTEGRATION_OFAC_ENDPOINT^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_OFAC_PASSWORD^$GRID_INTEGRATION_OFAC_PASSWORD^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_OFAC_USERNAME^$GRID_INTEGRATION_OFAC_USERNAME^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_PMS_BATCH_FILEOPLOCATION_BC^$GRID_INTEGRATION_PMS_BATCH_FILEOPLOCATION_BC^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_PRINT_BATCH_FILEOPLOCATION_BC^$GRID_INTEGRATION_PRINT_BATCH_FILEOPLOCATION_BC^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_PRINT_DOCUMENT_ENDPOINT^$GRID_INTEGRATION_PRINT_DOCUMENT_ENDPOINT^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_PRINT_DOCUMENT_PASSWORD^$GRID_INTEGRATION_PRINT_DOCUMENT_PASSWORD^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_PRINT_DOCUMENT_USERNAME^$GRID_INTEGRATION_PRINT_DOCUMENT_USERNAME^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_PRODUCERPAYMENT_ENDPOINT^$GRID_INTEGRATION_PRODUCERPAYMENT_ENDPOINT^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_SSO_PC_URL^$GRID_INTEGRATION_SSO_PC_URL^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_PRODUCERPAYMENT_PARSER_FILEREADLOCATION^$GRID_PRODUCERPAYMENT_PARSER_FILEREADLOCATION^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_BLACKOUT_STOP_ENDPOINT^$GRID_INTEGRATION_BLACKOUT_STOP_ENDPOINT^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_BLACKOUT_START_ENDPOINT^$GRID_INTEGRATION_BLACKOUT_START_ENDPOINT^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_BLACKOUT_USERNAME^$GRID_INTEGRATION_BLACKOUT_USERNAME^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_BLACKOUT_PASSWORD^$GRID_INTEGRATION_BLACKOUT_PASSWORD^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
sed -i "s^GRID_INTEGRATION_BLACKOUT_REQUESTID^$GRID_INTEGRATION_BLACKOUT_REQUESTID^" $CATALINA_HOME/webapps/bc/modules/configuration/gsrc/grg/properties/grid/integration.properties
if [[ ! -f $CATALINA_HOME/logs/bclog.log ]]
then
    touch $CATALINA_HOME/logs/bclog.log
fi

echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) entrypoint.sh: GRID_DB_TYPE is $GRID_DB_TYPE"
echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) entrypoint.sh: Checking $GRID_JDBC_URL for kerberos"
if [[ $(echo $GRID_JDBC_URL | awk '/JavaKerberos/') == *JavaKerberos* ]]
then
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) entrypoint.sh: Database Authentication contains kerberos"
    # javakerberos conf SQLJDBCDriver.conf
    sed -i "s^GRID_KEYTAB_USER^$GRID_KEYTAB_USER^" /home/webuser/SQLJDBCDriver.conf
    sed -i "s^GRID_KEYTAB_DOMAIN^$GRID_KEYTAB_DOMAIN^" /home/webuser/SQLJDBCDriver.conf
    # Generate keytab and set permissions /home/webuser/keytab.keytab
    printf "%b" "addent -password -p $GRID_KEYTAB_USER -k 1 -e rc4-hmac\n$GRID_KEYTAB_PASSWORD\nwrite_kt /home/webuser/keytab.keytab" | ktutil
    printf "%b" "read_kt /home/webuser/keytab.keytab\nlist" | ktutil

    kinit $GRID_KEYTAB_USER@$GRID_KEYTAB_DOMAIN -k -t /home/webuser/keytab.keytab
else
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) entrypoint.sh: Database Authentication does not contain kerberos"
fi
set +u

echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) entrypoint.sh: mount fileshare"
if [[ -z $GRID_FILESHARE_MOUNT_FOLDER ]]
then
  echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) WARN: entrypoint.sh: GRID_FILESHARE_MOUNT_FOLDER folder variable is null, not making directory"
elif [[ -z $GRID_FILESHARE_MOUNTPOINT ]]
then
  echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) WARN: entrypoint.sh: GRID_FILESHARE_MOUNTPOINT variable is null"
elif [[ -z $GRID_FILESHARE_USERNAME ]]
then
  echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) WARN: entrypoint.sh: GRID_FILESHARE_USERNAME variable is null"
elif [[ -z $GRID_FILESHARE_PASSWORD ]]
then
  echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) WARN: entrypoint.sh: FILESHARE_PASSWORD variable is null"
else
  if [[ ! -d $GRID_FILESHARE_MOUNT_FOLDER ]]
  then
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) entrypoint.sh: Making $GRID_FILESHARE_MOUNT_FOLDER directory"
    mkdir -p $GRID_FILESHARE_MOUNT_FOLDER
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) entrypoint.sh: Updating fstab for GRID_FILESHARE_MOUNTPOINT: $GRID_FILESHARE_MOUNTPOINT GRID_FILESHARE_MOUNT_FOLDER: $GRID_FILESHARE_MOUNT_FOLDER GRID_FILESHARE_USERNAME: $GRID_FILESHARE_USERNAME"
    echo "$GRID_FILESHARE_MOUNTPOINT $GRID_FILESHARE_MOUNT_FOLDER cifs   uid=1000,gid=1000,vers=3.0,domain=gmcc,username=$GRID_FILESHARE_USERNAME,password=$GRID_FILESHARE_PASSWORD,iocharset=utf8,sec=ntlmssp,users,noauto,noperm   0  0" >> /etc/fstab
  else
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) entrypoint.sh: Found $GRID_FILESHARE_MOUNT_FOLDER. Not updating /etc/fstab for GRID_FILESHARE_MOUNTPOINT: $GRID_FILESHARE_MOUNTPOINT GRID_FILESHARE_MOUNT_FOLDER: $GRID_FILESHARE_MOUNT_FOLDER GRID_FILESHARE_USERNAME: $GRID_FILESHARE_USERNAME"
  fi
  echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) entrypoint.sh: Running command to update mount.cifs for GRID_FILESHARE_MOUNTPOINT: $GRID_FILESHARE_MOUNTPOINT GRID_FILESHARE_MOUNT_FOLDER: $GRID_FILESHARE_MOUNT_FOLDER GRID_FILESHARE_USERNAME: $GRID_FILESHARE_USERNAME"
  /sbin/mount.cifs --verbose $GRID_FILESHARE_MOUNTPOINT $GRID_FILESHARE_MOUNT_FOLDER -o uid=1000,gid=1000,vers=3.0,domain=gmcc,username=$GRID_FILESHARE_USERNAME,password=$GRID_FILESHARE_PASSWORD,iocharset=utf8,sec=ntlmssp,users
  echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) entrypoint.sh: done with for GRID_FILESHARE_MOUNTPOINT: $GRID_FILESHARE_MOUNTPOINT GRID_FILESHARE_MOUNT_FOLDER: $GRID_FILESHARE_MOUNT_FOLDER GRID_FILESHARE_USERNAME: $GRID_FILESHARE_USERNAME"
fi
echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) entrypoint.sh: mount fileshare done"

set -u

echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) entrypoint.sh: GRID_DB_TYPE is $GRID_DB_TYPE"

if [[ $GRID_SSO_ENABLED == "true" ]]
then
  echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) entrypoint.sh: GRID_SSO_ENABLED is $GRID_SSO_ENABLED"
  if [[ -f /opt/tomcat/webapps/bc/modules/configuration/gsrc/grg/integrations/sso/certificate/Saml2.cer ]]
  then
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) entrypoint.sh: found Saml2.cer"
  else
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) entrypoint.sh: could not find Saml2.cer"
    exit 1
  fi
fi

echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) entrypoint.sh: Launching Tomcat"
$CATALINA_HOME/bin/catalina.sh run
sleep 5

echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) entrypoint.sh: Tailing Tomcat Logs"
tail --pid $(pidof java) -F $CATALINA_HOME/logs/bclog.log

```
