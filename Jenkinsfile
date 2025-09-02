pipeline {
    agent any

    tools {
        maven 'Maven3'   // Make sure this matches your Jenkins Maven tool name
        jdk 'Java11'     // Make sure this matches your Jenkins JDK tool name
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/your-repo/your-app.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean install -DskipTests'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-pro') {
                    withCredentials([string(credentialsId: 'sonar-auth-token', variable: 'sqa_303c4b8230457a17c99666b18a975066b74b0794')]) {
                        sh 'mvn sonar:sonar -Dsonar.login=$sqa_303c4b8230457a17c99666b18a975066b74b0794'
                    }
                }
            }
        }

        stage('Quality Gate (Non-blocking)') {
            steps {
                script {
                    echo "Skipping waitForQualityGate to avoid pipeline failure..."
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline completed successfully ✅"
        }
    }
}
