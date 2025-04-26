pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'eu-west-1'
    }

    parameters {
        booleanParam(name: 'DESTROY_INFRASTRUCTURE', defaultValue: false, description: 'Destroy infrastructure after apply?')
    }

    stages {
        stage('Pull Code') {
            steps {
                git branch: 'main', poll: false, url: 'https://github.com/Lay-ke/Terraform-Jenkins-Project.git'
            }
        }

        stage('Terraform Init & Validate') {
            steps {
                echo "Initializing and validating Terraform"
                
                // Use withCredentials directly in the stage
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
                    sh '''
                        cd environments/active
                        terraform init
                        terraform fmt -recursive
                        terraform validate
                    '''
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                echo "Generating Terraform plan"
                
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
                    sh '''
                        cd environments/active
                        terraform plan -out=tfplan
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                echo "Applying Terraform changes"
                
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
                    sh '''
                        cd environments/active
                        terraform apply -auto-approve tfplan
                    '''
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { params.DESTROY_INFRASTRUCTURE }
            }
            steps {
                echo "Destroying Terraform infrastructure"

                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
                    sh '''
                        cd environments/active
                        terraform destroy -auto-approve
                    '''
                }
            }
        }
    }
    stage('Wait Before DR') {
        steps {
            echo "Waiting for a few minutes before proceeding to the DR region"
            sleep time: 5, unit: 'MINUTES' // Adjust the time as needed
        }
    }

    stage('Terraform Init & Validate DR Region') {
            steps {
                echo "Initializing and validating Terraform"
                
                // Use withCredentials directly in the stage
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
                    sh '''
                        cd environments/passive
                        terraform init
                        terraform fmt -recursive
                        terraform validate
                    '''
                }
            }
        }

        stage('Terraform Plan DR Region') {
            steps {
                echo "Generating Terraform plan"
                
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
                    sh '''
                        cd environments/passive
                        terraform plan  -out=drplan
                    '''
                }
            }
        }

        stage('Terraform Apply DR Region') {
            steps {
                echo "Applying Terraform changes"
                
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
                    sh '''
                        cd environments/passive
                        terraform apply -auto-approve drplan
                    '''
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { params.DESTROY_INFRASTRUCTURE }
            }
            steps {
                echo "Destroying Terraform infrastructure"

                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
                    sh '''
                        cd environments/passive
                        terraform destroy -auto-approve
                    '''
                }
            }
        }
    }

    post {
        always {
            echo "Terraform execution complete."
        }
        success {
            echo "Terraform deployment (or destruction) successful."
        }
        failure {
            echo "Terraform deployment (or destruction) failed."
        }
    }
}
