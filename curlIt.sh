url=${1:-"http://localhost:3000"}

set -x

curl "$url"
echo ""
curl -w'\n' -d "hola mundo" "$url/echo"
curl -I -H "x-language: spanish" "$url/echo-headers"

curl -w'\n' "$url/idontexist"

