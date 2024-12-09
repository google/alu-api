# ALU API Deployment Resources

This repository contains resources to deploy the [ALU API](https://agri.withgoogle.com/developer/)
service on your GCP project. Please refer to the [Customer Onboarding](./customer_onboarding.md)
documentation for instructions on using this repository.

## Resources

This repository contains the following resources:

- `terraform/`: contains Terraform configuration files for deploying cloud services.
- `apirproxy/`: contains configuration files for the Apigee API proxy.
- `apiproduct-op-group.json`: defines the configuration for the Apigee product.
- `notebook/`: contains Jupyter notebooks for utility scripts.
  - `s2cell_id_from_kml_example.ipynb`: contains a guide for extracting
    S2Cell ID from KML file.
- `customer_onboarding.md`: contains instructions for deploying the service.
