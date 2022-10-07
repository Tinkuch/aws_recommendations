node('worker02'){
        stage('Git Clone'){
            git branch: 'main', url: 'git@github.com:Tinkuch/aws_recommendations.git'
            sh 'chmod 777 /home/tinku_ccc/jenkins/workspace/AWS_Recommendations'
        }
        stage("AWS"){
            dir ("${env.WORKSPACE}"){
                sh 'chmod 755 aws_recommender.sh'
                sh './aws_recommender.sh'
            }
        }
    }