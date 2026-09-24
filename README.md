# ⚡ Pipeline de Detecção de Fraudes em Tempo Real (Postgres → Confluent Cloud → Flink SQL)

Este repositório contém a implementação completa de um pipeline *Stream-Native* para ingestão CDC, enriquecimento de dados e detecção de fraudes em pagamentos em tempo real utilizando **Confluent Cloud**, **Postgres (Debezium)** e **Flink SQL**.

---

## 🏗️ Arquitetura da Solução

1. **Origem:** Banco de Dados Postgres enviando eventos de transações e contas via CDC (Change Data Capture).
2. **Ingestão & Schemas:** Confluent Cloud (Kafka) com Schemas Avro registrados e governados no Schema Registry (evoluções *BACKWARD*).
3. **Processamento:** Apache Flink SQL executando *Temporal Joins* e correspondência de padrões complexos (*MATCH_RECOGNIZE*) para detecção de alta velocidade em janelas de 60 segundos.
4. **Destino:** Tópico `desafio.fraud.detected` gerando alertas imediatos para consumo.

---

## 🚀 Como Executar o Projetos (Setup & Teardown)

### Pré-requisitos
- Confluent CLI instalado e autenticado.
- Banco de Dados Postgres (ex: Neon ou local) configurado para WAL (`wal_level = logical`).
- Arquivo `.env` configurado a partir do `.env.example`.

### Subindo a Infraestrutura
```bash
chmod +x scripts/setup.sh
./scripts/setup.sh
