pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
          
                sh 'docker build . -t scheduling_script'
             
            }
        }
        stage('Deploy') {
            steps { 
                    sh 'kubectl apply -f deployment.yaml' 
            }
        }
    }
}
