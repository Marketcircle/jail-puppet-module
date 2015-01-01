# jail

[![Build Status](https://travis-ci.org/Marketcircle/jail-puppet-module.svg)](https://travis-ci.org/Marketcircle/jail-puppet-module)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with jail](#setup)
    * [What jail affects](#what-jail-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with jail](#beginning-with-jail)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module creates and manages FreeBSD jails.

## Module Description

## Setup

### What jail affects

* A list of files, packages, services, or operations that the module will alter,
  impact, or execute on the system it's installed on.
* This is a great place to stick any warnings.
* Can be in list or paragraph form.

### Setup Requirements **OPTIONAL**

If your module requires anything extra before setting up (pluginsync enabled,
etc.), mention it here.

### Beginning with jail

This module creates and manages FreeBSD jails. It is possible to create simple jails and use them as seperate systems.
The module also allows to generate ezjail style basejails. Basejails are like templates for other jails, that allow
to not duplicate the system data.

## Usage

### Setting up the host

```
include jail
```



### Create a jail

#### Create basic jail

A basic jail will download FreeBSD from the FreeBSD FTP servers.

```
jail::jail {'myjail':

}
```
#### Create a base jail and 2 jails

```
jail::jail {'mybase':
}
jail::jail {'jail1:
  hostname => "jail1.example.com"
  basejail => "mybase"
}
jail::jail {'jail2:
  hostname => "jail2.example.com"
  basejail => "mybase"
}

```

## Limitations

At this point only FreeBSD 10 is supported. Older versions of FreeBSD might work, however the installation of puppet
within the jail uses the pkg(8) utility.

