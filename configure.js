var {
  generateProject
} = require('diy-build')

generateProject(_ => {
  _.collectSeq("all", _ => {
    _.collect("build", _ => {
      _.livescript("*.ls")

    })
    _.cmd("((echo '#!/usr/bin/env node') && cat command.js) > index.js", "command.js")
    _.cmd("chmod +x ./index.js", "index.js")
  })

  _.collect("test", _ => {
    _.cmd("./test/test.sh")
  })

  _.collect("up", _ => {
    _.cmd("make clean && babel configure.js | node")
  });

  ["major", "minor", "patch"].map(it => {
    _.collect(it, _ => {
      _.cmd(`./node_modules/.bin/xyz -i ${it}`)
    })
  })

})
