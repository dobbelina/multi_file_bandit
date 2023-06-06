FROM alpine:latest

RUN apk update && \
    apk upgrade && \
    apk add git rsync && \
    apk add --no-cache git git-lfs

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

