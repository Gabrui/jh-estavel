FROM jhipster/jhipster:v5.8.2 as dependencias

USER jhipster
COPY --chown=jhipster:jhipster . /home/jhipster/jh-estavel
RUN \
  cd /home/jhipster/jh-estavel && \
  ./mvnw dependency:purge-local-repository && npm install
RUN \
  cd /home/jhipster/jh-estavel && \
  ./mvnw clean install
RUN \
  cd /home/jhipster/jh-estavel && \
  ./mvnw org.jacoco:jacoco-maven-plugin:prepare-agent sonar:sonar || true && \
  ./mvnw verify -Pprod -DskipTests


FROM jhipster/jhipster:v5.8.2
COPY --chown=jhipster:jhipster --from=dependencias /home/jhipster/.m2 /home/jhipster/.m2
COPY --chown=jhipster:jhipster --from=dependencias /home/jhipster/jh-estavel/node /home/jhipster/node
COPY --chown=jhipster:jhipster --from=dependencias /home/jhipster/jh-estavel/node_modules /home/jhipster/node_modules
COPY --chown=jhipster:jhipster src/main/resources/banner_preto.txt /home/jhipster/banner_preto.txt

USER root
RUN \
  apt-get update && \
  apt-get install -y chromium-browser

USER jhipster
CMD ["tail", "-n", "20", "-f", "/home/jhipster/banner_preto.txt"]
