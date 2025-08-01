pipeline {
    agent any
    tools {
        maven "maven3"
        jdk "jdk17"
    }
    
    environment {
        SNAP_REPO = 'vprofile-snapshot'
		NEXUS_USER = 'admin'
		NEXUS_PASS = 'redhat'
		RELEASE_REPO = 'patel-repo'
		CENTRAL_REPO = 'patel-maven-central'
		NEXUSIP = '192.168.239.130'
		NEXUSPORT = '8081'
		NEXUS_GRP_REPO = 'patel-maven-group'
        NEXUS_LOGIN = 'nexus'
    }

    stages {
        stage('Build'){
            steps {
                sh 'mvn -s settings.xml -DskipTests install'
            }
            post {	
                success {
                    echo "Now Archiving."
                    archiveArtifacts artifacts: '**/*.war'
                }
            }
        }	

        stage('Test'){
            steps {
                sh 'mvn -s settings.xml test'
            }

        }
        stage('Checkstyle Analysis'){
            steps {
                sh 'mvn -s settings.xml checkstyle:checkstyle'
            }
        }

    }   
}
