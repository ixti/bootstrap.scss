diff:
	echo \
		&& lessc src/lib/bootstrap.less | support/css_compressor > /tmp/bootstrap-less.css \
		&& sass lib/bootstrap.scss | support/css_compressor > /tmp/bootstrap-sass.css \
		&& support/css_diff /tmp/bootstrap-less.css /tmp/bootstrap-sass.css \
		&& rm /tmp/bootstrap-less.css /tmp/bootstrap-sass.css
