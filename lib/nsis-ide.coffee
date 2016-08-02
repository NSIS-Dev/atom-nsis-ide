meta = require '../package.json'

os = require 'os'

module.exports =
  activate: (state) ->
    require('atom-package-deps').install(meta.name)

  deactivate: ->
    @toolBar?.removeItems()

  consumeToolBar: (toolBar) ->

    if atom.config.get('nsis-ide.disableToolbar') is true
      return

    switch os.platform()
      when 'win32'
        fileManager = 'Explorer'
      when 'darwin'
        fileManager = 'Finder'
      else
        fileManager = 'file manager'

    @toolBar = toolBar 'nsis-ide'

    if atom.packages.loadedPackages['build-makensis']
      @toolBar.addButton
        icon: 'social-buffer'
        callback: 'makensis:compile'
        tooltip: 'Compile'
        iconset: 'ion'

      @toolBar.addButton
        icon: 'social-buffer-outline'
        callback: 'makensis:compile-and-stop-at-warning'
        tooltip: 'Compile and stop at warnings'
        iconset: 'ion'

    @toolBar.addSpacer()

    if atom.packages.loadedPackages['browse']
      @toolBar.addButton
        icon: 'ios-search-strong'
        callback: 'browse:reveal-file'
        tooltip: "Show in #{fileManager}"
        iconset: 'ion'

    @toolBar.addSpacer()
