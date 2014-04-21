Swapzapp
========

Swapzapp POS system

Installation
------------

You will need to have a server capable of allowing subdomains. [http://pow.cx](Pow) is a good choice.

    $ curl get.pow.cx | sh

After cloning this repository to get set up do the following:

    $ cd swapzapp
    $ bundle install
    $ powify create
    $ powify open
    
If everything works you should get a 404 page at swapzapp.dev

You need to generate some fake data to get started

    $ rake fakeout:small
    
After that completes you should have an account with the following credentials

    email: example@example.com
    password: password
    
Go to [http://example.swapzapp.dev](http://example.swapzapp.dev) and login!