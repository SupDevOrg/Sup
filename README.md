# Проект Sup - Микросервисная архитектура

Микросервисная система на основе Spring Boot с API Gateway для управления пользователями и событиями.

## 📋 Структура проекта

Проект состоит из основного репозитория и нескольких Git Submodules:

- **api_gateway** - API Gateway на Spring Cloud Gateway
- **user_service** - Сервис управления пользователями с JWT аутентификацией
- **message_service** - Сервис сообщений (заглушка)
- **notification_service** - Сервис уведомлений (заглушка)

## 🚀 Быстрый старт

### Вариант 1: Сборка с использованием скрипта (рекомендуется)

```bash
# Windows (PowerShell/CMD)
.\BUILD_WITHOUT_SBOM.bat

# Linux/Mac
chmod +x BUILD_WITHOUT_SBOM.sh
./BUILD_WITHOUT_SBOM.sh
```

### Вариант 2: Ручная сборка без SBOM

```bash
# Windows PowerShell
$env:DOCKER_BUILDKIT="0"
docker-compose build
docker-compose up -d

# Linux/Mac
DOCKER_BUILDKIT=0 docker-compose build
docker-compose up -d
```

### Вариант 3: Стандартная сборка (может зависать на Windows)

```bash
docker-compose up --build -d
```

## 📦 Работа с Git Submodules

### Получение проекта впервые

Если вы клонируете продуктовый репозиторий впервые:

```bash
# Клонируем основной репозиторий
git clone <repository-url>
cd Sup

# Инициализируем и скачиваем все submodules
git submodule update --init --recursive
```

Или одним командом:

```bash
git clone --recurse-submodules <repository-url>
cd Sup
```

### Обновление Submodules

Обновить все submodules до последних коммитов:

```bash
# Обновить все submodules до последних коммитов на их master ветках
git submodule update --remote

# Или обновить конкретный submodule
git submodule update --remote api_gateway
git submodule update --remote user_service
```

### Работа с изменениями в Submodules

#### 1. Внесение изменений в submodule

```bash
# Переходим в директорию submodule
cd api_gateway

# Делаем изменения в коде
# ...

# Коммитим и пушим изменения в submodule
git add .
git commit -m "Описание изменений"
git push origin master

# Возвращаемся в основной репозиторий
cd ..

# Обновляем ссылку на submodule в основном репозитории
git add api_gateway
git commit -m "Update api_gateway submodule"
git push
```

#### 2. Просмотр изменений в submodules

```bash
# Проверить статус всех submodules
git submodule status

# Посмотреть незакоммиченные изменения в submodules
git submodule foreach git status
```

#### 3. Получение последних изменений из submodules

```bash
# Получить изменения из submodules (но не обновлять ссылки)
git submodule update --remote --merge

# При конфликтах в submodules
cd api_gateway
git status
git merge origin/master
# Разрешить конфликты
cd ..
git add api_gateway
git commit
```

### Типичные проблемы с Submodules

#### Submodule показывает "modified content"

Это означает, что submodule был изменен, но изменения не закоммичены:

```bash
# Проверить что изменено
cd api_gateway
git status

# Если хотите оставить изменения - закоммитьте
git add .
git commit -m "Ваши изменения"
git push

# Если хотите отменить - сбросить
git reset --hard HEAD
git clean -fd
```

#### Удалить submodule из проекта

```bash
# 1. Удалить из .gitmodules
# 2. Удалить из .git/config
git config -f .git/config --remove-section submodule.api_gateway 2>/dev/null

# 3. Удалить из индекса
git rm --cached api_gateway

# 4. Удалить каталог
rm -rf api_gateway

# 5. Удалить из .git/modules
rm -rf .git/modules/api_gateway

# 6. Закоммитить изменения
git commit -m "Remove api_gateway submodule"
```

## 🐳 Docker команды

### Сборка образов

```bash
# Собрать все сервисы
docker-compose build

# Собрать конкретный сервис
docker-compose build user-service
docker-compose build api-gateway

# Сборка без кеша
docker-compose build --no-cache

# Сборка только измененных сервисов
docker-compose build --only user-service
```

### Запуск и остановка

```bash
# Запустить все сервисы
docker-compose up -d

# Запустить конкретные сервисы
docker-compose up -d user-service api-gateway

# Остановить все
docker-compose down

# Остановить и удалить volumes
docker-compose down -v

# Перезапустить
docker-compose restart

# Перезапустить конкретный сервис
docker-compose restart user-service
```

### Логи и мониторинг

```bash
# Просмотр логов
docker-compose logs -f

# Логи конкретного сервиса
docker-compose logs -f user-service

# Последние 100 строк логов
docker-compose logs --tail=100 api-gateway

# Проверить статус
docker-compose ps

# Использование ресурсов
docker stats
```

## 🔧 Конфигурация

### Переменные окружения

Основные переменные установлены в `docker-compose.yml`:

- `JWT_SECRET` - Секретный ключ для JWT токенов (общий для всех сервисов)
- `SPRING_PROFILES_ACTIVE` - Активный профиль Spring (docker для контейнеров)

### Порты

- **API Gateway**: `8080` (внешний доступ)
- **User Service**: `8081` (внешний), `8080` (внутри контейнера)
- **PostgreSQL**: `5432`
- **Kafka**: `9092`
- **Kafka UI**: `8082`
- **Zookeeper**: `2181`

## 📡 API эндпоинты

### Через API Gateway (порт 8080)

```bash
# Публичные эндпоинты (без авторизации)
POST http://localhost:8080/api/auth/register
POST http://localhost:8080/api/auth/login

# Эндпоинты с авторизацией (требуют JWT)
POST http://localhost:8080/api/auth/refresh
GET  http://localhost:8080/api/v1/user/{username}
```

### Напрямую к User Service (порт 8081)

```bash
POST http://localhost:8081/api/v1/user/register
POST http://localhost:8081/api/v1/user/login
POST http://localhost:8081/api/v1/user/refresh
GET  http://localhost:8081/api/v1/user/{username}
```

### Примеры использования

```bash
# Регистрация пользователя
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"username": "testuser", "password": "password123"}'

# Логин
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username": "testuser", "password": "password123"}'

# Поиск пользователей (с JWT токеном)
curl -X GET "http://localhost:8080/api/v1/user/test" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

## 🛠️ Разработка

### Локальная разработка без Docker

```bash
# Запустить PostgreSQL, Kafka, Zookeeper
docker-compose up -d postgres kafka zookeeper

# Запустить User Service локально (порт 8081)
cd user_service
./gradlew bootRun

# В другом терминале - запустить API Gateway (порт 8080)
cd api_gateway
mvn spring-boot:run
```

### Профили Spring

- **default** - для локальной разработки (`application.yaml`)
- **docker** - для работы в контейнерах (`application-docker.yaml`)

## 🐛 Устранение проблем

### Проблема: Зависание на этапе "resolving provenance"

**Симптомы**: Сборка зависает на этапе "resolving provenance for metadata file" более 20 минут.

**Решение**: Используйте сборку без BuildKit:

```bash
# Windows PowerShell
$env:DOCKER_BUILDKIT="0"
docker-compose build

# Или используйте скрипт
.\BUILD_WITHOUT_SBOM.bat
```

### Проблема: Port is already allocated

**Решение**: Остановите контейнер, использующий порт:

```bash
# Найти процесс
netstat -ano | findstr :8080

# Остановить контейнер
docker stop api-gateway
docker-compose down
```

### Проблема: JWT validation fails

**Решение**: Убедитесь, что `JWT_SECRET` одинаковый в user-service и api-gateway:

```bash
# Проверить в docker-compose.yml
# В обоих сервисах должно быть:
# JWT_SECRET=D4fN8Qr6Zu1WgX9Cv3PyL5Mk2Jh7Vt0s
```

### Проблема: Cannot connect to user-service

**Решение**: Проверьте healthcheck и зависимости:

```bash
# Проверить логи
docker-compose logs user-service

# Проверить статус БД
docker-compose logs postgres

# Перезапустить сервис
docker-compose restart user-service
```

## 📚 Дополнительные ресурсы

### Swagger UI

После запуска сервисов Swagger UI доступен по адресам:

- User Service: http://localhost:8081/swagger-ui.html
- API Gateway: http://localhost:8080/actuator (health check)

### Kafka UI

Мониторинг Kafka доступен по адресу: http://localhost:8082
