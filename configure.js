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

	_.collect("docs", _ => {
		_.cmd("./node_modules/.bin/mustache package.json docs/readme.md | ./node_modules/.bin/stupid-replace '~USAGE~' -f docs/usage.md > readme.md")
	})

})
