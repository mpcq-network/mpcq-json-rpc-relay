// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.5.0 <0.9.0;
pragma experimental ABIEncoderV2;

import "../FeeHelper.sol";

contract BaseHTS is FeeHelper {

    string name = "tokenName";
    string symbol = "tokenSymbol";
    string memo = "memo";
    uint initialTotalSupply = 1000;
    uint32 maxSupply = 1000;
    uint decimals = 8;

    event CreatedToken(address tokenAddress);

    function createToken(
        address treasury
    ) public payable {
        IMPCQTokenService.TokenKey[] memory keys = new IMPCQTokenService.TokenKey[](1);
        keys[0] = getSingleKey(0, 0, 1, bytes(""));

        IMPCQTokenService.Expiry memory expiry = IMPCQTokenService.Expiry(
            0, treasury, 8000000
        );

        IMPCQTokenService.MPCQToken memory token = IMPCQTokenService.MPCQToken(
            name, symbol, treasury, memo, true, maxSupply, false, keys, expiry
        );

        (int responseCode, address tokenAddress) =
        MPCQTokenService.createFungibleToken(token, initialTotalSupply, decimals);

        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert ();
        }

        emit CreatedToken(tokenAddress);
    }

    function associateTokenTo(address account, address token) public returns (int responseCode) {
        responseCode = MPCQTokenService.associateToken(account, token);
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
    }

    function transferTokenTo(address account, address token, int64 amount) public returns (int responseCode) {
        IMPCQTokenService.NftTransfer[] memory nftTransfers = new IMPCQTokenService.NftTransfer[](0);

        IMPCQTokenService.AccountAmount memory accountAmountNegative =
        IMPCQTokenService.AccountAmount(msg.sender, - amount);
        IMPCQTokenService.AccountAmount memory accountAmountPositive =
        IMPCQTokenService.AccountAmount(account, amount);
        IMPCQTokenService.AccountAmount[] memory transfers = new IMPCQTokenService.AccountAmount[](2);
        transfers[0] = accountAmountNegative;
        transfers[1] = accountAmountPositive;

        IMPCQTokenService.TokenTransferList memory tokenTransfer =
        IMPCQTokenService.TokenTransferList(token, transfers, nftTransfers);
        IMPCQTokenService.TokenTransferList[] memory tokenTransferList = new IMPCQTokenService.TokenTransferList[](1);
        tokenTransferList[0] = tokenTransfer;

        responseCode = MPCQTokenService.cryptoTransfer(tokenTransferList);
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
    }

    function transferTokenFrom(address account, address token, int64 amount) public returns (int responseCode) {
        IMPCQTokenService.NftTransfer[] memory nftTransfers = new IMPCQTokenService.NftTransfer[](0);

        IMPCQTokenService.AccountAmount memory accountAmountNegative =
        IMPCQTokenService.AccountAmount(msg.sender, - amount);
        IMPCQTokenService.AccountAmount memory accountAmountPositive =
        IMPCQTokenService.AccountAmount(account, amount);
        IMPCQTokenService.AccountAmount[] memory transfers = new IMPCQTokenService.AccountAmount[](2);
        transfers[0] = accountAmountNegative;
        transfers[1] = accountAmountPositive;

        IMPCQTokenService.TokenTransferList memory tokenTransfer =
        IMPCQTokenService.TokenTransferList(token, transfers, nftTransfers);
        IMPCQTokenService.TokenTransferList[] memory tokenTransferList = new IMPCQTokenService.TokenTransferList[](1);
        tokenTransferList[0] = tokenTransfer;

        responseCode = MPCQTokenService.cryptoTransfer(tokenTransferList);
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
    }

    function transferFrom(address account, address token, int64 amount) public returns (int responseCode) {
        IMPCQTokenService.NftTransfer[] memory nftTransfers = new IMPCQTokenService.NftTransfer[](0);

        IMPCQTokenService.AccountAmount memory accountAmountNegative =
        IMPCQTokenService.AccountAmount(msg.sender, - amount);
        IMPCQTokenService.AccountAmount memory accountAmountPositive =
        IMPCQTokenService.AccountAmount(account, amount);
        IMPCQTokenService.AccountAmount[] memory transfers = new IMPCQTokenService.AccountAmount[](2);
        transfers[0] = accountAmountNegative;
        transfers[1] = accountAmountPositive;

        IMPCQTokenService.TokenTransferList memory tokenTransfer =
        IMPCQTokenService.TokenTransferList(token, transfers, nftTransfers);
        IMPCQTokenService.TokenTransferList[] memory tokenTransferList = new IMPCQTokenService.TokenTransferList[](1);
        tokenTransferList[0] = tokenTransfer;

        responseCode = MPCQTokenService.cryptoTransfer(tokenTransferList);
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
    }

    function transferTo(address account, address token, int64 amount) public returns (int responseCode) {
        IMPCQTokenService.NftTransfer[] memory nftTransfers = new IMPCQTokenService.NftTransfer[](0);

        IMPCQTokenService.AccountAmount memory accountAmountNegative =
        IMPCQTokenService.AccountAmount(msg.sender, - amount);
        IMPCQTokenService.AccountAmount memory accountAmountPositive =
        IMPCQTokenService.AccountAmount(account, amount);
        IMPCQTokenService.AccountAmount[] memory transfers = new IMPCQTokenService.AccountAmount[](2);
        transfers[0] = accountAmountNegative;
        transfers[1] = accountAmountPositive;

        IMPCQTokenService.TokenTransferList memory tokenTransfer =
        IMPCQTokenService.TokenTransferList(token, transfers, nftTransfers);
        IMPCQTokenService.TokenTransferList[] memory tokenTransferList = new IMPCQTokenService.TokenTransferList[](1);
        tokenTransferList[0] = tokenTransfer;

        responseCode = MPCQTokenService.cryptoTransfer(tokenTransferList);
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
    }

    function sendTo(address account, address token, int64 amount) public returns (int responseCode) {
        IMPCQTokenService.NftTransfer[] memory nftTransfers = new IMPCQTokenService.NftTransfer[](0);

        IMPCQTokenService.AccountAmount memory accountAmountNegative =
        IMPCQTokenService.AccountAmount(msg.sender, - amount);
        IMPCQTokenService.AccountAmount memory accountAmountPositive =
        IMPCQTokenService.AccountAmount(account, amount);
        IMPCQTokenService.AccountAmount[] memory transfers = new IMPCQTokenService.AccountAmount[](2);
        transfers[0] = accountAmountNegative;
        transfers[1] = accountAmountPositive;

        IMPCQTokenService.TokenTransferList memory tokenTransfer =
        IMPCQTokenService.TokenTransferList(token, transfers, nftTransfers);
        IMPCQTokenService.TokenTransferList[] memory tokenTransferList = new IMPCQTokenService.TokenTransferList[](1);
        tokenTransferList[0] = tokenTransfer;

        responseCode = MPCQTokenService.cryptoTransfer(tokenTransferList);
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
    }

    function sendFrom(address account, address token, int64 amount) public returns (int responseCode) {
        IMPCQTokenService.NftTransfer[] memory nftTransfers = new IMPCQTokenService.NftTransfer[](0);

        IMPCQTokenService.AccountAmount memory accountAmountNegative =
        IMPCQTokenService.AccountAmount(msg.sender, - amount);
        IMPCQTokenService.AccountAmount memory accountAmountPositive =
        IMPCQTokenService.AccountAmount(account, amount);
        IMPCQTokenService.AccountAmount[] memory transfers = new IMPCQTokenService.AccountAmount[](2);
        transfers[0] = accountAmountNegative;
        transfers[1] = accountAmountPositive;

        IMPCQTokenService.TokenTransferList memory tokenTransfer =
        IMPCQTokenService.TokenTransferList(token, transfers, nftTransfers);
        IMPCQTokenService.TokenTransferList[] memory tokenTransferList = new IMPCQTokenService.TokenTransferList[](1);
        tokenTransferList[0] = tokenTransfer;

        responseCode = MPCQTokenService.cryptoTransfer(tokenTransferList);
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
    }
    function getTokenInformation(address token) public returns (int responseCode, IMPCQTokenService.TokenInfo memory tokenInfo) {
        (responseCode, tokenInfo) = MPCQTokenService.getTokenInfo(token);
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
        return (responseCode, tokenInfo);
    }
}
