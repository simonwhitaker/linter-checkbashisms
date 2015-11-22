path = require 'path'
child_process = require 'child_process'

module.exports = class LinterProvider
  regex = "possible bashism in (.+) line (\\d+) \\((.*)\\):"

  getCommand = -> "#{atom.config.get 'checkbashisms.executablePath'}"

  getCommandWithFile = (file) -> "#{getCommand()} #{file}"

  lint: (TextEditor) ->
    new Promise (Resolve) ->
      console.log "Running checkbashisms" if atom.inDevMode()
      file = path.basename TextEditor.getPath()
      cwd = path.dirname TextEditor.getPath()
      data = []
      command = getCommandWithFile file
      console.log "checkbashisms command: #{command}" if atom.inDevMode()
      process = child_process.exec command, {cwd: cwd}
      process.stderr.on 'data', (d) -> data.push d.toString()
      process.on 'close', ->
        toReturn = []
        for line in data
          console.log "checkbashisms provider: #{line}" if atom.inDevMode()
          if line.match regex
            [file, line, message] = line.match(regex)[1..3]
            toReturn.push(
              type: 'error',
              text: message,
              filePath: path.join(cwd, file).normalize()
              range: [[line - 1, 0], [line - 1, 0]]
            )
        Resolve toReturn
