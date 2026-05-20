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

## STATUS ATUAL (atualizado 2026-05-19)

### Concluído
- Ciclo principal do ATS funcionando (triagem → entrevistas → aprovação → admissão)
- Correção do vaga_id em candidatura.html
- Admin: abas de status (Em processo / Reprovados / Arquivados) + botão Arquivar/Restaurar implementados
- Deploy pendente: aguardando `git push` para confirmar subida do admin.html

### Próximos passos
1. Confirmar deploy do admin.html (git push + verificar produção)
2. Adicionar mensagem WhatsApp de confirmação no WF01
3. Corrigir WF16 — retornando 404

## REGRAS PARA O CLAUDE
1. Sempre usar MCP n8n para workflows
2. Sempre usar Claude Code para arquivos no servidor
3. Credencial Postgres n8n: ID GGiSHBVIkgMdXboT
4. Sempre publicar workflows após atualizar
5. Atualizar este arquivo e o endpoint ao fim de cada sessão
