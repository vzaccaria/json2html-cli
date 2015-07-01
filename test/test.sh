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

rm -rf $postdstdir
mkdir $postdstdir
$bindir/index.js md2json directory $postsrcdir -d $postdstdir -t $template -c $config

ref0=$refdir/lezione-del-81-su-sistemi-operativi-memoria-processi.json
tem0=$postdstdir/lezione-del-81-su-sistemi-operativi-memoria-processi.json
$npm/diff-files $ref0 $tem0 -m "Test generate json with html inside."

