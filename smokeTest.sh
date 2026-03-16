#!/usr/bin/env bash
set -euo pipefail

url=${1:-"http://localhost:3000"}
failures=0

check() {
  local desc=$1 pattern=$2
  shift 2
  if "$@" | grep -qi "$pattern"; then
    echo "PASS: $desc"
  else
    echo "FAIL: $desc"
    failures=$((failures + 1))
  fi
}

check "GET / returns 200" "200" \
  curl -s -o /dev/null -w '%{http_code}' "$url"

check "POST /echo echoes body" "hola mundo" \
  curl -s -d "hola mundo" "$url/echo"

check "GET /echo-headers reflects custom header" "x-language: spanish" \
  curl -s -I -H "x-language: spanish" "$url/echo-headers"

check "GET /idontexist returns 404" "404" \
  curl -s -o /dev/null -w '%{http_code}' "$url/idontexist"

echo ""
[ "$failures" -gt 0 ] && echo "$failures test(s) failed" && exit 1
echo "All tests passed"
