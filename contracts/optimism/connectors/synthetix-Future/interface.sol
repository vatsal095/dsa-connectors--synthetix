interface IFuturesMarket {
    function assetPrice() external view returns (uint256 price, bool invalid);

    function baseAsset() external view returns (bytes32 key);

    function remainingMargin(address account) external view returns (uint256 marginRemaining, bool invalid);

    function transferMargin(int256 marginDelta) external;

    function withdrawAllMargin() external;

    function modifyPositionWithTracking(int256 sizeDelta, bytes32 trackingCode) external;
    
    struct TradeParams {
        int sizeDelta;
        uint price;
        uint takerFee;
        uint makerFee;
        bytes32 trackingCode; // optional tracking code for volume source fee sharing
    }
}
interface IExchangeRates {
    function rateAndInvalid(
        bytes32 currencyKey
    ) external view returns (uint rate, bool isInvalid);
}
interface ISynthetix {

    function exchange(
        bytes32 sourceCurrencyKey,
        uint sourceAmount,
        bytes32 destinationCurrencyKey
    ) external returns (uint amountReceived);
  
    function exchangeOnBehalf(
        address exchangeForAddress,
        bytes32 sourceCurrencyKey,
        uint sourceAmount,
        bytes32 destinationCurrencyKey
    ) external returns (uint amountReceived);

    function exchangeWithTracking(
        bytes32 sourceCurrencyKey,
        uint sourceAmount,
        bytes32 destinationCurrencyKey,
        address rewardAddress,
        bytes32 trackingCode
    ) external returns (uint256 amountReceived);

}


