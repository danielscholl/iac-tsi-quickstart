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

      it('should have 3 parameters', () => actual.length.should.be.exactly(3));
      it('should have a initials', () => actual.should.containEql('initials'));
      it('should have a random', () => actual.should.containEql('random'));
      it('should have a storageAccountType', () => actual.should.containEql('storageAccountType'));
    });

    context('creates the expected resources', () => {
      const actual = template.resources.map(resource => resource.type);
      const securityGroups = actual.filter(resource => resource === 'Microsoft.Network/networkSecurityGroups');

      it('should have 1 resources', () => actual.length.should.be.exactly(1));
      it('should create Microsoft.Storage/storageAccounts', () => actual.should.containEql('Microsoft.Storage/storageAccounts'));
    });

    context('storage has expected properties', () => {
      const storage = template.resources.find(resource => resource.type === 'Microsoft.Storage/storageAccounts');

      it('should define accessTier', () => should.exist(storage.properties.accessTier));
      it('should define supportsHttpsTrafficOnly', () => should.exist(storage.properties.supportsHttpsTrafficOnly));
      it('should define isHnsEnabled', () => should.exist(storage.properties.isHnsEnabled));

      it('should have ADSL Gen2 Enabled', () => template.variables.isHnsEnabled.should.be.true());
    });

    context('has expected output', () => {
      it('should define storageAccount', () => should.exist(template.outputs.storageAccount));
      it('should define storageAccount id', () => should.exist(template.outputs.storageAccount.value.id));
      it('should define storageAccount name', () => should.exist(template.outputs.storageAccount.value.name));
      it('should define storageAccount key', () => should.exist(template.outputs.storageAccount.value.key));
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