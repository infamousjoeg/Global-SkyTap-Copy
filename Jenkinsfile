pipeline {
    agent any

    stages {
        stage ('Build Docker Image') {
            steps {
                sh 'docker build -t nfmsjoeg/gsc:test .'
            }
        }
        stage ('Test Docker Container') {
            withCredentials([conjurSecretCredential(credentialsId: 'gsc/skytap/username', variable: 'username'), conjurSecretCredential(credentialsId: 'gsc/skytap/password', variable: 'password')]) {
                steps {
                    sh '''
                        docker run --name gsc_test -i -e SKYTAP_USER=$username -e SKYTAP_PASS=$password -e SKYTAP_REGION="US Central" nfmsjoeg/gsc:test > test.log
                        docker rm -f gsc_test
                    '''
                    sh 'cat test.log'
                }
            }
        }
        stage ('Commit Docker Image as Latest') {
            steps {
                sh 'docker commit gsc_test nfmsjoeg/gsc:latest'
            }
        }
        stage ('Clean Up Docker Host') {
            steps {
                sh 'docker rmi nfmsjoeg/gsc:test'
                sh 'docker rmi $(docker images | grep none | awk \'/ / { print \$3 }\')'
            }
        }
    }
}
