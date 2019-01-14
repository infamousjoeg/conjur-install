# infamousjoeg/conjur-install
Home of the script that lives at `conjur.cybr.rocks`!

The purpose of the install script is for a convenience for quickly
installing the latest Docker-CE releases, Docker Compose releases, and Conjur on the supported linux
distros. It is not recommended to deploy Conjur Open Source
to production systems. For more thorough instructions for installing
on the supported distros, see the [install
instructions](https://conjur.org).

This repository is solely maintained by Joe Garcia, CISSP. It is not officially supported by CyberArk.

## Usage:

From `https://conjur.cybr.rocks`:
```shell
curl -fsSL https://conjur.cybr.rocks | bash -s
```

From the source repo:
```shell
./install.sh
```

## Reporting security issues

The maintainer takes security seriously. If you discover a security issue,
please bring it to my attention right away!

Please **DO NOT** file a public issue, instead send your report privately to
[security@joe-garcia.com](mailto:security@joe-garcia.com).

Security reports are greatly appreciated and I will publicly thank you for it.
I also like to send gifts — if you're into schwag, make sure to let
me know. I currently do not offer a paid security bounty program, nor does CyberArk Software.

## Licensing

infamousjoeg/conjur-install is licensed under the Apache License, Version 2.0.
See [LICENSE](LICENSE) for the full license text.