FROM openshift/base-centos7
 
MAINTAINER Mangirdas Judeikis mangirdas[at]judeikis[dot]lt
LABEL io.openshift.s2i.scripts-url file://usr/local/s2i/bin/
 
ENV MAVEN_VERSION="3.3.9" \
    JOLOKIA_VERSION="1.3.2.redhat-1" \
    PATH=$PATH:"/usr/local/s2i" \
    JAVA_VERSION="7" \
    AB_JOLOKIA_CONFIG="/opt/jolokia/jolokia.properties" \
    AB_JOLOKIA_AUTH_OPENSHIFT="true" \
    JAVA_DATA_DIR=/deployments/data
 
# Some version information
LABEL io.k8s.description="Platform for building and running plain Java applications (fat-jar and flat classpath)" \
      io.k8s.display-name="Java Applications" \
      io.openshift.tags="builder,java" \
      io.openshift.s2i.scripts-url="image:///usr/local/s2i" \
      io.openshift.s2i.destination="/tmp" \
      org.jboss.deployments-dir="/deployments"
 
# Temporary switch to root
USER root

RUN yum install epel-release -y

# Install openJDK
RUN INSTALL_PKGS="tar unzip bc which lsof java-1.7.0-openjdk java-1.7.0-openjdk-devel jq" && \
    yum install -y --enablerepo=centosplus $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y
RUN (curl -v https://www.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | \
    tar -zx -C /usr/local) && \
    ln -sf /usr/local/apache-maven-$MAVEN_VERSION/bin/mvn /usr/local/bin/mvn && \
    mkdir -p $HOME/.m2 

# Use /dev/urandom to speed up startups.
RUN echo securerandom.source=file:/dev/urandom >> /usr/lib/jvm/java/jre/lib/security/java.security

# Jolokia agent
RUN mkdir -p /opt/jolokia/etc \
 && curl https://repository.jboss.org/nexus/content/repositories/fs-releases/org/jolokia/jolokia-jvm/$JOLOKIA_VERSION/jolokia-jvm-$JOLOKIA_VERSION-agent.jar \
         -o /opt/jolokia/jolokia.jar
ADD jolokia-opts /opt/jolokia/jolokia-opts
RUN chmod 444 /opt/jolokia/jolokia.jar \
 && chmod 755 /opt/jolokia/jolokia-opts \
 && chmod 775 /opt/jolokia/etc \
 && chgrp root /opt/jolokia/etc

EXPOSE 8778 8080

ADD jolokia.properties /opt/jolokia/jolokia.properties
 
# S2I scripts + README
COPY s2i /usr/local/s2i
RUN chmod 755 /usr/local/s2i/*
ADD README.md /usr/local/s2i/usage.txt
 
# Add run script as /opt/run-java/run-java.sh and make it executable
COPY run-java.sh debug-options container-limits java-default-options /opt/run-java/
RUN chmod 755 /opt/run-java/run-java.sh /opt/run-java/java-default-options /opt/run-java/container-limits /opt/run-java/debug-options

 
# Adding run-env.sh to set app dir
COPY run-env.sh /opt/run-java/run-env.sh
RUN chmod 755 /opt/run-java/run-env.sh
 
# Necessary to permit running with a randomised UID
RUN mkdir -p /deployments/data \
&& chmod -R "a+rwX" /deployments
# S2I requires a numeric, non-0 UID. This is the UID for the jboss user in the base image
USER 1001
 
# Use the run script as default since we are working as an hybrid image which can be
# used directly to. (If we were a plain s2i image we would print the usage info here)
CMD [ "/usr/local/s2i/usage" ]