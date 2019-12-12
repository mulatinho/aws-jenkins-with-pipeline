FROM jenkins/jenkins:latest

USER root

RUN apt-get update -y

RUN apt-get install maven -y

WORKDIR /opt/petclinic

COPY Jenkinsfile /opt/petclinic

# installing plugins
COPY plugins.txt /opt/petclinic

RUN while read PLUGIN; do \
	/usr/local/bin/install-plugins.sh $PLUGIN; done < plugins.txt


# creating first pipeline job
RUN mkdir -p /var/jenkins_home/jobs

COPY config.xml /var/jenkins_home/jobs/petclinic-job/

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

EXPOSE 8080
