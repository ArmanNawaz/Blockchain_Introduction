const intro = artifacts.require("Introduction");

module.exports = function (deployer) {
  deployer.deploy(intro);
};
