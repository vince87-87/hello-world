pipeline {
    agent any 
    tools {
        maven "MAVEN3"
        jdk "OracleJDK8"
    }
    stages {
        stage('scm'){
            steps {
                git credentialsId: 'githublogin', url: 'git@github.com:vince87-87/hello-world.git'
            }
        }

        stage('scan_code'){
            withSonarQubeEnv('sonarserver') {
                sh '''mvn clean package sonar:sonar \
                -Dsonar.projectKey=devops_assignment_1'''
            }
        }

        stage('Build'){
            steps {
                echo "Running ${JOB_NAME} on build job ${BUILD_NUMBER}"
                sh 'mvn clean install'
            }
            post {
                success {
                    echo "Now Archiving."
                    archiveArtifacts artifacts: '**/*.war'
                }
            }
        }

        stage('test') {
            steps {
                echo "Perform unit testing!"
                sh 'mvn verify'
            }
        }

        stage('deploy') {
            steps {
                sshagent(['tomcat-ec2-user']) {
                    sh "scp -o StrictHostKeyChecking=no webapp/target/webapp.war ec2-user@172.31.36.227:/opt/tomcat/webapps"
                }
            }
        }


        // stage('Checkstyle Analysis'){
        //     steps {
        //         sh 'mvn -s settings.xml checkstyle:checkstyle'
        //     }
        // }

        // stage('Sonar Analysis') {
        //     environment {
        //         scannerHome = tool "${SONARSCANNER}"
        //     }
        //     steps {
        //        withSonarQubeEnv("${SONARSERVER}") {
        //            sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=vprofile \
        //            -Dsonar.projectName=vprofile \
        //            -Dsonar.projectVersion=1.0 \
        //            -Dsonar.sources=src/ \
        //            -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
        //            -Dsonar.junit.reportsPath=target/surefire-reports/ \
        //            -Dsonar.jacoco.reportsPath=target/jacoco.exec \
        //            -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
        //       }
        //     }
        // }
    }
}