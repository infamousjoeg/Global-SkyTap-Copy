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
                sh 'summon docker run --name gsc_test -d -e "SKYTAP_USER=$SKYTAP_USER" -e "SKYTAP_PASS=$SKYTAP_PASS" nfmsjoeg/gsc:test'
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
