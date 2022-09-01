FROM gcr.io/kaniko-project/executor:v1.9.0

FROM alpine
COPY --from=0 /kaniko/executor /usr/local/bin/executor
ENTRYPOINT ["executor"]