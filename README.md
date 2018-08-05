A simple file organizer built with nim.

Example ~/.nimfileconfig usage:

```
[~/Documents/Audio] ; Puts files matching the '.mp3' extension under '~/Documents/Audio'
                    ; Creates the directory if not found
.mp3

[src] ; Puts files matching the '.cpp' extension in a directory under the cwd named 'src'
.cpp
```
