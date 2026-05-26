# CONTEXT.md — ATS TechRecruit AI
> Atualizado: 2026-05-26

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
| WF21 | Gerar Contrato via IA | (atualizado para usar template do banco) |
| WF22 | Upload Template Contrato | `xsOJX5x5pJRvqHQD` |
| WF23 | Info Template Contrato | `UqWvNt67qEktYLlP` |
| WF24 | Download Template Completo | `YRVXi3WTXCjVPCr3` |
| WF25 | Assistente Planilhas IA | `ZD2PhutUiq2Ex9To` |
| WF26 | Métricas | `7McEclEKdvmOSTxi` |
| WF Resposta WA | Resposta WhatsApp | `5PL1gPhSf11XZj1V` |

### Endpoints principais (base: `https://webhook.danns.com.br/webhook`)
- `POST /ats-candidatura` — WF01, recebe candidatura + currículo base64
- `GET /ats-admin-candidatos` — WF09, lista todos os candidatos com dados completos
- `POST /ats-atualizar-etapa` — WF16, avança/reprova candidato, agenda entrevista
- `POST /ats-formulario-admissao` — WF18, salva dados de admissão
- `POST /ats-upload-contrato-modelo` — WF22, salva template .docx no banco
- `GET /ats-get-contrato-modelo` — WF23, retorna info do template (sem base64)
- `GET /ats-get-contrato-modelo-completo` — WF24, retorna template com base64
- `POST /ats-assistente-planilha` — WF25, assistente IA para planilhas
- `GET /ats-metricas` — WF26, retorna todas as métricas

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

## STATUS ATUAL (2026-05-26)

### Concluído nesta sessão
- Seção Configurações refatorada com abas internas: Empresa, Contrato, IA & Triagem, Integrações, Segurança, Planilhas
- WF22 `POST /ats-upload-contrato-modelo` (ID: `xsOJX5x5pJRvqHQD`) — salva template .docx no banco
- WF23 `GET /ats-get-contrato-modelo` (ID: `UqWvNt67qEktYLlP`) — retorna info do template
- WF24 `GET /ats-get-contrato-modelo-completo` (ID: `YRVXi3WTXCjVPCr3`) — retorna template com base64
- WF21 atualizado para usar template do banco ao gerar contrato
- Tabela `contratos_modelo` criada no banco
- Fix: nome "undefined" no modal de Admissão corrigido
- WF25 `POST /ats-assistente-planilha` (ID: `ZD2PhutUiq2Ex9To`) — assistente IA para planilhas
- Aba Planilhas nas Configurações com suporte a Excel e Google Sheets (SheetJS)
- WF26 `GET /ats-metricas` (ID: `7McEclEKdvmOSTxi`) — retorna todas as métricas
- Painel de Métricas completo: KPIs, funil atual + histórico com toggle, evolução mensal, ranking por vaga, donuts de status/etapa

### Pendente / Próximas melhorias
1. Contrato modelo: melhorar preenchimento do template real
2. Planilhas: edição mais inteligente preservando formatação do .xlsx original
3. Personalização de marca (logo, cores, nome da empresa)
4. Multi-tenant (múltiplas empresas no mesmo ATS)

---

## ATUALIZAR ESTE ARQUIVO

Ao final de cada sessão, atualizar a seção "Status Atual" com o que foi feito e o que ficou pendente.
