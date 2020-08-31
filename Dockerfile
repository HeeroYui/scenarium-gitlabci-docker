FROM debian:9

RUN apt-get update && \
	apt-get install -y curl fontconfig && \
	rm -rf /var/lib/apt/lists/*

ENV  LANG=en_US.UTF-8 \
     LANGUAGE=en_US:en

ARG LIBERICA_ROOT=/usr/lib/jvm/jdk-14.0.2-bellsoft
ARG LIBERICA_VERSION=14.0.2
ARG LIBERICA_BUILD=13
ARG LIBERICA_VARIANT=jdk

RUN LIBERICA_ARCH='' && LIBERICA_ARCH_TAG='' && \
  case `uname -m` in \
        x86_64) \
            LIBERICA_ARCH="amd64" \
            ;; \
        i686) \
            LIBERICA_ARCH="i586" \
            ;; \
        aarch64) \
            LIBERICA_ARCH="aarch64" \
            ;; \
        armv[67]l) \
            LIBERICA_ARCH="arm32-vfp-hflt" \
            ;; \
        *) \
            LIBERICA_ARCH=`uname -m` \
            ;; \
  esac  && \
  mkdir -p $LIBERICA_ROOT && \
  mkdir -p /tmp/java && \
  RSUFFIX="-full" && \
  LIBERICA_BUILD_STR=${LIBERICA_BUILD:+"+${LIBERICA_BUILD}"} && \
  PKG=`echo "bellsoft-${LIBERICA_VARIANT}${LIBERICA_VERSION}${LIBERICA_BUILD_STR}-linux-${LIBERICA_ARCH}${RSUFFIX}.tar.gz"` && \
  curl -SL "https://download.bell-sw.com/java/${LIBERICA_VERSION}${LIBERICA_BUILD_STR}/${PKG}" -o /tmp/java/jdk.tar.gz && \
  SHA1=`curl -fSL "https://download.bell-sw.com/sha1sum/java/${LIBERICA_VERSION}${LIBERICA_BUILD_STR}" | grep ${PKG} | cut -f1 -d' '` && \
  echo "${SHA1} */tmp/java/jdk.tar.gz" | sha1sum -c - && \
  tar xzf /tmp/java/jdk.tar.gz -C /tmp/java && \
  find "/tmp/java/${LIBERICA_VARIANT}-${LIBERICA_VERSION}${RSUFFIX}" -maxdepth 1 -mindepth 1 -exec mv "{}" "${LIBERICA_ROOT}/" \; && \
  ln -s $LIBERICA_ROOT /usr/lib/jvm/jdk && \
  rm -rf /tmp/java

ENV JAVA_HOME=${LIBERICA_ROOT} \
	PATH=${LIBERICA_ROOT}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
LABEL Edouard DUPIN <yui.heero@gmail.com>

# Contain tools for: Ant, graddle, maven, junit, javaFX

# based on the https://medium.com/@migueldoctor/how-to-create-a-custom-docker-image-with-jdk8-maven-and-gradle-ddc90f41cee4 tutorial
# generic image: https://hub.docker.com/r/migueldoctor/cosmos-gitlabci-jdk8-maven-gradle

# globals variables:

ARG USER_HOME_DIR="/root"


####################################################################################
## previous from https://github.com/bell-sw/Liberica/blob/master/docker/repos/liberica-openjdk-debian/14/Dockerfile ==> add full
##
## https://download.bell-sw.com/java/14.0.2+13/bellsoft-jdk14.0.2+13-linux-amd64.tar.gz
## https://download.bell-sw.com/java/14.0.2+13/bellsoft-jdk14.0.2+13-linux-amd64-full.tar.gz
####################################################################################





####################################################################################
## install others ...
####################################################################################

RUN apt-get update && \
	apt-get install -y gawk curl tar bash procps unzip git && \
	rm -rf /var/lib/apt/lists/*

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