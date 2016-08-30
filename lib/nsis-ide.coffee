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
  config:
    components:
      type: "object"
      properties:
        toolbar:
          title: "Enable toolbar"
          description: "Displays a toolbar with useful NSIS actions, can be tweaked in the Toolbar settings below"
          order: 1
          type: 'boolean'
          default: true
        "nsis-plugins":
          title: "Enable nsis-plugins"
          description: "Snippets for third-party plug-ins"
          type: 'boolean'
          default: true
          order: 2
        "language-nlf":
          title: "Enable language-nlf"
          description: "Support for NSIS Language Files (NLF)"
          type: 'boolean'
          default: true
          order: 3
        "language-nsl":
          title: "Enable language-nsl"
          description: "Support for [nsL Assembler](https://sourceforge.net/projects/nslassembler/)"
          type: 'boolean'
          default: true
          order: 4
        "build-makensis":
          title: "Enable build-makensis"
          description: "Build provider for `makensis`, builds NSIS scripts"
          type: 'boolean'
          default: true
          order: 5
        "build-makensis-wine":
          title: "Enable build-makensis-wine"
          description: "Build provider for `makensis`, builds NSIS scripts on Wine](https://www.winehq.org/)"
          type: 'boolean'
          default: false
          order: 6
        "build-nsl":
          title: "Enable build-nsl"
          description: "Build provider for `nsL.jar`, builds [nsL Assembler](https://sourceforge.net/projects/nslassembler/). Requires valid `pathToJar` in the package settings."
          type: 'boolean'
          default: true
          order: 7
    toolbar:
      type: "object"
      properties:
        showBuildTools:
          title: "Show Build Tools"
          description: "Displays buttons to build NSIS scripts"
          type: 'boolean'
          default: true
          order: 1
        showFileButtons:
          title: "Show File Tools"
          description: "Displays buttons for `Load` / `Save`"
          type: 'boolean'
          default: true
          order: 2
        showHistoryButtons:
          title: "Show History Tools"
          description: "Displays buttons for `Undo` / `Redo`"
          type: 'boolean'
          default: true
          order: 3
        showClipboardButtons:
          title: "Show Clipboard Tools"
          description: "Displays buttons for `Cut` / `Copy` / `Paste`"
          type: 'boolean'
          default: false
          order: 4
        showInfoButtons:
          title: "Show Info Tools"
          description: "Displays buttons to show `makensis` version and to reveal file"
          type: 'boolean'
          default: true
          order: 4

  activate: (state) ->
    require('atom-package-deps').install(meta.name)
    @adjustSettings()

    atom.config.onDidChange "#{meta.name}.components.build-makensis", ({newValue, oldValue}) => @toggleComponents(newValue, 'build-makensis')
    atom.config.onDidChange "#{meta.name}.components.build-makensis-wine", ({newValue, oldValue}) => @toggleComponents(newValue, 'build-makensis-wine')
    atom.config.onDidChange "#{meta.name}.components.build-nsl", ({newValue, oldValue}) => @toggleComponents(newValue, 'build-nsl')
    atom.config.onDidChange "#{meta.name}.components.language-nlf", ({newValue, oldValue}) => @toggleComponents(newValue, 'language-nlf')
    atom.config.onDidChange "#{meta.name}.components.language-nsl", ({newValue, oldValue}) => @toggleComponents(newValue, 'language-nsl')
    atom.config.onDidChange "#{meta.name}.components.nsis-plugins", ({newValue, oldValue}) => @toggleComponents(newValue, 'nsis-plugins')
    atom.config.onDidChange "#{meta.name}.components.toolbar", ({newValue, oldValue}) => @toggleToolbar(newValue)

  deactivate: ->
    @toolBar?.removeItems()

  consumeToolBar: (toolBar) ->
    unless atom.config.get("#{meta.name}.components.toolbar")
      return

    switch os.platform()
      when 'win32'
        fileManager = 'Explorer'
      when 'darwin'
        fileManager = 'Finder'
      else
        fileManager = 'file manager'

    @toolBar = toolBar "#{meta.name}"

    if atom.packages.loadedPackages['build-makensis'] and atom.config.get("#{meta.name}.toolbar.showBuildTools")
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

  adjustSettings: () ->
    for component in @components
      if atom.packages.isPackageDisabled(component) and atom.config.get("#{meta.name}.components.#{component}") is true
        atom.config.set("#{meta.name}.components.#{component}", false)
      else if atom.packages.isPackageActive(component) and atom.config.get("#{meta.name}.components.#{component}") isnt false
        atom.config.unset("#{meta.name}.components.#{component}")
        atom.packages.enablePackage(component)

  toggleComponents: (state, component) ->
    if state
      atom.notifications.addSuccess("Enabling `#{component}` package", dismissable: false)
      atom.packages.enablePackage(component)
    else
      atom.notifications.addWarning("Disabling `#{component}` package", dismissable: false)
      atom.packages.disablePackage(component)

  toggleToolbar: (state) ->
    if state
      verb = "Enabling"
    else
      verb = "Disabling"

    atom.confirm
      message: "nsis-ide"
      detailedMessage: "#{verb} the toolbar requires a reload of the Atom window. It is recommend to save your work before reloading."
      buttons:
        "Reload now": ->
          # Room for improvment?
          setTimeout =>
            atom.reload()
          , 300
        "Cancel": ->
          return
