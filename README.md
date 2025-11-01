# 💎 API Ruby – Desafio de Contas e Eventos

API desenvolvida em **Ruby + Sinatra**, simulando operações bancárias simples (depósito, saque e transferência).  

Código dividido entre **camada HTTP** e **lógica de negócio**.

---

## ⚙️ Requisitos

- Docker instalado (não é necessário Ruby ou Bundler na máquina host)

---

## 🚀 Como rodar
    docker-compose up --build

A API estará disponível em:  
👉 `http://localhost:4567`

Para parar a aplicação:

    docker-compose up --build
  
---

## Usando Docker diretamente

    # Build da imagem
    docker build -t sinatra_app .

    # Rodar o container
    docker run --rm -p 4567:4567 -v "$PWD":/app sinatra_app
---

## 🧩 Endpoints principais

| Método | Rota | Descrição |
|--------|------|-----------|
| POST   | `/reset`                       | Reseta o estado da aplicação |
| GET    | `/balance?account_id=ID`       | Retorna o saldo da conta |
| POST   | `/event`                       | Cria evento (`deposit`, `withdraw`, `transfer`) |

---

## 🧠 Estrutura

    app.rb                # Camada HTTP (Sinatra)
    lib/account_store.rb  # Lógica de negócio (encapsulada)

---

## 🧪 Teste rápido (exemplos)

Reset:

    curl -X POST http://localhost:4567/reset

Depósito:

    curl -X POST http://localhost:4567/event \
      -H "Content-Type: application/json" \
      -d '{"type":"deposit","destination":"100","amount":10}'

Consultar saldo:

    curl "http://localhost:4567/balance?account_id=100"

---

## 📌 Observações

- Lógica de negócio isolada em `AccountStore` → fácil de trocar por persistência (arquivo/DB) sem alterar endpoints.  
- Implementação atende ao formato esperado nos testes: códigos HTTP e corpos (strings ou JSON).
- Todo o desenvolvimento é feito dentro do container Docker, mantendo a máquina host limpa e sem necessidade de instalar Ruby ou gems.

---