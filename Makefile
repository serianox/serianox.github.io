md = $(shell find . -type f -name '*.md')
html = $(patsubst %.md, %.html, $(md))

styl = $(shell find . -type f -name '*.styl')

all: $(html) ## Build all the files

%.html: %.frag.html %.css template.slim html-minifier.conf
	slimrb $(word 3, $^) /dev/stdout <$< $(word 2, $^) |\
	html-minifier --config-file html-minifier.conf >$@

%.css: %.plain.html style.css
	purifycss -r $(word 2, $^) $< --min --out=$@

%.plain.html: %.frag.html /dev/null template.slim
	slimrb $(word 3, $^) /dev/stdout <$< $(word 2, $^) >$@

%.frag.html: %.md
	pandoc $< -f markdown -t html5 -o $@

index.md: $(filter-out ./index.md, $(md))
	./tocify.sh $@

style.css: $(styl)
	cat $^ |\
	stylus |\
	cleancss -O2 >$@

.PRECIOUS: %.plain.html %.frag.html %.css
.DEFAULT_GOAL := all

.PHONY: help
help: ## Show the list of targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
