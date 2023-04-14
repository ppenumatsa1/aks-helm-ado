# Variable block
let "randomIdentifier=$RANDOM*$RANDOM"
location="southcentralus"
resourceGroup="rg-ingenio"
containerRegistryDev="acrdev$randomIdentifier"
containerRegistryStage="acrstage$randomIdentifier"
containerRegistryProd="acrprod$randomIdentifier"
aksDev="aks-dev-$randomIdentifier"
aksStaging="aks-staging-$randomIdentifier"
aksProd="aks-prod-$randomIdentifier"


# Create a resource group
echo "Creating resource group $resourceGroup in "$location"..."
az group create --name $resourceGroup --location $location

# Create Dev container registry
echo "Creating container registry $containerRegistryDev in "$location"..."
az acr create --resource-group $resourceGroup --name $containerRegistryDev --sku Basic

# Create Stage container registry
echo "Creating container registry $containerRegistryStage in "$location"..."
az acr create --resource-group $resourceGroup --name $containerRegistryStage --sku Basic

# Create production container registry
echo "Creating container registry $containerRegistryProd in "$location"..."
az acr create --resource-group $resourceGroup --name $containerRegistryProd --sku Basic

# Create Dev Kubernetes cluster
echo "Creating dev aks cluster $aksDev in "$location"..."
az aks create \
    --resource-group $resourceGroup \
    --name $aksDev \
    --node-count 1 \
    --enable-addons monitoring \
    --attach-acr $containerRegistryDev \
    --generate-ssh-keys \
    --kubernetes-version 1.23.15 


# Create Staging Kubernetes cluster
echo "Creating staging aks cluster $aksStaging in "$location"..."
az aks create \
    --resource-group $resourceGroup \
    --name $aksStaging \
    --node-count 1 \
    --enable-addons monitoring \
    --attach-acr $containerRegistryStage \
    --generate-ssh-keys \
    --kubernetes-version 1.23.15 


# Create a Kubernetes cluster
echo "Creating aks Production cluster $aksProd in "$location"..."
az aks create \
    --resource-group $resourceGroup \
    --name $aksProd \
    --node-count 1 \
    --enable-addons monitoring \
    --attach-acr $containerRegistryProd \
    --generate-ssh-keys \
    --kubernetes-version 1.23.15
 

# Clean up Resource Group
# echo "Deleting resource group $resourceGroup in "$location"..."
# az group delete --name $resourceGroup
