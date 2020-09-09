FROM openjdk:16-alpine

RUN apk update && apk upgrade && apk add apache-ant unzip wget openssh-client git gawk curl tar bash

###################################################################################
## install tools for ant
####################################################################################

RUN mkdir -p ~/extern/jacoco
RUN wget http://search.maven.org/remotecontent?filepath=org/jacoco/jacoco/0.8.5/jacoco-0.8.5.zip -O /tmp/jacoco.zip
RUN unzip -d /tmp/jacoco_unzip /tmp/jacoco.zip
RUN mv /tmp/jacoco_unzip/lib/*.jar ~/extern/jacoco
RUN rm -rf /tmp/jacoco_unzip /tmp/jacoco.zip

RUN mkdir -p ~/extern/checkstyle
RUN wget https://github.com/checkstyle/checkstyle/releases/download/checkstyle-8.36/checkstyle-8.36-all.jar -O ~/extern/checkstyle/checkstyle-all.jar

RUN mkdir -p ~/extern/lib
RUN wget https://repo1.maven.org/maven2/org/junit/platform/junit-platform-commons/1.6.2/junit-platform-commons-1.6.2.jar -O ~/extern/lib/junit-platform-commons.jar
RUN wget https://repo1.maven.org/maven2/org/junit/platform/junit-platform-engine/1.6.2/junit-platform-engine-1.6.2.jar -O ~/extern/lib/junit-platform-engine.jar
RUN wget https://repo1.maven.org/maven2/org/junit/platform/junit-platform-launcher/1.6.2/junit-platform-launcher-1.6.2.jar -O ~/extern/lib/junit-platform-launcher.jar
RUN wget https://repo1.maven.org/maven2/org/opentest4j/opentest4j/1.2.0/opentest4j-1.2.0.jar -O ~/extern/lib/opentest4j.jar
RUN wget https://repo1.maven.org/maven2/junit/junit/4.13/junit-4.13.jar -O ~/extern/lib/junit.jar
RUN wget https://repo1.maven.org/maven2/org/apiguardian/apiguardian-api/1.1.0/apiguardian-api-1.1.0.jar -O ~/extern/lib/apiguardian-api.jar
RUN wget https://repo1.maven.org/maven2/org/junit/jupiter/junit-jupiter-api/5.6.2/junit-jupiter-api-5.6.2.jar -O ~/extern/lib/junit-jupiter-api.jar
RUN wget https://repo1.maven.org/maven2/org/junit/jupiter/junit-jupiter-engine/5.6.2/junit-jupiter-engine-5.6.2.jar -O ~/extern/lib/junit-jupiter-engine.jar
RUN wget https://repo1.maven.org/maven2/org/junit/vintage/junit-vintage-engine/5.6.2/junit-vintage-engine-5.6.2.jar -O ~/extern/lib/junit-vintage-engine.jar
RUN wget https://repo1.maven.org/maven2/org/junit/jupiter/junit-jupiter-params/5.6.2/junit-jupiter-params-5.6.2.jar -O ~/extern/lib/junit-jupiter-params.jar
RUN wget https://repo1.maven.org/maven2/org/junit/platform/junit-platform-runner/1.6.2/junit-platform-runner-1.6.2.jar -O ~/extern/lib/junit-platform-runner.jar
RUN wget https://repo1.maven.org/maven2/org/junit/jupiter/junit-jupiter-migrationsupport/5.6.2/junit-jupiter-migrationsupport-5.6.2.jar -O ~/extern/lib/junit-jupiter-migrationsupport.jar
RUN wget https://repo1.maven.org/maven2/org/hamcrest/hamcrest-core/2.2/hamcrest-core-2.2.jar -O ~/extern/lib/hamcrest-core.jar
RUN wget https://repo1.maven.org/maven2/org/junit/platform/junit-platform-suite-api/1.6.2/junit-platform-suite-api-1.6.2.jar -O ~/extern/lib/junit-platform-suite-api.jar
RUN wget https://repo1.maven.org/maven2/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar -O ~/extern/lib/hamcrest-core.jar


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




RUN java --version
RUN which java

RUN wget -O ~/javaFXSDK.zip http://gluonhq.com/download/javafx-14-sdk-linux/ -P ~
RUN unzip ~/javaFXSDK.zip -d ~/javaFXSDK
RUN ls ~/javaFXSDK/javafx-sdk-14/lib
RUN rm -rf ~/javaFXSDK.zip

RUN cp -rvf /root/javaFXSDK/javafx-sdk-14/lib/* /opt/openjdk-14/lib
RUN cp -rvf /root/javaFXSDK/javafx-sdk-14/legal/* /opt/openjdk-14/legal
RUN rm -rf ~/javaFXSDK


####################################################################################
## No specific command for gitlab-ci
####################################################################################


CMD [""]
