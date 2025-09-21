# Diagnóstico de Azure Deployment

## Verificar permisos del Service Principal

1. Ve a Azure Portal → Azure Active Directory → App registrations
2. Busca tu Service Principal (el que usaste para AZURE_CREDENTIALS)
3. Ve a "Certificates & secrets" para verificar que el secret no haya expirado

## Verificar roles en Resource Groups

1. Ve a tu Resource Group: `sebastian-ecommerce-api_group`
   - Clic en "Access control (IAM)"
   - Verificar que tu Service Principal tenga rol "Contributor"

2. Ve a tu Resource Group: `sebastian-ecommerce-web_group-9df4`
   - Clic en "Access control (IAM)" 
   - Verificar que tu Service Principal tenga rol "Contributor"

## Si no tienes permisos, agregar roles:

```bash
# Para API Resource Group
az role assignment create \
  --assignee <SERVICE_PRINCIPAL_ID> \
  --role "Contributor" \
  --resource-group "sebastian-ecommerce-api_group"

# Para Web Resource Group  
az role assignment create \
  --assignee <SERVICE_PRINCIPAL_ID> \
  --role "Contributor" \
  --resource-group "sebastian-ecommerce-web_group-9df4"
```

## URLs para verificar:
- Actions: https://github.com/UPT-FAING-EPIS/examen-2025-ii-pds-u1-SebastianFuentesAvalos/actions
- API: https://sebastian-ecommerce-api-cneebwapd4becrgf.eastus-01.azurewebsites.net
- Web: https://sebastian-ecommerce-web-g7g9fbgrdeh7ftbp.eastus-01.azurewebsites.net