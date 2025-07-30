# Bash-script tools

Цей інструмент розробляється для `~/.local/share/nautilus/scripts/` на Ubuntu та інших дистрибутивів. Також для створення своїх розширень полегшене створення ui.

```text
Права кнопка миші > scripts > ...
```


### Встановлення

```bash
chmod +x "~/.local/share/nautilus/scripts/Створити Ярлик"``` 
...


## Створити Ярлик
Створює ярилк на робочому столі - потрібно просто виділити картинку і bash-срипт файл. 





## Example use api UI

```bash

#   # Проста форма
show_form "Заголовок" "Текст форми" "Поле 1" "Поле 2"
if [ $? -eq 0 ]; then
    IFS="|" read -r field1 field2 <<< "$FORM_RESULT"
    echo "Поле 1: $field1, Поле 2: $field2"
fi


#   # Entry
show_entry "Введіть ім'я" "Як вас звати?" "Ім'я"
if [ $? -eq 0 ]; then
    echo "Привіт, $ENTRY_RESULT"
fi  

#   # Слайдер
show_slider "Гучність" "Виберіть рівень" 0 100 5 50
if [ $? -eq 0 ]; then
    echo "Вибрано рівень гучності: $SLIDER_RESULT"
fi  

#   # Список
show_list "Список" "Виберіть опцію" "Опція 1" "Опція 2" "Опція 3"
if [ $? -eq 0 ]; then
    echo "Вибрано: $LIST_RESULT"
fi

#   # Календар
show_calendar "Календар" "Виберіть дату"
if [ $? -eq 0 ]; then
    echo "Вибрана дата: $CALENDAR_RESULT"
fi  

#   # Меню
show_menu "Меню" "Оберіть дію" "Почати" "Зупинити" "Статус"
if [ $? -eq 0 ]; then
    echo "Вибрана дія: $MENU_RESULT"
fi  

#   # Чекліст
show_checklist "Чекліст" "Оберіть опції" "Опція A" "Опція B" "Опція C"
if [ $? -eq 0 ]; then
    echo "Вибрані опції: $CHECKLIST_RESULT"
fi
```