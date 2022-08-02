# Kubernetes Workshop

## Getting Started

First, we need to connect with our Kubernetes cluster.

```
aws eks list-clusters --region eu-west-1
```

Now update your `~/.kube/config` file with the following:

```
aws eks update-kubeconfig --name <CLUSTER_NAME> --region eu-west-1
```

To test the connection, run the following command:

```
kubectl get namespaces
```

This should list the namespaces in your cluster.

## Kubernetes Architecture

The Kubernetes architecture is a distributed system that is designed to be highly available and scalable. It consists of a collection of Kubernetes nodes, each of which is responsible for a portion of the cluster.
We have master nodes, which are responsible for managing the cluster, and worker nodes, which are responsible for running the workloads.

Since we are running on AWS EKS we don't have access to the Kubernetes master nodes.

[More Information](https://www.aquasec.com/cloud-native-academy/kubernetes-101/kubernetes-architecture/)

## Kubernetes Basic Components

#### Kubelet

The kubelet is the primary component of Kubernetes. It is responsible for starting and maintaining the containers that make up your cluster.
It can register with the Kubernetes API server and receive updates about the status of your cluster.

[More Information](https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/).

#### Kube Api Server

The Kubernetes API server validates and configures data for the api objects which include pods, services, replicationcontrollers, and others. The API Server services REST operations and provides the frontend to the cluster's shared state through which all other components interact.

[More Information](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/).

#### Kube Controller Manager

The Kubernetes Controller Manager is responsible for monitoring and managing the health of a cluster's services and replication controllers. Is a control loop that watches the shared state of the cluster through the apiserver and makes changes attempting to move the current state towards the desired state. Examples of controllers that ship with Kubernetes today are the replication controller, endpoints controller, namespace controller, and serviceaccounts controller.

[More Information](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-controller-manager/).

#### Kube Proxy

The Kubernetes network proxy runs on each node. This reflects services as defined in the Kubernetes API on each node and can do simple TCP, UDP, and SCTP stream forwarding or round robin TCP, UDP, and SCTP forwarding across a set of backends.

[More Information](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-proxy/).

#### Kube Scheduler

The Kubernetes scheduler is responsible for assigning pods to nodes. It is a simple round-robin scheduler that assigns pods to nodes in a round-robin fashion. The scheduler determines which Nodes are valid placements for each Pod in the scheduling queue according to constraints and available resources.

[More Information](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-scheduler/).

#### Etcd Cluster

A distributed key-value store that is used to store the state of the cluster. It is only accessible from the API server for security reasons. etcd enables notifications to the cluster about configuration changes with the help of watchers. Notifications are API requests on each etcd cluster node to trigger the update of information in the node’s storage.

[More Information](https://kubernetes.io/docs/concepts/overview/components/#etcd)
[Detailed Information](https://etcd.io/docs/v3.5/)

## Kubernetes Objects

Kubernetes objects are persistent entities in the Kubernetes system. Kubernetes uses these entities to represent the state of your cluster. Specifically, they can describe:

- What containerized applications are running (and on which nodes)
- The resources available to those applications
- The policies around how those applications behave, such as restart policies, upgrades, and fault-tolerance

When you use the Kubernetes API to create the object (either directly or via kubectl), that API request must include that information as JSON in the request body. Most often, you provide the information to kubectl in a .yaml file. kubectl converts the information to JSON when making the API request.

[More Information](https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/)

An example of object, a `Pod`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: webapp
  labels:
    role: mypod
spec:
  containers:
    - name: web
      image: nginx
      ports:
        - name: web
          containerPort: 80
          protocol: TCP
```

Now let's take a look into some objects that Kubernetes supports.

#### Namespaces

A Kubernetes namespace is a collection of objects. It is used to organize your cluster.
If you delete a namespace, all objects in that namespace are deleted. You also need to reference the namespace in your commands, if needed.

[More Information](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)

#### Pods

Pods are the containers that run on the nodes of your cluster. They are the smallest unit of work in Kubernetes.
A Pod is a group of one or more containers, with shared storage and network resources, and a specification for how to run the containers. A Pod's contents are always co-located and co-scheduled, and run in a shared context.

[More Information](https://kubernetes.io/docs/concepts/workloads/pods/)

#### Replica Sets

A ReplicaSet's purpose is to maintain a stable set of replica Pods running at any given time. As such, it is often used to guarantee the availability of a specified number of identical Pods.
A ReplicaSet is defined with fields, including a selector that specifies how to identify Pods it can acquire, a number of replicas indicating how many Pods it should be maintaining, and a pod template specifying the data of new Pods it should create to meet the number of replicas criteria. A ReplicaSet then fulfills its purpose by creating and deleting Pods as needed to reach the desired number. When a ReplicaSet needs to create new Pods, it uses its Pod template.

[More Information](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset)

#### Deployments

A Deployment provides declarative updates for Pods and ReplicaSets.

You describe a desired state in a Deployment, and the Deployment Controller changes the actual state to the desired state at a controlled rate. You can define Deployments to create new ReplicaSets, or to remove existing Deployments and adopt all their resources with new Deployments.

[More Information](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)

#### Horizontal Pod Autoscaler

The Horizontal Pod Autoscaler automatically scales the number of Pods in a replication controller, deployment, replica set or stateful set based on observed CPU utilization (or, with custom metrics support, on some other application-provided metrics).

[More Information](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)

#### Services

In Kubernetes, a Service is an abstraction which defines a logical set of Pods and a policy by which to access them (sometimes this pattern is called a micro-service). A Service is a collection of Pods that share a common purpose.

Why do we need a Service? [Read this](https://kubernetes.io/docs/concepts/services-networking/service/#motivation)

[More Information](https://kubernetes.io/docs/concepts/services-networking/service/)

#### Ingress

Ingress exposes HTTP and HTTPS routes from outside the cluster to services within the cluster. Traffic routing is controlled by rules defined on the Ingress resource.
An Ingress may be configured to give Services externally-reachable URLs, load balance traffic, terminate SSL / TLS, and offer name-based virtual hosting.

[More Information](https://kubernetes.io/docs/concepts/services-networking/ingress/)

#### Service Account

When you (a human) access the cluster (for example, using kubectl), you are authenticated by the apiserver as a particular User Account (currently this is usually admin, unless your cluster administrator has customized your cluster). Processes in containers inside pods can also contact the apiserver. When they do, they are authenticated as a particular Service Account (for example, default).

[More Information](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/)

So now imagine that you application needs access to a S3 Bucket in AWS. How do you think we could manage our credentials without setting anything as a plain-text password?
[How to use Service Accounts to access AWS Services](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html)

## How to Interact with a Kubernetes Cluster?

There are multiple ways to do that. You can use a programmatic API, or you can use the command line tools. We have for example the Go client. In which you define an object that represents a Kubernetes cluster, and then you can use the API to interact with it.

But the most convenient way is to use the command line tools. [Make sure to check this link to understand how to connect to a Kubernetes Cluster](https://kubernetes.io/docs/tasks/access-application-cluster/access-cluster/).

I'll link two cheat sheets here:

- [The official Kubernetes cheat sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [This one is very comprehensive](https://swissarmydevops.com/containers/kubernetes/kubernetes-cheat-sheet/)

Also make sure to check the short names of the commands.

<details>
<summary>Short Name list for Kubernetes API</summary>
<pre><code>
| Short Name | Long Name                  |
|------------|----------------------------|
| csr        | certificatesigningrequests |
| cs         | componentstatuses          |
| cm         | configmaps                 |
| ds         | daemonsets                 |
| deploy     | deployments                |
| ep         | endpoints                  |
| ev         | events                     |
| hpa        | horizontalpodautoscalers   |
| ing        | ingresses                  |
| limits     | limitranges                |
| ns         | namespaces                 |
| no         | nodes                      |
| pvc        | persistentvolumeclaims     |
| pv         | persistentvolumes          |
| po         | pods                       |
| pdb        | poddisruptionbudgets       |
| psp        | podsecuritypolicies        |
| rs         | replicasets                |
| rc         | replicationcontrollers     |
| quota      | resourcequotas             |
| sa         | serviceaccounts            |
| svc        | services                   |

</code></pre>

</details>
</br>
Now, let's check a few commands.

#### Config

The `config` subcommand is used to interact with the Kubernetes configuration file. For example we can check the current context, or switch to a different one. Context is a representation of a Kubernetes cluster.

```
kubectl config view
```

We can also remove, update and add contexts. Which is useful when you want to switch to a different cluster.

[More Information](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#config)

#### Get

The `get` subcommand is used to interact with objects in the cluster. For example, we can get a list of all the pods in the cluster.

```
kubectl get pods --all-namespaces
```

Or even a specific pod in a specific namespace.

```
kubectl get pods -n kube-system
```

[More Information](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#get)

#### Create

The `create` subcommand is used to create objects in the cluster. For example, we can create a new namespace.

```
kubectl create namespace my-namespace
```

[More Information](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#create)

#### Apply

The `apply` subcommand is used to apply a manifest to the cluster. For example, we can apply a new deployment. Or modify an existing one. If the resource does not exist, it will be created. If it does exist, it will be updated.

```
kubectl apply -f manifest.yaml
```

[More Information](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#apply)

#### Describe

The `describe` subcommand is used to describe objects in the cluster. For example, we can describe a deployment.

```
kubectl describe deployment my-deployment -n my-namespace
```

[More Information](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#describe)

#### Logs

The `logs` subcommand is used to get logs from pods. For example, we can get the logs of a pod.

```
kubectl logs nginx -n my-namespace
```

[More Information](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#logs)

#### Port-Forward

The `port-forward` subcommand is used to forward ports from a pod to the local machine. For example, we can forward the port 8080 of a pod to the local machine.

```
kubectl port-forward pod/mypod -n my-namespace 8080 8080
```

[More Information](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#port-forward)

#### Exec

The `exec` subcommand is used to execute a command in a container in a pod. For example, we can execute a command in a pod.

```
kubectl exec mypod -- bash
```

[More Information](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#exec)

## Our first application

In your tests, make sure to create a namespace for your group. This could be done by running:

```bash
kubectl create namespace <group-name>
```

For our first application, we will create a simple web server.
We will use the `nginx` container to serve our application.

To create the application, run the following command:

```
cd demo
kubectl create -f first-pod.yaml
```

So now, if you check your namespace, you should see the following:

```
kubectl get pods -n <group-name>
```

And you'll see a message saying `No resources found in <group-name> namespace.` That means the pod is not running in your namespace, so where did it go?

Since we haven't specified a namespace, the pod will be created in the `default` namespace.
We can check this by running:

```
kubectl get pods
```

So our pod is there, but I want to move it into another namespace. One way of doing this is deleting the pod and recreating it in the new namespace.

```
kubectl delete -f first-pod.yaml
```

With this command, I'll delete any objects declared in the `first-pod.yaml` file.

Now to create it in the correct namespace:

```
kubectl create -f first-pod.yaml -n <group-name>
```

Now check if it's there:

```
kubectl get pods -n <group-name>
```

But this is kind bad, because we are specifying the namespace in the command line. It would be better if we could specify it in the file. And we can. We have the `metadata` section in the file. We can use a section to indicate which namespace the pod should be created in. Like this:

```yaml
metadata:
  name: webserver
  namespace: group1
```

Now, I want to test other commands in my pod. How can I start? Let's begin with the `describe` command.

```
kubectl describe pod/webserver -n group1
```

There are a few things to note here. We can check from where the image is coming from. We can check the container name, annotations, ports and so on.

But one thing that I'd like for you to notice is the tab `Events`. Those are not the `logs` from the container, but `logs` related to that pod from the Kubernetes Cluster.

In our case:

```
Normal  Scheduled  <invalid>  default-scheduler  Successfully assigned group1/webserver to ip-172-33-5-234.eu-west-1.compute.internal
Normal  Pulling    <invalid>  kubelet            Pulling image "nginx:latest"
Normal  Pulled     <invalid>  kubelet            Successfully pulled image "nginx:latest" in 1.235685729s
Normal  Created    <invalid>  kubelet            Created container webserver
Normal  Started    <invalid>  kubelet            Started container webserver
```

You can see that we talked about Kubernetes Components, and look at the `kubelet` and `default-scheduler` components. They were responsible for your pod comming up.

Now, let's try to execute a command in our pod.

```
kubectl exec -it webserver -n group1 -- /bin/bash
```

Now we are inside our container, we can run commands like:

```
date
hostname
whoami
```

And we can see if the Nginx is running:

```
curl localhost
```

So it is running, but how can I see its logs?

```
kubectl logs -n group1 webserver
```

You'll see something like this:

```
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2021/09/07 11:28:42 [notice] 1#1: using the "epoll" event method
2021/09/07 11:28:42 [notice] 1#1: nginx/1.21.1
2021/09/07 11:28:42 [notice] 1#1: built by gcc 8.3.0 (Debian 8.3.0-6)
2021/09/07 11:28:42 [notice] 1#1: OS: Linux 5.4.129-63.229.amzn2.x86_64
2021/09/07 11:28:42 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
2021/09/07 11:28:42 [notice] 1#1: start worker processes
2021/09/07 11:28:42 [notice] 1#1: start worker process 30
2021/09/07 11:28:42 [notice] 1#1: start worker process 31
127.0.0.1 - - [07/Sep/2021:11:30:23 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.64.0" "-"
```

But, can I open this application in my local host? Yes, you can do a `port-forward` to your pod:

```bash
kubectl port-forward -n group1 webserver 8081:80
# the first number is the port in your local host, the second is the port in your pod.
```

Now if we refresh the page, we should see the Nginx running.
And if you run the `logs` command, you'll see that we have a lot of logs.

```
kubectl logs -n group1 webserver
```

Now, just delete all the resources you have created:

```
kubectl delete -f first-pod.yaml -n <group-name>
kubectl delete ns <group-name>
```

## Exercises

### Exercise 1

Let's create a multicontianer pod.

The primary purpose of a multi-container Pod is to support co-located, co-managed helper processes for a primary application. There are some general patterns for using helper processes in Pods:

- Sidecar containers “help” the main container. Some examples include log or data change watchers, monitoring adapters, and so on. A log watcher, for example, can be built once by a different team and reused across different applications. Another example of a sidecar container is a file or data loader that generates data for the main container.
- Proxies, bridges, and adapters connect the main container with the external world. For example, Apache HTTP server or nginx can serve static files. It can also act as a reverse proxy to a web application in the main container to log and limit HTTP requests. Another example is a helper container that re-routes requests from the main container to the external world. This makes it possible for the main container to connect to localhost to access, for example, an external database, but without any service discovery.

While you can host a multi-tier application (such as WordPress) in a single Pod, the recommended way is to use separate Pods for each tier, for the simple reason that you can scale tiers up independently and distribute them across cluster nodes.

[More Information](https://www.mirantis.com/blog/multi-container-pods-and-container-communication-in-kubernetes/)

Your exercise is to create a multi-container pod. For that, use the following template:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: webserver
spec:
  containers:
    - name: webserver
      image: nginx:latest
      ports:
        - containerPort: 80
```

Now, you should add this container: `afakharany/watcher:latest`. It doesn't need any port.

So, for this exercise, you need to do the following:

1. Create a namespace for this exercise, like this `<group-id>-exercise-1`.
2. Adapt the template to your needs.
3. Apply the template to your namespace. You need to define the namespace in the template.
4. Get the pods using a additional information. [Check here for help](https://kubernetes.io/docs/reference/kubectl/overview/)
5. Get the pods using a `json` output.
6. Get all the resources in your namespace.
7. Get the events of your pod.
8. Exec into the `webwatcher` container. Get information on the OS Release.
9. Get the logs from the Nginx container.
10. Do a port-forward to the Nginx pod in port 8081 of your localhost.
11. Delete all the resources you have created.
12. Questions:

- Can you `curl` nginx from the `webwatcher` container? Why?
- If you write a file in the `webwatcher` container, can you read it from the `nginx` container? Why? How could we do that?

### Exercise 2

Now let's work with deployments. A Deployment resource uses a ReplicaSet to manage the pods. However, it handles updating them in a controlled way. Let’s dig deeper into Deployment Controllers and patterns.

So, for this exercise, you need to do the following:

1. Create a namespace for this exercise, like this `<group-id>-exercise-2`.
2. Create a Nginx Deployment in a YAML file. It should contain:

- A single container with the name `nginx` and the image `nginx:1.7.9`.
- 2 Replicas.
- it should be deployed in the `<group-id>-exercise-2` namespace.
- A `selector` with the key `app` and the value `nginx`.
- A `metadata` with `labels` with the key `app` and the value `nginx`.
- Runs on port 80.

3. Apply the template to your namespace. You need to define the namespace in the template.
4. Get the deployment and describe it. Check if it's using the right image.
5. Scale your deployment to 3 replicas.
6. Now, change the image to `nginx:latest`. Keep the 3 replicas in the new file. And apply the changes.
7. Describe the deployment again. Check if the images are the same.
8. Now, you need to rollback the deployment to the previous version. [Check the `rollout` command](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#rollout).
9. Get the status of the rollout.
10. Describe the deployment again. What version is it using?
11. Delete all the resources you have created.

12. Questions:

- What is the difference between a `Deployment` and a `ReplicaSet`?
- What is the difference between a `Deployment` and a `DaemonSet`?
- Do you see why it's useful to use a `rollout` command?

### Exercise 3

Now let's work with Services. A Service is a collection of endpoints that are exposed to the internet or internal services. We can use a Service to expose a set of pods to the internet or even to other pods.

1. Create a namespace for this exercise, like this `<group-id>-exercise-3`.
2. Create a Nginx Service in a YAML file. It should contain:

- port 80 exposed.
- a `selector` with the key `app` and the value `nginx`.
- it should be deployed in the `<group-id>-exercise-3` namespace.
- it should be of type `ClusterIP`.

3. In the same file, create a Nginx Deployment. It should contain:

- A single container with the name `nginx` and the image `nginx:latest`.
- 2 Replicas.
- it should be deployed in the `<group-id>-exercise-3` namespace.
- A `selector` with the key `app` and the value `nginx`.
- A `metadata` with `labels` with the key `app` and the value `nginx`.
- Runs on port 80.

4. Apply the template to your namespace.
5. Get the service and describe it.
6. Get the deployment and describe it.
7. Check the logs of you deployment.
8. Run a `port-forward` to the Nginx pod in port 80 of your localhost.
9. Check the logs of you deployment.
10. Now, change the type of Service to `LoadBalancer`.
11. Get the service and describe it. Do you see any `External-IP`?
12. Log in our AWS console and check the status of the load balancer. Wait about 2 minutes to see if it's ready. Can you access it?
13. Delete all the resources you have created.

Questions:

- How does the Service know which pods to connect to?
- What are the types of Services? How do they differ?

### Exercise 4

(Sorry, I didn't have time to do this one. But, I'll try to put a link to the solution in the future. So think of this as a homework =P)

Now, let's try to connect two differents containers to each other, using their services.

1. Create a namespace for this exercise, like this `<group-id>-exercise-4-1`.
2. Create a namespace for this exercise, like this `<group-id>-exercise-4-2`.
3. Create an application(you can choose the language) that:

- It returns a "Hello World" message in the "/" endpoint.
- Runs on port 5000.

4. Create an application(you can choose the language) that:

- It returns the response of the previous application in the "/" endpoint.
- The endpoint of the first service should be a Env Variable with the name `SERVICE_URL`.
- Runs on port 5001.

5. Dockerize the two applications. And push them to our [Hackaton ECR](https://eu-west-1.console.aws.amazon.com/ecr/repositories/private/607373615695/hackaton?region=eu-west-1).

6. Create a Service in a YAML file for the first app.

- port 5000 exposed.
- a `selector` with the key `app` and the value `app1`.
- it should be deployed in the `<group-id>-exercise-4-1` namespace.
- it should be of type `ClusterIP`.

7. Create a Service in a YAML file for the second app.

- port 5001 exposed.
- a `selector` with the key `app` and the value `app2`.
- it should be deployed in the `<group-id>-exercise-4-2` namespace.
- it should be of type `ClusterIP`.

8. Create a Deployment in a YAML file for the first app, in the same file as the first service. It should contain:

- A single container with the name `app1` and the image that you pushed to the ECR.
- 2 Replicas.
- it should be deployed in the `<group-id>-exercise-4-1` namespace.
- A `selector` with the key `app` and the value `app1`.
- A `metadata` with `labels` with the key `app` and the value `app1`.
- Runs on port 5000.

9. Create a Deployment in a YAML file for the second app, in the same file as the second service. It should contain:

- A single container with the name `app2` and the image that you pushed to the ECR.
- 2 Replicas.
- it should be deployed in the `<group-id>-exercise-4-2` namespace.
- A `selector` with the key `app` and the value `app2`.
- A `metadata` with `labels` with the key `app` and the value `app2`.
- Runs on port 5001.
- Has the `SERVICE_URL` as an Env Variable. With the value from the first service. [Maybe this could help](https://stackoverflow.com/questions/45720084/how-to-make-two-kubernetes-services-talk-to-each-other).

10. Apply the template to your namespaces.
11. Get and describe both services and deployments.
12. Run a `port-forward` to the first app in port 5000 of your localhost.
13. Run a `port-forward` to the second app in port 5001 of your localhost.
14. Make a request from the second app to the first app. Did it work?
