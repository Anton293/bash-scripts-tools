# ui.sh — Зручне Bash API для Zenity UI
# ----------------------------------------
# Підключи: source ui.sh
# Функції:
#   Прогрес-бар:
#     start_progress <title> <text> [width] [height]
#     update_progress <percent> [text]
#     end_progress
#   Форми й діалоги:
#     show_form <title> <text> <field1> [<field2> ...]
#     show_entry <title> <text>
#     show_slider <title> <text> <min> <max> <step> <initial>
#     show_list <title> <text> <col1> [<col2> ...]
#     show_calendar <title> <text>
#   Меню та кнопки:
#     show_menu <title> <text> <option1> [<option2> ...]
#     show_checklist <title> <text> <item1> [<item2> ...]
# Все результати у змінних: FORM_RESULT, ENTRY_RESULT, SLIDER_RESULT,
# LIST_RESULT, CALENDAR_RESULT, MENU_RESULT, CHECKLIST_RESULT
# ----------------------------------------

# Прогрес-бар --------------------------------
PROG_FIFO="/tmp/zenity_progress_$$.fifo"
PROG_PID=

start_progress() {
  local title="${1:-Будь ласка, зачекайте...}"
  local text="${2:-Обробка...}"
  local width=${3:-400}
  local height=${4:-100}
  [[ -p $PROG_FIFO ]] || mkfifo "$PROG_FIFO"
  zenity --progress \
    --title="$title" \
    --text="$text" \
    --percentage=0 \
    --auto-close \
    --width="$width" \
    --height="$height" \
    < "$PROG_FIFO" &
  PROG_PID=$!
}

update_progress() {
  local pct=$1
  local msg=${2:-}
  [[ -n $msg ]] && printf "# %s\n" "$msg" > "$PROG_FIFO"
  printf "%d\n" "$pct" > "$PROG_FIFO"
}

end_progress() {
  printf "100\n" > "$PROG_FIFO"
  wait "$PROG_PID" 2>/dev/null
  rm -f "$PROG_FIFO"
}

# Форми та діалоги ---------------------------

show_form() {
  local title=$1 text=$2; shift 2
  local args=(--forms --title="$title" --text="$text")
  for field in "$@"; do args+=(--add-entry="$field"); done
  FORM_RESULT=$(zenity "${args[@]}" 2>/dev/null)
  return $?
}

show_entry() {
  ENTRY_RESULT=$(zenity --entry --title="$1" --text="$2" 2>/dev/null)
  return $?
}

show_slider() {
  SLIDER_RESULT=$(zenity --scale --title="$1" --text="$2" \
    --min-value="$3" --max-value="$4" --step="$5" --value="$6" 2>/dev/null)
  return $?
}

show_list() {
  local title=$1 text=$2; shift 2
  local cols=($@)
  local args=(--list --title="$title" --text="$text")
  for col in "${cols[@]}"; do args+=(--column="$col"); done
  LIST_RESULT=$(zenity "${args[@]}" 2>/dev/null)
  return $?
}

show_calendar() {
  CALENDAR_RESULT=$(zenity --calendar --title="$1" --text="$2" 2>/dev/null)
  return $?
}

# Меню та кнопки -----------------------------

show_menu() {
  local title=$1 text=$2; shift 2
  local args=(--list --radiolist --title="$title" --text="$text" --column="Select" --column="Option")
  for opt in "$@"; do args+=(FALSE "$opt"); done
  MENU_RESULT=$(zenity "${args[@]}" 2>/dev/null)
  return $?
}

show_checklist() {
  local title=$1 text=$2; shift 2
  local args=(--list --checklist --title="$title" --text="$text" --column="Select" --column="Option")
  for item in "$@"; do args+=(FALSE "$item"); done
  CHECKLIST_RESULT=$(zenity "${args[@]}" 2>/dev/null)
  return $?
}

# ----------------------------------------------
# Приклад використання:
# source ui.sh
#
#
# if show_menu "Дія" "Оберіть дію" "Start" "Stop" "Status"; then
#   echo "Action: $MENU_RESULT"
# fi
#
# if show_checklist "Опції" "Оберіть" "A" "B" "C"; then
#   echo "Selected: $CHECKLIST_RESULT"
# fi

# ----------------------------------------------

#   # Проста форма
#   if show_form "Налаштування" "Вкажи дані" "Поле1" "Поле2"; then
#     IFS="|" read -r val1 val2 <<< "$FORM_RESULT"
#     echo "Pole1=$val1, Pole2=$val2"
#   fi
#   # Entry
#   if show_entry "Введи ім'я" "Як тебе звати?" "Ім'я"; then
#     echo "Hello, $ENTRY_RESULT"
#   fi
#   # Слайдер
#   if show_slider "Гучність" "Вибери рівень" 0 100 5 50; then
#     echo "Volume=$SLIDER_RESULT"
#   fi
#   # Список
#   if show_list "Вибір" "Оберіть: " "Option1" "Option2"; then
#     echo "Choice=$LIST_RESULT"
#   fi
#   # Календар
#   if show_calendar "Дата" "Оберіть дату"; then
#     echo "Date=$CALENDAR_RESULT"
#   fi

# ----------------------------------------------
