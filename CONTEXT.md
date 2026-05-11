# 🧠 CONTEXT.md — ATS TechRecruit AI
> Arquivo de contexto persistente. Atualizar ao final de cada sessão.
> Em nova conversa com Claude, comece colando:
> "Leia o CONTEXT.md do projeto e o endpoint de contexto:
>  https://webhook.danns.com.br/webhook/ats-contexto"

## COMO INICIAR UMA NOVA CONVERSA
Cole exatamente isso no início do chat:

---
Continuando projeto ATS TechRecruit AI.
Contexto completo: https://webhook.danns.com.br/webhook/ats-contexto
Fetch essa URL e leia tudo antes de responder.
---

## ATUALIZAR CONTEXTO (fazer ao final de cada sessão)
POST https://webhook.danns.com.br/webhook/ats-atualizar-contexto
Body: { "chave": "proximo_passo", "valor": "...", "categoria": "progresso" }

Chaves importantes para atualizar:
- proximo_passo
- concluido  
- pendente_fase1
- workflows_ativos

## REGRAS PARA O CLAUDE
1. Sempre usar MCP n8n para workflows
2. Sempre usar Claude Code para arquivos no servidor
3. Credencial Postgres n8n: ID GGiSHBVIkgMdXboT
4. Sempre publicar workflows após atualizar
5. Atualizar este arquivo e o endpoint ao fim de cada sessão
