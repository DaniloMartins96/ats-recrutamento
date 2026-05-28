# CONTEXT.md — ATS TechRecruit AI
> Atualizado: 2026-05-28

## COMO INICIAR UMA NOVA CONVERSA
Cole exatamente isso no início do chat:
---
Continuando projeto ATS TechRecruit. Leia o CONTEXT.md
---

## SISTEMA
**ATS TechRecruit AI** — funcionando em produção em `ats.danns.com.br`

### Páginas do sistema
- `ats.danns.com.br` → index.html (página inicial)
- `ats.danns.com.br/login` → login.html
- `ats.danns.com.br/vagas` → vagas.html (portal público de vagas)
- `ats.danns.com.br/candidatura` → candidatura.html (formulário)
- `ats.danns.com.br/admin` → admin.html (painel admin)
- `ats.danns.com.br/admissao` → admissao.html (módulo DP candidato)
- `ats.danns.com.br/teste` → teste.html (testes técnicos)
- `ats.danns.com.br/avaliacao` → avaliacao.html (avaliações comportamentais)

## FORMA DE TRABALHO
- Código editado com **Claude Code no VS Code**
- `git push` → **EasyPanel** faz redeploy automático
- Repositório: DaniloMartins96/ats-recrutamento
- n8n alterado via **MCP pelo Claude.ai**
- URLs sem .html (nginx try_files configurado)

## CREDENCIAIS
- **Login admin:** danilo_santiago96@hotmail.com / admin123
- **n8n Postgres:** ID `GGiSHBVIkgMdXboT` (PostgreSQL — ATS)
- **n8n OpenAI:** ID `tQFBNLElNNuvshjI` (OpenAI — ATS)
- **Evolution API:** https://evolution.danns.com.br, instância: ats-recrutamento, apikey: 429683C4C977415CAAFCCE10F7D57E11
- **n8n URL:** https://n8n.danns.com.br
- **Webhook base:** https://webhook.danns.com.br/webhook

## WORKFLOWS N8N (todos publicados)

| ID | Nome | Endpoint |
|----|------|----------|
| FwiPkcJ72u636AUR | WF01 Triagem GPT-4o | POST /ats-candidatura |
| PjDkMlETX6LQYdap | WF09 Admin Candidatos | GET /ats-admin-candidatos |
| 3L1ZEDy8ykWQsUsJ | WF16 Atualizar Etapa | POST /ats-atualizar-etapa |
| 5PL1gPhSf11XZj1V | WF Resposta WhatsApp | — |
| xsOJX5x5pJRvqHQD | WF22 Upload Contrato Modelo | POST /ats-upload-contrato-modelo |
| UqWvNt67qEktYLlP | WF23 Get Info Contrato | GET /ats-get-contrato-modelo |
| YRVXi3WTXCjVPCr3 | WF24 Get Contrato Completo | GET /ats-get-contrato-modelo-completo |
| ZD2PhutUiq2Ex9To | WF25 Assistente Planilha IA | POST /ats-assistente-planilha |
| 7McEclEKdvmOSTxi | WF26 Métricas | GET /ats-metricas |
| g1ageYwKkJJ04fHc | WF27 Marca | POST /ats-marca |
| lSgBYICBx3xhh7nQ | WF28 Migração Multi-tenant | manual |
| TXNvmO9Psj3Mk8pR | WF29 Login | POST /ats-login |
| rYZyV4OsUXOrkjCq | WF30 Vagas Públicas | GET /ats-vagas-publicas |
| 2lkOZciN29WyxNhU | WF31 WhatsApp Reprovado | POST /ats-whatsapp-reprovado |
| pprnXhFZ6cNGrYl9 | WF32 Gerenciar Testes | POST /ats-testes |
| cZpMB5sZPnrEfroI | WF33 Submeter Teste | POST /ats-submeter-teste |
| 2QZeYT1FUi0hBJvt | WF34 Enviar Teste WhatsApp | POST /ats-enviar-teste |
| ZreB2Xx02Unf7fl2 | WF35 Get Teste por Token | GET /ats-get-teste |
| ONMXpYO54Zs1kEFm | WF36 Listar Testes | GET /ats-testes-lista |
| 4KoXDQZehpiQzSha | WF37 Enviar Avaliação | POST /ats-enviar-avaliacao |
| NFfWwDkgf5ASG9qB | WF38 Perfil Candidato | GET /ats-perfil-candidato |
| HcVYj0wqhtXpIQPc | WF39 Análise Consolidada | POST /ats-analise-consolidada |
| hKkEVrgsK9yBfBn5 | WF40 Docs Admissão | POST /ats-docs-admissao |
| UBSXAGVGEAFWF2GH | WF41 Upload Documento | POST /ats-upload-documento |
| BWdCUkcg0sGZzZdM | WF42 Get Docs Admissão | GET /ats-get-docs-admissao |
| 6vSHD78JOHiFy6Y5 | WF43 Get Arquivo | GET /ats-get-arquivo |
| 0NG6GyOKwWiiMlFR | WF21 Gerar Contrato DP | POST /ats-dp-gerar-contrato |

## BANCO DE DADOS (PostgreSQL — ats_db)

### Tabelas principais
- `empresas` — multi-tenant, empresa_id em todas as tabelas
- `vagas` — vagas com todos os campos (titulo, departamento, modalidade, salario_min/max, etc)
- `candidatos` — dados + curriculo_base64
- `candidaturas` — vínculo candidato↔vaga, etapa_atual, empresa_id
- `avaliacoes` — triagem GPT-4o com scores por dimensão, análise STAR
- `admissoes` — dados pessoais completos do candidato
- `entrevistas` — agendamentos
- `testes_vaga` — testes técnicos por vaga
- `testes_perguntas` — perguntas dos testes
- `testes_tentativas` — tentativas dos candidatos com scores
- `testes_respostas` — respostas individuais
- `avaliacoes_comportamentais` — resultados DISC, Big Five, etc
- `analises_consolidadas` — análise GPT cruzando tudo
- `testes_sugeridos_cargo` — sugestões por departamento
- `contratos_modelo` — template .docx da empresa
- `empresa_marca` — logo, cores, nome
- `empresa_sessoes` — tokens de autenticação
- `documentos_catalogo` — 17 tipos de documentos disponíveis
- `documentos_requeridos` — documentos configurados por admissão
- `documentos_enviados` — arquivos enviados pelos candidatos

### Etapas (candidatura.etapa_atual)
triagem → entrevista_rh → entrevista_tecnica → aprovado / reprovado / arquivado / admissao

### empresa_id padrão
ID: 1 (TechRecruit AI)

## FUNCIONALIDADES IMPLEMENTADAS

### Ciclo principal ✅
1. Candidato preenche candidatura.html
2. WF01 triagem GPT-4o com score, análise STAR, pontos fortes/fracos
3. Admin vê painel com ranking por score
4. Admin envia avaliações comportamentais (DISC, Big Five, Raciocínio, Liderança, Vendas, Criatividade)
5. Admin envia testes técnicos (gerados manualmente ou por IA)
6. Admin acessa Perfil & Avaliações: 3 abas (Perfil Completo, Entrevista, Dados Brutos)
7. Admin gera Análise Consolidada (GPT cruza tudo + perguntas STAR personalizadas)
8. Admin agenda entrevista → Google Calendar + WhatsApp
9. Admin reprova → WhatsApp personalizado gerado por GPT
10. Admin aprova → módulo DP
11. DP configura documentos necessários → candidato faz upload pelo sistema
12. Admin valida cada documento

### Módulo Admin ✅
- Login com sessão persistente
- 5 seções: Vagas, Candidatos, Testes, Métricas, Depto. Pessoal
- Configurações com abas: Empresa/Marca, Contrato, IA & Triagem, Integrações, Segurança, Planilhas
- Painel de Métricas completo com funil atual + histórico, KPIs, gráficos

### Avaliações Comportamentais ✅
6 tipos: DISC, Big Five, Raciocínio Lógico, Liderança, Perfil Comercial, Criatividade
Resultados vinculados ao perfil do candidato

### Documentos DP ✅ (parcial)
- Admin configura quais documentos são necessários
- Catálogo com 17 tipos agrupados por categoria
- Upload pelo sistema (não pelo WhatsApp)
- Admin valida cada documento

## PENDENTES / PRÓXIMAS MELHORIAS

### Bugs conhecidos
1. Catálogo de documentos no DP mostrando vazio (corrigindo)
2. Modal de editar vaga com campos vazios (responsabilidades, requisitos, salário)
3. Botão Sair não funciona em alguns casos
4. Salário nas vagas.html mostrando R$0-R$0

### Funcionalidades planejadas
1. **Upload documentos DP completo** — finalizar integração admissao.html com novo sistema
2. **Email para candidatos** — integração SendGrid
3. **Painel master** — gerenciar múltiplas empresas + cadastro de novas
4. **Tela de cadastro** — novas empresas se cadastrarem
5. **Divulgação automática de vagas** — WhatsApp ao banco de talentos ao publicar
6. **Integração LinkedIn** — capturar candidatos (complexo, deixar por último)
7. **Módulo psicológico** — quando Danilo tiver CRP em avaliação psicológica
8. **Contrato modelo** — melhorar preenchimento com template real
9. **Planilhas** — edição mais inteligente preservando formatação
10. **Análise consolidada automática** — gerar automaticamente após candidato submeter teste

## ARQUITETURA MULTI-TENANT
- Banco compartilhado com empresa_id em todas as tabelas
- Empresa padrão ID: 1
- Sessões com expiração de 8h
- Pronto para adicionar novas empresas

## STACK TÉCNICA
- Frontend: HTML/CSS/JS vanilla (sem framework)
- Backend: n8n (workflows como API)
- Banco: PostgreSQL
- IA: GPT-4o (OpenAI)
- WhatsApp: Evolution API
- Calendar: Google Calendar API
- Deploy: EasyPanel + Docker + nginx
- VPS: Hostinger

## ATUALIZAR ESTE ARQUIVO
Ao final de cada sessão, atualizar com o que foi feito e o que ficou pendente.
