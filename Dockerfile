ARG BASE_TAG
FROM python:${BASE_TAG}

ENV SUPERVISORD_CONFDIR /etc
ENV UWSGI_CONFDIR /etc

RUN set -x \
 && apt-get update -qq \
 && apt-get upgrade -y \
 && apt-get install --no-install-recommends -y \
	supervisor \
 && mkdir -p $SUPERVISORD_CONFDIR $UWSGI_CONFDIR \
 && pip --no-cache-dir install \ 
	uwsgi

RUN { \
		echo '[supervisord]'; \
		echo 'nodaemon=true'; \
		echo; \
		echo '[program:uwsgi]'; \
		echo "command=uwsgi --ini $UWSGI_CONFDIR/uwsgi.ini"; \
		echo 'autostart=true'; \
		echo 'autorestart=true'; \
	} | tee "$SUPERVISORD_CONFDIR/supervisord.conf"

CMD ["supervisord", "-c", "$SUPERVISORD_CONFDIR/supervisord.conf"]
