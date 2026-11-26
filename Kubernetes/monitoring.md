In kubernetes for each microservice writes log to stdout in /var/log/containers/*.log location and filebeat run as a daemonset which is used as a logging agent will pick up the logs from /var/log/containers folder and send to elastic search from there we visualise the logs in Kibana and logstash


In our setup, we separate metrics and logging for better performance and scalability.
For metrics like CPU, memory, and pod-level resource usage, we use Prometheus, which scrapes data from Kubernetes components like node-exporter and kube-state-metrics. These metrics are visualized in Grafana dashboards, where we also configure alerts for thresholds like high CPU or memory usage.

For logging, applications write logs to stdout, which Kubernetes stores on nodes. A log collector like Filebeat forwards these logs to Elasticsearch, where they are indexed. We use Kibana to search and visualize logs across microservices.

This separation ensures efficient monitoring, where Prometheus handles time-series metrics and ELK handles log aggregation, and together they provide complete observability of the system.

Loki uses label-based indexing → cost efficient
Promtail runs as DaemonSet
Grafana supports log-metric correlation
alerting based on logs + metrics

## Different kinds of metrics

Apart from CPU, memory, and disk, I monitor infrastructure metrics like network and disk I/O, Kubernetes metrics like pod status and restart count, and application-level metrics such as request rate, latency, and error rate. These are visualized in Grafana dashboards and used for alerting to detect issues proactively.

“In Prometheus, I define SLIs using PromQL queries like success rate, latency, and error rate. Then in Grafana, I visualize these metrics and set thresholds based on SLOs. I also configure alerts when SLOs are breached, and optionally track error budget burn rate to control deployments.”