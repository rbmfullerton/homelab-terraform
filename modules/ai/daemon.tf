resource "kubernetes_manifest" "daemonset_kube_system_nvidia_device_plugin_daemonset" {
  field_manager {
    name = "terraform"
    force_conflicts = true
  }
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "DaemonSet"
    "metadata" = {
      "labels" = {
        "name" = "nvidia-device-plugin-ds"
      }
      "name" = "nvidia-device-plugin-daemonset"
      "namespace" = "kube-system"
    }
    "spec" = {
      "selector" = {
        "matchLabels" = {
          "name" = "nvidia-device-plugin-ds"
        }
      }
      "template" = {
        "metadata" = {
          "annotations" = {
            "kubectl.kubernetes.io/restartedAt" = "{{RESTART_TIMESTAMP}}"
          }
          "labels" = {
            "name" = "nvidia-device-plugin-ds"
          }
        }
        "spec" = {
          "containers" = [
            {
              "env" = [
                {
                  "name" = "FAIL_ON_INIT_ERROR"
                  "value" = "false"
                },
              ]
              "image" = "nvcr.io/nvidia/k8s-device-plugin:v0.17.3"
              "imagePullPolicy" = "IfNotPresent"
              "name" = "nvidia-device-plugin-ctr"
              "securityContext" = {
                "privileged" = true
              }
              "terminationMessagePath" = "/dev/termination-log"
              "terminationMessagePolicy" = "File"
              "volumeMounts" = [
                {
                  "mountPath" = "/var/lib/kubelet/device-plugins"
                  "name" = "device-plugin"
                },
                {
                  "mountPath" = "/usr/lib/x86_64-linux-gnu"
                  "mountPropagation" = "HostToContainer"
                  "name" = "nvidia-driver"
                  "readOnly" = true
                },
                {
                  "mountPath" = "/dev"
                  "mountPropagation" = "HostToContainer"
                  "name" = "dev"
                },
              ]
            },
          ]
          "dnsPolicy" = "ClusterFirst"
          "nodeSelector" = {
            "gpu" = "true"
          }
          "priorityClassName" = "system-node-critical"
          "restartPolicy" = "Always"
          "runtimeClassName" = "nvidia"
          "schedulerName" = "default-scheduler"
          "terminationGracePeriodSeconds" = 30
          "tolerations" = [
            {
              "effect" = "NoSchedule"
              "key" = "nvidia.com/gpu"
              "operator" = "Exists"
            },
          ]
          "volumes" = [
            {
              "hostPath" = {
                "path" = "/var/lib/kubelet/device-plugins"
                "type" = "DirectoryOrCreate"
              }
              "name" = "device-plugin"
            },
            {
              "hostPath" = {
                "path" = "/usr/lib/x86_64-linux-gnu"
                "type" = "Directory"
              }
              "name" = "nvidia-driver"
            },
            {
              "hostPath" = {
                "path" = "/dev"
                "type" = "Directory"
              }
              "name" = "dev"
            },
          ]
        }
      }
      "updateStrategy" = {
        "rollingUpdate" = {
          "maxUnavailable" = 1
        }
        "type" = "RollingUpdate"
      }
    }
  }
}
