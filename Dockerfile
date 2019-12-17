FROM jenkins/jenkins:latest

USER root

RUN apt-get update -y

RUN apt-get install maven -y

USER jenkins

WORKDIR /opt/petclinic

COPY Jenkinsfile /opt/petclinic

COPY plugins.txt /opt/petclinic

RUN while read PLUGIN; do \
	/usr/local/bin/install-plugins.sh $PLUGIN; done < plugins.txt

COPY petclinic-job.groovy /usr/share/jenkins/ref/init.groovy.d/

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

EXPOSE 8080
