
# Feature Backlog

This backlog tracks planned features and improvements for the SQL Server container setup.

## To Do

- [ ] **Clustering with Pacemaker**
  - **Description:** Implement Pacemaker to provide a high-availability and disaster recovery solution for the SQL Server Availability Group on Linux. This will involve configuring a Pacemaker cluster to manage the failover of the AG listener and resources.
  - **Tasks:**
    - [ ] Research and document the steps for installing and configuring Pacemaker on the container OS.
    - [ ] Create a new Docker Compose setup or modify the existing one to include Pacemaker.
    - [ ] Develop scripts to automate the Pacemaker cluster configuration.
    - [ ] Test the failover scenarios to ensure Pacemaker is working correctly.

- [ ] **Active Directory Integration**
  - **Description:** Set up an Active Directory domain controller and integrate it with the SQL Server containers to enable AD-based authentication for users and services.
  - **Tasks:**
    - [ ] Create a new Docker container for the Active Directory domain controller.
    - [ ] Configure the SQL Server containers to join the AD domain.
    - [ ] Create AD users and groups for SQL Server authentication.
    - [ ] Configure SQL Server to use AD authentication.
    - [ ] Test the AD authentication by connecting to SQL Server with AD credentials.

- [ ] **Kubernetes Deployment**
  - **Description:** Explore the deployment of the SQL Server Availability Group on Kubernetes. This will involve creating Kubernetes manifests (Deployments, StatefulSets, Services, etc.) to manage the SQL Server containers and the AG.
  - **Tasks:**
    - [ ] Research and document best practices for running SQL Server on Kubernetes.
    - [ ] Create Kubernetes manifests for the SQL Server containers.
    - [ ] Configure a Kubernetes operator (e.g., the Microsoft SQL Server Operator) to manage the AG.
    - [ ] Define storage classes and persistent volumes for the SQL Server data.
    - [ ] Test the deployment and failover of the AG on a Kubernetes cluster.
