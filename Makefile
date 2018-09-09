md = $(shell find . -type f -name '*.md')
html = $(patsubst %.md, %.html, $(md))

styl = $(shell find . -type f -name '*.styl')

all: $(html) ## Build all the files

%.html: %.max.html html-minifier.conf
	html-minifier $< --config-file html-minifier.conf --output=$@

%.max.html: %.frag.html %.css template.slim
	slimrb $(word 3, $^) /dev/stdout <$< $(word 2, $^) >$@

%.css: %.plain.html style.css
	purifycss $(word 2, $^) $< --min --out=$@

%.plain.html: %.frag.html /dev/null template.slim
	slimrb $(word 3, $^) /dev/stdout <$< $(word 2, $^) >$@

%.frag.html: %.md
	pandoc $< -f markdown -t html5 -o $@

index.md: $(filter-out ./index.md, $(md))
	./tocify.sh $@

style.css: $(styl)
	cat $^ |\
	stylus -c |\
	cleancss -O2 >$@

.PRECIOUS: %.max.html %.plain.html %.frag.html %.css
.DEFAULT_GOAL := all

.PHONY: help
help: ## Show the list of targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
