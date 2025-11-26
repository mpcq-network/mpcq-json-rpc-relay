// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.5.0 <0.9.0;
pragma experimental ABIEncoderV2;

import "./FeeHelper.sol";

abstract contract TokenCreate is FeeHelper {

    string name = "tokenName";
    string symbol = "tokenSymbol";
    string memo = "memo";
    uint64 initialTotalSupply = 1000;
    int64 maxSupply = 1000;
    uint32 decimals = 8;
    bool freezeDefaultStatus = false;

    event CreatedToken(address tokenAddress);
    event ResponseCode(int responseCode);
    event MintedToken(uint64 newTotalSupply, int64[] serialNumbers);
    event NonFungibleTokenInfo(IMPCQTokenService.NonFungibleTokenInfo tokenInfo);
    event TokenInfo(IMPCQTokenService.TokenInfo tokenInfo);

    function createFungibleTokenPublic(
        address treasury
    ) public payable {
        IMPCQTokenService.TokenKey[] memory keys = new IMPCQTokenService.TokenKey[](4);
        keys[0] = getSingleKey(0, 6, 1, bytes(""));
        keys[1] = getSingleKey(1, 1, bytes(""));
        keys[2] = getSingleKey(2, 1, bytes(""));
        keys[3] = getSingleKey(3, 1, bytes(""));

        IMPCQTokenService.Expiry memory expiry = IMPCQTokenService.Expiry(
            0, treasury, 8000000
        );

        IMPCQTokenService.MPCQToken memory token = IMPCQTokenService.MPCQToken(
            name, symbol, treasury, memo, true, maxSupply, freezeDefaultStatus, keys, expiry
        );

        (int responseCode, address tokenAddress) =
        MPCQTokenService.createFungibleToken(token, initialTotalSupply, decimals);

        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert ();
        }

        emit CreatedToken(tokenAddress);
    }

    function createNonFungibleTokenPublic(
        address treasury
    ) public payable {
        IMPCQTokenService.TokenKey[] memory keys = new IMPCQTokenService.TokenKey[](5);
        keys[0] = getSingleKey(0, 6, 1, bytes(""));
        keys[1] = getSingleKey(1, 1, bytes(""));
        keys[2] = getSingleKey(2, 1, bytes(""));
        keys[3] = getSingleKey(4, 1, bytes(""));
        keys[4] = getSingleKey(3, 1, bytes(""));

        IMPCQTokenService.Expiry memory expiry = IMPCQTokenService.Expiry(
            0, treasury, 8000000
        );

        IMPCQTokenService.MPCQToken memory token = IMPCQTokenService.MPCQToken(
            name, symbol, treasury, memo, true, maxSupply, freezeDefaultStatus, keys, expiry
        );

        (int responseCode, address tokenAddress) =
        MPCQTokenService.createNonFungibleToken(token);

        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert ();
        }

        emit CreatedToken(tokenAddress);
    }

    function cryptoTransferTokenPublic(address account, address token, int64 amount) public returns (int responseCode) {
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

    function mintTokenPublic(address token, uint64 amount, bytes[] memory metadata) public
    returns (int responseCode, uint64 newTotalSupply, int64[] memory serialNumbers) {
        (responseCode, newTotalSupply, serialNumbers) = MPCQTokenService.mintToken(token, amount, metadata);
        emit ResponseCode(responseCode);

        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }

        emit MintedToken(newTotalSupply, serialNumbers);
    }

    function transferNFTPublic(address token, address sender, address receiver, int64 serialNumber) public
    returns (int responseCode)
    {
        responseCode = MPCQTokenService.transferNFT(token, sender, receiver, serialNumber);
        emit ResponseCode(responseCode);
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert ();
        }
    }

    function associateTokenPublic(address account, address token) public returns (int responseCode) {
        responseCode = MPCQTokenService.associateToken(account, token);
        emit ResponseCode(responseCode);
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert ();
        }
    }

    function grantTokenKycPublic(address token, address account) external returns (int64 responseCode){
        (responseCode) = this.grantTokenKyc(token, account);

        emit ResponseCode(responseCode);

        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
    }

    function getNonFungibleTokenInfoPublic(address token, int64 serialNumber) public returns (int responseCode, IMPCQTokenService.NonFungibleTokenInfo memory tokenInfo) {
        (responseCode, tokenInfo) = MPCQTokenService.getNonFungibleTokenInfo(token, serialNumber);

        emit ResponseCode(responseCode);

        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }

        emit NonFungibleTokenInfo(tokenInfo);
    }

    function getTokenInfoPublic(address token) public returns (int responseCode, IMPCQTokenService.TokenInfo memory tokenInfo) {
        (responseCode, tokenInfo) = MPCQTokenService.getTokenInfo(token);

        emit ResponseCode(responseCode);

        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }

        emit TokenInfo(tokenInfo);
    }
}
