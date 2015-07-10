# First get Craft downloaded and setup
wget -O latest.zip http://buildwithcraft.com/latest.zip?accept_license=yes
mv latest.zip?accept_license=yes latest.zip
unzip latest.zip
rm latest.zip
mv public public_html
mv craft/templates templates
mv craft/plugins plugins

mkdir craft/config/local
cp craft/config/db.php craft/config/local/db.php
cp craft/config/general.php craft/config/local/general.php

mkdir public_html/assets

rm craft/config/db.php
rm craft/config/general.php
rm public_html/index.php
rm .gitignore

cp craft-templates/db.php craft/config/db.php
cp craft-templates/general.php craft/config/general.php
cp craft-templates/index.php public_html/index.php
cp craft-templates/gitignore.txt .gitignore
cp craft-templates/craftignore.txt .craftignore
cp craft-templates/local.general.php craft/config/local/general.php

rm -rf craft-templates

mkdir db_backups
mkdir db_backups/local
mkdir db_backups/staging
mkdir db_backups/production

# now the build templates mostly from html5 boilerplate
rm public_html/htaccess
rm public_html/web.config

cp build-templates/apple-touch-icon.png public_html/apple-touch-icon.png
cp build-templates/browserconfig.xml public_html/browserconfig.xml
cp build-templates/crossdomain.xml public_html/crossdomain.xml
cp build-templates/favicon.ico public_html/favicon.ico
cp build-templates/humans.txt public_html/humans.txt
cp build-templates/robots.txt public_html/robots.txt

cp build-templates/_layout.html templates/_layout.html

# copy whole src folder as starting point
cp -r build-templates/src public_html/src

rm -rf build-templates

# now npm & bower install
npm install
bower install

# more bower files into place
mkdir public_html/src/js/vendor
cp public_html/src/bower_components/jquery/dist/jquery.js public_html/src/js/vendor/jquery.js
cp -r public_html/src/bower_components/bootstrap-sass-official/assets/fonts/* public_html/src/fonts