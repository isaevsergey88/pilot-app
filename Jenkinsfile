pipeline {
  environment {
    registry = "isaevgreensight/pilot-app"
    registryCredential = 'dockerhub'
    dockerImage = ''
  }
  agent any
  def is_master = env.BRANCH_NAME == 'master'
  def docker_image_tag = is_master ? 'latest' : 'latest-dev'
  stages {
    stage('Cloning Git') {
      steps {
        git branch: env.BRANCH_NAME,
            url: 'https://github.com/isaevsergey88/pilot-app.git'
      }
    }
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build registry + ":$BUILD_NUMBER"
        }
      }
    }
    stage('Deploy Image') {
      steps{
        script {
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push()
            dockerImage.push('latest')
          }
        }
      }
    }
    stage('Remove Unused docker images') {
      steps{
        // sh "docker rmi $registry:$BUILD_NUMBER"
        sh "docker rmi $registry:${docker_image_tag}"
      }
    }
  }
}