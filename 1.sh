#!/bin/bash
gcloud auth revoke --all

while [[ -z "$(gcloud config get-value core/account)" ]]; 
do echo "waiting login" && sleep 2; 
done

while [[ -z "$(gcloud config get-value project)" ]]; 
do echo "waiting project" && sleep 2; 
done


gcloud compute networks create securenetwork --subnet-mode=custom
gcloud compute networks subnets create securenetwork --network=securenetwork --region=us-central1 --range=192.168.1.0/24


gcloud compute firewall-rules create allow-rdp --direction=INGRESS --priority=1000 --network=securenetwork --target-tags=rdp --action=ALLOW --rules=tcp:3389 --source-ranges=0.0.0.0/0

gcloud compute firewall-rules create "allow-http" --network=securenetwork --target-tags=http --allow=tcp:80 --source-ranges="0.0.0.0/0" --description="Narrowing HTTP traffic"

gcloud beta compute instances create vm-securehost --zone=us-central1-a --machine-type=n1-standard-2 --subnet=securenetwork --no-address --image=windows-server-2016-dc-v20200908 --image-project=windows-cloud --boot-disk-size=150GB --boot-disk-type=pd-standard --boot-disk-device-name=vm-securehost --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any


gcloud beta compute instances create vm-bastionhost --zone=us-central1-a --machine-type=n1-standard-2 --subnet=securenetwork --image=windows-server-2016-dc-v20200908 --image-project=windows-cloud --boot-disk-size=150GB --boot-disk-type=pd-standard --boot-disk-device-name=vm-bastionhost --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any

gcloud compute instances add-tags vm-bastionhost --tags=rdp --zone=us-central1-a
gcloud compute instances add-tags vm-securehost --tags=rdp --zone=us-central1-a
gcloud compute instances add-tags vm-securehost --tags=http --zone=us-central1-a
gcloud compute instances add-tags vm-bastionhost --tags=http --zone=us-central1-a


# set account password windows
gcloud compute reset-windows-password vm-bastionhost --user app_admin --zone us-central1-a
gcloud compute reset-windows-password vm-securehost --user app_admin2 --zone us-central1-a


# Alternative for Provisioning Process
# cd terraform
# terraform fmt
# terraform init
# terraform plan
# terraform apply

