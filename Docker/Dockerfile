From nginx 

RUN rm-rf /usr/share/nginx/html/*

COPY mfe-adapter /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]


FROM 3vilgenius/nginx-proxy

RUN rm -rf /usr/share/nginx/html/*

COPY mfe-adapters /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]