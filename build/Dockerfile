FROM eclipse-temurin:23-jre-alpine

# ── configuration

LABEL maintainer="martin.kraetke@le-tex.de"
LABEL version="0.1.1"
LABEL description="convert hello world"

ARG BASEX_VERSION=12.2
ARG BASEX_FILE=BaseX${BASEX_VERSION/./}
ARG USER=letex
  
ENV SHELL=/bin/bash
ENV JAVA_VERSION=23
   
# ── system dependencies
  
RUN apk update && apk upgrade && apk add bash curl git make nano sudo && rm -rf /var/cache/apk/*

# ── add default user
  
RUN adduser -s /bin/bash -S ${USER} -S ${USER}

# ── get BaseX

RUN curl -fSL "https://files.basex.org/releases/${BASEX_VERSION}/${BASEX_FILE}.zip" \
      -o /tmp/basex.zip && \
   unzip -q /tmp/basex.zip -d /home/${USER} && \
   rm /tmp/basex.zip && \
   mv /home/${USER}/basex /home/${USER}/basex-tmp 2>/dev/null; \
   mv /home/${USER}/basex-tmp /home/${USER}/basex 2>/dev/null || mv /home/${USER}/BaseX /srv/basex 2>/dev/null || tru e&& \
   chmod +x /home/${USER}/basex/bin/*

# ── create base dirs

RUN mkdir -p /home/${USER}/convert/data /home/${USER}/convert/converter
  
# ── copy webapp

COPY webapp-convert /home/${USER}/basex/webapp/convert
    
COPY converter /home/${USER}/convert/converter

# ── select dirs

RUN chown -R ${USER}:users /home/${USER}/convert/data /home/${USER}/convert/converter

RUN chmod 755 -R /home/${USER}/convert/data /home/${USER}/convert/converter

USER ${USER}

WORKDIR /home/${USER}
    
# ── expose

EXPOSE 8080
CMD ["basex/bin/basexhttp"]
