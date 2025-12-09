FROM golang:1.23-alpine AS builder

ENV CGO_ENABLED=0 GOOS=linux GOARCH=amd64

RUN apk add --no-cache git

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN go build -o app ./cmd/main.go

FROM alpine:latest

RUN apk --no-cache add ca-certificates

RUN adduser -D -g '' appuser

WORKDIR /app

COPY --from=builder /app/app .

RUN chown -R appuser:appuser /app
USER appuser

EXPOSE 14703

CMD ["./app"]
