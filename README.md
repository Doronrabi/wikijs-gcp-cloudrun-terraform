
## Deployment Documentation

### Prerequisites

Before deployment, ensure the following:
- Bash Shell environment
- Terraform installed
- gcloud CLI installed
- A clean GCP project (free tier is sufficient)

### Environment Configuration:
run:
```
export TF_VAR_db_password="[super-secure-password]"
export TF_VAR_project_id="[your-gcp-project-id]"
```

then authenticate with GCP:
```
gcloud auth application-default login
```

### Deployment Instructions

From the project root directory run:
```
terraform init
```
```
until terraform apply -auto-approve; do echo "creation failed. retrying in 30 seconds..."; sleep 30; done
```
creation might fail a couple of times due to api access creation takes some time to propagate, the command will insure retry until success

Terraform will:
1. Enable required APIs 
2. Create VPC & networking 
3. Provision Cloud SQL 
4. Deploy Cloud Run 
5. Configure monitoring 
6. Configure IAM

Note the output of terraform: "wikijs_service_url" - this will be your public url for the wiki.js service

### Secure Initial Setup of Wiki.js

To prevent unauthorized takeover during initial installation, Cloud Run resource is configured with "Require Authentication"

To Perform Initial Setup you must first Proxy the service locally:
```
gcloud run services proxy [cloud run resource] --region [the cloud region you used] --project [your project id]
```
Example:
```
gcloud run services proxy wikijs-dev --region us-central1 --project YOUR_PROJECT_ID
```

Then access the service locally from the browser :
```
http://127.0.0.1:8080 - or whatever output you got from gcloud run services proxy command
```
When you are in the browser and the page for the setup appears, You'll need to register an admin account
Then for the url:
Paste in your Cloud Run url("wikijs_service_url" terraform output), should be something like this:
```
https://wikijs-dev-gdrqgideka-uc.a.run.app
```

Click install

Wait for a few seconds and refresh.
after the service is back run:
```
terraform apply --auto-approve -var="allow_public_access_cloud_run=true"
```
Now use the url you entered in the wiki.js installation phase to access the service from the public internet.
You can use the admin credentials you used to register the admin account to login to the admin dashboard securely

### teardown
run:
```
until terraform destroy -auto-approve; do echo "Destroy failed. retrying in 90 seconds..."; sleep 90; done
```
It might fail few times but will try again automatically until successfully destroys all resources 



## Technology Stack & Design Decisions

### Cloud provider - Google Cloud Platform (GCP)

Google Cloud Platform (GCP) was selected due to:
- Native serverless capabilities
- Managed HTTPS and autoscaling
- Strong integration between cloud Run and cloud SQL
- Minimal operational overhead
- Built in monitoring and logging

---

### Infrastructure as code - Terraform

Terraform was chosen because:
- It is industry standard
- Enables reproducible infrastructure
- Provides declarative configuration
- Ensures clean teardown capability
- Supports modular architecture

The project is structured into reusable modules:

- `network`
- `sql`
- `wikijs`
- `iam`
- `monitoring`

---

### Compute - Cloud Run

Wiki.js is deployed on Google Cloud Run because it provides:

- Fully managed serverless container runtime
- Automatic HTTPS provisioning
- Built in autoscaling
- Regional high availability
- No server management required

---

### Networking

The solution uses:
- Custom VPC
- Dedicated Subnetwork
- Private Service Access

This architecture ensures:
- Cloud SQL is not publicly accessible
- Cloud Run accesses SQL privately
- No database exposure to the internet

---

### Database - Cloud SQL (PostgreSQL)

Wiki.js requires a relational database backend.

Cloud SQL (PostgreSQL) was selected because it offers:
- Fully managed PostgreSQL
- Automated backups and maintenance
- Private IP support
- Secure integration with VPC

The database is configured with access restricted through VPC networking only,
This ensures the database is never exposed to the public internet.

---

####  Observability

Built in Cloud Run Monitoring

For application-level monitoring, Google Cloud Run provides built-in observability features, including:

- Request logs
- Error logs
- Container logs
- CPU and memory metrics
- Request latency metrics
- Revision-level metrics
- Autoscaling metrics

### Uptime Monitoring & Alerts:

To ensure external availability monitoring, an explicit uptime check was implemented using Cloud Monitoring.

This provides:
- External health verification (from outside the service)
- Automatic detection of downtime


