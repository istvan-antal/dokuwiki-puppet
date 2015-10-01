#!/bin/bash
wget http://download.dokuwiki.org/src/dokuwiki/dokuwiki-$1.tgz
tar xvf dokuwiki-$1.tgz
rm dokuwiki-$1.tgz
mv dokuwiki-$1 web