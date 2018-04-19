#!/usr/bin/env python3
import os
import sys

def main(argv):
    if len(argv) not in [2,3]:
        print("usage: %s <source_dir> [suffix (default .v)]" % argv[0])
        exit(1)

    source_dir = argv[1]
    suffix = ".v" if len(argv) == 2 else argv[2]

    try:
        names = [name for name in os.listdir(source_dir) \
                 if name.endswith(suffix)]
    except:
        print("open dir failed")
        exit(1)

    content = ""
    content_tpl = """
```
// {file_name}
{file_content}
```

"""
    for name in names:
        content += content_tpl.format(file_name=name, file_content=open(os.path.join(source_dir,name)).read())

    print(content)



if __name__ == "__main__":
    main(sys.argv)
