pipeline {
    agent any

    triggers {
        pollSCM('H * * * *')
    }

    stages {
        stage ('Build Docker Image') {
            steps {
                sh 'docker build -t nfmsjoeg/gsc:test .'
            }
        }
        stage ('Test Docker Container') {
            steps {
                sh '''
                    set +x
                    chmod a+x test.sh
                    ./test.sh
                    set -x
                '''
                sh 'cat test.log'
            }
        }
        stage ('Commit Docker Image as Latest') {
            steps {
                sh 'docker commit gsc_test nfmsjoeg/gsc:latest'
            }
        }
        stage ('Clean Up Docker Host') {
            steps {
                sh 'docker rm -f gsc_test'
                sh 'docker rmi nfmsjoeg/gsc:test'
                sh 'docker rmi $(docker images | grep none | awk \'/ / { print \$3 }\')'
            }
        }
    }
}
