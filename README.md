# Symfony Standard Vagrant Edition

This repo builds a [symfony-standard][1] based application within a Vagrant provisioned VM.

This can be used to quickly get aup and running with a new Symfony project.

Included:

* [Symfony Standard Edition][1] with extra dependencies on [Behat][2] and [PHPSpec][3]
* Ubuntu Server (precise64)
* All the usual suspects (vim, tmux etc)
* Apache 2.4
* PHP 5.4
* Mysql 5.6
* NodeJS (latest)
* Ruby (Latest)
* Sass & Compass
* Capifony
* Grunt
* Bower
* PhantomJS
* Mocha & Mocha Gherkin

It should be noted that the scripts within the vagrant/scripts directory were taken almost verbosely from the awesome [Vaprobash][4] project.

# Installation

```shell
git clone https://github.com/trq/symfony-vagrant-standard.git project_dir
cd project_dir

# If you haven't already, install the vagrant-bindfs plugin for vagrant
vagrant plugin install vagrant-bindfs

vagrant up

# Add the dev.lcl hostname to your hosts file:
echo "192.168.10.10 wr.lcl" | sudo tee -e /etc/hosts

# You should apply the following patch to the AppKernel to improve performance when using an NSF filesystems
cd app && patch < ../vagrant/files/app_kernel.patch
```

Now visit http://dev.lcl in your brooser.

[1]: https://github.com/symfony/symfony-standard
[2]: http://behat.org
[3]: http://phpspec.net
[4]: https://github.com/fideloper/Vaprobash
