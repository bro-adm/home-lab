# home-lab
home lab resources and setup

## Repository Structure and Purpose

This repository contains the configuration and setup for a home lab environment. It automates the deployment of applications and services on a Kubernetes cluster using GitOps principles.

*   **`/setup/`**: Contains initial setup scripts and configurations for the Kubernetes cluster, including Helm chart values for tools like ArgoCD and ingress-nginx.
*   **`/templates/`**: Holds templates used by GitHub Actions to generate the final Kubernetes resource definitions.
*   **`/resources/`**: Contains Kubernetes resource definitions managed by Kustomize, which are read by ArgoCD and applied to the cluster.
*   **`/.github/workflows/`**: Contains GitHub Actions workflows for CI/CD and automation.

**Technologies Used:** Kubernetes, Helm, Kustomize, ArgoCD, and GitHub Actions.
