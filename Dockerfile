FROM golang:1.13 as builder
WORKDIR /app
COPY invoke.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -v -o server

FROM ghcr.io/dbt-labs/dbt-snowflake:1.7.1
USER root
WORKDIR /dbt
COPY --from=builder /app/server ./
COPY script.sh ./
COPY . ./

# Install elementary-data[bigquery] using pip
#RUN pip install elementary-data[bigquery]

ENTRYPOINT "./server"
