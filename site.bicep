param namePrefix string
param location string = resourceGroup().location
param dockerImage string
param dockerImageTag string
param appPlanId string

param locked bool

resource namePrefix_site 'Microsoft.Web/sites@2020-06-01' = {
  name: '${namePrefix}site'
  location: location
  properties: {
    siteConfig: {
      appSettings: [
        {
          name: 'DOCKER_REGISTRY_SERVER_URL'
          value: 'https://index.docker.io'
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_USERNAME'
          value: ''
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_PASSWORD'
          value: ''
        }
        {
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: 'false'
        }
      ]
      linuxFxVersion: 'DOCKER|${dockerImage}:${dockerImageTag}'
    }
    serverFarmId: appPlanId
  }
}

resource siteLock 'Microsoft.Authorization/locks@2016-09-01' = if (locked) {
  name: '${namePrefix}lock'
  properties: {
    level: 'CanNotDelete'
    notes: 'Don\'t delete this site!!!'
  }
  scope: namePrefix_site
}

output siteUrl string = namePrefix_site.properties.hostNames[0]
