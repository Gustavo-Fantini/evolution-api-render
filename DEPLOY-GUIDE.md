# 🚀 Guia de Deploy no Render

## 📋 Pré-requisitos

- Conta no [Render.com](https://render.com)
- Repositório GitHub
- Plano Starter ou superior (recomendado para produção)

## ⚡ Deploy Automático (Recomendado)

### 1. Preparar Repositório

```bash
# 1. Fork este repositório para sua conta GitHub
# 2. Clone seu fork localmente (opcional)
git clone https://github.com/SEU-USUARIO/evolution-api-render.git
cd evolution-api-render

# 3. Verifique se os arquivos essenciais existem:
ls -la Dockerfile.render render.yaml .env.render README-RENDER.md
```

### 2. Configurar no Render

1. **Acesse o Dashboard Render**
   - Login em [dashboard.render.com](https://dashboard.render.com)

2. **Criar Blueprint**
   - Clique em **"New+"**
   - Selecione **"Blueprint"**
   - Conecte sua conta GitHub
   - Selecione o repositório forkado

3. **Confirmar Configuração**
   - Render detectará automaticamente o `render.yaml`
   - Verifique os serviços que serão criados:
     - ✅ Web Service: evolution-api
     - ✅ PostgreSQL: evolution-db  
     - ✅ Redis: evolution-redis
   - Clique em **"Apply Blueprint"**

4. **Aguardar Deploy**
   - O Render construirá e fará deploy automaticamente
   - Tempo estimado: 5-10 minutos

## 🔧 Deploy Manual (Alternativa)

### 1. Criar Serviços Individualmente

#### Web Service (API)

```yaml
# No Dashboard Render:
New → Web Service → Docker
```

**Configurações:**
- **Name**: evolution-api
- **Environment**: Docker
- **Dockerfile Path**: ./Dockerfile.render
- **Branch**: main
- **Plan**: Starter (ou superior)

**Variáveis de Ambiente:**
```bash
SERVER_NAME=evolution
SERVER_TYPE=http
PORT=8080
DATABASE_PROVIDER=postgresql
DATABASE_CONNECTION_URI=postgresql://user:pass@host:5432/db
CACHE_REDIS_ENABLED=true
CACHE_REDIS_URI=redis://host:port
AUTHENTICATION_API_KEY=sua-chave-aqui
LANGUAGE=pt_BR
```

#### Banco de Dados PostgreSQL

```bash
# Dashboard: New → PostgreSQL
Name: evolution-db
Database Name: evolution_db
User: evolution
Plan: Starter
```

#### Cache Redis

```bash
# Dashboard: New → Redis  
Name: evolution-redis
Plan: Starter
```

### 2. Conectar Serviços

1. **PostgreSQL → API**
   - Em evolution-api → Environment
   - Add Database Variable → evolution-db
   - Isso criará `DATABASE_CONNECTION_URI` automaticamente

2. **Redis → API**
   - Em evolution-api → Environment  
   - Add Redis Variable → evolution-redis
   - Isso criará `CACHE_REDIS_URI` automaticamente

## 🌱 Pós-Deploy

### 1. Verificar Funcionamento

```bash
# Testar health check
curl https://seu-app.onrender.com/

# Verificar instâncias
curl -H "apikey: SUA_API_KEY" \
     https://seu-app.onrender.com/instance
```

### 2. Obter API Key

A API Key é gerada automaticamente. Para encontrar:

1. Dashboard → evolution-api
2. Aba "Environment"
3. Procure por `AUTHENTICATION_API_KEY`

### 3. Criar Primeira Instância

```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -H "apikey: SUA_API_KEY" \
  -d '{
    "instanceName": "minha-instancia",
    "qrcode": true,
    "number": "5511999999999"
  }' \
  https://seu-app.onrender.com/instance/create
```

## 🔍 Monitoramento e Logs

### Acessar Logs

1. Dashboard → evolution-api
2. Aba "Logs"
3. Filtre por tempo ou nível de log

### Métricas Disponíveis

- CPU Usage
- Memory Usage  
- Request Count
- Response Time
- Error Rate

### Health Checks

- **Path**: `/health`
- **Interval**: 30 segundos
- **Timeout**: 30 segundos
- **Expected**: Status 200

## ⚠️ Limitações e Soluções

### Plano Gratuito

| Problema | Solução |
|----------|---------|
| Sleep após 15min | Upgrade para Starter |
| Build timeout | Otimizar Dockerfile |
| Memória limitada | Limpar cache, usar Redis |

### Performance

| Issue | Fix |
|-------|-----|
| Cold starts | Plano Starter |
| Lentidão | Redis cache |
| Conexões | Pool de conexões |

## 🔄 CI/CD Automático

### Branch Strategy

- **main** → Produção
- **develop** → Staging  
- **feature/*** → Preview

### Deploy Automático

```bash
# Push para main = deploy produção
git push origin main

# Pull request = preview deploy
git push origin feature/nova-feature
```

### Rollback

1. Dashboard → evolution-api
2. Aba "Deploys"
3. Clique no deploy anterior
4. "Redeploy"

## 🛠️ Customização

### Variáveis Customizadas

Adicione ao `render.yaml`:

```yaml
envVars:
  - key: WEBHOOK_GLOBAL_URL
    value: https://seu-webhook.com
  - key: CORS_ORIGIN  
    value: https://seusite.com
```

### Domínio Personalizado

1. Dashboard → evolution-api
2. Settings → Custom Domain
3. Adicionar domínio
4. Configurar DNS

### SSL Automático

Render fornece SSL gratuito para todos os domínios.

## 🐛 Troubleshooting

### Erros Comuns

#### 1. "Database connection failed"
```bash
# Verificar se PostgreSQL está rodando
# Testar string de conexão manualmente
```

#### 2. "Redis connection timeout"  
```bash
# Verificar se Redis está ativo
# Configurar firewall se necessário
```

#### 3. "Health check failed"
```bash
# Verificar se aplicação subiu
# Aumentar timeout no render.yaml
```

#### 4. "Build timeout"
```bash
# Otimizar Dockerfile
# Usar cache de layers
# Reduzir dependências
```

### Debug Local

```bash
# Para testar localmente antes do deploy
cp .env.render .env
# Editar .env com credenciais locais
docker build -f Dockerfile.render -t evolution-local .
docker run -p 8080:8080 evolution-local
```

## 📈 Escalabilidade

### Vertical Scaling

1. Dashboard → evolution-api
2. Settings
3. Change plan
4. Aumentar CPU/RAM

### Horizontal Scaling

1. Criar múltiplos web services
2. Usar load balancer
3. Configurar sticky sessions

### Performance Tips

- ✅ Usar Redis para cache
- ✅ Configurar pool de conexões
- ✅ Implementar rate limiting
- ✅ Monitorar métricas
- ✅ Otimizar queries

## 📞 Suporte

### Render Support

- [Render Docs](https://render.com/docs)
- [Render Status](https://status.render.com)
- [Render Community](https://community.render.com)

### Evolution API Support

- [Evolution API Docs](https://doc.evolution-api.com)
- [GitHub Issues](https://github.com/EvolutionAPI/evolution-api/issues)
- [Discord Community](https://discord.gg/evolution-api)

---

## ✅ Checklist Final

- [ ] Repositório forkado
- [ ] Arquivos render.yaml criados
- [ ] Dockerfile.render otimizado
- [ ] Variáveis de ambiente configuradas
- [ ] Deploy realizado com sucesso
- [ ] Health check funcionando
- [ ] API testada
- [ ] Logs monitorados
- [ ] Domínio configurado (opcional)
- [ ] Backup implementado

Pronto! Sua Evolution API está rodando no Render! 🎉
