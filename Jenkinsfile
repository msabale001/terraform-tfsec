pipeline {
    agent any

    parameters {
        booleanParam(
            name: 'Auto_Approve',
            defaultValue: false,
            description: 'If true, Terraform will auto-approve'
        )
        choice(
            name: 'Action',
            choices: ['apply', 'destroy'],
            description: 'Choose Terraform action'
        )
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_KEY')
        AWS_DEFAULT_REGION    = 'us-east-1'
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/msabale001/terraform-tfsec.git'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    if (params.Action == 'apply') {
                        sh 'terraform plan -out=tfplan'
                        sh 'terraform show -no-color tfplan > tfplan.txt'
                    } else {
                        sh 'terraform plan -destroy -out=tfdestroy'
                        sh 'terraform show -no-color tfdestroy > tfdestroy.txt'
                    }
                }
            }
        }
        stage(Approval){
            when {
                expression { params.Auto_Approve == false }
            }
            steps {
                input message: "Do you want to proceed with Terraform ${params.Action}?", ok: "Yes"
            }
        }

        stage('Terraform Apply / Destroy') {
            steps {
                script {
                    if (params.Action == 'apply') {
                        sh 'terraform apply --auto-approve tfplan'
                    }
                    else if (params.Action == 'destroy') {
                        sh 'terraform apply --auto-approve tfdestroy'
                    } 
                    else {
                        sh 'terraform apply tfdestroy'
                    }
                }
            }
        }
    }
}
