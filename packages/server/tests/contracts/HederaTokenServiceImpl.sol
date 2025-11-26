// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.5.0 <0.9.0;
pragma experimental ABIEncoderV2;

import "./MPCQTokenService.sol";
import "./MPCQResponseCodes.sol";

contract MPCQTokenServiceImpl is MPCQTokenService {
    function isTokenAddress(address token) external returns (bool) {
        (int256 response, bool tokenFlag) = MPCQTokenService.isToken(token);

        if (response != MPCQResponseCodes.SUCCESS) {
            revert("Token isTokenAddress failed!");
        }
        return tokenFlag;
    }

    function isTokenFrozen(address token, address account) external returns (bool) {
        (int256 response, bool frozen) = MPCQTokenService.isFrozen(token, account);
        if (response != MPCQResponseCodes.SUCCESS) {
            revert("Token isFrozen failed!");
        }
        return frozen;
    }

    function isKycGranted(address token, address account) external returns (bool){
        (int256 response, bool kycGranted) = MPCQTokenService.isKyc(token, account);
        if (response != MPCQResponseCodes.SUCCESS) {
            revert("Token isKyc failed!");
        }
        return kycGranted;
    }

    function getTokenDefaultFreeze(address token) external returns (bool) {
        (int256 response, bool frozen) = MPCQTokenService.getTokenDefaultFreezeStatus(token);
        if (response != MPCQResponseCodes.SUCCESS) {
            revert("getTokenDefaultFreezeStatus failed!");
        }
        return frozen;
    }

    function getTokenDefaultKyc(address token) external returns (bool) {
        (int256 response, bool kyc) = MPCQTokenService.getTokenDefaultKycStatus(token);
        if (response != MPCQResponseCodes.SUCCESS) {
            revert("getTokenDefaultKycStatus failed!");
        }
        return kyc;
    }

    function getCustomFeesForToken(address token) external returns (
        IMPCQTokenService.FixedFee[] memory fixedFees,
        IMPCQTokenService.FractionalFee[] memory fractionalFees,
        IMPCQTokenService.RoyaltyFee[] memory royaltyFees
    )
    {
        int256 responseCode;
        (responseCode, fixedFees, fractionalFees, royaltyFees) = MPCQTokenService.getTokenCustomFees(token);
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
    }

    function getInformationForToken(address token) external returns (IMPCQTokenService.TokenInfo memory tokenInfo)
    {
        (int256 responseCode,IMPCQTokenService.TokenInfo memory retrievedTokenInfo) = MPCQTokenService.getTokenInfo(token);
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
        tokenInfo = retrievedTokenInfo;
    }

    function getInformationForFungibleToken(address token) external returns (IMPCQTokenService.FungibleTokenInfo memory fungibleTokenInfo)
    {
        (int256 responseCode,IMPCQTokenService.FungibleTokenInfo memory retrievedTokenInfo) = MPCQTokenService.getFungibleTokenInfo(token);
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
        fungibleTokenInfo = retrievedTokenInfo;
    }

    function getInformationForNonFungibleToken(address token, int64 serialNumber) external returns (
        IMPCQTokenService.NonFungibleTokenInfo memory nonFungibleTokenInfo
    )
    {
        (int256 responseCode,IMPCQTokenService.NonFungibleTokenInfo memory retrievedTokenInfo) = MPCQTokenService.getNonFungibleTokenInfo(token, serialNumber);
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
        nonFungibleTokenInfo = retrievedTokenInfo;
    }

    function getType(address token) external returns (int256) {
        (int256 statusCode, int256 tokenType) = MPCQTokenService.getTokenType(token);
        if (statusCode != MPCQResponseCodes.SUCCESS) {
            revert("Token type appraisal failed!");
        }
        return tokenType;
    }

    function getExpiryInfoForToken(address token) external returns (IMPCQTokenService.Expiry memory expiry)
    {
        (int256 responseCode,IMPCQTokenService.Expiry memory retrievedExpiry) = MPCQTokenService.getTokenExpiryInfo(token);
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
        expiry = retrievedExpiry;
    }

    function getTokenKeyPublic(address token, uint256 keyType) public returns (IMPCQTokenService.KeyValue memory)
    {
        (int256 responseCode,IMPCQTokenService.KeyValue memory key) = MPCQTokenService.getTokenKey(token, keyType);
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
        return key;
    }
}

