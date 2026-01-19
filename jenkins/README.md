# MVPA on Docker with Jenkins

This just contains detils about this directory, the official instructions live here;

[Official Instructions](../BUILD_IN_JENKINS_FROM_GITHUB.md)

Also these commands might come in handy;

On Windows in Git Bash;

```
winpty docker exec -it -u root <containerId/> bash
```

On Max Os or other Unix

```
docker exec -it -u root <containerId/> bash
docker exec -it -u root c65c7e0e12cc83df1a1a8732e31680471fbf35514363fc43758d7ae1cf8e48d6 bash
```

Then 

```
cat /var/jenkins_home/secrets/initialAdminPassword
```
