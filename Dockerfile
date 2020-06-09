FROM alpine:3.12.0

RUN echo @repo http://nl.alpinelinux.org/alpine/v3.12/community >> /etc/apk/repositories && \
    echo @repo http://nl.alpinelinux.org/alpine/v3.12/main >> /etc/apk/repositories && \
    apk add --no-cache bash@repo jq@repo gawk@repo coreutils@repo

COPY src/truncate-logs.sh /usr/local/bin/truncate-logs
COPY src/truncate-logs-cron /var/spool/cron/crontabs/root

RUN chmod +x /usr/local/bin/truncate-logs

ENV PERIOD=29

CMD crond -f && gulp
