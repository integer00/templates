
In order to provide some logic to ansible -  `ANSIBLE_VARS` env should be set:

```shell script
export ANSIBLE_VARS='{foo: True}'
```

General way to execute playbooks from laptop
```shell script
ansible-playbook -i inventory playbook.yml --extra-vars "@ansible-vars.json" --extra-vars "$ANSIBLE_VARS"
```
