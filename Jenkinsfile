pipeline {
    agent any

    stages {
        stage('Build') {
            agent {
                label "docker"
            }

            steps {
                sh 'docker build . -t scheduling_script:v1.0'
            }
        }

        stage('Deploy') {
            agent {
                label "docker"
            }
            steps { 
                    withKubeConfig(caCertificate: "${KUBE_CERT}", clusterName: 'kubernetes', contextName: 'kubernetes-admin@kubernetes', credentialsId: 'my-kube-config-credentials', namespace: 'default', restrictKubeConfigAccess: false, serverUrl: 'https://jump-host:6443') 
            }
            {
                    sh 'kubectl apply -f deployment.yaml' 
            
            }
                    
        }
    }
}
