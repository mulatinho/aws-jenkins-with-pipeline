# jenkins-ci-pipeline-example
this is an example of jenkins-ci pipeline using a default job initialized on startup of jenkins.

## how to build

    $ git clone https://github.com/mulatinho/jenkins-ci-pipeline-example.git
    $ cd jenkins-ci-pipeline-example
    $ docker build -t jenkins-ci .

## how to run

    $ docker run -p 8080:8080 jenkins-ci
  
  
## trigger job

1. access the job list
2. enter `petclinic-job` job
3. make him build
