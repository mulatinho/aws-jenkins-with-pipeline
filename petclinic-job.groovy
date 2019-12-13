#! groovy
import hudson.model.FreeStyleProject;
import hudson.plugins.git.*;
import hudson.triggers.SCMTrigger;
import hudson.util.Secret;

import jenkins.model.Jenkins;
import jenkins.model.JenkinsLocationConfiguration;
import org.jenkinsci.plugins.workflow.job.WorkflowJob;
import org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition;

def jenkins = Jenkins.getInstance();
def scm = new GitSCM("https://github.com/mulatinho/jenkins-ci-pipeline-example.git")
scm.branches = [new BranchSpec("*/dev")];

def flowDefinition = new CpsScmFlowDefinition(scm, "Jenkinsfile")
def workflow = new WorkflowJob(jenkins, "petclinic-job")
workflow.definition = flowDefinition
jenkins.add(workflow, "petclinic-job");

jenkins.reload()
