
{docopt} = require('docopt')
glob     = require 'glob'
jade     = require 'jade'
_        = require 'underscore'
bb       = require 'bluebird'
beml     = require('beml')
{parse}  = require('./parse')
moment   = require 'moment'
sh       = bb.promisifyAll(require 'shelljs')
require! 'fs'

# ../website/assets/layouts/post.jade -c ../website/site.json

doc = """

Usage:
    blog-cli md2json [ input | directory DIR -d DEST ] -t TEMPLATE -c CONFIG 
    blog-cli json2html [ directory -d DEST ] DIR  
    blog-cli json2json [-k CATEGORY] [ -t TEMPLATE -c CONFIG ] DIR  
    blog-cli renderjson -f JSON -t TEMPLATE -c CONFIG 
    blog-cli -v | -h | --help 

Options: 
    -t, --template TEMPLATE   Jade template that expands the `post.contents` 
    -c, --config CONFIG       JSON configuration file of the site (has a `baseUrl` property)
    -d, --destination DEST    Destination directory
    -k, --filter CATEGORY     Filter by category
    -f, --file JSON           Render JSON inside the template

Arguments: 
    DIR         Source directory


"""



get-option = (a, b, def, o) ->
    if not o[a] and not o[b]
        return def
    else 
        return o[b]

o = docopt(doc)
# console.log o




md = {}

if false
    Remarkable = require('remarkable');
    md.render = (new Remarkable()).render;
else 
    md.render = require('marked');

o = docopt(doc)

# console.log o

fs = bb.promisifyAll(fs)

category   = get-option('-k' , '--filter'      , '' , o)
dest       = get-option('-d' , '--destination' , '' , o)
o-template = get-option('-t' , '--template'    , '' , o)
o-config   = get-option('-c' , '--config'      , '' , o)
jsonfile   = get-option('-f' , '--file'        , '' , o)
directory  = o["DIR"]

read-json = -> JSON.parse(fs.readFileSync(it, 'utf-8'))

render-json-w-locals = (locals) ->

    template        = fs.readFileSync(o-template, 'utf-8')
    conf            = read-json(o-config)

    locals          = _.extend(locals, conf)
    locals.filename = o-template
    locals.pretty   = true

    result          = jade.compile(template, locals)(locals)
    result          = beml.process(result)
    return result

render-json-with-post-list = (post-list) ->
    render-json-w-locals(data: post-list)


render-json-post = (jj) ->
    jj.post.contents = (md.render(jj.md-content));
    res = render-json-w-locals(post: jj.post)
    delete jj.post.contents 
    jj.post.html-content = res
    jj.post.link = "#{jj.post.dir-name}/#{jj.post.file-name}.html"
    return jj 


if o['md2json'] and not o['directory'] 
        data = {}
        if o['input'] 
            data := parse(fs.readFileSync('/dev/stdin', 'utf-8'))
        else
            throw "not supported"

        render-json-post(data)
        console.log JSON.stringify(data, 0, 4)

if o['md2json'] and o['directory'] 
        filenames = glob.sync("#directory/*.md")
        sh.execAsync("mkdir -p #dest", { +async })
        .then ->
            fn = filenames.map (f) ->
                    fs.readFileAsync(f, 'utf-8').then ->
                        data = parse(it)
                        rendered = render-json-post(data)
                        # console.log "Writing #dest/#{rendered.post.file-name}.json "
                        fs.writeFileAsync("#dest/#{rendered.post.file-name}.json", JSON.stringify(rendered, 0, 4), 'utf-8')
            bb.all(fn).then ->
                console.log "done"

if o['json2html']
    filenames = glob.sync("#directory/*.json")
    fn = filenames.map (f) ->
        fs.readFileAsync(f, 'utf-8').then ->
            {post} = JSON.parse(it) 
            sh.execAsync("mkdir -p #dest/#{post.dir-name}", { +async })
            .then -> 
               fs.writeFileAsync("#dest/#{post.dir-name}/#{post.file-name}.html", post.html-content, 'utf-8')

    bb.all(fn).then ->
        console.log "done"

if o['json2json'] 
    filenames = glob.sync("#directory/*.json")

    fn = filenames.map (f) ->
            fs.readFileAsync(f, 'utf-8').then ->
                {post} = JSON.parse(it) 
                delete post.html-content
                return post

    bb.all(fn).then ->
        filtered-posts = it
        filtered-posts = _.sort-by(filtered-posts, -> -1*moment(it.date).unix())
        if category != ""
            filtered-posts := _.filter(filtered-posts, (-> it.category == category))

        if o-template != ''
            console.log render-json-with-post-list(filtered-posts)
        else
            console.log JSON.stringify(filtered-posts, 0, 4)

if o['renderjson'] 
            fs.readFileAsync(jsonfile, 'utf-8').then ->
                data = JSON.parse(it)    
                console.log render-json-w-locals(data: data)







