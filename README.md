# VISION LEADS — estrutura inicial

Este pacote contém um protótipo navegável da plataforma web responsiva da Vision Telecom.

## O que já funciona neste protótipo
- Painel com indicadores
- Cadastro de leads e vendedores
- Atribuição manual de lead
- Alteração de status
- Relatório básico por vendedor
- Layout adaptável para computador e celular
- Manifesto PWA e service worker inicial

## Importante
Esta primeira versão é uma demonstração local. Os dados ficam no armazenamento do navegador (`localStorage`), não há login real, sincronização entre aparelhos nem banco de dados conectado. Não utilize dados pessoais reais de clientes nesta demonstração.

## Próxima etapa: publicar e conectar
1. Criar um repositório privado no GitHub.
2. Publicar o frontend na Vercel.
3. Criar projeto Supabase e executar `supabase_schema.sql` após revisão.
4. Implementar autenticação real, convites de vendedores e permissões RLS completas.
5. Conectar o frontend ao Supabase usando somente chave pública/anon no navegador; nunca expor service-role key.
6. Adicionar integrações oficiais de captação (Meta Lead Ads, formulários e WhatsApp Business), com autorização, consentimento e controles de privacidade.

## Publicação
O conteúdo deste diretório pode ser enviado para um repositório GitHub e importado na Vercel. Para a primeira publicação, selecione a pasta raiz e não é necessário comando de build.
