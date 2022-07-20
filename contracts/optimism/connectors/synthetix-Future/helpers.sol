//SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;



import { DSMath } from "../../common/math.sol";
import { Basic } from "../../common/basic.sol";
import { IFuturesMarket, IExchangeRates, ISynthetix} from "./interface.sol";

abstract contract Helpers is DSMath, Basic {
    /**
	 * @dev future market 
	 */
    IFuturesMarket internal constant futureMarket = 
    // TODO: need to find the address and pass here 
        IFuturesMarket(0x834Ef6c82D431Ac9A7A6B66325F185b2430780D7);


    IExchangeRates internal constant exchangeRates = 
     // TODO: need to find the address and pass here 
        IExchangeRates(0xb4dc5ced63C2918c89E491D19BF1C0e92845de7C);


    ISynthetix internal constant synthetix = 
     // TODO: need to find the address and pass here 
        ISynthetix(0x08F30Ecf2C15A783083ab9D5b9211c22388d0564);

    function getSpotPrice(bytes32 currencyKey) 
        internal 
        view 
        returns (uint rate) {
            (uint spotprice,) = exchangeRates.rateAndInvalid(currencyKey);
            return spotprice; 
    }   
    
    function totalMargin(address user)
        internal
        view 
        returns (uint256 marginRemaining) {

        (uint marginRemaining,) = futureMarket.remainingMargin(msg.sender);
        return marginRemaining;
    }

    function underlyingReceivedForOpen(uint amount, bytes32 currencyKey)
        internal
        returns(uint256) 
    {
        uint256 underlyingReceived = synthetix.exchangeWithTracking("sUSD", amount, currencyKey, address(this), "TRACKING_CODE"); 
        return underlyingReceived;
    }
    function underlyingReceivedForClose(uint amount, bytes32 currencyKey)
        internal
        returns(uint256) 
    {
        uint256 underlyingReceived = synthetix.exchangeWithTracking(currencyKey, amount,"sUSD",  address(this), "TRACKING_CODE"); 
        return underlyingReceived;
    }
}