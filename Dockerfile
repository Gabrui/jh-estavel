FROM jhipster/jhipster:v5.8.2

USER root
RUN \
  apt-get update && \
  apt-get install -y chromium-browser

USER jhipster
RUN \
  cd /home/jhipster && \
  git clone https://github.com/Gabrui/jh-estavel.git && cd jh-estavel && \
  ./mvnw dependency:purge-local-repository && \
  npm install
