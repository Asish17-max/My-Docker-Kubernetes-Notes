We create terraform infa using diffrent modules and there will be diffrent folders for each environment like dev,qa and prod in which each of them have their own tfvars file and backend.tf inorder to store the state file remotely in diffrent places to maintain stability and prevent corruption so if we want to run pipeline for dev we do 
terraform init -backend-config=backend-dev.tf
terrafomr apply -var-file=dev.tfavrs

## Good way

We organize Terraform using reusable modules and environment-specific folders like dev, QA, and prod. Each environment has its own tfvars file for configuration and a separate backend configuration for state management.

During deployment, we initialize Terraform with the environment-specific backend config, which points to a unique S3 bucket or key path and DynamoDB table. Then we apply using the corresponding tfvars file.

This ensures that each environment maintains its own isolated state file, preventing conflicts and enabling safe parallel deployments across environments

This approach also allows us to integrate easily with CI/CD pipelines, where the pipeline dynamically selects the backend config and tfvars file based on the target environment

terrafrom {
    backend "s3" {
        name = 
        key  = 
        use_lockfile =
        
    }
}