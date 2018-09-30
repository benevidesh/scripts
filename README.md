# Scripts

Some of my personal scripts


### BibPhil

A script to download philosophy papers using PhilPapers links. Sometimes the script uses sci-hub site. So, in such a case, the download may be illegal.

a) Download the script

```bash
curl -O https://raw.githubusercontent.com/hbenevides/scripts/master/bibphil
```

b) Make `bibphil` executable.

```bash
$ chmod +x bibphil
```


c) How to use it.

```bash
$ ./bibphil https://philpapers.org/rec/ATTWOT
```

If you like use it system wide, then the file must be put on `/usr/local/bin`. 
