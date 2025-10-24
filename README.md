# 💎 API Ruby – Desafio de Contas e Eventos

API desenvolvida em **Ruby + Sinatra**, simulando operações bancárias simples (depósito, saque e transferência).  

Código dividido entre **camada HTTP** e **lógica de negócio**.

---

## ⚙️ Requisitos

- Ruby 3.x  
- Bundler instalado (`gem install bundler`)

---

## 🚀 Como rodar
    bundle install
    ruby app.rb -p 4567

A API estará disponível em:  
👉 `http://localhost:4567`

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

---