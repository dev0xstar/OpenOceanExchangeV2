const OpenOceanState = artifacts.require("OpenOceanState");
const OpenOceanCaller = artifacts.require("OpenOceanCaller");
const OpenOceanExchange = artifacts.require("OpenOceanExchange");

module.exports = function (deployer) {
    deployer.deploy(OpenOceanState).then(function () {
        return deployer.deploy(OpenOceanCaller).then(function () {
            return deployer.deploy(OpenOceanExchange);
        });
    });
};
