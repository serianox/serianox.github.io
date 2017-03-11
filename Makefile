md = $(shell find . -type f -name '*.md')
html = $(patsubst %.md, %.html, $(md))

styl = $(shell find . -type f -name '*.styl')
css = $(patsubst %.styl, %.css, $(styl))

default: $(html) $(css)

%.html: %.md Makefile
	pandoc -s $< -f markdown -t html5 -o $@

%.css: %.styl Makefile
	stylus <$< >$@
