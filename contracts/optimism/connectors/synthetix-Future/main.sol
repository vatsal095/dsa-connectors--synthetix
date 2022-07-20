//SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

/**
 * @title synthetix-future
 * @dev future market
 */

import { DSMath } from "../../common/math.sol";

import { TokenInterface , MemoryInterface } from "../../common/interfaces.sol";

import { Stores } from "../../common/stores.sol";

import { Helpers } from "./helpers.sol";

import { Events } from "./events.sol";
abstract contract SynthetixFutureResolver is DSMath,Events, Helpers {
    function openPosition(
        uint amount, 
        bytes32 currencyKey, 
        uint leverage,
        bool positiontype  // true for long/open and false for short/close
    ) 
    external
    payable

    {
        uint256 spotPrice = getSpotPrice(currencyKey);
        uint256 totalPosition = mul(spotPrice,amount);
        uint256 futuresCost = div(totalPosition,leverage);
        uint256 underlyingReceived = underlyingReceivedForOpen(totalPosition, currencyKey);
        futureMarket.transferMargin(int256(futuresCost));
        if(positiontype == true)
            futureMarket.modifyPositionWithTracking(int(underlyingReceived), bytes32(0));
        else {
            futureMarket.modifyPositionWithTracking(-int(underlyingReceived), bytes32(0));
        }
        
    }


    function closePosition(
        uint amount,
        bytes32 currencyKey,
        bool positiontype // true/open for long and false for short/close
    )
    external
    payable
    {
        uint256 spotPrice = getSpotPrice(currencyKey);
        uint256 sUSDReceived = underlyingReceivedForClose(amount, currencyKey);
        uint256 totalMargin = totalMargin(msg.sender);
        uint256 marginToWithdraw = mul(amount,totalMargin);
        if(positiontype == true)
            futureMarket.modifyPositionWithTracking(-int256(amount), bytes32(0));
        else
            futureMarket.modifyPositionWithTracking(-int256(amount), bytes32(0));
        futureMarket.transferMargin(int256(marginToWithdraw));
    }

    function openBasisTrading(
        uint amount,
        bytes32 currencyKey
    )
    external
    payable 
    {
        uint256 spotPrice = getSpotPrice(currencyKey);
        uint256 basisOpenAmount = div(amount, 2);
        uint256 totalPosition = mul(spotPrice,basisOpenAmount);
        uint256 futuresCost = div(totalPosition,1); //with 1x leverage
        uint256 underlyingReceived = underlyingReceivedForOpen(totalPosition, currencyKey);
        futureMarket.transferMargin(int256(futuresCost));
        futureMarket.modifyPositionWithTracking(-int(underlyingReceived), bytes32(0));
    }
    function closeBasisTrading(
        uint amount, 
        bytes32 currencyKey

    )
    external
    payable
    {
        uint256 spotPrice = getSpotPrice(currencyKey);
        uint256 basisCloseAmount = div(amount,2);
        uint256 sUSDReceived = underlyingReceivedForClose(basisCloseAmount, currencyKey);
        uint256 totalMargin = totalMargin(msg.sender);
        uint256 marginToWithdraw = mul(basisCloseAmount,totalMargin);
        futureMarket.modifyPositionWithTracking(int256(amount), bytes32(0));
    }

}

contract synthetixFuture is SynthetixFutureResolver {
	string public constant name = "SynthetixFuture";
}