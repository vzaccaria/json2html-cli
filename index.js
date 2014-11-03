#!/usr/bin/env node
// Generated by LiveScript 1.3.1
(function(){
  var docopt, glob, jade, _, bb, beml, parse, moment, sh, fs, doc, getOption, o, md, Remarkable, category, dest, oTemplate, oConfig, jsonfile, directory, readJson, renderJsonWLocals, renderJsonWithPostList, renderJsonPost, data, filenames, fn;
  docopt = require('docopt').docopt;
  glob = require('glob');
  jade = require('jade');
  _ = require('underscore');
  bb = require('bluebird');
  beml = require('beml');
  parse = require('./parse').parse;
  moment = require('moment');
  sh = bb.promisifyAll(require('shelljs'));
  fs = require('fs');
  doc = "\nUsage:\n    blog-cli md2json [ input | directory DIR -d DEST ] -t TEMPLATE -c CONFIG \n    blog-cli json2html [ directory -d DEST ] DIR  \n    blog-cli json2json [-k CATEGORY] [ -t TEMPLATE -c CONFIG ] DIR  \n    blog-cli renderjson -f JSON -t TEMPLATE -c CONFIG \n    blog-cli -v | -h | --help \n\nOptions: \n    -t, --template TEMPLATE   Jade template that expands the `post.contents` \n    -c, --config CONFIG       JSON configuration file of the site (has a `baseUrl` property)\n    -d, --destination DEST    Destination directory\n    -k, --filter CATEGORY     Filter by category\n    -f, --file JSON           Render JSON inside the template\n\nArguments: \n    DIR         Source directory\n\n";
  getOption = function(a, b, def, o){
    if (!o[a] && !o[b]) {
      return def;
    } else {
      return o[b];
    }
  };
  o = docopt(doc);
  md = {};
  if (false) {
    Remarkable = require('remarkable');
    md.render = new Remarkable().render;
  } else {
    md.render = require('marked');
  }
  o = docopt(doc);
  fs = bb.promisifyAll(fs);
  category = getOption('-k', '--filter', '', o);
  dest = getOption('-d', '--destination', '', o);
  oTemplate = getOption('-t', '--template', '', o);
  oConfig = getOption('-c', '--config', '', o);
  jsonfile = getOption('-f', '--file', '', o);
  directory = o["DIR"];
  readJson = function(it){
    return JSON.parse(fs.readFileSync(it, 'utf-8'));
  };
  renderJsonWLocals = function(locals){
    var template, conf, result;
    template = fs.readFileSync(oTemplate, 'utf-8');
    conf = readJson(oConfig);
    locals = _.extend(locals, conf);
    locals.filename = oTemplate;
    locals.pretty = true;
    result = jade.compile(template, locals)(locals);
    result = beml.process(result);
    return result;
  };
  renderJsonWithPostList = function(postList){
    return renderJsonWLocals({
      data: postList
    });
  };
  renderJsonPost = function(jj){
    var res;
    jj.post.contents = md.render(jj.mdContent);
    res = renderJsonWLocals({
      post: jj.post
    });
    delete jj.post.contents;
    jj.post.htmlContent = res;
    jj.post.link = jj.post.dirName + "/" + jj.post.fileName + ".html";
    return jj;
  };
  if (o['md2json'] && !o['directory']) {
    data = {};
    if (o['input']) {
      data = parse(fs.readFileSync('/dev/stdin', 'utf-8'));
    } else {
      throw "not supported";
    }
    renderJsonPost(data);
    console.log(JSON.stringify(data, 0, 4));
  }
  if (o['md2json'] && o['directory']) {
    filenames = glob.sync(directory + "/*.md");
    sh.execAsync("mkdir -p " + dest, {
      async: true
    }).then(function(){
      var fn;
      fn = filenames.map(function(f){
        return fs.readFileAsync(f, 'utf-8').then(function(it){
          var data, rendered;
          data = parse(it);
          rendered = renderJsonPost(data);
          return fs.writeFileAsync(dest + "/" + rendered.post.fileName + ".json", JSON.stringify(rendered, 0, 4), 'utf-8');
        });
      });
      return bb.all(fn).then(function(){
        return console.log("done");
      });
    });
  }
  if (o['json2html']) {
    filenames = glob.sync(directory + "/*.json");
    fn = filenames.map(function(f){
      return fs.readFileAsync(f, 'utf-8').then(function(it){
        var post;
        post = JSON.parse(it).post;
        return sh.execAsync("mkdir -p " + dest + "/" + post.dirName, {
          async: true
        }).then(function(){
          return fs.writeFileAsync(dest + "/" + post.dirName + "/" + post.fileName + ".html", post.htmlContent, 'utf-8');
        });
      });
    });
    bb.all(fn).then(function(){
      return console.log("done");
    });
  }
  if (o['json2json']) {
    filenames = glob.sync(directory + "/*.json");
    fn = filenames.map(function(f){
      return fs.readFileAsync(f, 'utf-8').then(function(it){
        var post;
        post = JSON.parse(it).post;
        delete post.htmlContent;
        return post;
      });
    });
    bb.all(fn).then(function(it){
      var filteredPosts;
      filteredPosts = it;
      filteredPosts = _.sortBy(filteredPosts, function(it){
        return -1 * moment(it.date).unix();
      });
      if (category !== "") {
        filteredPosts = _.filter(filteredPosts, function(it){
          return it.category === category;
        });
      }
      if (oTemplate !== '') {
        return console.log(renderJsonWithPostList(filteredPosts));
      } else {
        return console.log(JSON.stringify(filteredPosts, 0, 4));
      }
    });
  }
  if (o['renderjson']) {
    fs.readFileAsync(jsonfile, 'utf-8').then(function(it){
      var data;
      data = JSON.parse(it);
      return console.log(renderJsonWLocals({
        data: data
      }));
    });
  }
}).call(this);
