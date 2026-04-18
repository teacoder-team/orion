FROM golang:1.24-alpine AS builder

RUN apk add --no-cache git

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o app ./cmd/main.go

FROM alpine:3.20

RUN apk --no-cache add ca-certificates tzdata

RUN adduser -D -g '' appuser
WORKDIR /app

COPY --from=builder /app/app .

RUN chown appuser:appuser /app/app
USER appuser

EXPOSE 14703

CMD ["./app"]