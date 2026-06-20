### подготовка образов для развертывания
#### готовим template под dns/nfs (debian 12)
cd /var/lib/vz/template/iso
wget https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2

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

