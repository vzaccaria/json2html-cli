#!/usr/bin/env sh
set -e

# Source directory
#
srcdir=`dirname $0`
srcdir=`cd $srcdir; pwd`
dstdir=`pwd`

npm="$srcdir/../node_modules/.bin"

bindir=$srcdir/..
postsrcdir=$srcdir/fixtures/posts
postdstdir=$srcdir/temp
template=$srcdir/fixtures/layouts/post.jade
config=$srcdir/fixtures/site.json
refdir=$srcdir/ref

#  _            _    ___  
# | |_ ___  ___| |_ / _ \ 
# | __/ _ \/ __| __| | | |
# | ||  __/\__ \ |_| |_| |
#  \__\___||___/\__|\___/ 
                        

rm -rf $postdstdir
mkdir $postdstdir
$bindir/index.js md2json directory $postsrcdir -d $postdstdir -t $template -c $config

ref0=$refdir/lezione-del-81-su-sistemi-operativi-memoria-processi.json
tem0=$postdstdir/lezione-del-81-su-sistemi-operativi-memoria-processi.json
$npm/diff-files $ref0 $tem0 -m "Test generate json with html inside."

#  _            _   _ 
# | |_ ___  ___| |_/ |
# | __/ _ \/ __| __| |
# | ||  __/\__ \ |_| |
#  \__\___||___/\__|_|

template=$srcdir/fixtures/blog.jade
ref1=$refdir/blog.html
tem1=$postdstdir/blog.html
$bindir/index.js json2json $postdstdir -k infob -t $template -c $config > $postdstdir/blog.html
$npm/diff-files $ref1 $tem1 -m "Test generation of html toc from json"

