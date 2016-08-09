meta = require '../package.json'
os = require 'os'

module.exports =

  activate: (state) ->
    # Install dependencies
    require('atom-package-deps').install(meta.name)

    # Write default config
    @defaultConfig()

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

    if atom.packages.loadedPackages['build-makensis'] and atom.config.get('nsis-ide.showBuildTools') isnt false
      @toolBar.addButton
        icon: 'paper-plane'
        callback: 'makensis:compile'
        tooltip: 'Compile'
        iconset: 'fa'

      @toolBar.addButton
        icon: 'paper-plane-o'
        callback: 'makensis:compile-and-stop-at-warning'
        tooltip: 'Compile and stop at warnings'
        iconset: 'fa'

      @toolBar.addSpacer()

    if atom.config.get('nsis-ide.showFileButtons') isnt false

      @toolBar.addButton
        icon: 'folder-open-o'
        callback: 'application:open'
        tooltip: "Open"
        iconset: 'fa'

      @toolBar.addButton
        icon: 'floppy-o'
        callback: 'core:save'
        tooltip: "Save"
        iconset: 'fa'

      @toolBar.addSpacer()

    if atom.config.get('nsis-ide.showHistoryButtons') isnt false

      @toolBar.addButton
        icon: 'step-backward'
        callback: 'core:undo'
        tooltip: "Undo"
        iconset: 'fa'

      @toolBar.addButton
        icon: 'step-forward'
        callback: 'core:redo'
        tooltip: "Redo"
        iconset: 'fa'

      @toolBar.addSpacer()

    if atom.config.get('nsis-ide.showClipboardButtons') isnt false

      @toolBar.addButton
        icon: 'scissors'
        callback: 'core:cut'
        tooltip: "Cut"
        iconset: 'fa'

      @toolBar.addButton
        icon: 'clone'
        callback: 'core:copy'
        tooltip: "Copy"
        iconset: 'fa'

      @toolBar.addButton
        icon: 'clipboard'
        callback: 'core:paste'
        tooltip: "Paste"
        iconset: 'fa'

      @toolBar.addSpacer()

    if atom.config.get('nsis-ide.showInfoButtons') isnt false

      if atom.packages.loadedPackages['browse']
          @toolBar.addButton
            icon: 'eye'
            callback: 'browse:reveal-file'
            tooltip: "Show in #{fileManager}"
            iconset: 'fa'

      if atom.packages.loadedPackages['language-nsis']
        @toolBar.addButton
          icon: 'info-circle'
          callback: 'NSIS:show-version'
          tooltip: "Show makensis version"
          iconset: 'fa'

        @toolBar.addSpacer()

  defaultConfig: ->

    unless atom.config.get('nsis-ide.disableToolbar')?
      atom.config.set('nsis-ide.disableToolbar', false)

    unless atom.config.get('nsis-ide.showBuildTools')?
      atom.config.set('nsis-ide.showBuildTools', true)

    unless atom.config.get('nsis-ide.showClipboardButtons')?
      atom.config.set('nsis-ide.showClipboardButtons', false)

    unless atom.config.get('nsis-ide.showFileButtons')?
      atom.config.set('nsis-ide.showFileButtons', true)

    unless atom.config.get('nsis-ide.showHistoryButtons')?
      atom.config.set('nsis-ide.showHistoryButtons', true)

    unless atom.config.get('nsis-ide.showInfoButtons')?
      atom.config.set('nsis-ide.showInfoButtons', true)
