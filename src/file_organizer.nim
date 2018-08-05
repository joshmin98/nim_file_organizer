import os
import parsecfg
import re
import strutils
import tables

proc getSections(dict: Config): seq[string] =
  result = newSeq[string]()
  for key in dict.keys:
    result.add(key)

proc getSectionContents(dict: Config, section: string): seq[string] =
  result = newSeq[string]()
  if dict.hasKey(section):
    for key in dict[section].keys:
      result.add(key)
 
var
  cwd: string = getCurrentDir()
  cwd_files: seq[string] = newSeq[string]()
  directories = newTable[string, seq[string]]()
  file_formats = newTable[string, string]()
  config: Config
  
try:
  config = loadConfig(expandTilde("~/.nimfileconfig"))
except:
  # TODO: Create config here
  echo "No config."

for section in config.getSections():
  for content in config.getSectionContents(section):
    file_formats.add(content, section)
    if not directories.hasKey(section):
      directories.add(section, newSeq[string]())
    directories[section].add(content)

for kind, path in walkDir(cwd):
  cwd_files.add(path)

for file in cwd_files:
  var
    extention_location = file.find(re"(\.[a-zA-Z0-9]{1,}$)")
    extention: string
  if extention_location != -1:
    extention = file.substr(extention_location, len(file) - 1)
  else:
    continue
  if not file_formats.hasKey(extention):
    continue

  var
    new_dir: string
  if not file_formats[extention].contains("/"):
    cwd.add("/")
    new_dir = cwd
    new_dir.add(file_formats[extention])
  else:
    new_dir = expandTilde(file_formats[extention])

  var
    filename_location = file.find(re"\w+(?:\.\w+)*$")
    filename = file.substr(filename_location, len(file) - 1)

  new_dir.add("/")
  discard existsOrCreateDir(new_dir)
  new_dir.add(filename)
  moveFile(file, new_dir)
