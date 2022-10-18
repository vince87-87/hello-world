pipeline {
    agent any 
    environment {
        AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
        AWS_DEFAULT_REGION="ap-southeast-1" 
        IMAGE_REPO_NAME="mytomcat"
        IMAGE_TAG="test"
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
    }
    tools {
        maven "MAVEN3"
        jdk "OracleJDK8"
    }
    stages {
        stage('scm'){
            steps {
                // using double quotes "" for credentials will leak credentials
                // using single quotes '' for credentials prevent leaking of credentials on build logs
                git credentialsId: 'githublogin', url: 'git@github.com:vince87-87/hello-world.git'
            }
        }

        stage('build maven'){
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

        stage('build docker image') {
            steps {
                script {
                    sh 'docker build -t mytomcat:${IMAGE_TAG} .'
                }
            }
        }

        stage('push to aws ecr') {
            steps {
                script {
                    sh 'aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com'
                    sh 'docker tag mytomcat:${IMAGE_TAG} ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/mytomcat:${IMAGE_TAG}'
                    sh 'docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/mytomcat:${IMAGE_TAG}'
                }
            }
        }

        stage('deploy to eks') {
            steps {
                script {
                    sh 'aws eks update-kubeconfig --region ap-southeast-1 --name eksdemo1' // create kubeconfig file
                    sh 'kubectl apply -f manifests/.' // create tomcat deployment & ingress
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