# Answers

<details>
<summary> Do you want to see the answers? </summary>
<pre>
1. `kubectl create namespace group1-ex1`
2. ```yaml
   apiVersion: v1
   kind: Pod
   metadata:
     name: webserver
     namespace: group1-ex1
   spec:
     containers:
       - name: webserver
         image: nginx:latest
         ports:
           - containerPort: 80
       - name: webwatcher
         image: afakharany/watcher:latest
   ```
3. `kubectl apply -f ex1.yaml`
4. `kubectl get po -o wide -n group1-ex1`
5. `kubectl get po -o json -n group1-ex1`
6. `kubectl get all -n group1-ex1`
7. `kubectl describe pod/webserver -n group1-ex1`
8. `kubectl exec -it webserver -c webwatcher -n group1-ex1 -- /bin/bash` </br>
   `cat /etc/*-release`
9. `kubectl logs webserver -c webserver -n group1-ex1` </br>
10. `kubectl port-forward -n group1-ex1 webserver 8081:80`
11. `kubectl delete namespace group1-ex1`
</pre>
</details>
