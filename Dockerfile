ARG ALPINE="alpine:3.18"

FROM ${ALPINE} AS builder
RUN apk add g++ make boost-dev openssl1.1-compat-dev
RUN wget https://github.com/jselbie/stunserver/archive/refs/heads/master.tar.gz -qO- | tar xz
WORKDIR /stunserver-master/
RUN sed -i 's/sys\/termios.h/termios.h/g' common/commonincludes.hpp
RUN make && ./stuntestcode
RUN mv stunclient stunserver /tmp/

FROM ${ALPINE}
RUN apk add libstdc++ openssl1.1-compat
COPY --from=builder /tmp/stunserver /tmp/stunclient /usr/bin/
EXPOSE 3478/tcp 3478/udp
ENTRYPOINT ["stunserver"]
