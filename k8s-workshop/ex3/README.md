# Answers

<details>
<summary> Do you want to see the answers? </summary>
<pre>
1. `kubectl create namespace group1-exercise-3`
2. ```yaml
   apiVersion: v1
   kind: Service
   metadata:
     name: nginx-service
     namespace: group1-ex3
   spec:
     selector:
       app: nginx
     ports:
       - port: 80
         targetPort: 80
     type: ClusterIP
   ```

3. ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: nginx
     namespace: group1-ex3
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
             image: nginx:latest
             ports:
               - containerPort: 80
   ```

4. `kubectl apply -f ex3.yaml`
5. `kubectl get svc -n group1-ex3` </br>
   `kubectl describe svc -n group1-ex3 nginx-service`
6. `kubectl get deploy -n group1-ex3` </br>
   `kubectl describe deploy -n group1-ex3 nginx`
7. `kubectl logs deploy/nginx -n group1-ex3`
8. `kubectl port-forward -n group1-ex3 deploy/nginx 8081:80`
9. `kubectl logs deploy/nginx -n group1-ex3`
10. ```yaml
    apiVersion: v1
    kind: Service
    metadata:
      name: nginx-service
      namespace: group1-ex3
    spec:
      selector:
        app: nginx
      ports:
        - port: 80
          targetPort: 80
      type: LoadBalancer
    ```
11. `kubectl get svc -n group1-ex3` </br>
    `kubectl describe svc -n group1-ex3 nginx-service`

Yes. There is a DNS for a ALB in AWS.

12. `curl http://<YOUR AWS ELB ID>.eu-west-1.elb.amazonaws.com/`
</pre>
</details>
