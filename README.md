# gcloud-jenkins-with-pipeline
in this is we run a Kubernetes cluster using AWS and using a jenkins-ci with a pipeline that is triggered at the startup.

## how to build

1. firstly, you build the docker image
2. you create your instance in AWS to run the docker image
3. execut the plan from terraform

### build docker image

    $ git clone https://github.com/mulatinho/jenkins-ci-pipeline-example.git
    $ cd jenkins-ci-pipeline-example
    $ docker build -t jenkins-ci .

#### how to run

    $ docker run -p 8080:8080 jenkins-ci
  
### make the ec2 instance public
 
    $ terraform init
    $ terraform plan -out plan.jenkins.out
    $ terraform apply "plan.jenkins.out"

## how to trigger job

1. access the jenkins on browser
2. got to job list
3. enter `petclinic-job` job
4. make him build
