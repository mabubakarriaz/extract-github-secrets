# extract-github-secrets
Save GitHub repository secrets in plain text to azure cosmos table using C# REST API


echo $ENV:extract_github_secrets_TOKEN | docker login ghcr.io -u mabubakarriaz --password-stdin

docker build -t ghcr.io/mabubakarriaz/extract-github-secrets:latest .

docker push ghcr.io/mabubakarriaz/extract-github-secrets:latest

docker pull ghcr.io/mabubakarriaz/extract-github-secrets:latest


docker run -d -p 8080:80 --name extract-github-secrets -e AzureWebJobsStorage=YourAzureStorageConnectionString extract-github-secrets:latest
