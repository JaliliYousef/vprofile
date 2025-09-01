pipeline {
    agent any

    tools {
        jdk "JDK17"
        maven "MAVEN3.9"
    }

    environment {
        NEXUS_VERSION       = "nexus3"
        NEXUS_PROTOCOL      = "http"
        NEXUS_URL           = "172.31.40.209:8081"
        NEXUS_REPOSITORY    = "vprofile-release"
        NEXUS_REPO_ID       = "vprofile-release"
        NEXUS_CREDENTIAL_ID = "nexuslogin"
        ARTVERSION          = "${env.BUILD_ID}"
    }

    stages {

        stage('Build') {
            steps {
                sh 'mvn clean install -DskipTests'
            }
            post {
                success {
                    archiveArtifacts artifacts: '**/target/*.war'
                }
            }
        }

        stage('Unit Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Integration Test') {
            steps {
                sh 'mvn verify -DskipUnitTests'
            }
        }

        stage('Code Analysis with Checkstyle') {
            steps {
                sh 'mvn checkstyle:checkstyle'
            }
        }

        stage('Code Analysis with SonarQube') {
            environment {
                scannerHome = tool 'sonarscanner4'
            }
            steps {
                withSonarQubeEnv('sonar-pro') {
                    sh '''
                        ${scannerHome}/bin/sonar-scanner \
                          -Dsonar.projectKey=vprofile \
                          -Dsonar.projectName=vprofile-repo \
                          -Dsonar.projectVersion=1.0 \
                          -Dsonar.sources=src \
                          -Dsonar.java.binaries=target/classes \
                          -Dsonar.junit.reportsPath=target/surefire-reports \
                          -Dsonar.coverage.jacoco.xmlReportPaths=target/site/jacoco/jacoco.xml \
                          -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml
                    '''
                }

                timeout(time: 10, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage("Publish to Nexus Repository Manager") {
            steps {
                script {
                    def pom = readMavenPom file: "pom.xml"
                    def filesByGlob = findFiles(glob: "target/*.${pom.packaging}")
                    if (filesByGlob.length == 0) {
                        error "*** Artifact not found in target folder"
                    }
                    def artifactPath = filesByGlob[0].path
                    echo "*** Uploading ${artifactPath} to Nexus ***"

                    nexusArtifactUploader(
                        nexusVersion: NEXUS_VERSION,
                        protocol: NEXUS_PROTOCOL,
                        nexusUrl: NEXUS_URL,
                        groupId: pom.groupId,
                        version: ARTVERSION,
                        repository: NEXUS_REPOSITORY,
                        credentialsId: NEXUS_CREDENTIAL_ID,
                        artifacts: [
                            [artifactId: pom.artifactId, classifier: '', file: artifactPath, type: pom.packaging],
                            [artifactId: pom.artifactId, classifier: '', file: "pom.xml", type: "pom"]
                        ]
                    )
                }
            }
        }
    }
}
