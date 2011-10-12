Collection of tools that helps investigate diffference between CSS results.


### Requirements

In order to run them, you'll need:

* Ruby + SASS gem
  `gem install sass`
* Node.JS + LESS module
  `npm install less`


### Tools

* `css_compressor` compresses (wipes out all comments etc) CSS from STDIN and
  outputs pure clean CSS to STDOUT.
* `css_diff a.css b.css` shows different between `a.css` and `b.css`. Each
  difference may be `line` (tags+rules hash presented in one file and not foun
  in another), `tags` (difference in tags`, `rules` (difference in rules).


### Usage

    $ lessc ./src/lib/bootstrap.less | ./support/css_compressor > less.css
    $ sass ./lib/bootstrap.scss | ./support/css_compressor > sass.css
    $ ./support/css_diff less.css sass.css


### Credits

* css_parser.rb - contains code extracted from Blueprint CSS framework
* hash_diff.rb  - contains code extracted from ActiveRecord


### License

`css_compressor` and `css_diff` are made available under terms of WTFPL.
