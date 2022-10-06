node(){
        stage('Git Clone'){
            git branch: 'main', url: 'https://github.com/Tinkuch/aws_recommendations'
            sh '/home/ashokdas_test1/jenkins/workspace/AWS_Recommendations'
        }
        stage("AWS"){
            dir ("${env.WORKSPACE}"){
                sh 'chmod 755 aws_recommender.sh'
                sh './aws_recommender.sh'
            }
        }
    }