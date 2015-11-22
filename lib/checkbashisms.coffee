{CompositeDisposable} = require 'atom'

module.exports = Checkbashisms =
  config:
    executablePath:
      title: 'checkbashisms script path'
      type: 'string'
      default: '/usr/local/bin/checkbashisms'

  activate: ->
    console.log 'Activating checkbashisms'
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.config.observe 'checkbashisms.executablePath',
      (executablePath) =>
        @executablePath = executablePath

    # Show the user an error if they do not have an appropriate linter based
    #   package installed from Atom Package Manager. This will not be an issue
    #   after a base linter package is integrated into Atom, in the coming
    #   months.
    # TODO: Remove when Linter Base is integrated into Atom.
    atom.notifications.addError(
      'Linter package not found.',
      {
        detail: 'Please install the `linter` package in your Settings view'
      }
    ) unless atom.packages.getLoadedPackages 'linter'

  deactivate: ->
    console.log 'Deactivating checkbashisms'
    @subscriptions.dispose()

  provideLinter: ->
    console.log 'Providing checkbashisms linter'
    LinterProvider = require './provider'
    provider = new LinterProvider()
    return {
      grammarScopes: ['source.shell']
      scope: 'file'
      lint: provider.lint
      lintOnFly: true
    }
