# Answers

<details>
<summary> Do you want to see the answers? </summary>
<pre>
1. `kubectl create namespace group1-ex2`
2. ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: nginx
     namespace: group1-ex2
   spec:
     selector:
       matchLabels:
         app: nginx
     replicas: 2
     template:
       metadata:
         labels:
           app: nginx
       spec:
         containers:
           - name: nginx
             image: nginx:1.7.9
             ports:
               - containerPort: 80
   ```

3. `kubectl apply -f ex2.yaml`
4. `kubectl get deploy -n group1-ex2` </br>
   `kubectl describe deploy nginx -n group1-ex2`
5. `kubectl scale deployments/nginx --replicas=3 -n group1-ex2`
6. ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: nginx
     namespace: group1-ex2
   spec:
     selector:
       matchLabels:
         app: nginx
     replicas: 3
     template:
       metadata:
         labels:
           app: nginx
       spec:
         containers:
           - name: nginx
             image: nginx:latest
             ports:
               - containerPort: 80
   ```
   </br>
   `kubectl apply -f ex2.yaml`
7. `kubectl describe deploy nginx -n group1-ex2`
8. `kubectl rollout undo deployments/nginx -n group1-ex2`
9. `kubectl rollout status deployments/nginx -n group1-ex2`
10. `kubectl describe deploy nginx -n group1-ex2`. It should be running 1.7.9
11. `kubectl delete namespace group1-ex2`
</pre>
</details>
