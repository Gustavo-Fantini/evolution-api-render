# Evolution API - Deploy no Render

Guia completo para fazer deploy da Evolution API no Render.com

## 🚀 Deploy Rápido

### 1. Fork do Repositório

```bash
# Fork este repositório para sua conta GitHub
# Clone seu fork:
git clone https://github.com/SEU-USUARIO/evolution-api-render.git
cd evolution-api-render
```

### 2. Configurar no Render

1. Vá para [Render Dashboard](https://dashboard.render.com/)
2. Clique em "New" → "Blueprint"
3. Conecte seu repositório GitHub
4. Render detectará automaticamente o arquivo `render.yaml`
5. Clique em "Apply"

O Render criará automaticamente:
- **Web Service**: Evolution API
- **PostgreSQL**: Banco de dados
- **Redis**: Cache

## 📋 Estrutura do Projeto

```
evolution-api-render/
├── src/                    # Código fonte
├── prisma/                 # Schemas do banco
├── Dockerfile.render       # Docker otimizado para Render
├── render.yaml            # Configuração do serviço Render
├── .env.render            # Template de variáveis de ambiente
├── package.json
└── README-RENDER.md        # Este arquivo
```

## ⚙️ Configurações Importantes

### Variáveis de Ambiente

As seguintes variáveis são configuradas automaticamente pelo Render:

- **`DATABASE_CONNECTION_URI`**: Conexão com PostgreSQL
- **`CACHE_REDIS_URI`**: Conexão com Redis
- **`SERVER_URL`**: URL da aplicação
- **`AUTHENTICATION_API_KEY`**: Chave de API (gerada automaticamente)

### Portas e Health Check

- **Porta**: 8080 (configurada via variável `PORT`)
- **Health Check**: `/health` a cada 30 segundos
- **Timeout**: 30 segundos

## 🔧 Configurações Específicas para Render

### Banco de Dados

- **PostgreSQL**: Configurado automaticamente
- **Nome do banco**: `evolution_db`
- **Usuário**: `evolution`
- **Migrações**: Executadas automaticamente no primeiro deploy

### Cache

- **Redis**: Configurado para cache distribuído
- **TTL**: 7 dias (604800 segundos)
- **Prefix**: `evolution`

### Segurança

- **Usuário não-root**: Container roda como usuário `evolution`
- **Signals**: `dumb-init` para gerenciamento adequado de sinais
- **Health Check**: Verificação automática de saúde

## 🌱 Uso da API

### Endpoint Principal

```
https://seu-app-name.onrender.com
```

### Autenticação

Use a API Key gerada automaticamente ou configure uma própria:

```bash
curl -H "apikey: SUA_API_KEY" \
     https://seu-app-name.onrender.com/instance
```

### Criar Instância WhatsApp

```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -H "apikey: SUA_API_KEY" \
  -d '{
    "instanceName": "minha-instancia",
    "qrcode": true,
    "number": "5511999999999"
  }' \
  https://seu-app-name.onrender.com/instance/create
```

## 📊 Monitoramento

### Logs

Acesse os logs no Dashboard do Render:
1. Vá para o serviço "evolution-api"
2. Clique na aba "Logs"

### Métricas

O Render fornece métricas básicas:
- CPU
- Memória
- Requests
- Response time

## 🔒 Configurações de Segurança

### CORS

Configurado para aceitar requisições de qualquer origem em desenvolvimento:

```env
CORS_ORIGIN=*
```

Para produção, configure domínios específicos:

```env
CORS_ORIGIN=https://seusite.com,https://app.seusite.com
```

### Rate Limiting

A API inclui rate limiting automático. Configure se necessário:

```env
# Adicionar ao render.yaml se necessário
- key: RATE_LIMIT_WINDOW_MS
  value: 900000  # 15 minutos
- key: RATE_LIMIT_MAX_REQUESTS
  value: 100
```

## 🚨 Limitações do Render

### Plano Gratuito

- **Sleep**: Após 15 minutos de inatividade
- **Build time**: Limitado a 15 minutos
- **RAM**: 512MB
- **CPU**: Compartilhada

### Recomendações

1. **Plano Starter**: Para produção contínua
2. **Background Workers**: Para processamento pesado
3. **Disk Storage**: Para arquivos e mídias

## 🔄 CI/CD

O Render oferece CI/CD automático:

1. **Push para main**: Deploy automático
2. **Preview deploys**: Para cada PR
3. **Rollbacks**: Um clique para versão anterior

### Branches

- `main`: Produção
- `develop`: Staging
- `feature/*`: Preview deploys

## 🐛 Troubleshooting

### Problemas Comuns

1. **Container não inicia**:
   - Verifique os logs no Render Dashboard
   - Confirme variáveis de ambiente

2. **Erro de banco de dados**:
   - Verifique se PostgreSQL está rodando
   - Confirme string de conexão

3. **Timeout no health check**:
   - Aplicação pode estar demorando para iniciar
   - Aumente timeout no `render.yaml`

### Debug Local

```bash
# Para testar localmente
cp .env.render .env
# Edite .env com suas credenciais locais
docker build -f Dockerfile.render -t evolution-local .
docker run -p 8080:8080 evolution-local
```

## 📚 Documentação Adicional

- [Render Docs](https://render.com/docs)
- [Evolution API Docs](https://doc.evolution-api.com)
- [PostgreSQL on Render](https://render.com/docs/postgresql)
- [Redis on Render](https://render.com/docs/redis)

## 🤝 Contribuição

1. Fork o projeto
2. Crie branch `feature/nova-feature`
3. Commit suas mudanças
4. Abra Pull Request

## 📄 Licença

Este projeto está licenciado sob a Apache License 2.0 - veja o arquivo [LICENSE](LICENSE) para detalhes.
