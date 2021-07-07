echo "Generating tree diagrams..."

pyang -f tree --tree-line-length 69 ../ietf-list-pagination@*.yang > tree-ietf-list-pagination.txt
pyang -f tree --tree-line-length 69 example-social@*.yang > tree-example-social.txt
