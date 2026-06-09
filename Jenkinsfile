pipeline {
    agent none
    environment{
        IMAGE_NAME = 'curso-contenedores:latest'
        R_IMAGE_NAME = 'roarenas/${env.IMAGE_NAME}'
        GHR = 'ghcr.io'
        GH_REPO = '${env.GHR}/${env.R_IMAGE_NAME}'
    }
    stages{
        stage('CI - de nuestra aplicacion de contenedores'){
            agent{
                docker {
                    image 'ghcr.io/pnpm/pnpm:latest'
                    label 'docker'
                }
            }
            stages{
                stage('CI - Configuracion de pnpm y node'){
                    steps{
                        sh '''
                        pnpm runtime set node 24 -g
                        pnpm --version
                        '''
                    }
                }
                stage('CI - Instalacion de dependencias'){
                    steps{
                        sh '''
                        pnpm install
                        '''
                    }
                }
                stage('CI - Revision de linter'){
                    steps{
                        sh '''
                        pnpm lint
                        '''
                    }
                }
                stage('CI - Ejecucion de build'){
                    steps{
                        sh '''
                        pnpm build
                        '''
                    }
                }
            }
        }
        stage('CD - Empaquetado y distribucion'){
            agent { label 'docker'}
            steps{
                sh '''
                    docker build -t ${env.IMAGE_NAME} .
                    docker tag ${env.IMAGE_NAME} ${env.GH_REPO}                    
                '''
                script{
                    docker.withRegistry('https://ghcr.io','roarenas'){
                        sh '''
                            docker push ${env.GH_REPO}
                        '''
                    }
                }
            }
        }
    }
}