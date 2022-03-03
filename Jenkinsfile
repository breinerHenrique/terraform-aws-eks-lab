pipeline {
    agent any
    stages {
        stage('Git Clone Source Repositoty') {
            steps {
                git credentialsId: 'GitHubCredentials', url: 'https://github.com/breinerHenrique/terraform-aws-eks-lab.git'
            }
        }
            stage('Enable Metrics Server on EKS') {
                steps {
                        sh 'kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml'
                 }
            }
            stage('Creating Monitoring Environment on AWS EKS') {
                steps {
                       sh 'kubectl create namespace monitoring'
                       sh 'helm repo add prometheus-community https://prometheus-community.github.io/helm-charts'
                       sh 'helm repo add kube-state-metrics https://kubernetes.github.io/kube-state-metrics'
                       sh 'helm repo add grafana https://grafana.github.io/helm-charts'
                       sh 'helm repo update'
                       sh 'helm upgrade --install prometheus prometheus-community/prometheus --values k8s/monitoring/values-prometheus.yaml  --namespace monitoring'
                       sh 'helm upgrade --install grafana grafana/grafana --values k8s/monitoring/values-grafana.yaml  --namespace monitoring'
                 }
            }
             stage('Sending Enviroment Access Details | Grafana') {
                steps {
                       sh 'kubectl get services -n monitoring'
                       sh 'kubectl get secret -n monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo'
                }
             }    
        }
    }