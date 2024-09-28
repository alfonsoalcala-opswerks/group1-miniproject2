pipeline {
    agent any

    stages {
        stage('Build') {
            agent {
                label "docker"
            }

            steps {
                sh 'docker build . -t scheduling_script'
            }
        }

        stage('Push image to hub') {
            steps {
                script {
                    sh 'docker login -u dock_user -p dock_password docker-host:5000'
                    sh 'docker push docker-host:5000/scheduling_script' 
                }
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
                    sh 'kubectl apply -f script-deployment.yaml' 
            
            }
                    
        }
    }
}
