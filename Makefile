md = $(shell find . -type f -name '*.md')
html = $(patsubst %.md, %.html, $(md))

styl = $(shell find . -type f -name '*.styl')

all: $(html) ## Build all the files

%.html: %.html.frag %.css template.slim html-minifier.conf
	slimrb template.slim /dev/stdout <$< $(word 2, $^) |\
	html-minifier --config-file html-minifier.conf >$@

%.css: %.html.plain style.css.frag
	purifycss $(word 2, $^) $< --min --out=$@

%.html.plain: %.html.frag template.slim
	slimrb $(word 2, $^) /dev/stdout <$< /dev/null >$@

%.html.frag: %.md
	pandoc $< -f markdown -t html5 -o $@

index.md: $(filter-out ./index.md, $(md))
	./tocify.sh $@

style.css.frag: $(styl)
	cat $^ |\
	stylus |\
	cleancss -O2 >$@

.PHONY: help
.DEFAULT_GOAL := all

help: ## Show the list of targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
