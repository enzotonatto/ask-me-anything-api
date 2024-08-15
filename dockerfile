# Use uma imagem base do Golang para construir a aplicação
FROM golang:1.22.4-alpine AS builder

# Defina o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copie os arquivos go.mod e go.sum e instale as dependências
COPY go.mod go.sum ./
RUN go mod download

# Copie o código-fonte da aplicação
COPY . .

# Compile o binário da aplicação
RUN go build -o out .

# Use uma imagem menor para o runtime
FROM alpine:latest

# Defina o diretório de trabalho no novo estágio
WORKDIR /root/

# Copie o binário da aplicação do estágio anterior
COPY --from=builder /app/out .

# Garanta que o binário tenha permissões de execução
RUN chmod +x out

# Exponha a porta em que a aplicação será executada
EXPOSE 8080

# Defina o comando para rodar a aplicação
CMD ["./out"]
