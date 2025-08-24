### Hexlet tests and linter status:
[![Actions Status](https://github.com/TARRAKAN/devops-for-programmers-project-77/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/TARRAKAN/devops-for-programmers-project-77/actions)

Link -> [krasnayaschahta.ru](http://krasnayaschahta.ru)

1. To update yc token use:
```commandline
export YC_TOKEN=$(yc iam create-token)
```
2. To export the terraform variables from the ansible vault use:
```commandline
make get_tf_vars_from_vault
```
3. To prepare thr infrostructure use:
```commandline
make prepare_infrostructure
```
4. To deploy redmine use:
```commandline
make deploy_redmine
```
