FROM nginx:1.25-alpine
COPY index.html /usr/share/nginx/html/index.html
COPY candidatura.html /usr/share/nginx/html/candidatura.html
EXPOSE 80
