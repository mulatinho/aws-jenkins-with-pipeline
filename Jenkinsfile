pipeline {
    agent any

    stages {
        stage('Removing old build artifacts') {
            steps {
		sh 'rm -rf spring-petclinic'
                echo 'Entering in directory (creating it if not exists)..'
            }
        }
        stage('Cloning repository') {
            steps {
                echo 'Cloning repository..'
		sh 'git clone https://github.com/spring-projects/spring-petclinic.git'
            }
        }
        stage('Build code with maven') {
            steps {
                echo 'Building'
		sh 'mvn -Dmaven.test.skip=true -f spring-petclinic/pom.xml package'
            }
        }
    }
}
