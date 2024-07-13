# extract-github-secrets

This repository contains a C# REST API that extracts GitHub repository secrets and saves them in plain text to an Azure Cosmos Table.

## Testing with Postman

To test the API using Postman, follow these steps:

1. **Create a new POST request:**
   - **URL:** `https://extract-github-secrets-3dtxzw4v.azurewebsites.net/api/keyvalue`
   - **Headers:**
     - `Content-Type: application/json`
   - **Body (raw JSON):**
     ```json
     {
       "RowKey": "exampleKey3",
       "Value": "exampleValue3"
     }
     ```

2. **Create a new GET request:**
   - **URL:** `https://extract-github-secrets-3dtxzw4v.azurewebsites.net/api/keyvalue/exampleKey1`

### Testing with cURL

1. **Insert a new key-value pair:**
   ```sh
   curl --location 'https://extract-github-secrets-3dtxzw4v.azurewebsites.net/api/keyvalue' \
   --header 'Content-Type: application/json' \
   --data '{
     "RowKey": "exampleKey3",
     "Value": "exampleValue3"
   }'
   ```

2. **Retrieve a value by key:**
   ```sh
   curl --location 'https://extract-github-secrets-3dtxzw4v.azurewebsites.net/api/keyvalue/exampleKey1'
   ```


## Setup

The API is deployed on Azure App Services as a container, and it uses an Azure Table from an Azure Storage Account.

### Prerequisites

- Azure Subscription
- Azure Storage Account
- Azure App Service
- Docker
- Terraform

### Environment Variables

The following environment variable is required in the container:

- `STORAGE_CONNECTION_STRING`: The connection string for your Azure Storage Account.

The Azure Table should be named `KeyValueTable`.

### Docker Commands

1. **Login to GitHub Container Registry:**
   ```sh
   echo $ENV:extract_github_secrets_TOKEN | docker login ghcr.io -u mabubakarriaz --password-stdin
   ```

2. **Build Docker Image:**
   ```sh
   docker build -t ghcr.io/mabubakarriaz/extract-github-secrets:latest .
   ```

3. **Push Docker Image to GitHub Container Registry:**
   ```sh
   docker push ghcr.io/mabubakarriaz/extract-github-secrets:latest
   ```

4. **Pull Docker Image from GitHub Container Registry:**
   ```sh
   docker pull ghcr.io/mabubakarriaz/extract-github-secrets:latest
   ```

5. **Run Docker Container:**
   ```sh
   docker run -d -p 8080:80 --name extract-github-secrets -e STORAGE_CONNECTION_STRING=your_key ghcr.io/mabubakarriaz/extract-github-secrets:latest
   ```

### Terraform Commands

1. **Navigate to Infrastructure Directory:**
   ```sh
   cd ./infra/
   ```

2. **Initialize Terraform:**
   ```sh
   terraform init
   ```

3. **Plan Terraform Deployment:**
   ```sh
   terraform plan -var="subscription_id=your_sub_id" -var="resource_group_name=your_rg"
   ```

4. **Validate Terraform Configuration:**
   ```sh
   terraform validate
   ```

5. **Apply Terraform Deployment:**
   ```sh
   terraform apply -var="subscription_id=your_sub_id" -var="resource_group_name=your_rg"
   ```

## Contributing

Feel free to submit issues, fork the repository, and send pull requests.

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Contact

For any questions or support, please reach out to Abubakar Riaz at [LinkedIn](https://www.linkedin.com/in/abubakarriaz).
