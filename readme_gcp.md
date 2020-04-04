gcloud cheat sheet
------

Auth with gcloud:
```
gcloud auth login
```

Set this account as default:
```
gcloud config set account MyAccount_Name
```

Set default project:
```
gcloud config set project MyProject_Name
```

Get access to docker registry
```
gcloud auth configure-docker
``` 

List projects:
```
gcloud projects list
```

List running compute instances:
```
gcloud compute instances list
```

List buckets:
```
gsutil ls
```

Create bucket:
```
gsutil mb gs://my-bucket-name
```

Show managed DNS-zones:
```
gcloud dns managed-zones list
```

Show DNS-records:
```
gcloud dns record-sets list --zone=dns_zone_name
```

Show firewall rules:
```
gcloud compute firewall-rules list
```
