# Konsole Profile and Utilities

## Installing

### For current user only
1. Extract the binary tarball into your current user data directory ($HOME/.local):

```shell
tar -C $HOME/.local -xzvf vinyl-konsole-*-.tar.gz
```

2. Optionally source the scripts on profile.d directory from your .bashrc. Add the
follow lines to your .bashrc file:

```shell
# Loads Konsole scripts
if [ -d ~/.local/share/konsole/profile.d ]; then
        for file in ~/.local/share/konsole/profile.d/*; do
                if [ -f "$file" ]; then
                        . "$file"
                fi
        done
        unset file
fi
```

### For all users (globally)
1. Extract the binary tarball into the global prefix directory (usually /usr):

```shell
tar -C /usr -xzvf vinyl-konsole-*-.tar.gz
```

2. Optionally link the scripts on profile.d diretory to your global /etc/profile.d 
directory:

```shell
cd /etc/profile.d
ln -sf /usr/share/konsole/profile.d/*.sh .
```
