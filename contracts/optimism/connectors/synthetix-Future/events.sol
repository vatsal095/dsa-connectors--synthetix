pragma solidity ^0.7.0;

contract Events {
    event MarginTransferred(address indexed account, int marginDelta);

    event PositionModified(
        uint indexed id,
        address indexed account,
        uint margin,
        int size,
        int tradeSize,
        uint lastPrice,
        uint fundingIndex,
        uint fee
    );

    event PositionLiquidated(
        uint indexed id,
        address indexed account,
        address indexed liquidator,
        int size,
        uint price,
        uint fee
    );

    event FundingRecomputed(int funding, uint index, uint timestamp);

    event FuturesTracking(bytes32 indexed trackingCode, bytes32 baseAsset, bytes32 marketKey, int sizeDelta, uint fee);

    event MarketAdded(address market, bytes32 indexed asset, bytes32 indexed marketKey);

    event MarketRemoved(address market, bytes32 indexed asset, bytes32 indexed marketKey);

    
}