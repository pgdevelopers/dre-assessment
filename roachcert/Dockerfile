####################################
#   Multi-stage build
#       1. generate certs
#       2. share certs
####################################

# Stage 1 - generate certs

FROM cockroachdb/cockroach:latest as generator

RUN mkdir -pv /tmp/certs/ca /tmp/certs/crdb0 /tmp/certs/crdb1 /tmp/certs/crdb2 /tmp/safe /tmp/certs/client

RUN ./cockroach cert create-ca --certs-dir=/tmp/certs/ca --ca-key=/tmp/safe/ca.key \
    && cp -v /tmp/certs/ca/ca.crt /tmp/certs/client \
    && cp -v /tmp/certs/ca/ca.crt /tmp/certs/crdb0 \
    && cp -v /tmp/certs/ca/ca.crt /tmp/certs/crdb1 \
    && cp -v /tmp/certs/ca/ca.crt /tmp/certs/crdb2

RUN ./cockroach cert create-client root --certs-dir=/tmp/certs/client --ca-key=/tmp/safe/ca.key --also-generate-pkcs8-key

RUN cp -v /tmp/certs/client/client.* /tmp/certs/crdb0 \
    && cp -v /tmp/certs/client/client.* /tmp/certs/crdb1 \
    && cp -v /tmp/certs/client/client.* /tmp/certs/crdb2

RUN ./cockroach cert create-node crdb0 localhost nginx --certs-dir=/tmp/certs/crdb0 --ca-key=/tmp/safe/ca.key
RUN ./cockroach cert create-node crdb1 localhost nginx --certs-dir=/tmp/certs/crdb1 --ca-key=/tmp/safe/ca.key
RUN ./cockroach cert create-node crdb2 localhost nginx --certs-dir=/tmp/certs/crdb2 --ca-key=/tmp/safe/ca.key

# Stage 2 - share certs

FROM alpine:latest

RUN mkdir -pv /certs/crdb0 /certs/crdb1 /certs/crdb2 /certs/client

COPY --from=generator  /tmp/certs/crdb0/* /certs/crdb0/
COPY --from=generator  /tmp/certs/crdb1/* /certs/crdb1/
COPY --from=generator  /tmp/certs/crdb2/* /certs/crdb2/
COPY --from=generator  /tmp/certs/client/* /certs/client/

CMD tail -f /dev/null
