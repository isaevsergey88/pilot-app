#!groovy
// -*- coding: utf-8; mode: Groovy; -*-

properties([
    buildDiscarder (logRotator (artifactDaysToKeepStr: '', artifactNumToKeepStr: '10', daysToKeepStr: '', numToKeepStr: '10')),
    disableConcurrentBuilds (),
])

// Registry credentials
env.DOCKER_REGISTRY = 'dockerhub.greensight.ru'
env.DOCKER_REGISTRY_CREDS = 'dockerhub-greensight-credentials'

// Docker build args
def GIT_REPO = scm.userRemoteConfigs[0].url
def is_master = env.BRANCH_NAME == 'master'
def image_days_retention = is_master ? "180" : "7"
env.BRANCH = env.BRANCH_NAME.toLowerCase().replaceAll('/','-')
def version_suffix = is_master ? '' : "-${BRANCH}"
def docker_image = (GIT_REPO =~ /.+\/(.+?).git$/)[0][1]
def docker_image_name = "${docker_image}${version_suffix}"
def docker_image_tag = "${env.BUILD_NUMBER}"

// k8s options

// k8s_name_space = "auchan-ecom" + (is_master ? "" : "-test")
// k8s_helm_chart = ".helm/"

// currentBuild.displayName = "#${env.BUILD_NUMBER} ${docker_image_name}:${docker_image_tag}"

node('docker-agent'){
    def jenkins_uid = sh(returnStdout: true, script: 'id -u').trim()
    def jenkins_gid = sh(returnStdout: true, script: 'id -g').trim()

    stage('Checkout  sources') {
        cleanWs();
        checkout scm
    }

    // def git_commit = sh(returnStdout:true, script: 'git log -1 --format=%h').trim();
    // def git_date = sh(returnStdout:true, script: "git show -s --format=%ci ${git_commit}").trim();

    // if (env.CHANGE_ID) {
    //     echo "skip pull request"
    // } else {
    //     stage('Build docker image') {
    //         image_build_and_push(docker_image_name, docker_image_tag, is_master, GIT_REPO, git_commit, git_date, image_days_retention)
    //     }

    //     stage('k8s deploy') {
    //       echo "skiping deploymnent"
    //     }
    // }
}

// def image_build_and_push(docker_image_name, docker_image_tag, is_master, git_repo, git_commit, git_date, image_days_retention) {
//     def env_vars = ["GIT_REPO=${git_repo}",
//                     "GIT_COMMIT=${git_commit}",
//                     "GIT_DATE='${git_date}'",
//                     "IMAGE_DAYS_RETENTION='${image_days_retention}'",
//                     "BRANCH=${env.BRANCH}"
//                     ]
//     build_args = env_vars.collect{arg -> '--no-cache --build-arg ' + arg}.join(' ')
//     def image = docker.build("${env.DOCKER_REGISTRY}/${docker_image_name}:${docker_image_tag}", build_args + " .")
//     try {
//         docker.withRegistry("https://${env.DOCKER_REGISTRY}", "$DOCKER_REGISTRY_CREDS") {
//             image.push(docker_image_tag)
//             // image.push('latest')
//             // sh "docker rmi ${env.DOCKER_REGISTRY}/${docker_image_name}:latest"
//         }
//     }
//     finally {
//       sh "docker rmi ${env.DOCKER_REGISTRY}/${docker_image_name}:${docker_image_tag}"
//     }
// }