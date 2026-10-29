#!/bin/bash -x

# 1. Удаляем старый контейнер, если он уже существует
docker stop nginx-cont 2>/dev/null
docker rm nginx-cont 2>/dev/null

# 2. Собираем собственный образ из директории ./nginx
docker build -t devops/nginx-server ./nginx

# 3. Создаем и запускаем контейнер в фоновом режиме (-d) с публикацией порта
docker run -d --name nginx-cont -p 54321:80 \
  --restart unless-stopped \
  devops/nginx-server

# 4. Проверяем статус контейнера
docker ps -a

# 5. Даем веб-серверу 5 секунд на инициализацию
sleep 5

# 6. Проверяем ответ сайта локально по порту 54321
curl 127.0.0.1:54321

# 7. Выводим последние 10 строк логов контейнера
docker logs -n 10 nginx-cont
