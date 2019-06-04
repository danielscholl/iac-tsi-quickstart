require('tap').mochaGlobals();
const should = require('should');

const template = require('../azuredeploy.json');
const parameters = require('../azuredeploy.parameters.json');

describe('iac-tsi-quickstart', () => {
  context('template file', () => {
    it('should exist', () => should.exist(template));

    context('has expected properties', () => {
      it('should have property $schema', () => should.exist(template.$schema));
      it('should have property contentVersion', () => should.exist(template.contentVersion));
      it('should have property parameters', () => should.exist(template.parameters));
      it('should have property variables', () => should.exist(template.variables));
      it('should have property resources', () => should.exist(template.resources));
      it('should have property outputs', () => should.exist(template.outputs));
    });

    context('defines the expected parameters', () => {
      const actual = Object.keys(template.parameters);

      it('should have 8 parameters', () => actual.length.should.be.exactly(8));
      it('should have a initials', () => actual.should.containEql('initials'));
      it('should have a random', () => actual.should.containEql('random'));
      it('should have a storageAccountType', () => actual.should.containEql('storageAccountType'));
      it('should have a timeSeriesId', () => actual.should.containEql('timeSeriesId'));
      it('should have a timeSeriesTimeStamp', () => actual.should.containEql('timeSeriesTimeStamp'));
      it('should have a timeSeriesOwnerId', () => actual.should.containEql('timeSeriesOwnerId'));
    });

    context('creates the expected resources', () => {
      const actual = template.resources.map(resource => resource.type);

      it('should have 6 resources', () => actual.length.should.be.exactly(6));
      it('should create Microsoft.Storage/storageAccounts', () => actual.should.containEql('Microsoft.Storage/storageAccounts'));
      it('should create Microsoft.Devices/IotHubs', () => actual.should.containEql('Microsoft.Devices/IotHubs'));
      it('should create Microsoft.TimeSeriesInsights/environments', () => actual.should.containEql('Microsoft.TimeSeriesInsights/environments'));
      it('should create Microsoft.TimeSeriesInsights/environments/accesspolicies', () => actual.should.containEql('Microsoft.TimeSeriesInsights/environments/accesspolicies'));
    });

    context('storage has expected properties', () => {
      const storage = template.resources.find(resource => resource.type === 'Microsoft.Storage/storageAccounts');

      it('should define accessTier', () => should.exist(storage.properties.accessTier));
      it('should define supportsHttpsTrafficOnly', () => should.exist(storage.properties.supportsHttpsTrafficOnly));
      it('should define isHnsEnabled', () => should.exist(storage.properties.isHnsEnabled));
      it('should enable ADSL Gen2', () => template.variables.IsHnsEnabled.should.be.false());
      it('should enable HTTPS Only', () => template.variables.SupportsHttpsTrafficOnly.should.be.false());
    });

    context('IoThub has expected properties', () => {
      const hub = template.resources.find(resource => resource.type === 'Microsoft.Devices/IotHubs');

      it('should specify S3 SKU', () => should.exist(hub.sku.name.should.be.equal("S3")));
      it('should specify Standard tier', () => should.exist(hub.sku.tier.should.be.equal("Standard")));
      it('should specify 1 Instance', () => should.exist(hub.sku.capacity.should.be.equal(1)));
    });

    context('TsiEnvironment has expected properties', () => {
      const tsi = template.resources.find(resource => resource.type === 'Microsoft.TimeSeriesInsights/environments');

      it('should specify L1 Preview', () => should.exist(tsi.sku.name.should.be.equal("L1")));
      it('should specify 1 Instance', () => should.exist(tsi.sku.capacity.should.be.equal(1)));
    });

    context('has expected output', () => {
      it('should define storageAccount', () => should.exist(template.outputs.storageAccount));
      it('should define storageAccount id', () => should.exist(template.outputs.storageAccount.value.id));
      it('should define storageAccount name', () => should.exist(template.outputs.storageAccount.value.name));
      it('should define storageAccount key', () => should.exist(template.outputs.storageAccount.value.key));
      it('should define iotHub', () => should.exist(template.outputs.iotHub));
      it('should define iotHub id', () => should.exist(template.outputs.iotHub.value.id));
      it('should define iotHub keys', () => should.exist(template.outputs.iotHub.value.keys));
      it('should define tsiEnvironment', () => should.exist(template.outputs.tsi));
      it('should define tsiEnvironment id', () => should.exist(template.outputs.tsi.value.id));
    });
  });

  context('parameters file', (done) => {
    it('should exist', () => should.exist(parameters));

    context('has expected properties', () => {
      it('should define $schema', () => should.exist(parameters.$schema));
      it('should define contentVersion', () => should.exist(parameters.contentVersion));
      it('should define parameters', () => should.exist(parameters.parameters));
    });
  });
});