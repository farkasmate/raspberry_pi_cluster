# Bootstrapping

The `certbot` ServiceAccount is managing the `csikoste-wildcard-tls` Secret, but not allowed to create it.

Run the following to get an initial version of the Secret:

```
kubectl apply -f bootstrap/dummy_secret.yaml
```
