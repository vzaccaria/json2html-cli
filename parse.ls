

_module = ->


    y        = require('js-yaml')
    moment   = require('moment')
    _        = require('underscore')
    _.str    = require('underscore.string');

    _.mixin(_.str.exports());
    _.str.include('Underscore.string', 'string');


    parse = (file) ->
        yaml = ""
        content = ""
        is-yaml = false
        for l in _.lines(file)
            if is-yaml
                if l == /^---$/
                    is-yaml := false
                else
                    yaml := yaml + "\n" + l
            else
                if l == /^---$/
                    is-yaml := true
                    yaml := yaml + "\n" + l
                else
                    content := content + "\n" + l

        data                   = {}

        post                   = y.safeLoad(yaml)
        post.formatted-date    = moment(post.date).format('dddd, MMMM Do YYYY')
        post.small-date        = moment(post.date).format('M/D')
        post.small-description = _(post.description).prune(70, '..')
        post.dir-name          = "#{post.category}/" + moment(post.date).format('YYYY/MM/DD');
        post.file-name         = _.slugify(post.title)
        data.post              = post
        data.md-content        = content
        return data
       
          
    iface = { 
        parse: parse
    }
  
    return iface
 
module.exports = _module()

# Add this to package.json:
#
#  "dependencies": {
#    "moment": "~1.7.2",
#    "underscore": "~1.4.3",
#    "underscore.string": "~2.3.1",
#    "ansi-color": "*",
#    "shelljs": "*",
#    "q": "*",
#  },