pipeline {
    agent any

    tools {
        jdk 'JAVA_HOME'      
        maven 'M2_HOME'     
    }
environment {
    DOCKER_CREDENTIALS_ID = 'sar123'
}

    stages {
        stage('GIT') {
            steps {
                git branch: 'main',   
                    url: 'https://github.com/saracher/Cherif_Sarra_4SLEAM3.git'
            }
        }

        stage('Compile Stage') {
            steps {
                sh 'mvn clean compile'
            }
        }
    }
}
