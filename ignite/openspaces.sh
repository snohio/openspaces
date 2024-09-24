#!/bin/bash

set -eu
set -o pipefail

SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
SCRIPT_DIR=$(dirname ${SCRIPT_PATH})

SLIDES=${1:-20}

cd $SCRIPT_DIR

cat > /tmp/$$ <<EOF
[
    {
      "filename": "openspaces.md",
      "attr":
      {
        "data-autoslide": 5000,
        "data-background": "#fffff",
        "data-background-image": "resources/images/dod-tb-banner.png"
      }
    },
EOF

i=1
for file in $(find resources/images/openspaces -type f)
do
    if [[ ! -e slides/${i}.html ]]; then
	echo "" > slides/${i}.html
    fi
    echo "    {" >> /tmp/$$
    echo "        \"filename\": \"${i}.html\"," >> /tmp/$$
    echo "        \"attr\": {" >> /tmp/$$
    echo "            \"data-background-image\": \"${file}\"," >> /tmp/$$
    echo "            \"data-background-size\": \"contain\"" >> /tmp/$$
    echo "        }" >> /tmp/$$
    echo -n "   }" >> /tmp/$$
    i=$((i + 1))
    if [[ $i -le ${SLIDES} ]]; then
	echo "," >> /tmp/$$
    fi
done
echo "]" >> /tmp/$$

mv /tmp/$$ slides/list.json
