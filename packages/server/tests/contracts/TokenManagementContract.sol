// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.5.0 <0.9.0;
pragma experimental ABIEncoderV2;

import "./TokenCreate.sol";

contract TokenManagementContract is TokenCreate {

    event TokenType(int32 tokenType);
    event IsToken(bool isToken);
    event TokenKey(IMPCQTokenService.KeyValue key);
    event Frozen(bool frozen);
    event PausedToken(bool paused);
    event UnpausedToken(bool unpaused);
    event TokenDefaultFreezeStatus(bool defaultFreezeStatus);
    event DefaultFreezeStatusChanged(bool freezeStatus);
    event TokenExpiryInfo(IMPCQTokenService.Expiry expiryInfo);

    function wipeTokenAccountPublic(address token, address account, uint32 amount) public returns (int responseCode)
    {
        responseCode = MPCQTokenService.wipeTokenAccount(token, account, amount);
        emit ResponseCode(responseCode);
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert ();
        }
    }

    function wipeTokenAccountNFTPublic(address token, address account, int64[] memory serialNumbers) public
    returns (int responseCode)
    {
        responseCode = MPCQTokenService.wipeTokenAccountNFT(token, account, serialNumbers);
        emit ResponseCode(responseCode);
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert ();
        }
    }

    function updateTokenKeysPublic(address token, IMPCQTokenService.TokenKey[] memory keys)
    public returns (int64 responseCode){

        (responseCode) = MPCQTokenService.updateTokenKeys(token, keys);

        emit ResponseCode(responseCode);

        if(responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
    }

    function updateTokenInfoPublic(address token, IMPCQTokenService.MPCQToken memory tokenInfo)external returns (int responseCode){
        (responseCode) = this.updateTokenInfo(token, tokenInfo);

        emit ResponseCode(responseCode);

        if(responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
    }

    function isTokenPublic(address token) public returns (int64 responseCode, bool isTokenFlag) {
        (responseCode, isTokenFlag) = MPCQTokenService.isToken(token);
        emit ResponseCode(responseCode);

        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }

        emit IsToken(isTokenFlag);
    }

    function getTokenTypePublic(address token) public returns (int64 responseCode, int32 tokenType) {
        (responseCode, tokenType) = MPCQTokenService.getTokenType(token);
        emit ResponseCode(responseCode);

        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }

        emit TokenType(tokenType);
    }

    function getTokenKeyPublic(address token, uint keyType)
    public returns (int64 responseCode, IMPCQTokenService.KeyValue memory key){
        (responseCode, key) = MPCQTokenService.getTokenKey(token, keyType);

        emit ResponseCode(responseCode);

        if(responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }

        emit TokenKey(key);
    }


    function pauseTokenPublic(address token) public returns (int responseCode) {
        responseCode = this.pauseToken(token);

        emit ResponseCode(responseCode);

        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }

        emit PausedToken(true);
    }

    function unpauseTokenPublic(address token) public returns (int responseCode) {
        responseCode = this.unpauseToken(token);

        emit ResponseCode(responseCode);

        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }

        emit UnpausedToken(true);
    }


    function freezeTokenPublic(address token, address account) public returns (int responseCode) {
        responseCode = MPCQTokenService.freezeToken(token, account);
        emit ResponseCode(responseCode);
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
    }

    function unfreezeTokenPublic(address token, address account) public returns (int responseCode) {
        responseCode = MPCQTokenService.unfreezeToken(token, account);
        emit ResponseCode(responseCode);
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
    }

    function isFrozenPublic(address token, address account) public returns (int responseCode, bool frozen) {
        (responseCode, frozen) = MPCQTokenService.isFrozen(token, account);
        emit ResponseCode(responseCode);
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
        emit Frozen(frozen);
    }

    function getTokenDefaultFreezeStatusPublic(address token) public returns (int responseCode, bool defaultFreezeStatus) {
        (responseCode, defaultFreezeStatus) = MPCQTokenService.getTokenDefaultFreezeStatus(token);

        emit ResponseCode(responseCode);

        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }

        emit TokenDefaultFreezeStatus(defaultFreezeStatus);
    }

    function setFreezeDefaultStatus(bool newFreezeStatus) public {
        freezeDefaultStatus = newFreezeStatus;

        emit DefaultFreezeStatusChanged(freezeDefaultStatus);
    }


    function getTokenExpiryInfoPublic(address token)external returns (int responseCode, IMPCQTokenService.Expiry memory expiryInfo){
        (responseCode, expiryInfo) = this.getTokenExpiryInfo(token);

        emit ResponseCode(responseCode);

        if(responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }

        emit TokenExpiryInfo(expiryInfo);
    }

    function updateTokenExpiryInfoPublic(address token, IMPCQTokenService.Expiry memory expiryInfo)external returns (int responseCode){
        (responseCode) = this.updateTokenExpiryInfo(token, expiryInfo);

        emit ResponseCode(responseCode);

        if(responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
    }
}