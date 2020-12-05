node('slave-node') {
    stage('下代码Clone') {
        echo "1.Clone Stage"
        echo "env.BRANCH_NAME"
        git credentialsId: 'git_test1', url: 'https://github.com/yuhuashi200/jenkins-test1.git'
        script {
            build_tag = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
            env.BRANCH_NAME = sh(returnStdout: true, script: 'git branch').trim()
            sh "echo build_tag"
            sh "mvn package -B -DskipTests"
        }
    }
    stage('测试Test') {
      echo "2.Test Stage"
    }
    stage('构建Build') {
        echo "3.Build Docker Image Stage"
        sh "docker build -t jenkins-demo:${build_tag} ."
        sh "docker imgages"
        sh "pwd"
    }
    stage('推仓库Push') {
        echo "4.Push Docker Image Stage"
        withCredentials([usernamePassword(credentialsId: 'repoID', passwordVariable: 'repoIDPassword', usernameVariable: 'repoIDUser')]) {
            sh "docker login -u ${repoIDUser} -p ${repoIDPassword} registry.cn-beijing.aliyuncs.com"
            sh "docker tag jenkins-demo:${build_tag} registry.cn-beijing.aliyuncs.com/sunac_k8s_test/sunac_repo_test:jenkins-demo:${build_tag}"
            sh "docker imgages"
            sh "docker push registry.cn-beijing.aliyuncs.com/sunac_k8s_test/sunac_repo_test:jenkins-demo:${build_tag}"
        }
    }
    stage('部署Deploy') {
        echo "5. Deploy Stage"
        def userInput = input(
            id: 'userInput',
            message: '选择一个环境Choose a deploy environment',
            parameters: [
                [
                    $class: 'ChoiceParameterDefinition',
                    choices: "Dev\nQA\nProd",
                    name: 'Env'
                ]
            ]
        )
        echo "This is a deploy step to ${userInput}"
        sh "sed -i 's/<BUILD_TAG>/${build_tag}/' deployment.yaml"
        sh "pwd"
        sh "cat deployment.yaml"
       // sh "kubectl apply -f deployment.yaml"
    }
}