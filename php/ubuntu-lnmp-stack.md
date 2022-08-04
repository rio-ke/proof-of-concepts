## ubuntu-lnmp-stack.md

| USERNAME | IP ADDRESS | PASSWORD | OPERATING SYSTEM | DOMAIN | SSL CERTIFICATE |
|---|---|---|---|---|---|
|ubuntu|20.222.90.150|Password@123| ubuntu | fourtimes.ml | |

_Configure the nginx_

```bash


```

_Configure the MySQL_

```bash


```

_Configure the PhpMyAdmin_

```bash


```

_Configure the Php_

 **PHP **


PHP is the language that is mostly used for server-side programming. It is executed, run, and must be installed on the webserver. Since it is an interpreted language, it doesn’t need any compiler. PHP handles the interaction between the front-end of the web pages and the back-end servers or databases.


Installation of PHP on Ubuntu 20.04 LTS

Before getting started with the installation of PHP, first, always update Ubuntu’s package repository.

```bash
sudo apt update
```

Next, install software-properties-common, which adds management for additional software

```bash
sudo apt -y install software-properties-common
```
Next, install the repository ppa:ondrej/php, which will give you all your versions of PHP:

```bash
sudo add-apt-repository ppa:ondrej/php
```

You have Nginx installed to serve your content and MySQL installed to store and manage your data. Now you can install PHP to process code and generate dynamic content for the web server.

While Apache embeds the PHP interpreter in each request, Nginx requires an external program to handle PHP processing and act as a bridge between the PHP interpreter itself and the web server. This allows for a better overall performance in most PHP-based websites, but it requires additional configuration. You’ll need to install php-fpm, which stands for “PHP fastCGI process manager”, and tell Nginx to pass PHP requests to this software for processing. Additionally, you’ll need php-mysql, a PHP module that allows PHP to communicate with MySQL-based databases. Core PHP packages will automatically be installed as dependencies.

To install the php-fpm and php-mysql packages, run:

```bash
sudo apt install php-fpm php-mysql

```


Check the version installed:

```bash
php -v
```





















```bash


```

_Configure the Vsftpd_

```bash


```
