meta = require "../package.json"

buildProviders = [ "(default)" ]
buildProviders.push "build-makensis" if atom.packages.loadedPackages["build-makensis"]
buildProviders.push "build-makensis-wine" if atom.packages.loadedPackages["build-makensis-wine"]
buildProviders.push "script" if atom.packages.loadedPackages["script"]

module.exports =
  config:
    building:
      type: "object"
      order: 1
      properties:
        defaultProvider:
          title: "Default Provider"
          description: "Choose your default build provider for `makensis`"
          type: "string"
          enum: buildProviders
          default: "(default)"
    toolbar:
      type: "object"
      order: 2
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
          order: 2
        showFileButtons:
          title: "Show File Tools"
          description: "Displays buttons for `Load` / `Save`"
          type: "boolean"
          default: true
          order: 3
        showHistoryButtons:
          title: "Show History Tools"
          description: "Displays buttons for `Undo` / `Redo`"
          type: "boolean"
          default: true
          order: 4
        showClipboardButtons:
          title: "Show Clipboard Tools"
          description: "Displays buttons for `Cut` / `Copy` / `Paste`"
          type: "boolean"
          default: false
          order: 5
        showInfoButtons:
          title: "Show Info Tools"
          description: "Displays buttons to show `makensis` version and to reveal file"
          type: "boolean"
          default: true
          order: 6
    manageDependencies:
      title: "Manage Dependencies"
      description: "When enabled, third-party dependencies will be installed automatically"
      type: "boolean"
      default: true
      order: 3

  activate: (state) ->
    {CompositeDisposable} = require "atom"

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register commands
    @subscriptions.add atom.commands.add "atom-workspace", "NSIS-IDE:setup-package-dependencies": => @setupPackageDeps()
    if atom.config.get("#{meta.name}.toolbar.enableToolbar") and atom.config.get("#{meta.name}.toolbar.showBuildTools")
      @subscriptions.add atom.commands.add "atom-workspace", "NSIS-IDE:compile": => @buildCommand(false)
      @subscriptions.add atom.commands.add "atom-workspace", "NSIS-IDE:compile-strict": => @buildCommand(true)
      @subscriptions.add atom.commands.add "atom-workspace", "NSIS-IDE:create-build-file": => @buildFile()

    # Using build-makensis-* will disable linter plug-in to avoid conflicts
    atom.config.onDidChange "#{meta.name}.building.defaultProvider", ({newValue, oldValue}) ->
      if newValue.startsWith "build-makensis"
        atom.notifications.addInfo("**#{meta.name}**: Disabling `linter-makensis` package", dismissable: false)
        return atom.packages.disablePackage "linter-makensis"

      atom.notifications.addInfo("**#{meta.name}**: Enabling `linter-makensis` package", dismissable: false)
      atom.packages.enablePackage "linter-makensis"

    atom.config.onDidChange "#{meta.name}.toolbar.enableToolbar", ({isValue, wasValue}) => @toggleToolbar(isValue)

    @setupPackageDeps(true) if atom.config.get("#{meta.name}.manageDependencies")

  deactivate: ->
    if toolBar
      toolBar.removeItems()
      toolBar = null

  setupPackageDeps: (autoRun = falase) ->
    require("atom-package-deps").install(meta.name)

    for k, v of meta["package-deps"]
      if atom.packages.isPackageDisabled(v)
        console.log "Enabling package '#{v}'" if atom.inDevMode()
        atom.packages.enablePackage(v)

  consumeToolBar: (toolBar) ->
    {platform} = require "os"
    unless atom.config.get("#{meta.name}.toolbar.enableToolbar")
      return

    @toolBar = toolBar "#{meta.name}"

    switch platform()
      when "win32"
        fileManager = "Explorer"
      when "darwin"
        fileManager = "Finder"
      else
        fileManager = "file manager"

    if atom.config.get("#{meta.name}.toolbar.showBuildTools")
      @toolBar.addButton
        icon: "check"
        callback: "NSIS-IDE:compile"
        tooltip: "Compile"
        iconset: "fa"

      @toolBar.addButton
        icon: "check-double"
        callback: "NSIS-IDE:compile-strict"
        tooltip: "Compile and stop at warnings"
        iconset: "fa"

      if atom.packages.loadedPackages["language-nsis"]
        @toolBar.addButton
          icon: "plus-square"
          callback: "NSIS-IDE:create-build-file"
          tooltip: "Create build file"
          iconset: "fa"

      @toolBar.addSpacer()

    if atom.config.get("#{meta.name}.toolbar.showFileButtons")
      @toolBar.addButton
        icon: "folder-open"
        callback: "application:open"
        tooltip: "Open"
        iconset: "fa"

      @toolBar.addButton
        icon: "save"
        callback: "core:save"
        tooltip: "Save"
        iconset: "fa"

      @toolBar.addSpacer()

    if atom.config.get("#{meta.name}.toolbar.showHistoryButtons")
      @toolBar.addButton
        icon: "angle-left"
        callback: "core:undo"
        tooltip: "Undo"
        iconset: "fa"

      @toolBar.addButton
        icon: "angle-right"
        callback: "core:redo"
        tooltip: "Redo"
        iconset: "fa"

      @toolBar.addSpacer()

    if atom.config.get("#{meta.name}.toolbar.showClipboardButtons")
      @toolBar.addButton
        icon: "scissors"
        callback: "core:cut"
        tooltip: "Cut"
        iconset: "fa"

      @toolBar.addButton
        icon: "clone"
        callback: "core:copy"
        tooltip: "Copy"
        iconset: "fa"

      @toolBar.addButton
        icon: "clipboard"
        callback: "core:paste"
        tooltip: "Paste"
        iconset: "fa"

      @toolBar.addSpacer()

    if atom.config.get("#{meta.name}.toolbar.showInfoButtons")
      if atom.packages.loadedPackages["browse"]
        @toolBar.addButton
          icon: "eye"
          callback: "browse:reveal-file"
          tooltip: "Show in #{fileManager}"
          iconset: "fa"

      if atom.packages.loadedPackages["language-nsis"]
        @toolBar.addButton
          icon: "sliders-h"
          callback: "NSIS:open-package-settings"
          tooltip: "Open Settings"
          iconset: "fa"

        @toolBar.addButton
          icon: "book"
          callback: "NSIS:command-reference"
          tooltip: "Look up command online"
          iconset: "fa"

        @toolBar.addButton
          icon: "info-circle"
          callback: "NSIS:show-version"
          tooltip: "Show makensis version"
          iconset: "fa"

        @toolBar.addButton
          icon: "flag-checkered"
          callback: "NSIS:show-compiler-flags"
          tooltip: "Show compiler flags"
          iconset: "fa"

        @toolBar.addSpacer()

  toggleToolbar: (getToolBar) ->
    if @toolBar
      @toolBar.removeItems()
      @toolBar = null
    else
      atom.confirm
        message: "nsis-ide"
        detailedMessage: "Modifying the toolbar requires a reload of the Atom window. It is recommend to save your work before reloading."
        buttons:
          "Reload now": ->
            # Room for improvment?
            setTimeout ->
              atom.reload()
            , 300
          "Cancel": ->
            return

  buildCommand: (isStrict) ->
    editor = atom.workspace.getActiveTextEditor()
    return atom.notifications.addWarning("**#{meta.name}**: No active editor", dismissable: false) unless editor?

    defaultProvider = atom.config.get("#{meta.name}.building.defaultProvider")

    if defaultProvider is "build-makensis" and atom.packages.loadedPackages["build-makensis"]
      buildCommand = if isStrict then "MakeNSIS:compile-and-stop-at-warning" else "MakeNSIS:compile"
    else if defaultProvider is "build-makensis-wine" and atom.packages.loadedPackages["build-makensis-wine"]
      buildCommand = if isStrict then "MakeNSIS-on-wine:compile-and-stop-at-warning" else "MakeNSIS-on-wine:compile"
    else if defaultProvider is "script" and atom.packages.loadedPackages["script"]
      buildCommand = "script:run"
    else
      buildCommand = if isStrict then "NSIS:compile-strict" else "NSIS:compile"

    atom.commands.dispatch atom.views.getView(editor), buildCommand

  buildFile: () ->
    editor = atom.workspace.getActiveTextEditor()
    return atom.notifications.addWarning("**#{meta.name}**: No active editor", dismissable: false) unless editor?

    defaultProvider = atom.config.get("#{meta.name}.building.defaultProvider")

    if defaultProvider is "build-makensis-wine" and atom.packages.loadedPackages["build-makensis-wine"]
      buildFile = "NSIS:create-.atom–build-file-for-wine"
    else
      buildFile = "NSIS:create-.atom–build-file"

    atom.commands.dispatch atom.views.getView(editor), buildFile
