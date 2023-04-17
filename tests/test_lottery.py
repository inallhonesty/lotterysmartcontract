# 0.019
# 190000000000000000
from brownie import Lottery, accounts, network, config
from web3 import Web3

print(network.show_active())


def test_get_entrance_fee():
    account = accounts[0]
    active_network = network.show_active()

    assert active_network in config["networks"], f"Invalid network '{active_network}'"
    lottery = Lottery.deploy(
        config["networks"][active_network]["eth_usd_price_feed"],
        {"from": account},
    )
    print(active_network)
    assert lottery.getEntranceFee() > Web3.toWei(0.005, "ether")
    assert lottery.getEntranceFee() < Web3.toWei(0.006, "ether")
