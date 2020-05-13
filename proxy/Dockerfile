FROM nginx

RUN mkdir /etc/nginx/ssl

# In swarm, actual certificates can be replaced with loaded secrets: https://docs.docker.com/engine/swarm/secrets/#use-secrets-in-compose

# Private certificates. Replace with hostname.
COPY ./certs/carter.crt /etc/nginx/ssl/carter.crt
COPY ./certs/carter.key /etc/nginx/ssl/carter.key

# dh_params
COPY ./certs/ffdhe4096.pem /etc/ssl/ffdhe4096.pem

COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./locations/*[^*\.d] /etc/nginx/locations/

COPY ./bin/wait-for-it.sh wait-for-it.sh

CMD ["nginx", "-g", "daemon off;"]
