md = $(shell find . -type f -name '*.md')
frag = $(patsubst %.md, %.frag, $(md))
slim = $(patsubst %.md, %.slim, $(md))
html = $(patsubst %.md, %.html, $(md))

styl = $(shell find . -type f -name '*.styl')
css = $(patsubst %.styl, %.css, $(styl))

default: $(html) $(css)

%.html: %.frag template.slim Makefile
	slimrb template.slim <$< >$@ && \
	html-minifier $@ >$@

%.frag: %.md Makefile
	pandoc $< -f markdown -t html5 -o $@

%.css: %.styl Makefile
	stylus <$< >$@
