# jobathon-challenge

## Overview

This project demonstrates a simple Flask application deployed to Azure using Terraform for infrastructure provisioning. The application is containerized using Docker, and the CI/CD pipeline is set up using Azure DevOps.

## Project Structure

- **app.py:** The main Flask application file.
- **Dockerfile:** Docker configuration for containerizing the Flask app.
- **main.tf:** Terraform configuration for Azure infrastructure.
- **requirements.txt:** List of Python dependencies for the Flask app.
- **.azurerm-backend:** Sample configuration for Azure Storage as the Terraform backend.
- **azure-pipelines.yml:** Azure DevOps pipeline configuration.

## Getting Started

### Prerequisites

1. Install [Docker](https://docs.docker.com/get-docker/).
2. Install [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).
3. Install [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli).
4. Set up an [Azure DevOps](https://dev.azure.com/) account.

### Development Setup with Docker Compose

1. Clone the repository: `git clone https://github.com/yourusername/your-repo.git`
2. Navigate to the project directory: `cd your-repo`
3. Create a virtual environment (optional): `python -m venv venv`
4. Activate the virtual environment:
   - On Windows: `venv\Scripts\activate`
   - On macOS/Linux: `source venv/bin/activate`
5. Install dependencies: `pip install -r requirements.txt`
6. Start the application with PostgreSQL locally: `docker-compose up`
7. Access the Flask app at `http://localhost:5000`.
8. The PostgreSQL database will be available at `localhost:5432`.
9. change database usr in app.py file with local database url

### Deployment to Azure

1. Ensure you have an Azure subscription.
2. Log in to Azure CLI: `az login`
3. Set up your Terraform backend:
   ```bash
   cd your-repo
   # Update .azurerm-backend with your Azure Storage account details
   ```
4. Initialize Terraform: `terraform init`
5. Deploy the infrastructure: `terraform apply -auto-approve`
6. Access the deployed Flask app at the provided URL.

### CI/CD with Azure DevOps

1. Create a new project in [Azure DevOps](https://dev.azure.com/).
2. Connect your Azure DevOps project to your Git repository.
3. Set up a new pipeline using `azure-pipelines.yml`.
4. Trigger a manual run to build and deploy the application.

## Additional Configurations

- **Scaling:** Modify the `azurerm_app_service_plan` configuration in `main.tf` to adjust scaling options.
- **Security:** Adjust security configurations in `main.tf`, and consider using Azure Key Vault for secret management.
- **Logging/Monitoring:** Configure Azure Application Insights in `main.tf` for application monitoring.
- **Custom Domains:** Update `azurerm_app_service` configuration in `main.tf` for custom domains.
