
MAX=500
arr=$(echo '[]' | jq '.')
RESULT=$(aws resource-explorer-2 search --query-string "*" --max-items $MAX --output json)

while :
do
    NEXT_TOKEN=$(echo $RESULT | jq .NextToken)
    arr2=$(echo $RESULT |  jq -r '[.Resources[].ResourceType] | unique')
    arr=$(echo $arr $arr2 | jq -s -c add)
    if [ "$NEXT_TOKEN" = "null" ]; then
        break
    fi

    RESULT=$(aws resource-explorer-2 search --query-string "*" \
        --max-items $MAX --starting-token $NEXT_TOKEN --output json)
done

echo $arr | jq '. | unique | .[]'
