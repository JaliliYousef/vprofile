pipeline {
    agent any

    tools {
        maven "MAVEN3.9"
        jdk "JDK17"
    }

    environment {
        NEXUS_URL = 'http://35.170.200.163:8081'
        NEXUS_REPO = 'vpro-maven-group'
    }

    stages {
        stage('Generate settings.xml') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'nexus-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh '''
                    cat <<EOF > settings.xml
<settings xmlns="http://maven.apache.org/SETTINGS/1.1.0"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.1.0 http://maven.apache.org/xsd/settings-1.1.0.xsd">

  <servers>
    <server>
      <id>vpro-maven-group</id>
      <username>${USERNAME}</username>
      <password>${PASSWORD}</password>
    </server>
  </servers>

  <mirrors>
    <mirror>
      <id>vpro-maven-central</id>
      <name>nexus mirror</name>
      <url>http://35.170.200.163:8081/repository/vpro-maven-group/</url>
      <mirrorOf>*</mirrorOf>
    </mirror>
  </mirrors>

</settings>
EOF
                    '''
                }
            }
        }

        stage('Maven Build') {
            steps {
                sh 'mvn -s settings.xml -DskipTests install'
            }
        }
    }

    post {
        always {
            sh 'rm -f settings.xml'
        }
    }
}
