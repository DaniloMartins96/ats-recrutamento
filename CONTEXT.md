# CONTEXT.md — ATS TechRecruit AI
> Atualizado: 2026-05-25

## COMO INICIAR UMA NOVA CONVERSA

Cole exatamente isso no início do chat:

---
Continuando projeto ATS TechRecruit. Leia o CONTEXT.md
---

## SISTEMA

**ATS TechRecruit AI** — funcionando em produção em `ats.danns.com.br`

### Ciclo completo funcionando
1. Candidato preenche formulário em `candidatura.html`
2. **WF01 Triagem** (GPT-4o) analisa e pontua o currículo automaticamente
3. Resultado aparece no painel admin (`admin.html`)
4. Admin agenda entrevista → cria evento no **Google Calendar** automaticamente + envia WhatsApp ao candidato
5. Admin reprova ou aprova o candidato
6. Aprovado → módulo DP (`admissao.html`) para coleta de documentos
7. DP libera admissão → admissão registrada no banco

### Módulo DP (admissao.html)
- Candidato enviado pelo admin após aprovação
- Formulário de dados pessoais completo
- Upload de documentos (CPF, RG, CNH, etc.)
- Admin valida cada documento individualmente
- Observações por documento
- Liberação de admissão registra no banco

---

## FORMA DE TRABALHO

### Código (admin.html, admissao.html, candidatura.html)
- Editado com **Claude Code no VS Code**
- `git push` → **EasyPanel** faz redeploy automático
- Repositório GitHub conectado ao EasyPanel

### n8n (workflows)
- Alterado via **MCP pelo Claude.ai** (não Claude Code)
- Ferramenta: `mcp__claude_ai_n8n__*`
- Sempre publicar após atualizar (`publish_workflow`)

---

## CREDENCIAIS N8N

| Nome | ID |
|------|----|
| PostgreSQL — ATS | `GGiSHBVIkgMdXboT` |
| OpenAI — ATS | (verificar no n8n) |
| Google Calendar ATS | (verificar no n8n) |

---

## WORKFLOWS (IDs n8n)

| WF | Nome | ID |
|----|------|----|
| WF01 | Triagem GPT-4o | `FwiPkcJ72u636AUR` |
| WF09 | Admin Candidatos (lista) | `PjDkMlETX6LQYdap` |
| WF16 | Atualizar Etapa | `3L1ZEDy8ykWQsUsJ` |
| WF Resposta WA | Resposta WhatsApp | `5PL1gPhSf11XZj1V` |

### Endpoints principais (base: `https://webhook.danns.com.br/webhook`)
- `POST /ats-candidatura` — WF01, recebe candidatura + currículo base64
- `GET /ats-admin-candidatos` — WF09, lista todos os candidatos com dados completos
- `POST /ats-atualizar-etapa` — WF16, avança/reprova candidato, agenda entrevista
- `POST /ats-formulario-admissao` — WF18, salva dados de admissão

---

## ESTRUTURA DO BANCO (PostgreSQL)

Tabelas principais:
- `vagas` — vagas abertas
- `candidatos` — dados do candidato + `curriculo_base64`, `curriculo_nome`
- `candidaturas` — vínculo candidato↔vaga, campo `etapa_atual`
- `entrevistas` — agendamentos de entrevistas
- `documentos_admissao` — documentos enviados pelo DP

Identificador único de linha: **`candidatura_id`** (não `candidato_id`)

Etapas (`etapa_atual`): `triagem` → `entrevista_rh` → `entrevista_tecnica` → `aprovado` / `reprovado` / `arquivado`

---

## REGRAS TÉCNICAS IMPORTANTES

1. **n8n via MCP** — nunca editar workflows manualmente no n8n UI; usar MCP
2. **Publicar sempre** após update de workflow
3. **Credencial Postgres**: ID `GGiSHBVIkgMdXboT`
4. **Base64 longo**: usar dollar-quoting `$cv$...$cv$` no SQL do n8n para evitar escape de aspas
5. **Sem re-fetch após ação**: atualizar estado local para evitar bug de deduplicação da API
6. **candidatura_id** é o identificador correto — não usar candidato_id como chave
7. Agendar entrevista: etapa máxima é `entrevista_tecnica` (não avança para `aprovado` ao agendar)
8. Botão "Agendar" some apenas quando etapa é `aprovado`, `reprovado` ou `arquivado`

---

## STATUS ATUAL (2026-05-25)

### Concluído nesta sessão
- `downloadCurriculo` no admin.html — baixa PDF do candidato via base64
- WF09 retorna `curriculo_base64` e `curriculo_nome` no SELECT
- Modal de Agendamento de Entrevista completo (data, hora, tipo, link/endereço)
- Botão "Avançar" removido — substituído por "Agendar"
- Botão "Rejeitar" corrigido para POST (antes era só local)
- Bug corrigido: botão Agendar sumia em entrevista_rh/tecnica
- Bug corrigido: coluna ETAPA mostrava 'aprovado' incorretamente
- Bug corrigido: documentos DP apareciam duplicados (dedup por `d.id`, campo `d.observacao`)
- WF01 publicado com campos de currículo no SQL

### Pendente / Próximas melhorias
1. Upload de modelo de contrato da empresa (PDF padrão da empresa)
2. Integração com Excel/Google Sheets para relatórios
3. Multi-tenant (múltiplas empresas no mesmo ATS)
4. Investigar causa raiz de linhas duplicadas em `documentos_admissao` (WF17?)
5. Verificar se credencial PostgreSQL está vinculada corretamente no WF09 após update via SDK

---

## ATUALIZAR ESTE ARQUIVO

Ao final de cada sessão, atualizar a seção "Status Atual" com o que foi feito e o que ficou pendente.
