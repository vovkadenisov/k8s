### подготовка образов для развертывания
#### готовим template под dns/nfs (debian 12)
cd /var/lib/vz/template/iso
wget https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2
!!!!!!!! поставить qemu-agent
```
qm create 1000 \
  --name debian-12-cloudinit-template \
  --memory 1024 \
  --cores 1 \
  --net0 virtio,bridge=vmbr0 \
  --ostype l26 \
  --scsihw virtio-scsi-pci

qm importdisk 1000 debian-12-genericcloud-amd64.qcow2 local-lvm

qm set 1000 --scsi0 local-lvm:vm-1000-disk-0
qm set 1000 --ide2 local-lvm:cloudinit
qm set 1000 --boot c --bootdisk scsi0
qm set 1000 --serial0 socket --vga serial0

qm resize 1000 scsi0 20G

qm template 1000
```
#### готовим темплейт под k8s
!!!!!!!! поставить qemu-agent
```
cd /var/lib/vz/template/iso

wget https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img

qm create 1001 \
  --name ubuntu-2404-cloudinit-template \
  --memory 2048 \
  --cores 2 \
  --net0 virtio,bridge=vmbr0 \
  --ostype l26 \
  --scsihw virtio-scsi-pci

qm importdisk 1001 noble-server-cloudimg-amd64.img local-lvm

qm set 1001 --scsi0 local-lvm:vm-1001-disk-0
qm set 1001 --ide2 local-lvm:cloudinit
qm set 1001 --boot c --bootdisk scsi0
qm set 1001 --serial0 socket --vga serial0
qm set 1001 --agent enabled=1
qm resize 1001 scsi0 30G

qm template 1001
```
### разворачиваем через terraform
##### установка на mac
```
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
terraform -install-autocomplete
terraform -version
```
#### развертываем мастер

```
terraform init
export TF_VAR_proxmox_api_token='root@pam!terraform-mac=55038957-523a-4c11-9c6d-db4268d66a4b'
terraform fmt
terraform validate
terraform plan #проверка изменений
terraform apply
```
после создания всегда проверяем хочет ли что-тоо изменить
> terraform plan
