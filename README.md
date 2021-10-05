# Bypass 403

Tool that tests `MANY` url bypass to reach a `40X protected page`.


## How to use?

```bash
git clone https://github.com/rahulMishra05/Bypass-403.git
sudo mv Bypass-403 /opt/ && cd /opt/Bypass-403
./403_bypass.sh http://127.0.0.1/path-to-reach/
```


## Convenient alias

Put it in your `.zshrc` or `.bashrc`

```bash
# Using tee to keep the logs, trust me, you'll need them
alias bypass-403='f(){ /opt/Bypass-403/403_bypass.sh -u $@ 2>&1 | tee bypass-403-$(date "+%Y-%m-%d-%T");  unset -f f; }; f'
```


## Dirty code disclaimer

The code is bad. Like, really bad.

A first python-base approach was made, but the issue if that while we're not using raw sockets, too many wrappers are decoding/encoding the url before sending it to the server, so it was a pain to send our actual payloads to the server, thus here we are, in 2021, using `curl --path-as-is -skg`, and it works smoothly!


## Contribute

1. Fork this repo
1. `git checkout -b "$USER/$FEATURE"`
1. Implement your feature / refactor
1. `git push --set-upstream origin "$USER/$FEATURE"`
1. Create pull request that we'll be happy to review :)

