# CONTEXT.md — ATS TechRecruit AI
> Atualizado: 2026-06-11

## COMO INICIAR UMA NOVA CONVERSA
Cole exatamente isso no início do chat:
```
Continuando projeto ATS TechRecruit. Leia o CONTEXT.md e os arquivos do projeto antes de qualquer ação.
```

---

## MODELO DE TRABALHO

### Divisão Claude.ai (n8n MCP) vs Claude Code (frontend)

| Tarefa | Onde fazer |
|--------|-----------|
| Criar/editar workflows n8n | Claude.ai via MCP |
| Queries SQL no banco | Claude.ai via WF diagnóstico |
| Criar tabelas / ALTER TABLE | Claude.ai via WF diagnóstico |
| Análise de código e sistema | Claude.ai (com arquivos enviados) |
| Editar HTML/JS/CSS das páginas | Claude Code no VS Code |
| Criar novos arquivos .html | Claude Code no VS Code |
| Git add/commit/push | Claude Code no VS Code |

### Regra de ouro
Todo prompt para Claude Code termina com:
> "Após concluir, faça git add, git commit e git push para o repositório."

### Deploy
- Código local em `C:\Users\danil\projetos\ats-recrutamento`
- `git push` → EasyPanel faz redeploy automático em `ats.danns.com.br`
- Repositório: DaniloMartins96/ats-recrutamento

---

## SISTEMA

**ATS TechRecruit AI** — produção em `ats.danns.com.br`

### Páginas

| URL | Arquivo | Acesso |
|-----|---------|--------|
| ats.danns.com.br | index.html | Público |
| ats.danns.com.br/vagas | vagas.html | Público (suporta ?empresa=ID) |
| ats.danns.com.br/candidatura | candidatura.html | Público |
| ats.danns.com.br/candidato | candidato.html | Público (tracking) |
| ats.danns.com.br/admissao | admissao.html | Candidato (via link) |
| ats.danns.com.br/teste | teste.html | Candidato (via link) |
| ats.danns.com.br/avaliacao | avaliacao.html | Candidato (via link) |
| ats.danns.com.br/login | login.html | Master admin |
| ats.danns.com.br/admin.html | admin.html | Master admin (Danilo) |
| ats.danns.com.br/login-empresa.html | login-empresa.html | Clientes empresa |
| ats.danns.com.br/empresa.html | empresa.html | Clientes empresa |

---

## CREDENCIAIS

### Logins
- **Master admin:** danilo_santiago96@hotmail.com / admin123
- **Empresa TechRecruit (id=1):** danilo_santiago96@hotmail.com / Admin@2025
- **Tibério Construtora (id=2):** admin@tiberio.com.br / Tiberio@2025

### n8n
- **URL n8n:** https://n8n.danns.com.br
- **Webhook base:** https://webhook.danns.com.br/webhook
- **MCP URL:** https://webhook.danns.com.br/mcp-server/http
- **PostgreSQL ATS:** ID `GGiSHBVIkgMdXboT`, nome "ATS — PostgreSQL" (tipo: postgresDb)
- **PostgreSQL Mari IA:** ID `4YwnfRQYEg3MapRI` — ⚠️ CREDENCIAL ERRADA, nunca usar para ATS
- **OpenAI:** ID `tQFBNLElNNuvshjI`, nome "OpenAI — ATS"
- **Gmail SMTP:** danns.authentication@gmail.com, cred ID: p0Pq4E10Oc3G7KL3
- **Google Calendar:** nome "Google Calendar ATS"

### Infraestrutura
- **Evolution API:** https://evolution.danns.com.br
- **Instância WhatsApp:** ats-recrutamento
- **API Key WA:** 429683C4C977415CAAFCCE10F7D57E11
- **Grupo WhatsApp:** 120363426989336143@g.us
- **Diagnóstico WF:** C5lA6E6ej4TENV5R → GET /ats-diagnostico-temp

---

## PADRÕES CRÍTICOS N8N

### Credencial Postgres — SEMPRE verificar após criar/atualizar workflow
O n8n auto-atribui "Postgres Mari IA" (errado) em todos os nós Postgres.
Após qualquer `create_workflow` ou `update_workflow` via MCP:
1. Ir no n8n UI → workflow criado
2. Clicar em cada nó Postgres
3. Trocar credencial para **"ATS — PostgreSQL"**
4. Salvar → Publicar

### JS em Code nodes
- ❌ NUNCA usar template literals (backticks)
- ❌ NUNCA usar strings multiline
- ✅ Sempre single-line com escape: `'string com \n escape'`

### Postgres — N linhas → N execuções (bug)
Fix: usar CTE + json_agg para retornar 1 linha com array:
```sql
WITH dados AS (SELECT ...) SELECT json_agg(d) as items FROM dados;
```

### Postgres — Zero rows trava execução
Fix: `COALESCE(json_agg(...), '[]'::json)`

### JSONB — apostrofes no GPT output
Fix: dollar-quoting: `$j$...conteúdo...$j$::jsonb`

---

## TODOS OS WORKFLOWS (produção)

### Core ATS
| ID | WF | Endpoint |
|----|-----|---------|
| FwiPkcJ72u636AUR | WF01 Triagem GPT-4o | POST /ats-candidatura |
| TMyDbBT737qoGGwZ | WF08 Criar Vaga Admin | POST /ats-admin-criar-vaga |
| PjDkMlETX6LQYdap | WF09 Admin Candidatos | GET /ats-admin-candidatos |
| 3L1ZEDy8ykWQsUsJ | WF16 Atualizar Etapa | POST /ats-atualizar-etapa |
| i5a62fuQW0L8YvPn | WF17 Liberar Admissão DP | POST /ats-liberar-admissao |
| FLAFG0Idf8H4c5Zr | WF20 DP Ações | POST /ats-dp-acao |
| rYZyV4OsUXOrkjCq | WF07 Vagas Públicas | GET /ats-vagas-publicas |
| mX0YyPVUnCaDA5VK | WF10 Admin Vagas | GET /ats-admin-vagas |
| pprnXhFZ6cNGrYl9 | WF32 Gerenciar Testes | POST /ats-testes |
| cZpMB5sZPnrEfroI | WF33 Submeter Teste | POST /ats-submeter-teste |
| 2QZeYT1FUi0hBJvt | WF34 Enviar Teste WA | POST /ats-enviar-teste |
| ONMXpYO54Zs1kEFm | WF36 Listar Testes | GET /ats-testes-lista |
| 4KoXDQZehpiQzSha | WF37 Enviar Avaliação | POST /ats-enviar-avaliacao |
| NFfWwDkgf5ASG9qB | WF38 Perfil Candidato | GET /ats-perfil-candidato |
| HcVYj0wqhtXpIQPc | WF39 Análise Consolidada | POST /ats-analise-consolidada |
| uzOHoXIONswXCuBM | WF44 Get Admissão | GET /ats-get-admissao |
| zpxVGhnrl0b08dTH | WF45 Acompanhar Candidatura | GET /ats-acompanhar-candidatura |
| dTXG9Z6tiUKE7VSx | WF46 Email | (sistema de emails) |
| p0JgHyiYO8S9kzak | WF47 Admin Query Testes | GET /ats-admin-query |
| 5PL1gPhSf11XZj1V | WF Resposta WhatsApp | webhook WA |
| g1ageYwKkJJ04fHc | WF27 Marca | POST /ats-marca |
| TXNvmO9Psj3Mk8pR | WF29 Login Master | POST /ats-login |
| 7McEclEKdvmOSTxi | WF26 Métricas | GET /ats-metricas |

### Multi-tenant
| ID | WF | Endpoint |
|----|-----|---------|
| O3pFrPPE9dh6dI0W | MT01 Login Empresa | POST /ats-login-empresa |
| FIbWhNG3wqu4QVt2 | MT02 Criar Empresa | POST /ats-criar-empresa |
| 2MxxOkMbUclg8r1P | MT03 Vagas da Empresa | GET /ats-empresa-vagas |
| b3FLGbalTFdjA1vC | MT04 Master Empresas | GET /ats-master-empresas |
| fO0lacu5e5tstunK | MT05 Candidatos Empresa | GET /ats-empresa-candidatos |
| fYoas9NbxwgeUjx2 | MT06 Banco de Talentos | GET /ats-banco-talentos |
| I4CorxPi1OUpXq2Z | MT07 Get Perfil Empresa | GET /ats-empresa-perfil |
| GniSfppiB6thaK3B | MT08 Salvar Perfil Empresa | POST /ats-salvar-perfil |
| V78ePdAvfPhVUvSX | MT09 Empresa DP | GET /ats-empresa-dp |
| 7ja4OGFtu63A3JNM | MT10 Empresa Testes | GET /ats-empresa-testes |

---

## BANCO DE DADOS (PostgreSQL — ats_db)

### Tabelas principais
- `vagas` — empresa_id, titulo, departamento, modalidade, status, etc.
- `candidatos` — nome, email, telefone, curriculo_base64
- `candidaturas` — vaga_id, candidato_id, etapa_atual, score_total
- `avaliacoes` — triagem GPT-4o com scores STAR
- `admissoes` — dados pessoais completos do candidato
- `documentos_admissao` — docs necessários por admissão
- `testes_vaga` — testes técnicos por vaga
- `testes_perguntas`, `testes_tentativas`, `testes_respostas`
- `empresa_marca` — logo, cores, nome (master branding)

### Tabelas Multi-tenant (criadas nesta sessão)
- `empresas` — id, nome, slug, email, plano, status, cor_primaria, sobre, missao, visao, valores, historia, cultura, beneficios_padrao, diferenciais, segmento, porte, ano_fundacao, num_funcionarios, linkedin_url, instagram_url, tom_voz, etc.
- `usuarios_empresa` — id, empresa_id, nome, email, senha_hash, role
- `sessoes_empresa` — tokens de autenticação das empresas
- `campanhas_captacao` — campanhas de captação ativa
- `banco_talentos` — pool global de candidatos
- `embaixadores` — sistema de indicação

### Empresas cadastradas
| ID | Nome | Plano | Admin |
|----|------|-------|-------|
| 1 | TechRecruit | master | danilo_santiago96@hotmail.com |
| 2 | Tibério Construtora | trial | admin@tiberio.com.br |

### Etapas do pipeline
`triagem → entrevista_rh → entrevista_tecnica → aprovado / reprovado / arquivado / admissao / admitido`

---

## STATUS DAS FUNCIONALIDADES

### ✅ Funcionando completamente
- Ciclo completo: candidatura → triagem IA → admin → agendamento → DP → admissão
- Portal público de vagas (com filtro por empresa: `vagas?empresa=2`)
- Login master e empresa separados
- Painel admin completo (vagas, candidatos, testes, DP, métricas, empresas)
- Painel empresa (vagas, candidatos, banco de talentos, perfil)
- Criação de vagas com modal profissional (3 abas)
- Perfil da Empresa completo (4 abas: Identidade, Sobre, Cultura, Visual & IA)
- Seção Empresas no admin master com "Entrar como empresa"
- Emails automáticos (6 tipos)
- WhatsApp automático (triagem, agendamento, reprovação)
- Admissão: formulário, pré-preenchimento, upload documentos
- Testes técnicos e avaliações comportamentais

### ❌ PENDENTE — Próxima sessão (bugs para corrigir)
1. **empresa.html — funções duplicadas** (fecharModalNovaVaga e salvarNovaVaga aparecem 2x)
2. **empresa.html — DP e Testes não carregam** (carregarSecao sem handler, funções ausentes)
3. **MT09 e MT10 — credencial** (precisam de fix manual no n8n UI)
4. **convidarTalento()** — toast falso, precisa enviar WhatsApp real

### 🚀 PRÓXIMA GRANDE FEATURE — WhatsApp Bot de Captação
Chip novo comprado. Implementar:
1. Número dedicado por empresa no WhatsApp
2. Bot Evolution API + n8n: candidato manda "Oi", bot coleta dados automaticamente
3. GPT-4o faz triagem das respostas
4. Candidato vai pro banco_talentos e pipeline do ATS
5. Landing Page "Trabalhe Conosco" por empresa
6. Sistema de Embaixadores (link de indicação por candidato)
7. Dashboard de Campanhas com métricas

### Bugs conhecidos (menor prioridade)
- CONTEXT.md do repositório desatualizado (substituir por este)
- convidarTodos() — disparo em massa ainda não implementado
- novaCampanha() — modal não implementado

---

## ARQUITETURA MULTI-TENANT

### Conceito
- **Candidatos** = globais (pertencem à plataforma, não à empresa)
- **Vagas, candidaturas, admissões** = isolados por empresa_id
- **Banco de talentos** = global (qualquer empresa pode ver candidatos que não aplicaram a ela)
- **Perfil da empresa** = configuração privada que alimenta a IA

### Auth da empresa
- SHA256 hash de senha
- Token em `sessoes_empresa` (expira 7 dias)
- localStorage: `tr_token`, `tr_empresa_id`, `tr_empresa_nome`, `tr_usuario_nome`, `tr_usuario_role`

### "Entrar como empresa" (master admin)
- Danilo clica "🔑 Entrar" na seção Empresas do admin
- localStorage recebe `tr_token: 'master-' + empresaId`
- `empresa.html` abre em nova aba com os dados da empresa

---

## STACK TÉCNICA

- **Frontend:** HTML/CSS/JS vanilla (sem framework)
- **Backend:** n8n (workflows como API REST)
- **Banco:** PostgreSQL (ats_db)
- **IA:** GPT-4o via OpenAI
- **WhatsApp:** Evolution API (instância: ats-recrutamento)
- **Calendar:** Google Calendar API
- **Email:** Gmail SMTP
- **Deploy:** EasyPanel + Docker + nginx
- **VPS:** Hostinger
- **Repo:** github.com/DaniloMartins96/ats-recrutamento
- **Local:** C:\Users\danil\projetos\ats-recrutamento
