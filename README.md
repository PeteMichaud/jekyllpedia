Jekyllpedia
===========

Wiki style links for Jekyll.

## Basic Usage

`[[Page Title]]` => `<a href="path/to/page.html">Page Title</a>`

`[[Page Title|New Anchor Text]]` => `<a href="path/to/page.html">New Anchor Text</a>`

## Missing Pages

`[[Missing Page Title]]` => `<a href="missing/missing-page-title.html">Missing Page Title</a>`

The file displays a message about the page not yet existing.

## Disambiguation

When there is more than one page in the system with the same title:

`[[Ambiguous Page Title]]` => `<a href="disambiguation/ambiguous-page-title.html">Ambiguous Page Title</a>`

The disambiguation page has a list of all the possible pages that the link could be referring to.

## Qualified Titles

Normally ambiguously titled pages live under separate directories, like so:

```
foo/ambiguous.html # Title == "Ambiguous Page Title"
bar/ambiguous.html # Title == "Ambiguous Page Title"
```

Normally linking to that title would lead to a disambiguation page, like in the section above.

To help disambiguate the links, Jekyllpedia provides this syntax:

`[[foo::Ambiguous Page Title]]` => `<a href="foo/ambiguous.html">Ambiguous Page Title</a>`

`[[bar::Ambiguous Page Title]]` => `<a href="bar/ambiguous.html">Ambiguous Page Title</a>`

`[[baz::Ambiguous Page Title]]` => `<a href="missing/ambiguous.html">Ambiguous Page Title</a>`

Note that qualified links that don't have a matching directory are considered missing.

### Even Less Ambiguous

Perhaps your directory structure is more complex:

```
foo/ambiguous.html # Title == "Ambiguous Page Title"
foo/fez/ambiguous.html # Title == "Ambiguous Page Title"
bar/ambiguous.html # Title == "Ambiguous Page Title"
```

`[[foo::Ambiguous Page Title]]` => `<a href="disambiguation/ambiguous-page-title.html">Ambiguous Page Title</a>`

There are now 2 possible candidate pages under `/foo`. You can more fully qualify the title:

`[[foo::fez::Ambiguous Page Title]]` => `<a href="foo/fez/ambiguous.html">Ambiguous Page Title</a>`

The qualification isn't strict. If you have this directory structure:

```
foo/fez/frum/ambiguous.html # Title == "Ambiguous Page Title"
```

Then any of these will work:

`[[foo::Ambiguous Page Title]]` => `<a href="foo/fez/frum/ambiguous.html">Ambiguous Page Title</a>`
`[[foo::fez::Ambiguous Page Title]]` => `<a href="foo/fez/frum/ambiguous.html">Ambiguous Page Title</a>`
`[[foo::fez::frum::Ambiguous Page Title]]` => `<a href="foo/fez/frum/ambiguous.html">Ambiguous Page Title</a>`
`[[fez::frum::Ambiguous Page Title]]` => `<a href="foo/fez/frum/ambiguous.html">Ambiguous Page Title</a>`
`[[foo::frum::Ambiguous Page Title]]` => `<a href="foo/fez/frum/ambiguous.html">Ambiguous Page Title</a>`

But this won't work because the directories are in the wrong order:

`[[fez::foo::Ambiguous Page Title]]` => `<a href="missing/ambiguous-page-title.html">Ambiguous Page Title</a>`

## Options

```
wiki:
    extensions: [".md"]
    directories: ["wiki"]
```