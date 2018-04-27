var OfferFabric = artifacts.require("./OfferFabric");

contract('OfferFabric', function([owner, investor0]) {
    let offerFabric;

    beforeEach('setup contract for each test', async function () {
        offerFabric = await OfferFabric.new(owner)
    })

    it('has an owner', async function () {
        assert.equal(await offerFabric.owner(), owner)
    })

    it('creating offer', async () => {
        await offerFabric.createOffer("Offer 0", "test", 100e+18, 1e+18, 10e+18, 1);
        // await offerFabric.createOffer("Offer 0", "test", 100e+18, 1e+18, 10e+18, 1);
        // console.log("!!! " + offerFabric.offers(1) instanceof Promise);
        // assert.equal(offerFabric.offers(1), null);

        await offerFabric.offers(1).then(function(name) {
            
        });

        // assert.equal(offerFabric.offers(0).name, "Offer 0");
    })

    // it("should put 10000 MetaCoin in the first account", function() {
    //     return OfferFabric.deployed().then(function(instance) {
    //         return instance.getBalance.call(accounts[0]);
    //     }).then(function(balance) {
    //         assert.equal(balance.valueOf(), 10000, "10000 wasn't in the first account");
    //     });
    // });
});
