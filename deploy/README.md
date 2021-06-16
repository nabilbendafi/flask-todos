# Terraform deployment files for Flask TODO app


# Deploy Docker image to GCP Artifact Registry

> __Note__: Make sure `gcloud` is available. If not, refer to  [Installing Google Cloud SDK](https://cloud.google.com/sdk/docs/install)

```bash
gcloud auth configure-docker europe-west1-docker.pkg.dev
gcloud auth login
```

Push image to Google Cloud Platform Artifact Registry
```
docker tag flask-todos gcr.io/<project_id>/flask-todos
docker push flask-todos gcr.io/<project_id>/flask-todos
```

# Deploy Kubernetes resources

```bash
terraform init
terraform plan
terraform apply
```

> __Node__: No remote tfstate storage is enabled


# TODO
 - Externalise secret (Secret manager)
 - HTTPS with managed TLS certificates for own domain
 - End-to-end HTTPS
