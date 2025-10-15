-- =====================================================
-- Bronze Layer - Ingestão de Dados de Clientes
-- Pipeline de Segmentação de Clientes - Lakeflow Declarative Pipelines
-- =====================================================

CREATE OR REFRESH STREAMING TABLE bronze.customers
AS
SELECT 
    customer_id,
    nome,
    documento,
    segmento,
    data_cadastro,
    ativo,
    current_timestamp() as horario_coleta
FROM cloud_files(
    '/Volumes/lakehouse/raw_public/customers',
    'csv',
    map(
        'header', 'true',
        'inferSchema', 'true'
    )
)
CONSTRAINT customer_id_not_null EXPECT (customer_id IS NOT NULL) ON VIOLATION DROP ROW
CONSTRAINT nome_not_null EXPECT (nome IS NOT NULL) ON VIOLATION DROP ROW
CONSTRAINT documento_not_null EXPECT (documento IS NOT NULL) ON VIOLATION DROP ROW
CONSTRAINT segmento_valid EXPECT (segmento IN ('Financeiro', 'Indústria', 'Varejo', 'Tecnologia')) ON VIOLATION DROP ROW
CONSTRAINT data_cadastro_not_null EXPECT (data_cadastro IS NOT NULL) ON VIOLATION DROP ROW
CONSTRAINT horario_coleta_valid EXPECT (horario_coleta <= current_timestamp()) ON VIOLATION DROP ROW;
