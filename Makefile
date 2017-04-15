md = $(shell find . -type f -name '*.md')
html.frag = $(patsubst %.md, %.html.frag, $(md))
html = $(patsubst %.md, %.html, $(md))

styl = $(shell find . -type f -name '*.styl')
css.frag = $(patsubst %.styl, %.css.frag, $(styl))

all: $(html) style.css ## Build all the files

%.html: %.html.frag template.slim Makefile
	slimrb template.slim /dev/stdout <$< style.css |\
	html-minifier >$@

%.html.frag: %.md Makefile
	pandoc $< -f markdown -t html5 -o $@

style.css: $(css.frag) Makefile
	cleancss -O2 $(filter %.css.frag, $^) >$@

%.css.frag: %.styl Makefile
	stylus <$< >$@

.PHONY: help
.DEFAULT_GOAL := all

help: ## Show the list of targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
