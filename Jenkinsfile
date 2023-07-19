pipeline {
  agent any

  stages {
    stage('Build Docker image') {
      steps {
        script {
          // Write the CONFIG parameter to a file
            // writeFile file: 'config.yml', text: params.CONFIG
                //   def rootPath = "/root/go/src/github.com/Josh-Diamond/rancher-terratest-tests/"
                //   def filename = "config.yml"
                //   def configContents = params.CONFIG

                //   writeFile file: filename, text: configContents
                //   env.CATTLE_TEST_CONFIG = filename

                dir("./terratest/cluster") {
                  def rootPath = "/root/go/src/github.com/Josh-Diamond/rancher-terratest-tests/"
                  def filename = "config.yml"
                  def configContents = env.CONFIG

                  writeFile file: filename, text: configContents
                  env.CATTLE_TEST_CONFIG = rootPath+filename
                }

          // Build the Docker image with ARG for config.yml
        //   sh 'docker build --build-arg CONFIG_FILE=config.yml -t my-app .'
          sh 'docker build -t my-app .'
        }
      }
    }

    stage('Run Module Test') {
      steps {
        script {
            // Define dockerImage by building an image or pulling from registry
            def dockerImage = docker.image('my-app') // Assuming 'my-app' is your Docker image name

            dockerImage.inside() {
            sh "printenv"
            sh "go test -v -timeout 1h -run ${params.TEST_CASE} ./terratest/cluster"
            }
        }
      }
    }

    // stage('Run Module Test') {
    //     steps {
    //         dir('terratest') {
    //             script {
    //                 // Define dockerImage by building an image or pulling from registry
    //                 def dockerImage = docker.image('my-app') // Assuming 'my-app' is your Docker image name

    //                 dockerImage.inside() {
    //                 sh "go env"
    //                 sh "export CATTLE_TEST_CONFIG=config.yml"
    //                 sh "go test -v -timeout 1h -run ${params.TEST_CASE} ./cluster"
    //                 }
    //             }
    //         }
    //     }
    // }
  }

  post {
    always {
      // Remove the Docker container if it exists
      sh 'docker rm -f my-app || true'
      sh 'docker rmi my-app || true'
      cleanWs() // Not available in Rancher environment
    }
  }
}