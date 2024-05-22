This terraform is intended to quickly prepare VM instance on GCP along with necessary configuration to run [eve-ng](https://www.eve-ng.net/).
It creates image based on `ubuntu` with enabled virtualization, vpc, private subnet, firewall rules and VM instance.

## Prerequisites
1. Install `terraform` -> follow [official guide](https://developer.hashicorp.com/terraform/install).
2. Install `gcloud` -> follow [official guide](https://cloud.google.com/sdk/docs/install).
3. [Create GCP project](https://cloud.google.com/resource-manager/docs/creating-managing-projects), enable Compute Engine API.
4. Initialize `gcloud` -> execute `gcloud init` and follow wizzard, choose created project.
5. Create and download service account key -> follow [guide](https://cloud.google.com/iam/docs/keys-create-delete) and export downloaded key's path to `GOOGLE_CLOUD_KEYFILE_JSON`.
6. Find project id -> execute `gcloud projects list`, copy id of a created project.
7. Initialize `terraform` -> execute `terraform init`.

## Provision infrastructure:
1. Plan `terraform` changes:
   
    ```terraform plan -var "project=<copied-project-id>"```

2. Apply `terraform` changes:

    ```terraform apply -var "project=<copied-project-id>"```

## Deprovision infrastructure:
1. Destroy `terraform` changes:
    
    ```terraform apply -destroy -var "project=<copied-project-id>"```

## Notes
### Installation proccess
Due to imperative nature of `eve-ng` installation proces, this terraform only prepares a VM for `eve-ng` installation.
Later instalation steps can be found in a [cookbook](https://www.eve-ng.net/index.php/documentation/community-cookbook/), section `3.4.4`.
Section `3.4.6` might be ommited as firewall rules have been already configured by this terraform.

### Resources and costs
GCP bills for running VM instances and persistent storage. It is highly recommended to stop `eve-ng` instance when it's not in use.
It can be quickly done by executing `gcloud compute instances stop <instance-name>`.
By default, machine type configured in this terraform is set to `n2-standard-2`.
This is rather minimal setup, yet it can be overriden by `machine_type` variable.

### Variables
See `variables.tf`.