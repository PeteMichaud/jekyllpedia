Jekyllpedia
===========

Wiki style links for Jekyll:

`[[Page Title]]` => `<a href="path/to/page.html">Page Title</a>`

`[[Page Title|New Anchor Text]]` => `<a href="path/to/page.html">New Anchor Text</a>`

##Missing Pages

`[[Missing Page Title]]` => `<a href="missing/missing-page-title.html">Missing Page Title</a>`

The file displays a message about the page not yet existing.

## Disambiguation

When there is more than one page in the system with the same title:

`[[Ambiguous Page Title]]` => `<a href="disambiguation/ambiguous-page-title.html">Ambiguous Page Title</a>`

The disambiguation page has a list of all the possible pages that the link could be referring to.

## Options

```
wiki:
    extensions: [".md"]
    directories: ["wiki"]
```