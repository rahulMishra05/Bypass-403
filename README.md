# Bypass 403

Tool that tests MANY url bypass to reach a 40X protected page.


## How to use?

```bash
git clone https://github.com/rahulMishra05/Bypass-403.git
sudo mv Bypass-403 /opt/ && cd /opt/Bypass-403
./403_bypass.sh http://127.0.0.1/path-to-reach/
```


## Convenient alias

```bash
echo "alias bypass-403='/opt/Bypass-403/403_bypass.sh -u'" >> ~/.bashrc
echo "alias bypass-403='/opt/Bypass-403/403_bypass.sh -u'" >> ~/.zshrc
```


## Contribute

1. Fork
1. `git checkout -b "$USER/$FEATURE"`
1. Implement your feature / refactor
1. `git push --set-upstream origin "$USER/$FEATURE"`
1. Create pull request that we'll be happy to review :)

