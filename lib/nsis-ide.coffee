meta = require '../package.json'
os = require 'os'

module.exports =
  config:
    disableToolbar:
      title: "Disable Toolbar"
      description: "Hides the toolbar altogether"
      type: 'boolean'
      default: false
    showBuildTools:
      title: "Show Build Tools"
      description: "Displays buttons to build NSIS scripts"
      type: 'boolean'
      default: true
    showFileButtons:
      title: "Show File Tools"
      description: "Displays buttons for `Load` / `Save`"
      type: 'boolean'
      default: true
    showHistoryButtons:
      title: "Show History Tools"
      description: "Displays buttons for `Undo` / `Redo`"
      type: 'boolean'
      default: true
    showClipboardButtons:
      title: "Show Clipboard Tools"
      description: "Displays buttons for `Cut` / `Copy` / `Paste`"
      type: 'boolean'
      default: false
    showInfoButtons:
      title: "Show Info Tools"
      description: "Displays buttons to show `makensis` version and to reveal file"
      type: 'boolean'
      default: true

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
