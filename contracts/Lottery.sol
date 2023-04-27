// SPDX-License-Identifier: MIT

pragma solidity >=0.8 <0.9.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Lottery is Ownable {
    address payable[] public players;
    uint256 public usdEntryFee;
    AggregatorV3Interface internal ethUsdPriceFeed;
    enum LOTTERY_STATE {
        OPEN,
        CLOSED,
        CALCULATING_WINNER
    }
    // OPEN = 0, CLOSED = 1, CALCULATING_WINNER = 2

    LOTTERY_STATE public lottery_state;

    constructor(address _priceFeedAddress) {
        usdEntryFee = 12 * (10 ** 18);
        ethUsdPriceFeed = AggregatorV3Interface(_priceFeedAddress);
        lottery_state = LOTTERY_STATE.CLOSED;
    }

    function enter() public payable {
        // 12$ min
        require(lottery_state == LOTTERY_STATE.OPEN);
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

    //onlyAdmin
    function startLottery() public onlyOwner {
        require(
            lottery_state == LOTTERY_STATE.CLOSED,
            "Can't start a new lottery yet"
        );
        lottery_state = LOTTERY_STATE.OPEN;
    }

    function endLottery() public onlyOwner {
        lottery_state = LOTTERY_STATE.CALCULATING_WINNER;
    }
}
