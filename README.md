Trend Store — DevOps Deployment Project
Project Overview
This project demonstrates an end-to-end DevOps workflow for deploying the Trend Store application to Amazon EKS. It includes infrastructure provisioning with Terraform, containerization with Docker, CI/CD through Jenkins, Kubernetes deployment, and monitoring with Prometheus and Grafana.
Note: Gmail SMTP alert delivery is currently not working because Gmail returns 535 5.7.8 BadCredentials. The monitoring dashboard itself is deployed and running. Email notifications are an outstanding optional configuration item.

Architecture
GitHub Repository
       |
       v
Jenkins Pipeline
       |
       +--> Build application Docker image
       |
       +--> Push image to Docker Hub
       |
       +--> Deploy/update application on Amazon EKS
                    |
                    v
             Kubernetes Service
                    |
                    v
             Trend Store application

Amazon EKS Cluster
       |
       +--> Prometheus
       |      +--> Kubernetes / node metrics
       |
       +--> Grafana
              +--> DevOps monitoring dashboard
              +--> Alert rules (email delivery not yet verified)
Technology Stack
- AWS EKS — Kubernetes cluster
- Terraform — infrastructure as code
- Docker — application containerization
- Docker Hub — container image registry
- Jenkins — CI/CD pipeline
- Kubernetes — application deployment and service
- Prometheus — metrics collection
- Grafana — dashboards and alert rules
- GitHub — source control
Repository
GitHub: https://github.com/FarhadBaig/Trend-DevOps-Project
AWS / Kubernetes Details
- AWS Region: ap-south-1
- EKS Cluster: trend-store-eks
- Kubernetes namespace for monitoring: monitoring
- Application Deployment: trend-store
- Application Service: trend-store-service
- Container image used by the pipeline: farhadbaig/trend-app:1.0
The application Service is configured as a Kubernetes LoadBalancer. Get the current external endpoint with:
kubectl get service trend-store-service -n default
If the service is in a different namespace, check the deployment YAML and use that namespace.
Prerequisites
Install and configure the following tools on the machine used to administer the project:
- AWS CLI with credentials/role permitted to access the cluster
- kubectl
- eksctl only if required by your workflow
- Terraform
- Helm
- Git
- Docker
- Access to the Jenkins server
- Access to the Docker Hub repository used by the pipeline
Do not commit AWS access keys, Kubernetes credentials, Docker Hub tokens, Jenkins credentials, Gmail App Passwords, or Kubernetes Secret manifests containing real values.
1. Clone the Repository
git clone https://github.com/FarhadBaig/Trend-DevOps-Project.git
cd Trend-DevOps-Project
2. Provision Infrastructure with Terraform
Review the Terraform files and variables before applying them. Never run terraform destroy against a shared or evaluation environment unless you intentionally want to delete the resources.
cd terraform
terraform init
terraform validate
terraform plan
terraform apply
Use the variable file expected by the repository, if one is required. Do not commit real credentials or sensitive .tfvars files.
After provisioning, return to the repository root:
cd ..
If the EKS cluster already exists, do not blindly re-run infrastructure creation. First inspect the Terraform state and AWS resources.
3. Configure kubectl for EKS
aws eks update-kubeconfig --region ap-south-1 --name trend-store-eks
kubectl config current-context
kubectl get nodes
Expected result: the context points to the trend-store-eks cluster and worker nodes are Ready.
4. Build and Push the Docker Image
The Jenkins pipeline is intended to build the application image and push it to Docker Hub. If building manually for troubleshooting, use the application directory that contains the Dockerfile:
docker build -t farhadbaig/trend-app:1.0 .
docker login
docker push farhadbaig/trend-app:1.0
Run the build from the directory containing the correct Dockerfile. Store Docker Hub credentials in Jenkins Credentials, not in the Jenkinsfile.
5. Deploy the Application to EKS
The Jenkins pipeline should apply or update the Kubernetes deployment and service manifests. To inspect the current state:
kubectl get deployments,pods,services -n default
kubectl rollout status deployment/trend-store -n default
kubectl describe service trend-store-service -n default
Get the application LoadBalancer hostname:
kubectl get service trend-store-service -n default
Open the EXTERNAL-IP hostname in a browser using http:// if the service is configured for HTTP.
6. Monitoring with Prometheus and Grafana
Monitoring components are installed in the monitoring namespace. Check their status:
kubectl get pods -n monitoring
kubectl get services -n monitoring
Open Grafana locally
Run this command in a dedicated PowerShell window and leave it running:
kubectl port-forward -n monitoring service/monitoring-grafana 3001:80
Then open:
http://127.0.0.1:3001
Use the configured Grafana credentials. Do not store the password in this README or commit it to Git.
Dashboard
The dashboard JSON is stored at:
monitoring/dashboards/complete-devops-guide.json
It includes Kubernetes monitoring panels such as pod counts, failed pods, CPU/memory by namespace, and pod restarts, depending on the configured metrics.
Alerting / Gmail SMTP status
A Grafana alert rule has been configured, but Gmail contact-point testing currently fails with:
535 5.7.8 Username and Password not accepted (BadCredentials)
The SMTP username and Kubernetes Secret references have been checked. Email notification delivery is not verified. Do not describe email alerting as complete until a contact-point test succeeds. This does not mean the dashboard or Prometheus metrics are unavailable.
If SMTP is not required for evaluation, leave the alert rule/dashboard in place and document email delivery as a known limitation. If you later troubleshoot it, use a valid App Password from the same Google account, keep it out of Git, and rotate any credential that was exposed.
7. Useful Troubleshooting Commands
# Cluster and nodes
kubectl config current-context
kubectl get nodes

# Application
kubectl get deployment trend-store -n default
kubectl get pods -n default -o wide
kubectl get service trend-store-service -n default
kubectl logs deployment/trend-store -n default --tail=100
kubectl rollout status deployment/trend-store -n default

# Monitoring
kubectl get pods -n monitoring
kubectl logs deployment/monitoring-grafana -n monitoring -c grafana --since=10m
kubectl get prometheus,servicemonitor,prometheusrule -n monitoring

# Jenkins pipeline and repository
git status
git log -5 --oneline
If a resource name differs, confirm the actual name first with kubectl get all -n <namespace>.
8. Evidence / Screenshots
The Screenshots/ directory contains project evidence, including:
- Jenkins pipeline success
- EKS deployment and running pods
- Trend Store application in the browser
- Monitoring namespace and monitoring pods
- Prometheus metrics
- Grafana dashboard
- Grafana alert rules
Use the screenshots already captured in the repository as evaluation evidence. Make sure the screenshots do not expose credentials, tokens, private keys, or other secrets.
9. Security and Cleanup Checklist
Before final submission:
- [ ] Do not commit grafana-password.txt, .env, private keys, or secret files.
- [ ] Confirm .gitignore covers local credentials and Terraform state.
- [ ] Keep AWS, Docker Hub, and Jenkins credentials in their supported credential stores.
- [ ] Do not commit real Gmail App Passwords or Secret manifests with values.
- [ ] Confirm the Terraform files, Jenkinsfile, Kubernetes YAML, monitoring dashboard JSON, and screenshots are tracked by Git.
- [ ] Verify the application URL and Grafana dashboard before capturing final screenshots.
- [ ] Report Gmail SMTP as a known limitation until test notification succeeds.
Current Status
Component	Status
Terraform / EKS infrastructure	Created; repository configuration should be reviewed before re-applying
Docker image build and push	Pipeline configured
Jenkins CI/CD	Build/push pipeline working
EKS application deployment	Deployment and service working
Prometheus metrics	Monitoring components running
Grafana dashboard	Created and visible
Grafana alert rule	Configured
Gmail SMTP notification	Not working — 535 BadCredentials


Final Submission Notes
This project demonstrates infrastructure provisioning, containerization, CI/CD, Kubernetes deployment, and monitoring. Be transparent that Gmail SMTP email delivery remains unresolved. Do not delete the EKS cluster or monitoring resources before evaluation unless you have been explicitly asked to tear them down.