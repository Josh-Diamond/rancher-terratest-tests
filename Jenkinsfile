pipeline {
  agent any

  stages {
    stage('Build Docker image') {
      steps {
        script {
            writeFile file: 'config.yml', text: params.CONFIG
            env.CATTLE_TEST_CONFIG='/home/jenkins/workspace/rancher_qa/tfp-automation/config.yml'
            sh 'docker build --build-arg CONFIG_FILE=config.yml -t tfp-automation .'
        }
      }
    }

    stage('Run Module Test') {
      steps {
        script {
            def dockerImage = docker.image('tfp-automation')
            dockerImage.inside() {
                sh "pwd"
                sh "go test -v -timeout 1h -run ${params.TEST_CASE} ./terratest/cluster"
            }
        }
      }
    }
  }

//   post {
//     always {
//       sh 'docker rm -f tfp-automation || true'
//       sh 'docker rmi tfp-automation || true'
//       cleanWs() // Not available in Rancher environment
//     }
//   }
}