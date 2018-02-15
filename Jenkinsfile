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
                sh 'chmod a+x test.sh && ./test.sh'
                sh 'cat test.log'
            }
        }
        stage ('Commit GSC as Latest') {
            steps {
                sh 'docker commit gsc_test nfmsjoeg/gsc:latest'
            }
        }
        stage ('Clean Up Workspace') {
            steps {
                sh 'docker rm -f gsc_test'
                sh 'docker rmi nfmsjoeg/gsc:test'
                sh 'docker rmi $(docker images | grep none | awk \'/ / { print \$3 }\')'
            }
        }
    }
}
