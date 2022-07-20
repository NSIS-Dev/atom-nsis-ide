# nsis-ide

[![apm](https://img.shields.io/apm/l/nsis-ide.svg?style=flat-square)](https://atom.io/packages/nsis-ide)
[![apm](https://img.shields.io/apm/v/nsis-ide.svg?style=flat-square)](https://atom.io/packages/nsis-ide)
[![apm](https://img.shields.io/apm/dm/nsis-ide.svg?style=flat-square)](https://atom.io/packages/nsis-ide)
[![Travis](https://img.shields.io/travis/NSIS-Dev/atom-nsis-ide.svg?style=flat-square)](https://travis-ci.org/NSIS-Dev/atom-nsis-ide)

Adds IDE-like features for [NSIS](https://nsis.sourceforge.net) development in Atom

## Installation

### apm

Install `nsis-ide` from Atom's [Package Manager](http://flight-manual.atom.io/using-atom/sections/atom-packages/) or the command-line equivalent:

`$ apm install nsis-ide`

### Using Git

Change to your Atom packages directory:

```powershell
# Windows Powershell
cd $Env:USERPROFILES\.atom\packages

# Windows Command Prompt
$ cd %USERPROFILE%\.atom\packages
```

```bash
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

This package is largely a “meta package”. Other than adding adding a tool-bar, it consists mainly of third-party NSIS packages. Together, they turn Atom into a powerful, *near-IDE* editor for NSIS developers.

**NSIS**

* [`language-nsis`](https://atom.io/packages/language-nsis) – grammar, snippets, build tool
* [`nsis-plugins`](https://atom.io/packages/nsis-plugins) – snippets for third-party plug-ins
* [`build-makensis`](https://atom.io/packages/build-makensis) – alternative build tool with [linter](https://atom.io/packages/linter) support
* [`build-makensis-wine`](https://atom.io/packages/build-makensis-wine) – build on any [Wine](https://www.winehq.org/)-compatible platform
* [`linter-makensis`](https://atom.io/packages/linter-makensis) – linter plug-in
* [`hyperclick-nsis`](https://atom.io/packages/hyperclick-nsis) – hyperclick provider

**nsL Assembler**

* [`language-nsl`](https://atom.io/packages/language-nsl) – grammar, snippets, build tool for [nsL Assembler](https://github.com/NSIS-Dev/nsl-assembler)
* [`build-nsl`](https://atom.io/packages/build-nsl) – alternative build tool with [linter](https://atom.io/packages/linter) support

**Haskell**

* [`haskell-nsis`](https://atom.io/packages/haskell-nsis) – snippets for the [Haskell](https://hackage.haskell.org/package/nsis) DSL

Also included are several convenience packages, that are not primarily targeted at NSIS users.

* [`linter`](https://atom.io/packages/linter)
* [`minimap`](https://atom.io/packages/minimap)
* [`tool-bar`](https://atom.io/packages/tool-bar)
* [`set-syntax`](https://atom.io/packages/set-syntax)
* [`browse`](https://atom.io/packages/browse)

## Related

- [node-makensis](https://www.npmjs.com/package/makensis) - Node wrapper for `makensis`
- [vscode-nsis](https://marketplace.visualstudio.com/items?itemName=idleberg.nsis) - NSIS package for Visual Studio Code

## License

This work is dual-licensed under [The MIT License](https://opensource.org/licenses/MIT) and the [GNU General Public License, version 2.0](https://opensource.org/licenses/GPL-2.0)
