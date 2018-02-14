pipeline {
    agent any

    triggers {
        pollSCM('H * * * *')
    }

    stages {
        stage ('Build GSC') {
            steps {
                sh 'docker build -t nfmsjoeg/gsc:test .'
            }
        }
        stage ('Test GSC') {
            steps {
                sh 'docker run --name gsc_test -d nfmsjoeg/gsc:test'
                
                # Add additional tests here
            }
        }
        stage ('Tag GSC as Latest') {
            steps {
                sh 'docker tag nfmsjoeg/gsc:test nfmsjoeg/gsc:latest'
            }
        }
        stage ('Clean Up Workspace') {
            steps {
                sh 'docker rm -f gsc_test'
                
                sh 'docker rmi nfmsjoeg/gsc:test'
            }
        }
    }
}
