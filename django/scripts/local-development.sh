#!/usr/bin/env bash
# بيئة تطوير محلية فقط. لا يستخدم أي بيانات أو أسرار من الإنتاج.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DJANGO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
QURAN_DIR="$DJANGO_DIR/QuranAPI"
OTLOHA_DIR="$DJANGO_DIR/OtlohaSah"
OTLOHA_APP_DIR="$OTLOHA_DIR/app"
PYTHON_VERSION="${PYTHON_VERSION:-3.12}"

usage() {
  cat <<'EOF'
الاستخدام:
  ./django/scripts/local-development.sh setup
  ./django/scripts/local-development.sh check
  ./django/scripts/local-development.sh run-quran [host] [port]
  ./django/scripts/local-development.sh run-otloha [host] [port]

الأوامر:
  setup       ينشئ بيئتي Python محليتين، وينسخ قوالب .env المحلية إن غابت،
              ويثبت الاعتمادات ويطبق migrations على قواعد SQLite مستقلة.
  check       يشغّل فحص Django للخدمتين.
  run-quran   يشغّل QuranAPI؛ الافتراضي 127.0.0.1:8001.
  run-otloha  يشغّل OtlohaSah؛ الافتراضي 127.0.0.1:8000.

لا تستخدم هذا السكربت في الإنتاج. لا يستورد بيانات المستخدمين أو أسرارهم.
EOF
}

ensure_environment_file() {
  local environment_dir="$1"
  local template_file="$2"
  if [[ ! -f "$environment_dir/.env" ]]; then
    cp "$template_file" "$environment_dir/.env"
    echo "أنشئ $environment_dir/.env من القالب المحلي. راجع القيم قبل ربط هاتف على الشبكة."
  fi
}

prepare_project() {
  local project_dir="$1"
  local manage_dir="$2"
  local environment_dir="$3"
  local template_file="$4"

  ensure_environment_file "$environment_dir" "$template_file"

  if [[ ! -x "$project_dir/.venv/bin/python" ]]; then
    uv venv "$project_dir/.venv" --python "$PYTHON_VERSION"
  fi

  uv pip sync --python "$project_dir/.venv/bin/python" "$project_dir/requirements.lock"
  (
    cd "$manage_dir"
    set -a
    source "$environment_dir/.env"
    set +a
    "$project_dir/.venv/bin/python" manage.py migrate --noinput
  )
}

run_project() {
  local project_dir="$1"
  local manage_dir="$2"
  local environment_dir="$3"
  local template_file="$4"
  local host="$5"
  local port="$6"

  ensure_environment_file "$environment_dir" "$template_file"

  if [[ ! -x "$project_dir/.venv/bin/python" ]]; then
    echo "شغّل الأمر setup أولاً."
    exit 1
  fi

  (
    cd "$manage_dir"
    set -a
    source "$environment_dir/.env"
    set +a
    exec "$project_dir/.venv/bin/python" manage.py runserver "$host:$port"
  )
}

command="${1:-}"
case "$command" in
  setup)
    prepare_project "$QURAN_DIR" "$QURAN_DIR" "$QURAN_DIR" "$QURAN_DIR/.env.local.example"
    prepare_project "$OTLOHA_DIR" "$OTLOHA_APP_DIR" "$OTLOHA_APP_DIR" "$OTLOHA_DIR/.env.local.example"
    echo "اكتمل تجهيز بيئة التطوير المحلية."
    ;;
  check)
    ensure_environment_file "$QURAN_DIR" "$QURAN_DIR/.env.local.example"
    ensure_environment_file "$OTLOHA_APP_DIR" "$OTLOHA_DIR/.env.local.example"
    (
      cd "$QURAN_DIR"
      set -a
      source "$QURAN_DIR/.env"
      set +a
      "$QURAN_DIR/.venv/bin/python" manage.py check --fail-level ERROR
    )
    (
      cd "$OTLOHA_APP_DIR"
      set -a
      source "$OTLOHA_APP_DIR/.env"
      set +a
      "$OTLOHA_DIR/.venv/bin/python" manage.py check --fail-level ERROR
    )
    ;;
  run-quran)
    run_project "$QURAN_DIR" "$QURAN_DIR" "$QURAN_DIR" "$QURAN_DIR/.env.local.example" "${2:-127.0.0.1}" "${3:-8001}"
    ;;
  run-otloha)
    run_project "$OTLOHA_DIR" "$OTLOHA_APP_DIR" "$OTLOHA_APP_DIR" "$OTLOHA_DIR/.env.local.example" "${2:-127.0.0.1}" "${3:-8000}"
    ;;
  *)
    usage
    exit 1
    ;;
esac
