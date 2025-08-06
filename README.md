# Terraform + K3S Homelab Adventures

Welcome to my journey into using **Terraform** to automate and manage my K3S-powered Kubernetes homelab! This project documents my experiments, learnings, and ongoing progress as I bring modern infrastructure-as-code tools into my personal environment.

## Table of Contents

- [About This Project](#about-this-project)
- [Homelab Diagram](#homelab-diagram)

## About This Project

This repository contains my experiments with using **Terraform** to define, provision, and manage services in my (K3S) homelab cluster. My ultimate goal is to codify the configuration and setup process, making environments reproducible and easy to share or rebuild.

## Homelab Diagram
```mermaid
flowchart TD
 subgraph PX1VMs["VMs on Node 1"]
        PX1VM["Docker VM<br>K3S Master 2<br>K3s Master 3<br>K3S Worker 2<br>K3S Longhorn 3<br>K3S Admin"]
        PX1DMZ["PX1DMZ"]
  end
 subgraph PX1DMZ["DMZ"]
        PX1VMDMZ["Game Server"]
  end
 subgraph PX2VMs["VMs on Node 2"]
        PX2VM["K3S Master 1<br>K3S Worker 1<br>K3S Longhorn 1<br>K3s Longhorn 2"]
        PX2DMZ["PX2DMZ"]
  end
 subgraph PX2DMZ["DMZ"]
        PX2VMDMZ["Plex (ARC A380)"]
  end
 subgraph K3SSers["K3S Services"]
        K3SPodList["Longhorn<br>Authenik<br>Traefik<br>Metallb"]
  end
 subgraph K3SCons["K3S Containers"]
        K3SSerList["Pi-Hole1<br>Pi-Hole2<br>Homarr<br>UpTimeKuma<br>Sonarr<br>Radarr<br>Overseerr"]
  end
 subgraph K3S["K3S Cluster"]
        K3SCons
        K3SSers
  end
 subgraph ProxmoxCluster["Proxmox Cluster"]
        PX1["Proxmox Node 1"]
        PX2["Proxmox Node 2"]
        PX1VMs
        PX2VMs
        K3S
        PXBKHA["Proxmox Backup VM (HA)<br>iSCSI 10G"]
  end
 subgraph TNMainVMs["Containers"]
        TNMainVM1["Pi-Hole3<br>UptimeKuma-NAS"]
  end
 subgraph TNBackupVMs["VMs"]
        TNBackupVM1["Proxmox QDevice"]
  end
 subgraph TrueNAS["TrueNAS Hosts"]
        TNmain["TrueNAS Main - RAIDZ1"]
        TNMainVMs
        TNbackup["TrueNAS Backup - Striped"]
        TNBackupVMs
        TNRSync["Nightly Rsync Task"]
  end
 subgraph Wireless["Wireless"]
        AP1["Acess Point 1 - House"]
        AP2["Acess Point 2 - Shed"]
  end
    ONT@{ label: "ONT (ISP)<span class=\"grow\"></span>" } --> FG["Fortigate"]
    FG -- "192.168.2.X/24 User LAN" --- Wireless
    PXBKHA -.- PX1 & PX2
    FG -- "192.168.2.X/24 Server LAN" --- ProxmoxCluster
    PX1VMs --> K3S
    PX2VMs --> K3S
    PX1 --> PX1VMs
    PX2 --> PX2VMs
    FG -- "192.168.0.X/24 Server LAN" --> TrueNAS
    TNmain --> TNMainVMs
    TNmain --- TNRSync
    TNbackup --> TNBackupVMs
    TNbackup --- TNRSync
    ProxmoxCluster --- 10G["10.0.0.X/24 10G SFP+"]
    TrueNAS --- 10G
    FG -- "172.16.0.X/24 DMZ" --> ProxmoxCluster

    K3SPodList@{ shape: rect}
    PX1@{ shape: db}
    PX2@{ shape: db}
    TNmain@{ shape: disk}
    TNbackup@{ shape: disk}
    AP1@{ shape: rect}
    AP2@{ shape: rect}
    ONT@{ shape: rect}
     PX1:::server
     PX2:::server
     PXBKHA:::storage
     TNmain:::server
     TNbackup:::server
     TNRSync:::storage
     AP1:::server
     AP2:::server
     ONT:::server
     FG:::server
     10G:::storage
    classDef server fill:#e3f2fd,stroke:#2196f3,stroke-width:2px
    classDef storage fill:#f1f8e9,stroke:#689f38,stroke-width:2px
    style PX1VM stroke:#2962FF
    style PX1DMZ stroke:#D50000
    style PX2VM stroke:#2962FF
    style PX2DMZ fill:transparent,stroke:#D50000
    linkStyle 1 stroke:#BBDEFB,fill:none
    linkStyle 4 stroke:#2962FF,fill:none
    linkStyle 8 stroke:#000000,fill:none
    linkStyle 9 stroke:#2962FF,fill:none
    linkStyle 11 stroke:#689f38,fill:none
    linkStyle 12 stroke:#000000,fill:none
    linkStyle 13 stroke:#689f38,fill:none
    linkStyle 14 stroke:#689f38,fill:none
    linkStyle 15 stroke:#689f38,fill:none
    linkStyle 16 stroke:#D50000,fill:none
```
