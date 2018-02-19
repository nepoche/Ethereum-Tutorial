# Welcome to the Ethereum Tutorial!

# To get all the branches from git:

    git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done
    git fetch --all
    git pull --all

# Useful links 

Solidity documentation: https://solidity.readthedocs.io/en/develop/

Truffle documentation: http://truffleframework.com/docs/

