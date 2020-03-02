# Makefile
# 
# Converts Markdown to other formats (HTML, PDF, DOCX, ODT, ICML) using Pandoc
#
# IF you're on Windows use Cygwin or the WSL


PANDOC = /usr/bin/pandoc  # find with `type -a pandoc` / `which pandoc`
CSS_NAME = morris.css
OUTPUT_PATH = output/

SOURCE_DOCS = $(wildcard *.md)
FILE_NAME = $(notdir $(SOURCE_DOCS))

# Remove cmd
RM = /bin/rm -rf


EXPORTED_PDF  = $(addprefix $(OUTPUT_PATH),$(FILE_NAME:.md=.pdf))
EXPORTED_HTML = $(addprefix $(OUTPUT_PATH),$(FILE_NAME:.md=.html))
EXPORTED_DOCX = $(addprefix $(OUTPUT_PATH),$(FILE_NAME:.md=.docx))
EXPORTED_ODF  = $(addprefix $(OUTPUT_PATH),$(FILE_NAME:.md=.odt))
EXPORTED_ICML = $(addprefix $(OUTPUT_PATH),$(FILE_NAME:.md=.icml))

EXPORTED_DOCS=\
 $(EXPORTED_PDF) \
 $(EXPORTED_HTML) \
 $(EXPORTED_DOCX) \
 $(EXPORTED_ODT) \
 $(EXPORTED_ICML)


# pandoc per document format options
PANDOC_OPTIONS=\
	--from markdown+task_lists+definition_lists+superscript+subscript+link_attributes+fenced_divs+inline_notes
PANDOC_HTML_OPTIONS=\
	--to html5\
	--css=morris.css\
	-s\
	-M date="Last updated: `date +"%x"`"
#	--extract-media=$(OUTPUT_PATH)\
# to have a TOC set
#   --toc\
#   --toc-depth=2
PANDOC_PDF_OPTIONS=\
	--pdf-engine=weasyprint\
	--css=morris.css
PANDOC_DOCX_OPTIONS=\
	--reference-doc=morris.docx
PANDOC_ODT_OPTIONS=\
	#--reference-doc=morris.odt
PANDOC_ICML_OPTIONS=\
	--standalone


# # Export options per format
$(OUTPUT_PATH)%.html : $(INPUT_PATH)%.md $(CSS_NAME)
	$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_HTML_OPTIONS) -o $@ $<

$(OUTPUT_PATH)%.pdf : %.md $(CSS_NAME)
	$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_PDF_OPTIONS) -o $@ $<

$(OUTPUT_PATH)%.docx : $(INPUT_PATH)%.md
	$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_DOCX_OPTIONS) -o $@ $<

$(OUTPUT_PATH)%.odt : $(INPUT_PATH)%.md 
	$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_ODT_OPTIONS) -o $@ $<

$(OUTPUT_PATH)%.icml : $(INPUT_PATH)%.md
	$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_ICML_OPTIONS) -o $@ $<


pdf: $(EXPORTED_PDF) $(SOURCE_DOCS)
html: $(EXPORTED_HTML) $(SOURCE_DOCS)
docx: $(EXPORTED_DOCX) $(SOURCE_DOCS)
odt: $(EXPORTED_ODT) $(SOURCE_DOCS)
icml: $(EXPORTED_ICML) $(SOURCE_DOCS)

both :\
 pdf\
 html

all :\
 pdf\
 html\
 docx\
 odt\
 icml

clean:
	-$(RM) $(EXPORTED_DOCS)
# the minus ignores errors
