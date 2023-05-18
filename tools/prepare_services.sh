PROJECT_ID=$(gcloud config get-value project)

gcloud config set project "$PROJECT_ID"

gcloud services enable cloudresourcemanager.googleapis.com
