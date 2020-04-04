#### some sketches for testing purposes 


In order to create or access kube resources from cli -  `KUBECONFIG` env should be set:
```shell script
export KUBECONFIG=~/kubeconfig
```
-------

#### [Dashboard]

```shell script
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta1/aio/deploy/recommended.yaml
kubectl apply -f https://gist.githubusercontent.com/chukaofili/9e94d966e73566eba5abdca7ccb067e6/raw/0f17cd37d2932fb4c3a2e7f4434d08bc64432090/k8s-dashboard-admin-user.yaml
kubectl describe sa admin-user -n kube-system
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')
```


route external dashboard as local
```shell script
ssh -L 9999:127.0.0.1:8001 -N root@remote_address
```

```shell script
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
http://localhost:9999/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
```

---

#### [influx-db]

add monitoring namespace firstly:
```shell script
kubectl apply -f ns_monitoring.yml
```

check it out:
```shell script
kubectl describe namespace monitoring
```

add influx secrets
```shell script
kubectl create secret generic influxdb-creds \
  --from-literal=INFLUXDB_DATABASE=mydb \
  --from-literal=INFLUXDB_USERNAME=root \
  --from-literal=INFLUXDB_PASSWORD=root \
  --from-literal=INFLUXDB_HOST=influxdb
```

check it out:
```shell script
kubectl describe secret influxdb-creds
```

deploy bundle then:
```shell script
kubectl apply -f influxdb.yaml
```

check it out:
```shell script
kubectl describe deployment influxdb -n monitoring
```
-----

#### [telegraf]

add monitoring namespace firstly:
```shell script
kubectl apply -f ns_monitoring.yml
```

check it out:
```shell script
kubectl describe namespace monitoring
```

add telegraf secrets
```shell script
kubectl create secret generic telegraf \     
    --from-literal=env=prod \
    --from-literal=monitor_username=root \
    --from-literal=monitor_password=root \
    --from-literal=monitor_host=http://influxdb:8086 \
    --from-literal=monitor_database=mydb
```
check it out:
```shell script
kubectl describe secret telegraf
```

deploy bundle then:
```shell script
kubectl apply -f telegraf.yaml
```

check it out:
```shell script
kubectl describe daemonset telegraf -n monitoring
```

-------

#### [grafana]

add monitoring namespace firstly:
```shell script
kubectl apply -f ns_monitoring.yml
```

check it out:
```shell script
kubectl describe namespace monitoring
```

add grafana secrets
```shell script
kubectl create secret generic grafana-creds \
  --from-literal=GF_SECURITY_ADMIN_USER=admin \
  --from-literal=GF_SECURITY_ADMIN_PASSWORD=admin
```

check it out:
```shell script
kubectl describe secret grafana-creds
```

deploy bundle then:
```shell script
kubectl apply -f grafana.yaml
```

check it out:
```shell script
kubectl describe deployment grafana -n monitoring
```

---

#### [kapacitor]

add monitoring namespace firstly:
```shell script
kubectl apply -f ns_monitoring.yml
```

check it out:
```shell script
kubectl describe namespace monitoring
```

add kapacitor secrets
```shell script
kubectl create secret generic kapacitor-creds \  
    --from-literal=KAPACITOR_INFLUXDB_0_URLS_0=http://influxdb:8086 \
    --from-literal=KAPACITOR_USER=root \
    --from-literal=KAPACITOR_PASS=root
```

check it out:
```shell script
kubectl describe secret kapacitor-creds
```

deploy bundle then:
```shell script
kubectl apply -f kapacitor.yaml
```

check it out:
```shell script
kubectl describe deployment kapacitor -n monitoring
```

----