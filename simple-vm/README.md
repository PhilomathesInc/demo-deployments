# Demo deployment on Linux VM

## Goal :rocket:

- [x] To create the target infrastructure using Terraform
- [x] The configuration of the server and application will be done via Ansible
- [ ] To deploy web applications to a Linux VM via GitHub Actions
- [ ] To setup DNS for the target using Terraform

## Details :memo:

The applications that will be deployed
1. **Go**: [A minimal golang application](https://github.com/PhilomathesInc/demo-applications/tree/main/minimal-go-app)
1. **PHP**: [A minimal PHP application](https://github.com/PhilomathesInc/demo-applications/tree/main/minimal-php-app)

## Steps

### Terraform
1. [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
2. Run `terraform init`
3. Authenticate using your credentials([GCP provider documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/getting_started#adding-credentials))
    ```sh
    export GOOGLE_APPLICATION_CREDENTIALS={{path}}
    export CLOUDFLARE_API_TOKEN={{token}}
    ```
4. Plan using `terraform plan out=tfplan`
5. Apply using `terraform apply tfplan`

**Cleanup:**
Delete the resources using `terraform delete`
