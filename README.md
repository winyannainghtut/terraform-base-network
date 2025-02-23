# Terraform Base Network Infrastructure

This project provides a modular Terraform configuration for creating a base AWS network infrastructure. It follows infrastructure-as-code best practices and provides a flexible, reusable foundation for AWS networking components.

## Architecture Overview

This infrastructure includes the following components:

- VPC with customizable CIDR blocks
- Public and private subnets across multiple availability zones
- Network ACLs with configurable rules
- Security Groups with customizable ingress/egress rules
- Route Tables for traffic management

## Prerequisites

- Terraform >= 0.12
- AWS CLI configured with appropriate credentials
- Basic understanding of AWS networking concepts

## Project Structure

```
├── data/
│   ├── nacl_rules.csv       # Network ACL rules configuration
│   ├── route_tables.csv      # Route tables configuration
│   ├── security_groups.csv   # Security groups configuration
│   ├── security_group_rules.csv # Security group rules
│   └── subnets.csv          # Subnet configuration
├── modules/
│   ├── vpc/                 # VPC module
│   ├── subnets/             # Subnet module
│   ├── security_groups/      # Security Groups module
│   ├── route_tables/        # Route Tables module
│   └── nacls/               # Network ACLs module
├── main.tf                  # Main configuration file
├── variables.tf             # Input variables
├── outputs.tf               # Output definitions
└── provider.tf             # Provider configuration
```

## Usage

1. Clone the repository:
```bash
git clone https://github.com/[your-username]/terraform-base-network.git
cd terraform-base-network
```

2. Initialize Terraform:
```bash
terraform init
```

3. Review and modify the configuration files in the `data/` directory according to your requirements.

4. Plan the infrastructure:
```bash
terraform plan
```

5. Apply the configuration:
```bash
terraform apply
```

## Module Description

### VPC Module
- Creates a Virtual Private Cloud with specified CIDR block
- Configures DNS hostnames and support
- Manages VPC default security group and network ACL

### Subnets Module
- Creates public and private subnets
- Supports multiple availability zones
- Configures auto-assign public IP settings

### Security Groups Module
- Creates and manages security groups
- Configures inbound and outbound rules
- Supports rule dependencies between security groups

### Route Tables Module
- Manages route tables for public and private subnets
- Configures routes for internet and NAT gateways
- Associates route tables with appropriate subnets

### Network ACLs Module
- Creates and manages network ACLs
- Configures inbound and outbound rules
- Associates NACLs with subnets

## Configuration

The infrastructure can be customized through CSV files in the `data/` directory:

- `subnets.csv`: Define subnet CIDR blocks and configurations
- `security_groups.csv`: Define security group names and descriptions
- `security_group_rules.csv`: Configure security group rules
- `nacl_rules.csv`: Define network ACL rules
- `route_tables.csv`: Configure routing tables and associations

## Outputs

The infrastructure provides various outputs including:

- VPC ID
- Subnet IDs
- Security Group IDs
- Route Table IDs
- Network ACL IDs

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Security

This project follows AWS security best practices. However, please ensure to:

- Review and adjust security group rules based on your requirements
- Follow the principle of least privilege when configuring NACLs
- Regularly update and patch dependencies
- Never commit AWS credentials to version control

## Support

For support and questions, please open an issue in the GitHub repository.

## GitHub Actions Pipeline

This section describes how to set up GitHub Actions workflows for automated deployment and destruction of the infrastructure.

### Prerequisites

1. GitHub repository with the infrastructure code
2. AWS credentials with appropriate permissions
3. Basic understanding of GitHub Actions

### Setting up GitHub Secrets

Store your AWS credentials and environment variables as GitHub Secrets:

1. Navigate to your repository's Settings > Secrets and variables > Actions
2. Add the following secrets:
   - `AWS_ACCESS_KEY_ID`: Your AWS access key
   - `AWS_SECRET_ACCESS_KEY`: Your AWS secret key
   - `AWS_REGION`: Your target AWS region
   - `TF_VAR_environment`: Environment name (e.g., development, staging, production)
   - `TF_VAR_vpc_name`: Name for your VPC
   - `TF_VAR_vpc_cidr`: CIDR block for your VPC

### Workflow Files

Create two workflow files in `.github/workflows/` directory:

#### 1. terraform-deploy.yml
```yaml
name: 'Terraform Deploy'

on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2

    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v1

    - name: Configure AWS Credentials
      uses: aws-actions/configure-aws-credentials@v1
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: ${{ secrets.AWS_REGION }}

    - name: Terraform Init
      run: terraform init

    - name: Terraform Plan
      run: terraform plan
      env:
        TF_VAR_environment: ${{ secrets.TF_VAR_environment }}
        TF_VAR_vpc_name: ${{ secrets.TF_VAR_vpc_name }}
        TF_VAR_vpc_cidr: ${{ secrets.TF_VAR_vpc_cidr }}

    - name: Terraform Apply
      if: github.ref == 'refs/heads/main'
      run: terraform apply -auto-approve
      env:
        TF_VAR_environment: ${{ secrets.TF_VAR_environment }}
        TF_VAR_vpc_name: ${{ secrets.TF_VAR_vpc_name }}
        TF_VAR_vpc_cidr: ${{ secrets.TF_VAR_vpc_cidr }}
```

#### 2. terraform-destroy.yml
```yaml
name: 'Terraform Destroy'

on:
  workflow_dispatch:

jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2

    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v1

    - name: Configure AWS Credentials
      uses: aws-actions/configure-aws-credentials@v1
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: ${{ secrets.AWS_REGION }}

    - name: Terraform Init
      run: terraform init

    - name: Terraform Destroy
      run: terraform destroy -auto-approve
      env:
        TF_VAR_environment: ${{ secrets.TF_VAR_environment }}
        TF_VAR_vpc_name: ${{ secrets.TF_VAR_vpc_name }}
        TF_VAR_vpc_cidr: ${{ secrets.TF_VAR_vpc_cidr }}
```

### Usage

1. **Deployment**:
   - Automatically triggered on push to main branch
   - Manually triggered from Actions tab using workflow_dispatch

2. **Destruction**:
   - Only manually triggered from Actions tab using workflow_dispatch
   - Use with caution as it will destroy all resources

### Security Considerations

- Never commit sensitive credentials to the repository
- Use GitHub Secrets for all sensitive values
- Regularly rotate AWS access keys
- Consider using OpenID Connect for AWS authentication
- Implement branch protection rules for the main branch

## Support

For support and questions, please open an issue in the GitHub repository.