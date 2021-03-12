# Micro Ads

Приложение "микросервис Ads"

# Зависимости

- Ruby `3.0.0`
- Bundler `2.2.3`
- Roda `3.19+`
- Sequel `5+`
- Puma `5.0+`
- PostgreSQL `9.3+`

# Установка и запуск приложения

1. Склонируйте репозиторий:

```
git clone git@github.com:prog-supdex/micro_ads.git && cd micro_ads
```

2. Установите зависимости и создайте базу данных:

```
bundle install
rake db:create
rake:db:migrate
```

3. Запустите приложение:

```
bundle exec puma
```

# TODOLIST
1. Покрыть код тестами(rspec)
2. Перейти на ROM
3. Углубиться в Puma и написать config под него
4. Реализовать своего рода аналог рельсовой ``` params.require(...).permit(...) ``` для параметров, для проверки в роутах
5. Написать Logger
6. Лучше разобраться в Roda
....
Список дополняется
