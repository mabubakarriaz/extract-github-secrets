# extract-github-secrets
Save GitHub repository secrets in plain text to azure cosmos table using C# REST API


docker build -t extract-github-secrets:latest .

docker run -d -p 8080:80 --name extract-github-secrets -e AzureWebJobsStorage=YourAzureStorageConnectionString extract-github-secrets:latest
