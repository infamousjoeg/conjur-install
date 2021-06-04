# infamousjoeg/conjur-install <!-- omit in toc -->

Home of the script that lives at `https://cybr.rocks/conjur-install`!

[![](https://github.com/infamousjoeg/conjur-install/workflows/CI/badge.svg)](https://github.com/infamousjoeg/conjur-install/actions?workflow=CI)

The purpose of the install script is for a convenience for quickly
installing the latest Docker-CE releases, Docker Compose releases, and Conjur on the supported linux
distros. It is not recommended to deploy Conjur Open Source
to production systems. For more thorough instructions for installing
on the supported distros, see the [install
instructions](https://conjur.org).

This repository is solely maintained by Joe Garcia, CISSP. It is not officially supported by CyberArk.

- [Usage](#usage)
    - [From `https://cybr.rocks/conjur-install`](#from-httpscybrrocksconjur-install)
    - [To review the output script first](#to-review-the-output-script-first)
    - [From the source repo](#from-the-source-repo)
    - [Skip apt/yum update for faster deployment](#skip-aptyum-update-for-faster-deployment)
- [Video of Usage](#video-of-usage)
  - [Ubuntu 18.04](#ubuntu-1804)
  - [CentOS 7](#centos-7)
- [Reporting Security Issues](#reporting-security-issues)
- [Licensing](#licensing)

## Usage

#### From `https://cybr.rocks/conjur-install`

```shell
curl -fsSL https://cybr.rocks/conjur-install | bash -s
```

#### To review the output script first

```shell
curl -fsSL https://cybr.rocks/conjur-install -o conjur-install.sh
./conjur-install.sh
```

#### From the source repo

```shell
./install.sh
```

#### Skip apt/yum update for faster deployment

```shell
curl -fsSL https://cybr.rocks/conjur-install | 
```

## Video of Usage

### Ubuntu 18.04

[![asciicast](https://asciinema.org/a/221614.svg)](https://asciinema.org/a/221614)

### CentOS 7

[![asciicast](https://asciinema.org/a/222131.svg)](https://asciinema.org/a/222131)

## Reporting Security Issues

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

[![Buy me a coffee][buymeacoffee-shield]][buymeacoffee]

[buymeacoffee]: https://www.buymeacoffee.com/infamousjoeg
[buymeacoffee-shield]: https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png
