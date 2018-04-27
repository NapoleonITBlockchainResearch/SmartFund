const OfferFabric = artifacts.require("./OfferFabric.sol")

module.exports = function(deployer) {
	deployer.deploy(OfferFabric);
};