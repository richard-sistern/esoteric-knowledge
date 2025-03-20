---
title: "Kubernetes Reference"
description: "Notes from the CKA course."
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

## Kubectl

### Pods
```shell
kubectl run nginx --image nginx
kubectl describe pod <name>
kubectl delete pod <name>
kubectl get pods -o wide
```

Create a pod with yaml
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
