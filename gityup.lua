#!/usr/bin/env lua

-- Copyright (c) 2011 Kevin D Williams
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.

local lfs = require("lfs")

function isDir(path)
    return lfs.attributes(path,"mode") == "directory"
end

function isGit(root)
    local path = root .. "/.git"
    return isDir(path)
end

local path = arg[1]
for dir in lfs.dir(path) do
  -- ignore "this" and "parent" dirs
  if dir ~= "." and dir ~= ".." then
    local d = path .. "/" .. dir
    if isGit(d) then
      -- process dir
      lfs.chdir(d)
      local xcode = os.execute("git status | grep 'nothing to commit' 2>&1 >/dev/null")
      if xcode == nil then
        print("local changes detected, skipping " .. d)
      else
        local handle = io.popen("git branch --show-current")
        local branchname = handle:read()
        handle:close()
        if #branchname == 0 then
          print("#### detached HEAD state, skipping ####")
        else
          local xcode = os.execute("git config branch." .. branchname .. ".remote 2>&1 >/dev/null")
          if xcode == nil then
            print("no remote to pull from, skipping " .. d)
          else
            print("#### pulling " .. d .. " ####")
            -- lfs.chdir(d)
            os.execute("git smart-pull && git remote update origin --prune")
            print("")
          end
        end
      end
    end
  end
end
