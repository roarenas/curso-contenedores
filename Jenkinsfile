pipeline {
    agent none
    environment{
        IMAGE_NAME = 'curso-contenedores:latest'
        R_IMAGE_NAME = "roarenas/${IMAGE_NAME}"
        GHR = 'ghcr.io'
        GH_REPO = "${GHR}/${R_IMAGE_NAME}"
        URL_GHR = "${GHR}"
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
                    echo ${GH_REPO}
                    docker build -t ${IMAGE_NAME} .
                    docker tag ${IMAGE_NAME} ${GH_REPO}                    
                '''
                script{
                    docker.withRegistry("${GHR}",'github'){
                        sh '''
                            docker push ${GH_REPO}
                        '''
                    }
                }
            }
        }
    }
}