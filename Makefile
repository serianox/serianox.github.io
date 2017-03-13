md = $(shell find . -type f -name '*.md')
frag = $(patsubst %.md, %.frag, $(md))
html = $(patsubst %.md, %.html, $(md))

styl = $(shell find . -type f -name '*.styl')
css = $(patsubst %.styl, %.css, $(styl))

default: $(html)

%.html: %.frag template.slim $(css) Makefile
	slimrb template.slim <$< >$@
	#html-minifier $@ >$@

%.frag: %.md Makefile
	pandoc $< -f markdown -t html5 -o $@

%.css: %.styl Makefile
	stylus <$< >$@
