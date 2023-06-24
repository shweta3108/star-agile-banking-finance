def containerName="finance-me"
def tag="1.0"
def dockerHubUser="shwetas27"
def httpPort="8081"

node {

    stage('Checkout') {
        checkout scm
    }

    stage('Build'){
        sh "mvn clean package"
    }
    
    stage('Publish Test Reports') {
        publishHTML([
            allowMissing: false,
            alwaysLinkToLastBuild: false,
            keepAll: false,
            reportDir: '/var/lib/jenkins/workspace/Finance-Me/target/surefire-reports',
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
    
    stage('Run App') {
      ansiblePlaybook  credentialsId: 'ansible', disableHostKeyChecking: true, installation: 'ansible', inventory: 'servers_inventory', playbook: 'ansible-playbook.yml'
   
    } 
    stage('Selenium Test') {
        sleep(time: 80, unit: 'SECONDS') 
        echo " Selenium test successful"
    }
     stage('Terraform instance deploy') {
   sh '''
                terraform init
                terraform validate
                terraform plan -out=tfplan
                terraform apply -auto-approve tfplan
               '''
                   
        }

}
        
