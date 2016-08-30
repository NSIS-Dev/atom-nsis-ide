meta = require '../package.json'
os = require 'os'

module.exports =
  components: [
    "build-makensis",
    "build-makensis-wine",
    "build-nsl",
    "language-nlf",
    "language-nsl",
    "nsis-plugins"
  ]
  buildProvider: null
  buildCmd: null
  buildWxCmd: null
  config:
    building:
      type: "object"
      order: 1
      properties:
        defaultProvider:
          title: "Build Provider"
          description: "Choose your preferred build provider for `makensis`"
          type: "string"
          enum: [
            "build-makensis"
            "build-makensis-wine"
          ]
          default: "build-makensis"
    toolbar:
      type: "object"
      properties:
        enableToolbar:
          title: "Enable toolbar"
          description: "Displays a toolbar with useful NSIS actions, can be tweaked in the Toolbar settings below"
          order: 1
          type: "boolean"
          default: true
        showBuildTools:
          title: "Show Build Tools"
          description: "Displays buttons to build NSIS scripts"
          type: "boolean"
          default: true
          order: 1
        showFileButtons:
          title: "Show File Tools"
          description: "Displays buttons for `Load` / `Save`"
          type: "boolean"
          default: true
          order: 2
        showHistoryButtons:
          title: "Show History Tools"
          description: "Displays buttons for `Undo` / `Redo`"
          type: "boolean"
          default: true
          order: 3
        showClipboardButtons:
          title: "Show Clipboard Tools"
          description: "Displays buttons for `Cut` / `Copy` / `Paste`"
          type: "boolean"
          default: false
          order: 4
        showInfoButtons:
          title: "Show Info Tools"
          description: "Displays buttons to show `makensis` version and to reveal file"
          type: "boolean"
          default: true
          order: 5

  activate: (state) ->
    require('atom-package-deps').install(meta.name)

    atom.config.onDidChange "#{meta.name}.toolbar", ({isValue, wasValue}) => @toggleToolbar(isValue)
    atom.config.onDidChange "#{meta.name}.building.defaultProvider", => @toggleProvider(true)

  deactivate: ->
    @toolBar?.removeItems()

  consumeToolBar: (toolBar) ->
    unless atom.config.get("#{meta.name}.toolbar.enableToolbar")
      return

    switch os.platform()
      when 'win32'
        fileManager = 'Explorer'
      when 'darwin'
        fileManager = 'Finder'
      else
        fileManager = 'file manager'

    @toolBar = toolBar "#{meta.name}"

    @toggleProvider(false)

    if atom.packages.loadedPackages[@buildProvider] and atom.config.get("#{meta.name}.toolbar.showBuildTools")
      @toolBar.addButton
        icon: 'paper-plane'
        callback: @buildCmd
        tooltip: 'Compile'
        iconset: 'fa'

      @toolBar.addButton
        icon: 'paper-plane-o'
        callback: @buildWxCmd
        tooltip: 'Compile and stop at warnings'
        iconset: 'fa'

      @toolBar.addSpacer()

    if atom.config.get("#{meta.name}.toolbar.showFileButtons")
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

    if atom.config.get("#{meta.name}.toolbar.showHistoryButtons")
      @toolBar.addButton
        icon: 'angle-left'
        callback: 'core:undo'
        tooltip: "Undo"
        iconset: 'fa'

      @toolBar.addButton
        icon: 'angle-right'
        callback: 'core:redo'
        tooltip: "Redo"
        iconset: 'fa'

      @toolBar.addSpacer()

    if atom.config.get("#{meta.name}.toolbar.showClipboardButtons")
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

    if atom.config.get("#{meta.name}.toolbar.showInfoButtons")
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

  toggleToolbar: (state) ->
    atom.confirm
      message: "nsis-ide"
      detailedMessage: "Modifying the toolbar requires a reload of the Atom window. It is recommend to save your work before reloading."
      buttons:
        "Reload now": ->
          # Room for improvment?
          setTimeout =>
            atom.reload()
          , 300
        "Cancel": ->
          return

  toggleProvider: (reload) ->
    @buildProvider = atom.config.get("#{meta.name}.building.defaultProvider")

    if atom.packages.isPackageDisabled(@buildProvider)
      atom.packages.enablePackage(@buildProvider)

    if @buildProvider is "build-makensis-wine"
      @buildCmd = "MakeNSIS-on-wine:compile"
      @buildWxCmd = "MakeNSIS-on-wine:compile-and-stop-at-warning"
    else
      @buildCmd = "MakeNSIS:compile"
      @buildWxCmd = "MakeNSIS:compile-and-stop-at-warning"

    @toggleToolbar() if reload
