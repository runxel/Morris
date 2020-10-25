# Morris

<!-- TODO:
 - pictures for gen. PDF like 'Gutenberg'
 -->

<img align="right" src="img/morris-logo.png" width="150">

> Make creating documents a pleasure.

[![license](https://img.shields.io/github/license/runxel/Morris?style=flat-square)]()

Pandoc is an incredibly powerful tool – which comes at the cost of being sometimes seemingly too complex.
This project aims to lower the hurdles and make document creating an easy thing. Morris provides you with everything you need to quickly generate beatiful documents from your Markdown.

Let's start! It's as easy as:

## Usage

```shell
make
```

## Features

Morris comes with a `makefile` you can modify to your liking.

- `make` will output a PDF for every `.md` file in the directory.
- `make both` will give you PDF & HTML.
- `make all` will output PDF, HTML, Word <samp>.docx</samp>, OpenOffice <samp>.odt</samp>, and InDesign <samp>.icml</samp>.
You can also be specific in what you generate by using the format as a <samp>make</samp> option, e.g. `make icml`.
- `make clean` will delete all generated content in the `OUTPUT_PATH` folder.

_Don't panic when seeing complaints about unknown CSS rules in your CLI: some boilerplate in the `morris.css` is for generating nice HTML – it is expected to make no sense in printing and vice versa._

- The HTML output has a simple lightbox enabled when using the `.lightbox` class on your images. 


### Your Markdown
Be sure to include some [metadata](https://pandoc.org/MANUAL.html#variables) in your Markdown files:
Use a YAML block right at the file's beginning. Otherwise you can write in the same way you would always do.


### On PDFs
There are different ways to get a PDF from a Markdown document in Pandoc. The default action requires a LaTeX version to be installed. I'm not a big fan of this (using the Markdown/Pandoc combination was to avoid LaTeX in the first place).
Pandoc however supports a wide range of [other engines](https://pandoc.org/MANUAL.html#option--pdf-engine), mostly with HTML as an intermediate format. Something which appeals to me much more coming from the web.

Interesting are `wkhtmltopdf` and `weasyprint`. [Prince](https://www.princexml.com/) might be good, but it's proprietary and unaffordable if you aren't a multi-billion dollar company.  
[**Wkhtmltopdf**](https://wkhtmltopdf.org/) is the next option here:  
However, the default will output an unreadable, smashed pile of text. You need a lot of styling to get something halfway decent.
This leads to more problems down the road. Wkthml uses a neolithic version of WebKit which makes it hardly usable (printing is no concern to the WebKit devs). Also none of the newer CSS stuff we got to like in the near past is supported. This already starts with trivial things like CSS variables (aka _custom properties_).
Soon enough you will be ridden with lots of meaningless errors and _man_, inserting a pagination is an endeavour on loosing your mind. And don't spend your time thinking about [hyphenation](https://github.com/wkhtmltopdf/wkhtmltopdf/issues/1730).

Younger and maybe less atrocious is [**Weasyprint**](https://weasyprint.org/).  
_Caveat for Windows users_: Weasyprint has a horrible and ridiculous way of [installation](https://weasyprint.readthedocs.io/en/stable/install.html#windows) – you have to install the GTK3 runtime…
<sub>Hint for Miniconda/Anaconda users: Since weasyprint is Python-based you might have to activate the right environment first (à la `activate <py3>`).</sub>

Once you got through the painful installation weasyprint appears to be quite nice and much more usable than wkhtml.  
***If*** you intend to use the `makefile` you don't need to care anyway, because you need `GNU make` for that – meaning you should use [Cygwin](https://www.cygwin.com/) or the [Windows Subsystem for Linux WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10) (Win10 only).  
<sub>I _have_ tried to use NMAKE in Windows [by using Qt's _Jom_, a drop-in replacement], but it is too limited. Don't waste time on that and use WSL instead.</sub>

In case you _are_ a Windows user and want to proceed with WSL to use the makefile there is one thing to take care of: You are most likey referecing fonts that aren't available in your Linux subsystem but in Windows natively. How to do that is written down [here](https://x410.dev/cookbook/wsl/sharing-windows-fonts-with-wsl/).

Weasyprint supports CSS' `@page` rules (designed for [paged media](https://www.quackit.com/css/at-rules/css_page_at-rule.cfm) so we can easily pass a custom CSS via the usual Pandoc CLI param:

```shell
pandoc input.md -o output.pdf --pdf-engine=weasyprint -c morris.css
```
<br>

However, in the end, the [sad state of automated layouting solutions](https://mb21.github.io/blog/2016/08/13/The-sad-state-of-automated-layouting-solutions) didn't got better in the last 10 years. Proper engine support is still lacking many features. So regarding your own CSS: better keep it simple. (Think of styling an email – both has some 90's vibe to it.)


## Utilities
You might want to enjoy the possibility to number figures, equations, tables and cross-reference them. This can be done with the [pandoc-crossref filter](https://github.com/lierdakil/pandoc-crossref).  
With [pandoc-plot](https://github.com/LaurentRDC/pandoc-plot) will turn your code blocks (Matplotlib, MATLAB, Mathematica, graphviz, and more) into embedded figures.


## Caution
**Be sure** you have a recent pandoc version. The versions in the package managers are usually _heavily_ outdated. Also follow the complete [weasyprint installation](https://weasyprint.readthedocs.io/en/stable/install.html) process.


## Automation
If you want to have an auto-conversion taking place everytime you push to your repo: That's possible with [GitHub Actions](https://github.com/pandoc/pandoc-action-example)!


## Trivia
This project was named in honor of [William Morris](https://en.wikipedia.org/wiki/William_Morris).

---

## Print CSS explained

<details>

The biggest difference in understandinng CSS is tied to the viewport and the page model. Whereas on the web we finally have let go of fixed viewport sizes meaning everything is fluid the opposite is true for print: We suddenly have no longer a continuous media, but discrete pages with finite space to fill.

Also there are new concepts which have no analogy on the web.

#### The @page rule
The page rule lets you define the '_box_' into which your content flows. 
```css
@page {
  /* use keywords */
  size: A4 landscape; }
@page {
  /* specify dimensions */
  size: 5in 7.5in; }
```

#### Understand the page model
Surrounding your main content there are 16 [margin boxes](https://www.w3.org/TR/css-page-3/#margin-boxes) defined. Those can be utilized for CSS generated content.

<table>
  <tr>
    <td>top-left-corner</td><td>top-left</td><td>top-center</td><td>top-right</td><td>top-right-corner</td>
  </tr>
  <tr>
    <td>left-top</td><td colspan="3" rowspan="3"><i>your content</i></td><td>right-top</td>
  </tr>
  <tr>
    <td>left-middle</td><td>right-middle</td>
  </tr>
  <tr>
    <td>left-bottom</td><td>right-bottom</td>
  </tr>
  <tr>
    <td>bottom-left-corner</td><td>bottom-left</td><td>bottom-center</td><td>bottom-right</td><td>bottom-right-corner</td>
  </tr>
</table>


#### Page spreads
There is a unique pseudo selector in print to select left and right pages (think of a book).
```css
@page:left {
  margin-left: 5cm; }

@page:right {
  margin-left: 3.2cm; }
```
The other ones are `:first` and `:blank`, which are pretty much self explainatory.


#### Page breaks
Of course you need to be able to define a page break. The older and mostly supported CSS flavor to achiveve this are `page-break-<where>`. In CSS3 this has been replaced by `break-<where>`. Morris supports both.
```css
h1 {
  page-break-before: always; }
h1, h2, h3, h4, h5 {
  page-break-after: avoid; }
table, figure {
  page-break-inside: avoid; }
```


#### Counters
Morris is doing page numbers like this:
```css
@bottom-right-corner {
  content: counter(page) " of " counter(pages); }
```

If you need chapter and/or image numbers you could do it like this:
```css
body {
  counter-reset: chapternum figurenum; }

h1 {
  counter-reset: figurenum; }

h1.title::before {
  counter-increment: chapternum;
  content: counter(chapternum) ". "; }

figcaption::before {
  counter-increment: figurenum;
  content: counter(chapternum) "-" counter(figurenum) ". "; }
```


#### Special strings
One of the weirder CSS specs is the `string-set` property. We can use that to inject CSS content but with a _document defined string_. To have a living column title you would do:
```css
h1 { 
  string-set: doctitle content(); }

@page:right {
  @top-right {
    content: string(doctitle); }}
```

#### Links
If you intend to actually print your document you should take care of the actual link so people could go and type it in. We achieve this by setting:
```css
a:link[href^="http"]::after,
a[href^="http"]:visited::after {
  content: " (" attr(href) ") ";
  font-size: 90%; }
```


- [Source](https://www.smashingmagazine.com/2015/01/designing-for-print-with-css/)

</details>


### Testing print stylesheets

<details>

Testing print stylesheets might seem like a boring task involving of actual printing the page, but there is some possibility of making your live a bit easier:

### Firefox
There is a dedicated button to switch into print view:

![Firefox print view button](img/printview-firefox.png)

### Chrome
Open the devtools, click on the three dots icon, select "More Tools > Rendering". In this tab you can choose to "Emulate CSS media".

Please be aware that this will only help with changes to CSS layout, but not with fragmentation (=_laying out the individual pages_). You still need to make a PDF for checking that.

</details>

### Other options
- [Gutenburg](https://github.com/BafS/Gutenberg)
- [Tufte CSS for Pandoc](https://jez.io/tufte-pandoc-css/)
- [Pan Am](https://benjam.info/panam/)
- [Hartija](https://github.com/vladocar/Hartija---CSS-Print-Framework)
- [GitHub readme look-a-like](https://gist.github.com/dashed/6714393)
- [this Gist](https://gist.github.com/killercup/5917178)

### Further reading
- [Print CSS Rocks!](https://print-css.rocks/)
- [Article on A List Apart](https://alistapart.com/article/building-books-with-css3/)
- [Print stylesheets in 2018](https://www.smashingmagazine.com/2018/05/print-stylesheets-in-2018/)
- [Look at the weasyprint samples](https://github.com/Kozea/WeasyPrint/tree/gh-pages/samples)