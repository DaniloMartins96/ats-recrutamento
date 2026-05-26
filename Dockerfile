FROM nginx:1.25-alpine
COPY index.html /usr/share/nginx/html/index.html
COPY candidatura.html /usr/share/nginx/html/candidatura.html
COPY admin.html /usr/share/nginx/html/admin.html
COPY admissao.html /usr/share/nginx/html/admissao.html
COPY login.html /usr/share/nginx/html/login.html
COPY vagas.html /usr/share/nginx/html/vagas.html
COPY teste.html /usr/share/nginx/html/teste.html
COPY avaliacao.html /usr/share/nginx/html/avaliacao.html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
