def is_master = env.BRANCH_NAME == 'master'
def docker_image_tag = is_master ? 'latest' : 'latest-dev'

pipeline {
  environment {
    registry = "isaevgreensight/pilot-app"
    registryCredential = 'dockerhub'
    dockerImage = ''
  }
  agent any
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
          withCredentials([usernamePassword(credentialsId: 'database-credentials', passwordVariable: 'app_db_password', usernameVariable: 'app_db_username'), string(credentialsId: 'app_jwt_secret', variable: 'app_jwt_secret')]) {
            sh """
              echo app_db_password: ${app_db_password} app_db_username: ${app_db_username} app_jwt_secret: ${app_jwt_secret}
            """
            dockerImage = docker.build registry + ":$BUILD_NUMBER"
          }
        }
      }
    }
    stage('Deploy Image') {
      steps{
        script {
          docker.withRegistry( '', registryCredential ) {
            // dockerImage.push()
            dockerImage.push(docker_image_tag)
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