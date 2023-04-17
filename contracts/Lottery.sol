// SPDX-License-Identifier: MIT

pragma solidity >=0.8 <0.9.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract Lottery {
    address payable[] public players;
    uint256 public usdEntryFee;
    AggregatorV3Interface internal ethUsdPriceFeed;

    constructor(address _priceFeedAddress) {
        usdEntryFee = 12 * (10 ** 18);
        ethUsdPriceFeed = AggregatorV3Interface(_priceFeedAddress);
    }

    function enter() public payable {
        // 12$ min
        require(
            msg.value >= usdEntryFee,
            "Not enough ether to enter the lottery"
        );

        players.push(payable(msg.sender));
    }

    function getEntranceFee() public view returns (uint256) {
        (, int price, , , ) = ethUsdPriceFeed.latestRoundData();
        uint256 adjustedPrice = uint256(price) * (10 ** 10); //18 decimals
        uint256 costToEnter = (usdEntryFee * (10 ** 18)) / adjustedPrice;
        return costToEnter;
        // 12$, 2,000$ / ETH
    }

    //modifier onlyAdmin() {}

    //function startLottery() public onlyAdmin {}

    function endLottery() public {}
}
