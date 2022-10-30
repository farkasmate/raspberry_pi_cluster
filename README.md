# I'm building a Raspberry Pi cluster

For details go to: https://farkasmate.github.io/raspberry_pi_cluster/

## Kustomize config for Raspberry Pi cluster

### Apply config

TODO: Migrate to sealed secrets

```
bundle exec kubectl eyaml apply -k .
```

## Schedule certificate renewal immediately

```
kubectl exec-cronjob certbot-renew-csikoste-wildcard-tls
```
