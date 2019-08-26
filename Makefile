md = $(shell find * -path 'node_modules' -prune -o -type f -name '*.md' -print)
html = $(patsubst %.md, %.html, $(md))

styl = $(shell find . -type f -name '*.styl')

all: $(html) style.css ## Build all the files

%.html: %.frag.html template.slim html-minifier.conf
	slimrb $(word 2, $^) /dev/stdout $< %.html |\
	`npm bin`/html-minifier --config-file html-minifier.conf --output=$@

%.frag.html: %.md
	pandoc $< -f markdown -t html5 -o $@

index.md: $(filter-out ./index.md, $(md))
	./tocify.sh $@

style.css: $(styl)
	cat $^ |\
	`npm bin`/stylus -c |\
	`npm bin`/cleancss -O2 >$@

.DEFAULT_GOAL := all

.PHONY: help
help: ## Show the list of targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
