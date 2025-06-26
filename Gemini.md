# Gemini Project Information

This file provides context for the Gemini AI assistant to understand the structure and purpose of this repository.

## Repository Purpose

This repository stores the configuration and setup for a home lab environment. It automates the deployment of applications and services on a Kubernetes cluster using GitOps principles.

## Directory Structure

*   `/.github/workflows/`: This directory contains GitHub Actions workflows, such as `deploy_resource.yml`, which likely automates the deployment of resources to the Kubernetes cluster.
*   `/resources/`: This directory contains Kubernetes resource definitions, likely managed by Kustomize. The subdirectories (e.g., `dbs/my-cassandra`) represent different applications or services. These resources are read by ArgoCD and applied to the cluster.
*   `/setup/`: This directory contains the initial setup scripts and configurations for the Kubernetes cluster. This includes:
    *   Helm chart values for tools like ArgoCD and ingress-nginx.
    *   Scripts for initial setup, like `local-path-storage-provisioner.bash`.
    *   Configuration for ArgoCD ApplicationSets.
*   `/templates/`: This directory holds templates that are likely used by GitHub Actions to generate the final Kubernetes resource definitions in the `resources` directory.

## Technologies Used

*   **Kubernetes (k8s):** The container orchestration platform for the home lab.
*   **Helm:** Used for packaging and deploying applications on Kubernetes. The `setup` directory contains Helm chart configurations.
*   **Kustomize:** Used for customizing Kubernetes resource configurations. The `resources` directory is structured for Kustomize.
*   **ArgoCD:** Used for GitOps-style continuous delivery to the Kubernetes cluster. It monitors the `resources` directory.
*   **GitHub Actions:** Used for CI/CD and automation, such as generating resources from templates and triggering deployments.
