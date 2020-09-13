FROM alpine:latest
MAINTAINER Frank Carnovale

ENV EV_EXTRA_DEFS -DEV_NO_ATFORK

RUN apk add shadow
RUN groupadd exposer && useradd -m -g exposer -G wheel exposer

COPY files/   /
COPY exposer/ /app

RUN apk update && \
  apk add perl perl-io-socket-ssl perl-dev g++ make wget curl vim nginx sudo && \
  curl -L https://cpanmin.us | perl - App::cpanminus && \
  cpanm --installdeps . -M https://cpan.metacpan.org && \
  apk del g++ make && \
  rm -rf /root/.cpanm/* /usr/local/share/man/* && \
  chown -R exposer:exposer /home/exposer /app

USER exposer
WORKDIR /app
CMD [ "/bin/sh", "-l" ]

