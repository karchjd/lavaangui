`DejaVuSans-subset.ttf` is embedded into exported PDFs for labels that the
standard PDF fonts cannot display (e.g., Greek letters, subscripts, math
symbols). It is a subset of DejaVu Sans 2.37
(https://github.com/dejavu-fonts/dejavu-fonts), see `LICENSE-DejaVu.txt`.

Regenerate with [fontTools](https://github.com/fonttools/fonttools):

```sh
pyftsubset DejaVuSans.ttf \
  --unicodes="U+0020-007E,U+00A0-017F,U+0192,U+02C6-02DD,U+0370-03FF,U+0400-045F,U+1D62-1D65,U+2010-2027,U+2030-205E,U+2070-209C,U+20AC,U+2122,U+2190-21FF,U+2200-22FF,U+2C7C" \
  --name-IDs='*' --name-languages='*' --no-hinting --layout-features='' \
  --drop-tables+=GSUB,GPOS,GDEF,MATH \
  --output-file=DejaVuSans-subset.ttf
```
