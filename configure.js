var {
  generateProject
} = require('diy-build')

generateProject(_ => {

_.livescriptc = (dir, prod, ...deps) => {
    var command = (_) => `((echo '#!/usr/bin/env node') && lsc -p -c ${_.source}) > ${_.product} && chmod +x ${_.product}`
    var product = (_) => prod
    _.compileFiles(...([command, product, dir].concat(deps)))
  }

  _.collectSeq("all", _ => {
    _.collect("build", _ => {
      _.livescriptc("command.ls", "index.js")
      _.livescript("*.ls")

    })
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
