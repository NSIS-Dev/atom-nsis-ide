# nsis-ide

[![apm](https://img.shields.io/apm/l/nsis-ide.svg?style=flat-square)](https://atom.io/packages/nsis-ide)
[![apm](https://img.shields.io/apm/v/nsis-ide.svg?style=flat-square)](https://atom.io/packages/nsis-ide)
[![apm](https://img.shields.io/apm/dm/nsis-ide.svg?style=flat-square)](https://atom.io/packages/nsis-ide)
[![Travis](https://img.shields.io/travis/NSIS-Dev/atom-nsis-ide.svg?style=flat-square)](https://travis-ci.org/NSIS-Dev/atom-nsis-ide)
[![David](https://img.shields.io/david/NSIS-Dev/atom-nsis-ide.svg?style=flat-square)](https://david-dm.org/NSIS-Dev/atom-nsis-ide#info=dependencies)
[![David](https://img.shields.io/david/dev/NSIS-Dev/atom-nsis-ide.svg?style=flat-square)](https://david-dm.org/NSIS-Dev/atom-nsis-ide#info=devDependencies)

Adds IDE-like features for [NSIS](https://nsis.sourceforge.net) development in Atom

## Installation

### apm

Install `nsis-ide` from Atom's [Package Manager](http://flight-manual.atom.io/using-atom/sections/atom-packages/) or the command-line equivalent:

`$ apm install nsis-ide`

### GitHub

Change to your Atom packages directory:

```bash
# Windows
$ cd %USERPROFILE%\.atom\packages

# Linux & macOS
$ cd ~/.atom/packages/
```

Clone repository as `nsis-ide`:

```bash
$ git clone https://github.com/NSIS-Dev/atom-nsis-ide nsis-ide
```

### Dependencies

This package makes use of [atom-package-deps](https://github.com/steelbrain/package-deps) to automatically install additional packages it depends on. However, you *might* have to restart Atom in order to use them.

## Features

* [`language-nsis`](https://atom.io/packages/language-nsis) – language grammar for NSIS
* [`language-nlf`](https://atom.io/packages/language-nlf) – language grammar for NSIS Language Files
* [`language-nsl`](https://atom.io/packages/language-nsl) – language grammar for nsL Assembler
* [`build-makensis`](https://atom.io/packages/build-makensis) – build provider for `makensis`
* [`build-nsl`](https://atom.io/packages/build-nsl) – build provider for `nsL.jar`
* auto-completion and snippets
* code linting

## License

This work is dual-licensed under [The MIT License](https://opensource.org/licenses/MIT) and the [GNU General Public License, version 2.0](https://opensource.org/licenses/GPL-2.0)

[nsL Assembler]: https://atom.io/packages/language-nsl
