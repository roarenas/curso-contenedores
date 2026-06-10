pipeline {
    agent none
    environment{
        IMAGE_NAME = 'curso-contenedores'
        R_IMAGE_NAME = "roarenas/${IMAGE_NAME}"
        GHR = 'ghcr.io'
        GH_REPO = "${GHR}/${R_IMAGE_NAME}"
        URL_GHR = "https://${GHR}"
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
                        script{
                            env.APP_SEMAMTIC_VERSION = sh(
                                script: '''
                                  node -p "require('./package.json').version"
                                ''',
                                returnStdout:true
                            ).trim()
                            echo "Version obtenida ${env.APP_SEMAMTIC_VERSION}"
                        }
                    }
                }
                stage('CI - Obtener semver o version del software'){
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
                    echo ${URL_GHR}
                    docker build -t ${IMAGE_NAME}:latest .
                    docker tag ${IMAGE_NAME}:latest ${GH_REPO}:${BUILD_NUMBER}
                    docker tag ${IMAGE_NAME}:latest ${GH_REPO}:latest
                    docker tag ${IMAGE_NAME}:latest ${GH_REPO}:${APP_SEMAMTIC_VERSION}
                '''
                script{
                    docker.withRegistry("${URL_GHR}",'github'){
                        sh '''
                            echo ${GH_REPO}:${BUILD_NUMBER}
                            docker push ${GH_REPO}:latest
                            docker push ${GH_REPO}:${BUILD_NUMBER}
                            docker push ${GH_REPO}:${APP_SEMAMTIC_VERSION}
                        '''
                    }
                }
            }
        }
    }
}