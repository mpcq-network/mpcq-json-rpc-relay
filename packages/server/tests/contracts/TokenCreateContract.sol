// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.5.0 <0.9.0;
pragma experimental ABIEncoderV2;

import "./TokenCreate.sol";

contract TokenContractContract is TokenCreate {


    event AllowanceValue(uint256 amount);
    event ApprovedAddress(address approved);
    event Approved(bool approved);
    event FungibleTokenInfo(IMPCQTokenService.FungibleTokenInfo tokenInfo);
    event TokenCustomFees(IMPCQTokenService.FixedFee[] fixedFees, IMPCQTokenService.FractionalFee[] fractionalFees, IMPCQTokenService.RoyaltyFee[] royaltyFees);
    event TokenDefaultKycStatus(bool defaultKycStatus);
    event KycGranted(bool kycGranted);

    function approvePublic(address token, address spender, uint256 amount) public returns (int responseCode) {
        responseCode = MPCQTokenService.approve(token, spender, amount);
        emit ResponseCode(responseCode);
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert ();
        }
    }

    function approveNFTPublic(address token, address approved, uint256 serialNumber) public returns (int responseCode)
    {
        responseCode = MPCQTokenService.approveNFT(token, approved, serialNumber);

        emit ResponseCode(responseCode);

        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert ();
        }
    }

    function allowancePublic(address token, address owner, address spender) public returns (int responseCode, uint256 amount) {
        (responseCode, amount) = MPCQTokenService.allowance(token, owner, spender);
        emit ResponseCode(responseCode);
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert ();
        }
        emit AllowanceValue(amount);
    }


    function transferTokenPublic(address token, address sender, address receiver, int64 amount) public returns (int responseCode) {
        responseCode = MPCQTokenService.transferToken(token, sender, receiver, amount);
        emit ResponseCode(responseCode);
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
    }

    function cryptoTransferPublic(IMPCQTokenService.TokenTransferList[] calldata tokenTransferList) public returns (int responseCode) {
        responseCode = MPCQTokenService.cryptoTransfer(tokenTransferList);
        emit ResponseCode(responseCode);
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
    }

    function getApprovedPublic(address token, uint256 serialNumber) public returns (int responseCode, address approved)
    {
        (responseCode, approved) = MPCQTokenService.getApproved(token, serialNumber);
        emit ResponseCode(responseCode);

        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }

        emit ApprovedAddress(approved);
    }

    function setApprovalForAllPublic(address token, address operator, bool approved) public returns (int responseCode)
    {
        responseCode = MPCQTokenService.setApprovalForAll(token, operator, approved);
        emit ResponseCode(responseCode);

        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
    }


    function isApprovedForAllPublic(address token, address owner, address operator) public returns (int responseCode, bool approved)
    {
        (responseCode, approved) = MPCQTokenService.isApprovedForAll(token, owner, operator);
        emit ResponseCode(responseCode);

        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }

        emit Approved(approved);
    }

    function getFungibleTokenInfoPublic(address token) public returns (int responseCode, IMPCQTokenService.FungibleTokenInfo memory tokenInfo) {
        (responseCode, tokenInfo) = MPCQTokenService.getFungibleTokenInfo(token);

        emit ResponseCode(responseCode);

        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }

        emit FungibleTokenInfo(tokenInfo);
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

    function getTokenCustomFeesPublic(address token) public returns (
        int64 responseCode,
        IMPCQTokenService.FixedFee[] memory fixedFees,
        IMPCQTokenService.FractionalFee[] memory fractionalFees,
        IMPCQTokenService.RoyaltyFee[] memory royaltyFees) {
        (responseCode, fixedFees, fractionalFees, royaltyFees) = MPCQTokenService.getTokenCustomFees(token);
        emit ResponseCode(responseCode);

        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }

        emit TokenCustomFees(fixedFees, fractionalFees, royaltyFees);
    }

    function deleteTokenPublic(address token) public returns (int responseCode) {
        responseCode = MPCQTokenService.deleteToken(token);
        emit ResponseCode(responseCode);

        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
    }

    function getTokenDefaultKycStatusPublic(address token) public returns (int responseCode, bool defaultKycStatus) {
        (responseCode, defaultKycStatus) = MPCQTokenService.getTokenDefaultKycStatus(token);

        emit ResponseCode(responseCode);

        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }

        emit TokenDefaultKycStatus(defaultKycStatus);
    }

    function isKycPublic(address token, address account) external returns (int64 responseCode, bool kycGranted){
        (responseCode, kycGranted) = this.isKyc(token, account);

        emit ResponseCode(responseCode);

        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }

        emit KycGranted(kycGranted);
    }

    function revokeTokenKycPublic(address token, address account) external returns (int64 responseCode){
        (responseCode) = this.revokeTokenKyc(token, account);

        emit ResponseCode(responseCode);

        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
    }
}