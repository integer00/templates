# google-nomad-consul-module

This module was generated from [google-module-template](https://github.com/terraform-cloud-modules/google-module-template)

In order to interact with google resources env should be set:

```shell script
export GOOGLE_CREDENTIALS=$(cat ~/gcp-key.json)
or
export GOOGLE_CLOUD_KEYFILE_JSON=~/gcp-key.json
or 
export GOOGLE_APPLICATION_CREDENTIALS=~/gcp-key.json
```

This module uses [kitchen](https://kitchen.ci/) tool with inspec-gcp module to test modules

Proceed to this [readme](test/readme.md) link for more info
