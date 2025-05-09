FROM swipl:latest as prolog

FROM python:3.10

ENV DEBIAN_FRONTEND=noninteractive

RUN pip install --upgrade pip

RUN apt-get -y update

RUN pip3 install Django

# Install additional required packages
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
	git \
	npm \
	libtcmalloc-minimal4 \
	libarchive13 \
	libxml2-dev \
	libxslt1-dev \
	gcc \
	wget \
	unzip \
	make \
	g++ \
	libpcre3-dev \
	libedit-dev \
	libgmp-dev \
	libssl-dev \
	libarchive-dev \
	libxml2-dev \
	libxslt1-dev \
	zlib1g-dev \
	libjpeg-dev \
	libpng-dev \
	libreadline-dev \
	libedit-dev \
	libgmp-dev \
	libssl-dev \
	libarchive-dev \
	libxml2-dev \
	libxslt1-dev \
	zlib1g-dev \
	libjpeg-dev \
	libpng-dev \
	libreadline-dev

WORKDIR /app

# Download and extract sCASP
RUN set -eux; \
	wget https://github.com/SWI-Prolog/sCASP/archive/refs/heads/master.zip ; \
	unzip master.zip; \
	mv sCASP-master sCASP; \
	rm master.zip

# Copy the entire SWI-Prolog installation
COPY --from=prolog /usr/lib/swipl/ /usr/lib/swipl/
COPY --from=prolog /usr/bin/swipl /usr/bin/swipl

# Make sure the binary is executable
RUN chmod +x /usr/bin/swipl

# Create necessary directories
RUN mkdir -p /root/.local/share/swi-prolog/pack

# Install sCASP manually
RUN set -eux; \
	cd sCASP && \
	mkdir -p /root/.local/share/swi-prolog/pack/scasp && \
	cp -r * /root/.local/share/swi-prolog/pack/scasp/ && \
	cd /root/.local/share/swi-prolog/pack/scasp && \
	swipl -g "make" -t halt

COPY ./blawx/requirements.txt blawx/blawx/requirements.txt

RUN pip3 install -r blawx/blawx/requirements.txt

RUN mkdir blawx/blawx/static

RUN mkdir blawx/blawx/static/blawx

RUN mkdir blawx/blawx/static/blawx/blockly

RUN mkdir blawx/blawx/static/blawx/fonts


RUN npm install blockly

RUN mv ./node_modules/blockly /app/blawx/blawx/static/blawx

RUN mkdir /app/blawx/blawx/static/blawx/blockly/appengine

RUN curl https://raw.githubusercontent.com/google/blockly/develop/appengine/storage.js > /app/blawx/blawx/static/blawx/blockly/appengine/storage.js


RUN npm install jquery

RUN mv ./node_modules/jquery/dist/jquery.min.js /app/blawx/blawx/static/blawx/jquery.min.js

RUN npm install bootstrap

RUN mv ./node_modules/bootstrap/dist/css/bootstrap.min.css /app/blawx/blawx/static/blawx/bootstrap.min.css

RUN mv ./node_modules/bootstrap/dist/css/bootstrap.min.css.map /app/blawx/blawx/static/blawx/bootstrap.min.css.map

RUN mv ./node_modules/bootstrap/dist/js/bootstrap.bundle.min.js /app/blawx/blawx/static/blawx/bootstrap.bundle.min.js

RUN mv ./node_modules/bootstrap/dist/js/bootstrap.bundle.min.js.map /app/blawx/blawx/static/blawx/bootstrap.bundle.min.js.map

RUN npm install bootstrap-icons

RUN mv ./node_modules/bootstrap-icons/font/bootstrap-icons.css /app/blawx/blawx/static/blawx/bootstrap-icons.css

RUN mv ./node_modules/bootstrap-icons/font/fonts/bootstrap-icons.woff /app/blawx/blawx/static/blawx/fonts/bootstrap-icons.woff

RUN mv ./node_modules/bootstrap-icons/font/fonts/bootstrap-icons.woff2 /app/blawx/blawx/static/blawx/fonts/bootstrap-icons.woff2

COPY . blawx

WORKDIR /app/blawx

ARG SU_PASSWORD=blawx2022

ENV DJANGO_SUPERUSER_PASSWORD=$SU_PASSWORD

RUN python manage.py makemigrations

RUN python manage.py migrate --run-syncdb

RUN python manage.py createsuperuser --noinput --username admin --email admin@admin.com

RUN python load_data.py

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

EXPOSE 8000