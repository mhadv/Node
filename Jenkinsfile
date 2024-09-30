pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', credentialsId: 'Docker', url: 'https://github.com/mhadv/Node.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t node ."
            }
        }

        stage('Docker Image Tag') {
            steps {
                sh "docker tag node omrajput/node:latest"
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'Docker') {
                        sh "docker push omrajput/node:latest"
                    }
                }
            }
        }

        stage('Deploy Docker Container') {
            steps {
                script {
                    docker.image('omrajput/node:latest').run('-p 3000:3000')
                }
            }
        }
    }
}
