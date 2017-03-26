md = $(shell find . -type f -name '*.md')
html.frag = $(patsubst %.md, %.html.frag, $(md))
html = $(patsubst %.md, %.html, $(md))

styl = $(shell find . -type f -name '*.styl')
css.frag = $(patsubst %.styl, %.css.frag, $(styl))

default: $(html) style.css

%.html: %.html.frag template.slim Makefile
	slimrb template.slim /dev/stdout <$< style.css |\
	html-minifier >$@

%.html.frag: %.md Makefile
	pandoc $< -f markdown -t html5 -o $@

style.css: $(css.frag) Makefile
	cleancss -O2 $(filter %.css, $^) >$@

%.css.frag: %.styl Makefile
	stylus <$< >$@
