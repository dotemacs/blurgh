### Description

Simple blog in sinatra with Github style syntax highlighting

Posts are stored as Markdown files


### Usage

```
$ git clone git@github.com:dotemacs/blurgh.git
$ cd blurgh
$ git checkout -b mine
$ bundle
$ $EDITOR setup.yaml
$ $EDITOR posts/your-post.md  # add a post
$ shotgun blurgh.rb
```

Make sure that you have python's pygments installed, **pygments.rb**
gem uses it to parse and highlight the code


### Note

Helpers for Google analytics and Clicky

Posts use **.md** extensions

Blurgh URL's are in format of:
   http://domain/file-name
  and not
   http://domain/yyyy/mm/dd/file-name

**syntax_highlight** method taken from Lee Jarvis via Ryan Bates, but
modified as it uses **pygments.rb**

Originally started as a tutorial for http://ruby.rs
