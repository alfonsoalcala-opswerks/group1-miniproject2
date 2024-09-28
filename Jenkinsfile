pipeline {
    agent any

    stages {
        stage('Build') {
            agent {
                label "docker"
            }

            steps {
                sh 'docker build . -t scheduling_script:v1.0'
                sh 'docker save -o /tmp/scheduling_script:v1.0.tar scheduling_script:v1.0'
                sh 'scp /tmp/scheduling_script:v1.0.tar root@192.18.21.6:/tmp/'
            }
        }

        stage('Deploy') {
            agent {
                label "kubernetes"
            }
            steps { 
                        
                    sh 'docker load -i /tmp/scheduling_script:v1.0.tar' 
                    sh 'kubectl apply -f deployment.yaml' 
            }
        }
    }
}
