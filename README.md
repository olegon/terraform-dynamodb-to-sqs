# Como reprocessar todos os registros criados em um DynamoDB?

## Desafio

Existem uma tabela no DynamoDB com vários registros criados, muito mais do que estes exemplos:

```json
// registro 1
{
  "pk": {"S": "USER#414e7eb8-c0d5-4636-8643-7833f380bd39"},
  "sk": {"S": "#METADATA#414e7eb8-c0d5-4636-8643-7833f380bd39"},
  "user_name": {"S": "Ritchie"}
}

// registro 2
{
  "pk": {"S": "USER#f35eb045-171b-4c4e-be68-0e4862a8a3ad"},
  "sk": {"S": "#METADATA#f35eb045-171b-4c4e-be68-0e4862a8a3ad"},
  "user_name": {"S": "Thompson"}
}

// registro 3
{
  "pk": {"S": "USER#dc57b7c8-76f3-4ac7-a5c6-d47ab7205f06"},
  "sk": {"S": "#METADATA#dc57b7c8-76f3-4ac7-a5c6-d47ab7205f06"},
  "user_name": {"S": "Dijkstra"}
}

// registro 4
{
  "pk": {"S": "USER#32c2d60c-cdc6-43ca-96e7-554c70ee31c5"},
  "sk": {"S": "#METADATA#32c2d60c-cdc6-43ca-96e7-554c70ee31c5"},
  "user_name": {"S": "Knuth"}
}
```

O desafio é reprocessar cada um destes itens.

## Stack

- AWS DynamoDB
- AWS Glue
- AWS S3
- AWS SQS
- Terraform


## Solução

Um *Glue Job* `from-dynamodb-to-sqs-job` faz a leitura da *DynamoDB Table* `user-data-table` e joga cada registro em um SQS `user-data-queue` que pode ser processado por uma aplicação ou uma *Lambda*.

### Glue lendo do DynamoDB

Ao fazer a leitura do DynamoDB, é importante especificar qual é o percentual de RCU utilizado `(dynamodb.throughput.read.percent)` e em quantas partições será feita a leitura `(dynamodb.splits)`. Também existe uma opção para jogar os dados no S3 `(dynamodb.export = ddb)` durante a leitura, o que permite ler novamente sem gastar RCU `(dynamodb.export = s3)`, porém a tabela precisa ter *Point-in-time receovery* habilitado. Fonte: [docs](https://docs.aws.amazon.com/glue/latest/dg/aws-glue-programming-etl-connect.html#aws-glue-programming-etl-connect-dynamodb).

