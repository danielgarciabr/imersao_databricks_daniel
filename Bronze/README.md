# Camada Bronze - Pipeline de Segmentação de Clientes

Esta camada implementa a ingestão de dados brutos conforme especificado no pipeline de segmentação de clientes utilizando Lakeflow Declarative Pipelines do Databricks.

## Estrutura dos Arquivos

### 1. customers.sql
- **Fonte**: `/Volumes/lakehouse/raw_public/customers`
- **Formato**: CSV com header
- **Campos**:
  - `customer_id`: Identificador único do cliente
  - `nome`: Nome do cliente
  - `documento`: Documento do cliente
  - `segmento`: Segmento do cliente (Financeiro, Indústria, Varejo, Tecnologia)
  - `data_cadastro`: Data de cadastro
  - `ativo`: Status do cliente
  - `horario_coleta`: Timestamp de coleta

### 2. transaction_btc.sql
- **Fonte**: `/Volumes/lakehouse/raw_public/transacation_btc`
- **Formato**: CSV com header
- **Campos**:
  - `transaction_id`: Identificador único da transação
  - `customer_id`: ID do cliente
  - `data_hora`: Data e hora da transação
  - `tipo_operacao`: Tipo de operação (COMPRA, VENDA)
  - `quantidade`: Quantidade transacionada
  - `preco`: Preço unitário
  - `moeda`: Moeda da transação
  - `horario_coleta`: Timestamp de coleta

### 3. transaction_commodities.sql
- **Fonte**: `/Volumes/lakehouse/raw_public/transaction_commodities`
- **Formato**: CSV com header
- **Campos**: Mesma estrutura de `transaction_btc.sql`

### 4. quotation_btc.sql
- **Fonte**: `/Volumes/lakehouse/raw_public/quotation_btc`
- **Formato**: CSV com header
- **Campos**:
  - `data_hora`: Data e hora da cotação
  - `moeda`: Moeda cotada
  - `preco_abertura`: Preço de abertura
  - `preco_fechamento`: Preço de fechamento
  - `preco_maximo`: Preço máximo
  - `preco_minimo`: Preço mínimo
  - `volume`: Volume negociado
  - `horario_coleta`: Timestamp de coleta

### 5. quotation_yfinance.sql
- **Fonte**: `/Volumes/lakehouse/raw_public/quotation_yfinance`
- **Formato**: CSV com header
- **Campos**: Mesma estrutura de `quotation_btc.sql`

## Regras de Qualidade de Dados

Todas as tabelas implementam regras de qualidade usando a sintaxe oficial `CONSTRAINT ... EXPECT`:

### Validações Aplicadas:
- **Campos obrigatórios**: Verificação de `NOT NULL` para campos críticos
- **Valores positivos**: Validação de `> 0` para quantidades e preços
- **Domínios permitidos**: Validação de valores em listas específicas
- **Consistência temporal**: Verificação de `horario_coleta <= current_timestamp()`

### Ações de Violação:
- **ON VIOLATION DROP ROW**: Remove registros que violam as regras de qualidade

## Configuração cloud_files

Todas as tabelas utilizam a função `cloud_files` com:
- **Formato**: CSV
- **Header**: true (primeira linha contém cabeçalhos)
- **InferSchema**: true (inferência automática de tipos de dados)

## Streaming Tables

Todas as tabelas são criadas como `STREAMING TABLE` para garantir:
- Processamento incremental
- Ingestão em tempo real
- Compatibilidade com Lakeflow Declarative Pipelines

## Execução

Para executar os scripts:
1. Execute cada arquivo SQL no Databricks SQL
2. As tabelas serão criadas automaticamente no schema `bronze`
3. O processamento será incremental conforme novos dados chegarem nos volumes
