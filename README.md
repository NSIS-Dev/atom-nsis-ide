# nsis-ide

[![apm](https://img.shields.io/apm/l/nsis-ide.svg?style=flat-square)](https://atom.io/packages/nsis-ide)
[![apm](https://img.shields.io/apm/v/nsis-ide.svg?style=flat-square)](https://atom.io/packages/nsis-ide)
[![apm](https://img.shields.io/apm/dm/nsis-ide.svg?style=flat-square)](https://atom.io/packages/nsis-ide)
[![Travis](https://img.shields.io/travis/NSIS-Dev/atom-nsis-ide.svg?style=flat-square)](https://travis-ci.org/NSIS-Dev/atom-nsis-ide)
[![David](https://img.shields.io/david/NSIS-Dev/atom-nsis-ide.svg?style=flat-square)](https://david-dm.org/NSIS-Dev/atom-nsis-ide)
[![David](https://img.shields.io/david/dev/NSIS-Dev/atom-nsis-ide.svg?style=flat-square)](https://david-dm.org/NSIS-Dev/atom-nsis-ide?type=dev)
[![Gitter](https://img.shields.io/badge/chat-Gitter-ed1965.svg?style=flat-square)](https://gitter.im/NSIS-Dev/Atom)

Adds IDE-like features for [NSIS](https://nsis.sourceforge.net) development in Atom

## Installation

### apm

Install `nsis-ide` from Atom's [Package Manager](http://flight-manual.atom.io/using-atom/sections/atom-packages/) or the command-line equivalent:

`$ apm install nsis-ide`

### Using Git

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

Inside the cloned directory, install Node dependencies:

```bash
$ yarn || npm install
```

### Dependencies

This package makes use of [atom-package-deps](https://github.com/steelbrain/package-deps) to automatically install additional packages it depends on. However, you *might* have to restart Atom in order to use them.

## Components

This package is largely a “meta package”. Other than adding adding a tool-bar, it consists mainly of third-party packages.

* NSIS
    * [`language-nsis`](https://atom.io/packages/language-nsis)
    * [`nsis-plugins`](https://atom.io/packages/nsis-plugins)
    * [`build-makensis`](https://atom.io/packages/build-makensis)
    * [`build-makensis-wine`](https://atom.io/packages/build-makensis-wine)
    * [`language-nlf`](https://atom.io/packages/language-nlf)
* nsL Assembler
    * [`language-nsl`](https://atom.io/packages/language-nsl)
    * [`build-nsl`](https://atom.io/packages/language-nsl)
* Helpers
    * [`linter`](https://atom.io/packages/linter)
    * [`minimap`](https://atom.io/packages/minimap)
    * [`tool-bar`](https://atom.io/packages/tool-bar)
    * [`set-syntax`](https://atom.io/packages/set-syntax)
    * [`browse`](https://atom.io/packages/browse)
    * and more

Also included are several convenience packages, that are not primarily targeted at NSIS users.

## License

This work is dual-licensed under [The MIT License](https://opensource.org/licenses/MIT) and the [GNU General Public License, version 2.0](https://opensource.org/licenses/GPL-2.0)
