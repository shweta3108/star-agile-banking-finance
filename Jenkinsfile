def containerName="finance-me"
def tag="latest"
def dockerHubUser="sejalmm06"
def httpPort="8081"

node {

    stage('Checkout') {
        checkout scm
    }

    stage('Build'){
        sh "mvn clean install"
    }
    
    stage('Publish Test Reports') {
        publishHTML([
            allowMissing: false,
            alwaysLinkToLastBuild: false,
            keepAll: false,
            reportDir: 'target/surefire-reports',
            reportFiles: 'index.html',
            reportName: 'HTML Report',
            reportTitles: '',
            useWrapperFileDirectly: true
        ])
    }

    stage("Image Prune"){
         sh "docker image prune -a -f"
    }

    stage('Image Build'){
        sh "docker build -t $containerName:$tag --no-cache ."
        echo "Image build complete"
    }

    stage('Push to Docker Registry'){
        withCredentials([usernamePassword(credentialsId: 'dockerHubAccount', usernameVariable: 'dockerUser', passwordVariable: 'dockerPassword')]) {
            sh "docker login -u $dockerUser -p $dockerPassword"
            sh "docker tag $containerName:$tag $dockerUser/$containerName:$tag"
            sh "docker push $dockerUser/$containerName:$tag"
            echo "Image push complete"
        }
    }
         stage('Terraform Provision') {
  
        sh 'terraform init'
        sh 'terraform validate'
        sh 'terraform plan -out=tfplan'
        sh 'terraform apply -auto-approve tfplan'
  
         }
    stage('Run Test Server') {
        ansiblePlaybook credentialsId: 'private-key', disableHostKeyChecking: true, installation: 'ansible', playbook: 'test-server-playbook.yml', inventory: 'servers_inventory'
    }

    stage('Run Prod Server') {
        ansiblePlaybook credentialsId: 'private-key', disableHostKeyChecking: true, installation: 'ansible', playbook: 'prod-server-playbook.yml', inventory: 'servers_inventory'
    }
}
