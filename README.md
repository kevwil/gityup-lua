Git Multi-Pull
==============

My standard scenario for learning new languages is to write a tool that
loops through child directories of a given directory and tries to pull
updates from remote repositories.

Examples
--------

I did this a few years ago with Haskell, although I was using [Subversion](http://subversion.apache.org/)
at the time.

[svnup-haskell](https://github.com/kevwil/svnup-haskell)

I've done it with Windows Powershell and Bash shell scripting too, but those aren't published.

Dependencies
------------

At the time of this writing, I was using Lua 5.1.4. I have not tested past or future versions,
but I would expect them to work.

Because Lua doesn't have a built-in way to iterate through directories, I used the
[LuaRocks](http://luarocks.org/) module "LuaFileSystem". You'll need to have that module
installed for this to work.

License
-------

Standard BSD, I believe.

