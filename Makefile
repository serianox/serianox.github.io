md = $(shell find . -type f -name '*.md')
frag = $(patsubst %.md, %.frag, $(md))
html = $(patsubst %.md, %.html, $(md))

styl = $(shell find . -type f -name '*.styl')
css = $(patsubst %.styl, %.css, $(styl))

default: $(html) style.css

%.html: %.frag template.slim Makefile
	slimrb template.slim /dev/stdout <$< style.css |\
	html-minifier >$@

%.frag: %.md Makefile
	pandoc $< -f markdown -t html5 -o $@

style.css: $(css) Makefile
	cleancss -O2 $(filter %.css, $^) >$@

%.css: %.styl Makefile
	stylus <$< >$@
