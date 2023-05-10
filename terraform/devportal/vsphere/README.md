# vSphere NGINX Devportal Machine Template Deployment

This directory contains templates and scripts to deploy an NGINX Devportal Ubuntu Virtual Machine to vSphere.

1. Follow the generic README, situated [here](../../README.md)

2. For deploying to vSphere with terraform, you will need to set your vSphere environment credentials:

```
export TF_VAR_vsphere_url="my-vcenter-url.com"
export TF_VAR_vsphere_password="my-password"
export TF_VAR_vsphere_user="my-username"
```

3. Set terraform parameters in an optional `.tfvars` file

```bash
cp terraform.tfvars.example terraform.tfvars
```

4. Initialise Terraform

   ```
       terraform init
   ```

5. Apply Terraform
   ```
      terraform apply
   ```

## Configuration

| Parameter           | Description                                                          | Default             | Required |
| ------------------- | -------------------------------------------------------------------- | ------------------- | -------- |
| cluster_name        | _The vSphere cluster name_                                           | -                   | Yes      |
| datacenter          | _The vSphere datacenter name_                                        | -                   | Yes      |
| datastore           | _The vSphere datastore name_                                         | -                   | Yes      |
| db_ca_cert_file     | _Database CA File (If using a custom CA file)._                      | -                   | No       |
| db_client_cert_file | _DB Client Cert File (Required for mTLS with DB)._                   | -                   | No       |
| db_client_key_file  | _DB Client Key File (Required for mTLS with DB)._                    | -                   | No       |
| db_host             | _Host of the db to connect to._                                      | `localhost`         | No       |
| db_password         | _Database password._                                                 | `nginx-devportal`   | No       |
| db_type             | _Type of database. Either psql or sqlite._                           | `psql`              | No       |
| db_user             | _Database user._                                                     | `nginx-devportal`   | No       |
| network             | _The name of the vSphere network to place the template in_           | -                   | Yes      |
| ssh_pub_key         | _Path to the ssh pub key that will be used for sshing into the host_ | `~/.ssh/id_rsa.pub` | No       |
| ssh_user            | _User account name allowed access via ssh._                          | `ubuntu`            | No       |
| template_name       | _Template being deployed_                                            | -                   | Yes      |
| vsphere_password    | _The password of the executing vSphere user. _                       | Environment value   | No       |
| vsphere_url         | _The url of the vSphere API. _                                       | Environment value   | No       |
| vsphere_username    | _The name of the executing vSphere user._                            | Environment value   | No       |
