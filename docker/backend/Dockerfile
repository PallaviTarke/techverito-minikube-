FROM golang:1.19-alpine AS build
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build -o server .


FROM alpine:3.19
WORKDIR /app
COPY --from=build /app/server /app/server
EXPOSE 8080
ENV PORT=8080
CMD ["/app/server"]