andrewrothstein.openjdk
=========
[![Build Status](https://travis-ci.org/andrewrothstein/ansible-openjdk.svg?branch=master)](https://travis-ci.org/andrewrothstein/ansible-openjdk)

Installs [AdoptOpenJDK](https://adoptopenjdk.net/)

Requirements
------------

See [meta/main.yml](meta/main.yml)

Role Variables
--------------

See [defaults/main.yml](defaults/main.yml)

Dependencies
------------

See [meta/main.yml](meta/main.yml)

Example Playbook
----------------

```yml
- hosts: servers
  roles:
    - andrewrothstein.openjdk
```

More complex examples, with a specific version of Java and a choice between JRE and JDK

```yml
- hosts: servers
  roles:
    - role: andrewrothstein.openjdk
      openjdk_app: jre
      openjdk_ver:
        major: 8
        minor: 242
        b: '08'
    - role: andrewrothstein.openjdk
      openjdk_app: jdk
      openjdk_ver:
        major: 11
        minor: 0
        patch: 8
        b: 10
```


License
-------

MIT

Author Information
------------------

Andrew Rothstein <andrew.rothstein@gmail.com>
