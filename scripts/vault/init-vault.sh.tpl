#!/bin/bash
set -ex

# Join to Consul cluster
consul join ${private_ip_consul}

###########
## VAULT ## 
###########
export VAULT_ADDR='http://127.0.0.1:8200'

# Initialize Vault
vault init | tee /tmp/vault.init > /dev/null
  
# Unsealing Vault
cat /tmp/vault.init | grep '^Unseal' | awk '{print $4}' | for key in $(cat -); do
  vault unseal $key 
done

# Store token in secret/vault/root-token
export ROOT_TOKEN=$(cat /tmp/vault.init | grep '^Initial' | awk '{print $4}')
vault auth $ROOT_TOKEN
vault write secret/vault/root-token value=$ROOT_TOKEN

#########
## PGP ##
#########

cat /tmp/vault.init

# Remove master keys from disk
#shred /tmp/vault.init

#COUNTER=1
#cat /tmp/vault.init | grep '^Unseal' | awk '{print $4}' | for key in $(cat -); do
#  curl -fX PUT 127.0.0.1:8500/v1/kv/service/vault/unseal-key-$COUNTER -d $key
#  COUNTER=$((COUNTER + 1))
#done

##########
## AUTH ##
##########

# Github
vault auth-enable github
vault write auth/github/config organization=DigitalOnUs
vault write auth/github/map/teams/default value=default

############
## SECRET ##
############

# AWS
vault mount aws
vault write aws/config/root access_key=${access_key} secret_key=${secret_key} region=${region}
vault write aws/config/lease lease="1m" lease_max="2m"

# Transit
vault mount transit
vault write -f transit/keys/DevSecOps

############
## POLICY ##
############

# AWS
