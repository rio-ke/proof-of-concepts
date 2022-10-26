yum install -y gfs2-utils dlm
pcs cluster cib dlm_cfg
pcs -f dlm_cfg resource create dlm ocf:pacemaker:controld op monitor interval=60s
pcs -f dlm_cfg resource clone dlm clone-max=2 clone-node-max=1

