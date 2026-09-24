# ⚡ Pipeline de Detecção de Fraudes em Tempo Real (Postgres → Confluent Cloud → Flink SQL)

Este repositório contém a implementação completa de um pipeline *Stream-Native* para ingestão CDC, enriquecimento de dados e detecção de fraudes em pagamentos em tempo real utilizando **Confluent Cloud**, **Postgres (Debezium)** e **Flink SQL**.

*A demanda real do mercado*
Em sistemas de pagamentos, transações precisam ser processadas rapidamente, enquanto mecanismos de controle de fraude analisam sinais que podem indicar atividades suspeitas.
*Um exemplo de demanda real*:
Uma instituição financeira precisa identificar padrões de transações suspeitas em poucos segundos, sem depender de consultas manuais ao banco de dados ou de processos batch executados em intervalos longos.

*A ideia central é*:
Uma alteração registrada no PostgreSQL pode ser capturada como um evento, transportada pela plataforma de streaming e processada pelo Flink SQL para gerar um alerta.
ostgreSQL como origem de eventos de transações e contas.
CDC (Change Data Capture) para capturar alterações.
Confluent Cloud/Kafka e Schema Registry para ingestão e esquemas.
Flink SQL para junções temporais e reconhecimento de padrões.

<img width="811" height="637" alt="image" src="https://github.com/user-attachments/assets/6361099d-9b72-41c5-8fa3-cef63a99592d" />

PostgreSQL
Banco de dados responsável por armazenar as informações de contas e transações, conforme a arquitetura do projeto. O PostgreSQL utiliza o Write-Ahead Log (WAL) para registrar alterações que fazem parte do funcionamento do banco. O CDC baseado em replicação lógica pode utilizar essas informações para capturar mudanças e transmiti-las a sistemas externos.

Debezium: O Debezium é utilizado para capturar mudanças no banco de dados e transformá-las em eventos que podem ser encaminhados ao Kafka. Ela permite que aplicações downstream recebam mudanças do banco sem precisar consultar continuamente todas as linhas das tabelas de origem. Isso é útil para integração de dados, sincronização, auditoria e processamento de eventos.

Kafka e Confluent Cloud — Transporte dos eventos: Apache Kafka
Sistema de transporte e armazenamento distribuído de eventos utilizado na arquitetura de streaming. 
O Kafka permite separar os produtores de eventos dos consumidores. No seu pipeline:
O PostgreSQL e o CDC produzem eventos.
O Kafka transporta e mantém os eventos conforme a configuração de retenção.
O Flink SQL consome os eventos para processamento.
Outros consumidores podem ler o tópico de alertas.
Isso cria um fluxo desacoplado, permitindo que diferentes sistemas consumam dados sem depender diretamente da execução de uma consulta no banco de origem.

Avro e Schema Registry — Governança dos dados: Confluent Schema Registry
Gerencia esquemas utilizados na serialização e desserialização de eventos, conforme a configuração da plataforma.
Benefício para o mercado: reduzir problemas de integração entre produtores e consumidores quando os contratos de dados evoluem.

Flink SQL — O núcleo do processamento de fraude: Apache Flink
O Apache Flink é a tecnologia de processamento utilizada para analisar os eventos recebidos e aplicar as lógicas de enriquecimento e detecção.

<img width="649" height="417" alt="image" src="https://github.com/user-attachments/assets/fde6582f-98c0-4fbc-aedf-1b823ecaf0f6" />

*Requisitos funcionais*

Exemplos aplicáveis ao projeto:

Capturar eventos de transações e contas.
Processar os eventos em streaming.
Enriquecer os dados das transações.
Identificar padrões suspeitos.
Publicar alertas para consumo por outros sistemas.


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
