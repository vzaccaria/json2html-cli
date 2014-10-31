
{docopt} = require('docopt')
glob     = require 'glob'
jade     = require 'jade'
_        = require 'underscore'
bb       = require 'bluebird'
beml     = require('beml')
{parse}  = require('./parse')
sh       = bb.promisifyAll(require 'shelljs')
require! 'fs'

# ../website/assets/layouts/post.jade -c ../website/site.json

doc = """

Usage:
    json2html-cli markdown [ input | directory DIR -d DEST ] -t TEMPLATE -c CONFIG 
    json2html-cli html directory DIR -d DEST 
    json2html-cli -v | -h | --help 

Options: 
    -t, --template TEMPLATE   Jade template that expands the `post.contents` 
    -c, --config CONFIG       JSON configuration file of the site (has a `baseUrl` property)
    -d, --dest DEST           Destination directory

Arguments: 
    DIR         Source directory

Description: 
    Command `html` unwraps each post's html-content in DEST for 
    each `json` file in DIR. It uses the post's date to create 
    appropriate directories.

    Command `markdown` is somewhat a preliminary step. It converts 
    markdown files to `.json` by: 

        - rendering markdown with marked 

        - rendering the blog post with jade template TEMPLATE 

    The html output is posted to the `post.html-content` property.
    This post either accepts a file from standard input (`input` command) or
    a directory with markdown files (DIR).

"""






# Description: 

#     # When using `json` command 

#     You have one or a bunch of json files that contain yaml data 
#     and markdown (yep, like blog posts).

#     This program lets you generate html for each one of those
#     by: 

#         - rendering markdown with marked 

#         - rendering the blog post with jade template <template>

#     This program generates a new json where the content has been 
#     substituted with the html equivalent.

#     # When using `md`
#     Expects a yaml formatted markdown instead of a json file.

#     # When using `dir` command

#     If the `dir` command is used, all json files in DIR are unwrapped
#     and the html is put into DEST following nested dirs post conventions.

# Options:
#     * DIR is the directory containing all the json files. 

#     * JSON is the name of a single json file. It should have a mdContent property 
#       with the suitable markup. Instead, if you prefer to read from stdin, replace
#       the name with the keyword `in`.

#     * TEMPLATE is the name of the jade file to be used as template. 

#     * CONFIG is a sitewide set of variables to be included in jade's locals.

#     * DEST is the directory that will contain the final html files. 
#       If it is not specified, it is intended equal toDIR 
    
# """


md = {}

if false
    Remarkable = require('remarkable');
    md.render = (new Remarkable()).render;
else 
    md.render = require('marked');

o = docopt(doc)

# console.log o

fs = bb.promisifyAll(fs)

o-template ?= o['-t']
o-template ?= o['--template']

o-config ?= o['-c']
o-config ?= o['--config']

read-json = -> JSON.parse(fs.readFileSync(it, 'utf-8'))


render-json = (jj) ->
    jj.post.contents = (md.render(jj.md-content));
    conf    = read-json(o-config)
    locals  = 
          post: jj.post
          filename: o-template
          pretty: true 

    locals   = _.extend(locals, conf)
    template = fs.readFileSync(o-template, 'utf-8')
    result   = jade.compile(template, locals)(locals)
    result   = beml.process(result)
    delete jj.post.contents 
    jj.post.html-content = result
    return jj 


if o['markdown']
    if not o['directory'] 
        data = {}
        if o['input'] 
            data := parse(fs.readFileSync('/dev/stdin', 'utf-8'))
        else
            throw "not supported"

        render-json(data)
        console.log JSON.stringify(data, 0, 4)
    else
        directory = o["DIR"]
        filenames = glob.sync("#directory/*.md")
        dest = o["-d"]
        sh.execAsync("mkdir -p #dest", { +async })
        .then ->
            fn = filenames.map (f) ->
                    fs.readFileAsync(f, 'utf-8').then ->
                        data = parse(it)
                        rendered = render-json(data)
                        # console.log "Writing #dest/#{rendered.post.file-name}.json "
                        fs.writeFileAsync("#dest/#{rendered.post.file-name}.json", JSON.stringify(rendered, 0, 4), 'utf-8')
            bb.all(fn).then ->
                console.log "done"

else
    if not o['directory'] 
        data = {}
        if o['input'] 
            data := JSON.parse(fs.readFileSync('/dev/stdin', 'utf-8'))
        else
            data := read-json(o["JSON"])

        render-json(data)
        console.log JSON.stringify(data, 0, 4)
    else 
        directory = o["DIR"]
        filenames = glob.sync("#directory/*.json")
        dest = o["-d"]
        fn = filenames.map (f) ->
            fs.readFileAsync(f, 'utf-8').then ->
                {post} = JSON.parse(it) 
                sh.execAsync("mkdir -p #dest/#{post.dir-name}", { +async })
                .then -> 
                   fs.writeFileAsync("#dest/#{post.dir-name}/#{post.file-name}.html", post.html-content, 'utf-8')

        bb.all(fn).then ->
            console.log "done"





