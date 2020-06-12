# kitchen.ci
This is project uses kitchen for testing google modules


## Installation
MacOS uses chefdk for kitchen install it via:
```shell script
$ brew cask install chef/chef/chefdk
```
then add terraform plugin 
```shell script
$ /opt/chefdk/embedded/bin/gem install kitchen-terraform
```

Service account is neccessery 
```shell script
export GOOGLE_APPLICATION_CREDENTIALS=~/gcp-key.json
```

Enable the appropriate APIs that you want to use:
https://console.cloud.google.com/apis/library/compute.googleapis.com/
https://console.cloud.google.com/apis/library/container.googleapis.com


To run full-fledged `create-test-destroy` test use:
```shell script
kitchen test
```
Or to converge node
```shell script
kitchen converge
```
and then test resources
```shell script
kitchen verify
```
after testing, destroy with
```shell script
kitchen destroy
```

## Info
kitchen:
https://kitchen.ci/

inspec gcp module:
https://github.com/inspec/inspec-gcp

gcp resources:
https://www.inspec.io/docs/reference/resources/#gcp-resources

os resources:
https://www.inspec.io/docs/reference/resources/#os-resources