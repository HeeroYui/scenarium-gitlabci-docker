FROM archlinux:latest

# update system
RUN pacman -Syu --noconfirm && pacman-db-upgrade
# install package
RUN pacman -S --noconfirm ant unzip wget openssh git gawk curl tar bash
#install jdk-openjdk java-openjfx
RUN pacman -S --noconfirm jdk-openjdk java-openjfx
# intall maven & gradle
RUN pacman -S --noconfirm maven gradle
# clean all the caches
RUN pacman -Scc --noconfirm

ENV LANG=C.UTF-8
ENV JAVA_HOME=/usr/lib/jvm/java-14-openjdk
ENV JAVAFX_HOME=$JAVA_HOME
ENV PATH=/usr/lib/jvm/java-14-openjdk/bin/:$PATH
#ENV JAVA_VERSION=14.0.2

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


####################################################################################
## No specific command for gitlab-ci
####################################################################################

CMD [""]
