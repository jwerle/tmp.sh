tmp.sh
======

Execute bash commands in your TMPDIR context

## install

```sh
$ bpkg install jwerle/tmp.sh
```

## usage

```sh
usage: tmp [-hwV] [-d tmpdir] <command>
```

## examples

List files using `ls`

```sh
$ tmp ls -la
total 8
drwx------  36 werle  staff  1224 Jul 21 14:42 .
drwxr-xr-x   5 werle  staff   170 Jul 14 12:40 ..
drwx------   3 werle  staff   102 Jul 18 10:24 .AddressBookLocks
drwx------   2 werle  staff    68 Jul 14 12:40 .CalendarLocks
drwx------@  2 werle  staff    68 Jul 14 12:51 Cleanup At Startup
...
```

Output your set `TMPDIR`

```sh
$ tmp -w
/var/folders/lt/2dwf57sd6k525m58m1hc10nm0000gn/T/
```

Set `TMPDIR` context for command

```sh
$ tmp -d ~/tmp 'touch foo && ls -la'
```

Execute script with set context

`file.sh`:

```sh
#!/usr/bin/env tmp -d ~/tmp

touch foo
echo 123 >> foo
cat foo
```

```sh
$ ./file.sh
```

```
123
```

## license

MIT

