pipeline {
    agent any
    stages {
        stage('Checkout Source') {
            steps {
                git url:'https://github.com/breinerHenrique/terraform-aws-eks-lab.git', branch: 'main'
            }
        }
            stage('Deploy Kubernetes') {
                agent {
                    kubernetes {
                        cloud 'ekslabs'
                    }
                }
                steps {
                        sh 'kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml'
                 }
            }
        }
    }