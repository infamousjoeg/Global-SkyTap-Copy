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
                sh 'summon docker run --name gsc_test -d -e "SKYTAP_USER=$SKYTAP_USER" -e "SKYTAP_PASS=$SKYTAP_PASS" -e "SKYTAP_REGION=$SKYTAP_REGION" nfmsjoeg/gsc:test'
            }
        }
        stage ('Commit GSC as Latest') {
            steps {
                sh 'docker commit nfmsjoeg/gsc:test nfmsjoeg/gsc:latest'
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
