To use Gitlab pipelines, in CI / CD Settings - Variables should be set:

```yaml
ANSIBLE_FORCE_COLOR: true
GCP_DOCKER_PASSWORD: "json from service account with access to gcp registry"
GOOGLE_CREDENTIALS: "json from service account with proper rights"
```

