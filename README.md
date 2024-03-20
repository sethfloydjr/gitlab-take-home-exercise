# GitLab Take Home Exercise


## SUMMARY AND THOUGHTS

This was a fun exercise and a welcome change of pace from what i have been doing recently. I like the two stage approach and thought it lent itself nicely to expanding on what someone might or might not know before starting this project.
That being said, it did take longer than I expected. If I had more time I would have added an actual webserver configuration onto the EC2 cluster as well as built a Docker image which would have been pulled from ECR and deployed into the EKS cluster. I would have added Istio to help handle the traffic routing for the EKS cluster. Security took soemwhat of a backseat in this project due to time contraints. I would have liked to have tightened down a few aspects such as the EKS cluster, rds, and ec2 security groups. Also due to time constraints I left off Cloudwatch monitoring. There should be that along with Cloudwatch alerting that could also roll up to Datadog or whatever other monitoring suite is in use.
Although not what I would consider complete I feel that this met the requirements of the exercise and demonstarted some of my abilities and ways of thinking about building infrastucture using Terraform. In the end I still learned a few things from hitting a few hurdles during this project but they were nothing that wasn't easily looked up.


---

## ASSIGNMENT

For this assessment there are two separate sections:

* Virtual Machine Deployment: This is to deploy first-generation infrastructure for hosting a web application on a virtual machine and PostgreSQL using a managed database instance.

* Kubernetes Deployment: This is to deploy second-generation infrastructure using Kubernetes (K8s) after your web application has been containerized. This will be deployed in the same VPC infrastructure as your virtual machine.

## DETAILS

### SECTION 1: VIRTUAL MACHINE DEPLOYMENT

#### GOAL:

Create a new GitLab repository that contains Terraform configuration for deploying the infrastructure to support hosting an application on Linux VMs using AWS or GCP (your choice).

#### REQUIREMENTS:

* The infrastructure must be deployed using IaC inside of an AWS or GCP virtual private cloud (VPC) with appropriate routing and subnets.
* The application must be set up to be public facing using a load balancer. Keep in mind that the application server(s) should not have a public IP.
* The application will use a managed Postgres database.
* This application will need an object storage bucket.
* We are not worried about Linux configuration for this exercise.

### SECTION 2: KUBERNETES DEPLOYMENT

#### GOAL:

The first generation infrastructure was Linux virtual machines. We have now containerized the application and we need to add a Kubernetes (K8s) cluster to the existing VPC for the second-generation iteration of our infrastructure.

#### REQUIREMENTS:

* Add a managed Kubernetes (K8s) cluster (EKS or GKE) to the environment. You can review our public Terraform module for an example configuration.
* The cluster should use a node pool with 2 CPU and 8GB of memory.

#### FINAL RESULTS:

When you have completed this exercise please commit all of your code to your GitLab project. 
Open a new incognito browser window and open the URL for the GitLab project to ensure that it is a public project. Send the URL to this project to your Candidate Experience Specialist (CES).

---


## ASSUMPTIONS:

* There is a "terraform only" user in this AWS account that has access to create whatever infra it needs. It only builds infra and is not used for any service related actions and does not have console access.

* The infra is built using Terraform version `1.7.5`

* There is already and existing domain named `setheryops.com` that I use for testing and building things and whatnot. Route53, ACM, Zone information is all pulled from exitsing infra. Otherwise it would be built in this stack as well.

___


## TERRAFORM WALKTHROUGH:
This covers a few of the files that contain spec for the infrastructure code built by Terraform.

### `vpc.tf`
A Hashicorp module to build the VPC that will hold the EC2 cluster along with the EKS cluster and other required infra.

### `web_cluster.tf`
This holds the code that builds the actual EC2 cluster module. This module was built by hand and includes the Auto Scaling Group, Loadbalancer, S3 bucket, and Route53 entires.

### `rds.tf`
This builds the RDS instance using a module from Hashicorp.

### `eks_cluster`
This is also a hand built module which builds and configures the EKS cluster with the given specs. One of the specific configurations for the node pool was to have "2 CPU and 8GB of memory". This is addressed by the `variables.tf` file with the `node_pool_config_machine_type` settings and is passed into the module. It should also be noted that the nodes created here ar Managed Nodes whic is easier to upgrade Vs Self managed nodes.

### `.terraform-version`
This file is for local terraform functions. I use `tfenv` to manage my local versions of terraform and this file dictates what version tfenv will accept to use for plans, and applies.

---


## CLOSING:

As I said previously, this was a fun exercise. I really enjoy building infrastructure with code and seeing it appear after a code push and a pipeline run. There are a few things I would have liked to complete or would have done differently if this were a production environment. At the end of the day im happy with this first draft of this infrasture stack. I look forward to speaking with you directly to discuss this project.

- Seth Floyd