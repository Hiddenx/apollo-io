FROM alpine:3.7
RUN apk --no-cache add python3
RUN apk --no-cache add nginx
COPY nginx.conf /etc/nginx/
RUN mkdir -p /run/nginx
COPY . /
RUN pip3 install -r ./requirements.txt
EXPOSE 80
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["sh", "entrypoint.sh"]