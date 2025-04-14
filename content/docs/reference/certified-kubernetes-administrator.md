---
title: "Certified Kubernetes Administrator (CKA)"
description: "Resources to help with CKA certification."
summary: ""
date: 2023-09-07T16:13:18+02:00
lastmod: 2023-09-07T16:13:18+02:00
draft: false
weight: 910
toc: true
seo:
  title: "" # custom title (optional)
  description: "" # custom description (recommended)
  canonical: "" # custom canonical URL (optional)
  robots: "" # custom robot tags (optional)
---

## Certified Kubernetes Administrator (CKA)

- The [Certified Kubernetes Administrator (CKA)](https://training.linuxfoundation.org/certification/certified-kubernetes-administrator-cka/) certification
- A [Certified Kubernetes Administrator (CKA) with Practice Tests](https://www.udemy.com/share/101WmE3@ggPePAgbaNO6slJ7gaU6UmU3TfoakpDVG_7Se0B6yzZNDMJrvb8pnKi_HJtlJYFS/) course on Udemy
- [Exam Curriculum](https://github.com/cncf/curriculum)
- [Candidate Handbook](https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2)

## Notes

### Pods
```shell
kubectl run nginx --image nginx
kubectl describe pod <name>
kubectl delete pod <name>
kubectl get pods -o wide
```

Create a redis pod manifest and export to yaml
```shell
kubectl run redis --image redis --dry-run=client -o yaml
```

```yml
apiVersion: v1
kind: Pod
metadata:
  name: redis
  labels:
    app: redis
spec:
  containers:
    - name: redis
      image: redis
```
Apply with
```shell
kubectl create -f redis-pod.yml

# To update existing
kubectl apply -f redis-pod.yml
```

### Replica Sets
```shell
kubectl describe replicaset <name>
kubectl create -f file.yaml
kubectl explain replicaset
kubectl edit rs <name>
kubectl scale rs <name> --replicas=5
```

### Deployments
```shell
kubectl create deployment --image=nginx nginx

kubectl create deployment --image=nginx nginx --dry-run=client -o yaml

kubectl create -f nginx-deployment.yaml
```
