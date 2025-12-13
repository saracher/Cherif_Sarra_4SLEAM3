pipeline {
    agent any

    tools { 
        jdk 'JAVA_HOME' 
        maven 'M2_HOME'
    }

    environment {
        DOCKERHUB_REPO = 'sarracherif/student-management'
        DOCKER_CREDENTIALS_ID = 'jenkinsDocker'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage('GIT') {
            steps {
                git branch: 'main',
                    credentialsId: 'github-token',
                    url: 'https://github.com/saracher/Cherif_Sarra_4SLEAM3.git'
            }
        }

        stage('Compile Stage') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('Package Stage') {
            steps {
                sh 'mvn package -DskipTests'
                sh 'ls -la target'
            }
        }
stage('MVN SonarQube') {
    steps {
       withSonarQubeEnv('sonarqubeServer') {
    withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
        sh "mvn sonar:sonar -Dsonar.projectKey=student-management -Dsonar.login=$SONAR_TOKEN"
    }
  }

    }
}



        stage('Build Docker Image') {
            steps {
                sh "docker build -t $DOCKERHUB_REPO:$IMAGE_TAG ."
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'jenkinsDocker',
                                usernameVariable: 'DOCKER_USER',
                                passwordVariable: 'DOCKER_PASS')]) {
                    sh "echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin"
                    sh "docker push $DOCKERHUB_REPO:$IMAGE_TAG"
                }
            }
        }
    }

    post {
        success {
            echo "Image Docker poussée avec succès sur $DOCKERHUB_REPO:$IMAGE_TAG"
        }
        failure {
            echo "Erreur dans le pipeline."
        }
    }
}
