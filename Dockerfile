FROM bellsoft/liberica-openjdk-alpine:latest
#FROM openjdk:8-jdk-alpine

LABEL Edouard DUPIN <yui.heero@gmail.com>

# Contain tools for: Ant, graddle, maven, junit, javaFX

# based on the https://medium.com/@migueldoctor/how-to-create-a-custom-docker-image-with-jdk8-maven-and-gradle-ddc90f41cee4 tutorial
# generic image: https://hub.docker.com/r/migueldoctor/cosmos-gitlabci-jdk8-maven-gradle

# globals variables:

ARG USER_HOME_DIR="/root"


####################################################################################
## install ant & others ...
####################################################################################

RUN apk update && apk add --no-cache curl tar bash procps apache-ant unzip wget openssh-client git

####################################################################################
## install Java FX
####################################################################################

ARG BASE_URL=http://gluonhq.com/download

RUN wget -O ${USER_HOME_DIR}/javaFXSDK.zip ${BASE_URL}/javafx-14-sdk-linux/

RUN unzip ${USER_HOME_DIR}/javaFXSDK.zip -d ${USER_HOME_DIR}/javaFXSDK

####################################################################################
## install Junit standalone
####################################################################################

ARG JUNIT_VERSION=1.5.2
ARG BASE_URL=https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone

RUN wget -O ${USER_HOME_DIR}/junit.jar ${BASE_URL}/${JUNIT_VERSION}/junit-platform-console-standalone-${JUNIT_VERSION}.jar

####################################################################################
## install checkstyle
####################################################################################

ARG CHECKSTYLE_VERSION=8.34
ARG BASE_URL=https://github.com/checkstyle/checkstyle/releases/download

RUN wget ${BASE_URL}/checkstyle-${CHECKSTYLE_VERSION}/checkstyle-${CHECKSTYLE_VERSION}-all.jar -O ${USER_HOME_DIR}/checkstyle.jar

###################################################################################
## install maven
####################################################################################

ARG MAVEN_VERSION=3.6.3
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

RUN mkdir -p /usr/share/maven /usr/share/maven/ref
RUN echo "Downlaoding maven"
RUN curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz

RUN echo "Unziping maven"
RUN tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1

RUN echo "Cleaning and setting links"
RUN rm -f /tmp/apache-maven.tar.gz
RUN ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"


####################################################################################
## install grable
####################################################################################

ARG GRADLE_VERSION=6.6.1
ARG GRADLE_BASE_URL=https://services.gradle.org/distributions

RUN mkdir -p /usr/share/gradle /usr/share/gradle/ref
RUN echo "Downlaoding gradle hash"
RUN curl -fsSL --progress-bar -o /tmp/gradle.zip ${GRADLE_BASE_URL}/gradle-${GRADLE_VERSION}-bin.zip

RUN echo "Unziping gradle"
RUN unzip -d /usr/share/gradle /tmp/gradle.zip

RUN echo "Cleaning and setting links"
RUN rm -f /tmp/gradle.zip
RUN ln -s /usr/share/gradle/gradle-${GRADLE_VERSION} /usr/bin/gradle

# 5- Define environmental variables required by gradle
ENV GRADLE_VERSION 6.6.1
ENV GRADLE_HOME /usr/bin/gradle
ENV GRADLE_USER_HOME /cache

ENV PATH $PATH:$GRADLE_HOME/bin

VOLUME $GRADLE_USER_HOME

####################################################################################
## No specific command for gitlab-ci
####################################################################################


CMD [""]