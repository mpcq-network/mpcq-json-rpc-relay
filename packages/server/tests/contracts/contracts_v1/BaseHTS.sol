// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.5.0 <0.9.0;
pragma experimental ABIEncoderV2;

import "./FeeHelper.sol";

contract BaseHTS is FeeHelper {

    string name = "tokenName";
    string symbol = "tokenSymbol";
    string memo = "memo";
    uint initialTotalSupply = 1000;
    uint32 maxSupply = 1000;
    uint decimals = 8;
    bool freezeDefaultStatus = false;

    event CreatedToken(address tokenAddress);
    event ResponseCode(int responseCode);

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

    function associateTokenPublic(address account, address token) public returns (int responseCode) {
        responseCode = MPCQTokenService.associateToken(account, token);
        emit ResponseCode(responseCode);
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert ();
        }
    }

        function createFungibleTokenWithCustomFeesPublic(
        address treasury,
        address fixedFeeTokenAddress
    ) public payable {
        IMPCQTokenService.TokenKey[] memory keys = new IMPCQTokenService.TokenKey[](1);
        keys[0] = getSingleKey(0, 0, 1, bytes(""));

        IMPCQTokenService.Expiry memory expiry = IMPCQTokenService.Expiry(
            0, treasury, 8000000
        );

        IMPCQTokenService.MPCQToken memory token = IMPCQTokenService.MPCQToken(
            name, symbol, treasury, memo, true, maxSupply, false, keys, expiry
        );

        IMPCQTokenService.FixedFee[] memory fixedFees = new IMPCQTokenService.FixedFee[](1);
        fixedFees[0] = IMPCQTokenService.FixedFee(1, fixedFeeTokenAddress, false, false, treasury);

        IMPCQTokenService.FractionalFee[] memory fractionalFees = new IMPCQTokenService.FractionalFee[](1);
        fractionalFees[0] = IMPCQTokenService.FractionalFee(4, 5, 10, 30, false, treasury);

        (int responseCode, address tokenAddress) =
        MPCQTokenService.createFungibleTokenWithCustomFees(token, initialTotalSupply, decimals, fixedFees, fractionalFees);
        emit ResponseCode(responseCode);

        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert ();
        }

        emit CreatedToken(tokenAddress);
    }
}