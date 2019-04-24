FROM jhipster/jhipster:v5.8.2 as dependencias

USER jhipster
RUN \
  cd /home/jhipster && \
  git clone https://github.com/Gabrui/jh-estavel.git && cd jh-estavel && \
  ./mvnw dependency:purge-local-repository
RUN \
  cd /home/jhipster/jh-estavel && \
  ./mvnw clean install
RUN \
  cd /home/jhipster/jh-estavel && \
  ./mvnw org.jacoco:jacoco-maven-plugin:prepare-agent sonar:sonar || true && \
  ./mvnw verify -Pprod -DskipTests
RUN \
  cd /home/jhipster/jh-estavel && \
  npm install


FROM jhipster/jhipster:v5.8.2
COPY --from=dependencias /home/jhipster/.m2 /home/jhipster/.m2
COPY --from=dependencias /home/jhipster/jh-estavel/node /home/jhipster/node
COPY --from=dependencias /home/jhipster/jh-estavel/node_modules /home/jhipster/node_modules
COPY src/main/resources/banner_preto.txt /home/jhipster/banner_preto.txt

USER root
RUN \
  apt-get update && \
  apt-get install -y chromium-browser

USER jhipster
CMD ["tail", "-n", "20", "-f", "/home/jhipster/banner_preto.txt"]
