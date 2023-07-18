pipeline {
  agent any

  stages {
    stage('Build Docker image') {
      steps {
        script {
          // Write the CONFIG parameter to a file
            writeFile file: 'cattle-config.yaml', text: params.CONFIG

          // Build the Docker image with ARG for config.yml
          sh 'docker build --build-arg CONFIG_FILE=cattle-config.yaml -t my-app .'
        }
      }
    }

    stage('Run Module Test') {
      steps {
        script {
            // Define dockerImage by building an image or pulling from registry
            def dockerImage = docker.image('my-app') // Assuming 'my-app' is your Docker image name

            dockerImage.inside() {
            sh "cat config.yaml"
            sh "export CATTLE_TEST_CONFIG=cattle-config.yaml"
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