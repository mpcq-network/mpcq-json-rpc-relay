// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.5.0 <0.9.0;
pragma experimental ABIEncoderV2;


import "./MPCQTokenService.sol";
import "./MPCQResponseCodes.sol";
import "./ExpiryHelper.sol";
import "./KeyHelper.sol";

contract EstimatePrecompileContract is MPCQTokenService, ExpiryHelper, KeyHelper {

    string name = "tokenName";
    string symbol = "TKY";
    string memo = "memo";
    int64 initialTotalSupply = 1000;
    int64 maxSupply = 1000;
    int32 decimals = 8;
    bool freezeDefaultStatus = false;
    event CreatedToken(address);
    event ResponseCode(int256);

    address constant PRNG_PRECOMPILE_ADDRESS = address(0x169);
    address constant EXCHANGE_RATE_PRECOMPILE_ADDRESS = address(0x168);
    uint256 constant TINY_PARTS_PER_WHOLE = 100_000_000;

    // Helper function to handle the common logic
    function handleResponseCode(int responseCode) internal pure {
        if (responseCode != MPCQResponseCodes.SUCCESS) {
            revert();
        }
    }

    // associate & dissociate
    function associateTokenExternal(address account, address token) external {
        int responseCode = MPCQTokenService.associateToken(account, token);
        handleResponseCode(responseCode);
        emit ResponseCode(responseCode);
    }

    function nestedAssociateTokenExternal(address account, address token) external {
        MPCQTokenService.associateToken(account, token);
        int responseCode = MPCQTokenService.associateToken(account, token);
        handleResponseCode(responseCode);
    }

    function dissociateAndAssociateTokenExternal(address account, address token) external {
        MPCQTokenService.dissociateToken(account, token);
        int responseCode = MPCQTokenService.associateToken(account, token);
        handleResponseCode(responseCode);
    }

    function dissociateTokenExternal(address account, address token) external {
        int responseCode = MPCQTokenService.dissociateToken(account, token);
        handleResponseCode(responseCode);
        emit ResponseCode(responseCode);
    }
    //associate & dissociate - many
    function associateTokensExternal(address account, address[] memory tokens) external {
        int responseCode = MPCQTokenService.associateTokens(account, tokens);
        handleResponseCode(responseCode);
    }

    function dissociateTokensExternal(address account, address[] memory tokens) external {
        int responseCode = MPCQTokenService.dissociateTokens(account, tokens);
        handleResponseCode(responseCode);
    }

    //approve
    function approveExternal(address token, address spender, uint256 amount) external {
        int responseCode = MPCQTokenService.approve(token, spender, amount);
        handleResponseCode(responseCode);
    }

    function approveNFTExternal(address token, address approved, uint256 serialNumber) external {
        int responseCode = MPCQTokenService.approveNFT(token, approved, serialNumber);
        handleResponseCode(responseCode);
    }

    //transfer
    function transferFromExternal(address token, address from, address to, uint256 amount) external {
        int responseCode = this.transferFrom(token, from, to, amount);
        handleResponseCode(responseCode);
    }

    function transferFromNFTExternal(address token, address from, address to, uint256 serialNumber) external {
        int responseCode = this.transferFromNFT(token, from, to, serialNumber);
        handleResponseCode(responseCode);
    }

    function transferTokenExternal(address token, address sender, address receiver, int64 amount) external {
        int responseCode = MPCQTokenService.transferToken(token, sender, receiver, amount);
        handleResponseCode(responseCode);
    }

    function transferNFTExternal(address token, address sender, address receiver, int64 serialNumber) external {
        int responseCode = MPCQTokenService.transferNFT(token, sender, receiver, serialNumber);
        handleResponseCode(responseCode);
    }

    //transfer-many
    function transferTokensExternal(address token, address[] memory accountIds, int64[] memory amounts) external {
        int responseCode = MPCQTokenService.transferTokens(token, accountIds, amounts);
        handleResponseCode(responseCode);
    }

    function transferNFTsExternal(address token, address[] memory sender, address[] memory receiver, int64[] memory serialNumber) external {
        int responseCode = MPCQTokenService.transferNFTs(token, sender, receiver, serialNumber);
        handleResponseCode(responseCode);
    }

    function cryptoTransferExternal(IMPCQTokenService.TransferList memory transferList, IMPCQTokenService.TokenTransferList[] memory tokenTransfers) external {
        int responseCode = MPCQTokenService.cryptoTransfer(transferList, tokenTransfers);
        handleResponseCode(responseCode);
    }

    event MintedToken(int64[]);
    function mintTokenExternal(address token, int64 amount, bytes[] memory metadata) external
    returns (int64 newTotalSupply, int64[] memory serialNumbers) {
        (int responseCode, int64 internalNewTotalSupply, int64[] memory internalSerialNumbers) = MPCQTokenService.mintToken(token, amount, metadata);
        handleResponseCode(responseCode);
        emit MintedToken(internalSerialNumbers);
        return (internalNewTotalSupply, internalSerialNumbers);
    }

    function burnTokenExternal(address token, int64 amount, int64[] memory serialNumbers) external
    returns (int64 newTotalSupply) {
        (int responseCode, int64 internalNewTotalSupply) = MPCQTokenService.burnToken(token, amount, serialNumbers);
        handleResponseCode(responseCode);
        return internalNewTotalSupply;
    }

    //create operations
    function createFungibleTokenPublic(address treasury) public payable returns (address) {
        IMPCQTokenService.TokenKey[] memory keys = new IMPCQTokenService.TokenKey[](5);
        keys[0] = getSingleKey(KeyType.ADMIN, KeyType.PAUSE, KeyValueType.INHERIT_ACCOUNT_KEY, bytes(""));
        keys[1] = getSingleKey(KeyType.KYC, KeyValueType.INHERIT_ACCOUNT_KEY, bytes(""));
        keys[2] = getSingleKey(KeyType.FREEZE, KeyValueType.INHERIT_ACCOUNT_KEY, bytes(""));
        keys[3] = getSingleKey(KeyType.WIPE, KeyValueType.INHERIT_ACCOUNT_KEY, bytes(""));
        keys[4] = getSingleKey(KeyType.SUPPLY, KeyValueType.INHERIT_ACCOUNT_KEY, bytes(""));

        IMPCQTokenService.Expiry memory expiry = IMPCQTokenService.Expiry(
            0, treasury, 8000000
        );

        IMPCQTokenService.MPCQToken memory token = IMPCQTokenService.MPCQToken(
            name, symbol, treasury, memo, true, maxSupply, freezeDefaultStatus, keys, expiry
        );

        (int responseCode, address createdTokenAddress) =
                            MPCQTokenService.createFungibleToken(token, initialTotalSupply, decimals);

        handleResponseCode(responseCode);
        emit CreatedToken(createdTokenAddress);

        return createdTokenAddress;
    }

    function createNonFungibleTokenPublic(address treasury) public payable returns (address) {
        IMPCQTokenService.TokenKey[] memory keys = new IMPCQTokenService.TokenKey[](5);
        keys[0] = getSingleKey(KeyType.ADMIN, KeyType.PAUSE, KeyValueType.INHERIT_ACCOUNT_KEY, bytes(""));
        keys[1] = getSingleKey(KeyType.KYC, KeyValueType.INHERIT_ACCOUNT_KEY, bytes(""));
        keys[2] = getSingleKey(KeyType.FREEZE, KeyValueType.INHERIT_ACCOUNT_KEY, bytes(""));
        keys[3] = getSingleKey(KeyType.SUPPLY, KeyValueType.INHERIT_ACCOUNT_KEY, bytes(""));
        keys[4] = getSingleKey(KeyType.WIPE, KeyValueType.INHERIT_ACCOUNT_KEY, bytes(""));

        IMPCQTokenService.Expiry memory expiry = IMPCQTokenService.Expiry(
            0, treasury, 8000000
        );

        IMPCQTokenService.MPCQToken memory token = IMPCQTokenService.MPCQToken(
            name, symbol, treasury, memo, true, maxSupply, freezeDefaultStatus, keys, expiry
        );

        (int responseCode, address createdTokenAddress) =
                            MPCQTokenService.createNonFungibleToken(token);

        handleResponseCode(responseCode);
        emit CreatedToken(createdTokenAddress);

        return createdTokenAddress;
    }

    function createFungibleTokenWithCustomFeesPublic(address treasury, address fixedFeeTokenAddress) public payable returns (address){
        IMPCQTokenService.TokenKey[] memory keys = new IMPCQTokenService.TokenKey[](1);
        keys[0] = getSingleKey(KeyType.ADMIN, KeyType.ADMIN, KeyValueType.INHERIT_ACCOUNT_KEY, bytes(""));

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

        (int responseCode, address createdTokenAddress) =
                            MPCQTokenService.createFungibleTokenWithCustomFees(token, initialTotalSupply, decimals, fixedFees, fractionalFees);

        handleResponseCode(responseCode);

        return createdTokenAddress;
    }

    function createNonFungibleTokenWithCustomFeesPublic(address treasury, address fixedFeeTokenAddress) public payable returns (address){
        IMPCQTokenService.TokenKey[] memory keys = new IMPCQTokenService.TokenKey[](5);
        keys[0] = getSingleKey(KeyType.ADMIN, KeyType.PAUSE, KeyValueType.INHERIT_ACCOUNT_KEY, bytes(""));
        keys[1] = getSingleKey(KeyType.KYC, KeyValueType.INHERIT_ACCOUNT_KEY, bytes(""));
        keys[2] = getSingleKey(KeyType.FREEZE, KeyValueType.INHERIT_ACCOUNT_KEY, bytes(""));
        keys[3] = getSingleKey(KeyType.SUPPLY, KeyValueType.INHERIT_ACCOUNT_KEY, bytes(""));
        keys[4] = getSingleKey(KeyType.WIPE, KeyValueType.INHERIT_ACCOUNT_KEY, bytes(""));

        IMPCQTokenService.Expiry memory expiry = IMPCQTokenService.Expiry(
            0, treasury, 8000000
        );

        IMPCQTokenService.MPCQToken memory token = IMPCQTokenService.MPCQToken(
            name, symbol, treasury, memo, true, maxSupply, freezeDefaultStatus, keys, expiry
        );

        IMPCQTokenService.FixedFee[] memory fixedFees = new IMPCQTokenService.FixedFee[](1);
        fixedFees[0] = IMPCQTokenService.FixedFee(1, fixedFeeTokenAddress, false, false, treasury);

        IMPCQTokenService.RoyaltyFee[] memory royaltyFees = new IMPCQTokenService.RoyaltyFee[](1);
        royaltyFees[0] = IMPCQTokenService.RoyaltyFee(4, 5, 10, fixedFeeTokenAddress, false, treasury);

        (int responseCode, address createdTokenAddress) =
                            MPCQTokenService.createNonFungibleTokenWithCustomFees(token, fixedFees, royaltyFees);

        handleResponseCode(responseCode);

        return createdTokenAddress;
    }

    function wipeTokenAccountExternal(address token, address account, int64 amount) external {
        int responseCode = MPCQTokenService.wipeTokenAccount(token, account, amount);
        handleResponseCode(responseCode);
    }

    function wipeTokenAccountNFTExternal(address token, address account, int64[] memory serialNumbers) external {
        int responseCode = MPCQTokenService.wipeTokenAccountNFT(token, account, serialNumbers);
        handleResponseCode(responseCode);
    }

    function setApprovalForAllExternal(address token, address account, bool approved) external {
        int responseCode = MPCQTokenService.setApprovalForAll(token, account, approved);
        handleResponseCode(responseCode);
    }

    function grantTokenKycExternal(address token, address account) external {
        int responseCode = MPCQTokenService.grantTokenKyc(token, account);
        handleResponseCode(responseCode);
    }

    function revokeTokenKycExternal(address token, address account) external {
        int responseCode = MPCQTokenService.revokeTokenKyc(token, account);
        handleResponseCode(responseCode);
    }

    function nestedGrantAndRevokeTokenKYCExternal(address token, address account) external {
        MPCQTokenService.grantTokenKyc(token, account);
        int responseCode = MPCQTokenService.revokeTokenKyc(token, account);
        handleResponseCode(responseCode);
    }

    function freezeTokenExternal(address token, address account) external {
        int responseCode = MPCQTokenService.freezeToken(token, account);
        handleResponseCode(responseCode);
    }

    function unfreezeTokenExternal(address token, address account) external {
        int responseCode = MPCQTokenService.unfreezeToken(token, account);
        handleResponseCode(responseCode);
    }

    function nestedFreezeUnfreezeTokenExternal(address token, address account) external {
        MPCQTokenService.freezeToken(token, account);
        int responseCode = MPCQTokenService.unfreezeToken(token, account);
        handleResponseCode(responseCode);
    }

    function deleteTokenExternal(address token) external {
        int responseCode = MPCQTokenService.deleteToken(token);
        handleResponseCode(responseCode);
    }

    function pauseTokenExternal(address token) external {
        int responseCode = MPCQTokenService.pauseToken(token);
        handleResponseCode(responseCode);
    }

    function unpauseTokenExternal(address token) external {
        int responseCode = MPCQTokenService.unpauseToken(token);
        handleResponseCode(responseCode);
    }

    function nestedPauseUnpauseTokenExternal(address token) external {
        MPCQTokenService.pauseToken(token);
        int responseCode = MPCQTokenService.unpauseToken(token);
        handleResponseCode(responseCode);
    }

    function updateTokenExpiryInfoExternal(address token, address treasury) external {
        IMPCQTokenService.Expiry memory expiry = IMPCQTokenService.Expiry(
            0, treasury, 9000
        );
        int responseCode = MPCQTokenService.updateTokenExpiryInfo(token, expiry);
        handleResponseCode(responseCode);
    }

    function updateTokenInfoExternal(address token, address treasury) external {
        IMPCQTokenService.TokenKey[] memory keys = new IMPCQTokenService.TokenKey[](5);
        keys[0] = getSingleKey(KeyType.ADMIN, KeyType.PAUSE, KeyValueType.INHERIT_ACCOUNT_KEY, bytes(""));
        keys[1] = getSingleKey(KeyType.KYC, KeyValueType.INHERIT_ACCOUNT_KEY, bytes(""));
        keys[2] = getSingleKey(KeyType.FREEZE, KeyValueType.INHERIT_ACCOUNT_KEY, bytes(""));
        keys[3] = getSingleKey(KeyType.SUPPLY, KeyValueType.INHERIT_ACCOUNT_KEY, bytes(""));
        keys[4] = getSingleKey(KeyType.WIPE, KeyValueType.INHERIT_ACCOUNT_KEY, bytes(""));

        IMPCQTokenService.Expiry memory expiry = IMPCQTokenService.Expiry(
            0, treasury, 9000
        );

        IMPCQTokenService.MPCQToken memory tokenInfo = IMPCQTokenService.MPCQToken(
            name, symbol, treasury, memo, true, maxSupply, freezeDefaultStatus, keys, expiry
        );

        int responseCode = MPCQTokenService.updateTokenInfo(token, tokenInfo);
        handleResponseCode(responseCode);
    }

    function updateTokenKeysExternal(address token) external {
        IMPCQTokenService.TokenKey[] memory keys = new IMPCQTokenService.TokenKey[](4);
        keys[0] = getSingleKey(KeyType.KYC, KeyValueType.SECP256K1, abi.encodePacked(hex"02e35698a0273a8c6509ae4716c26a52eebca73e5de2c6677b189ef40f6fcd1fed"));
        keys[1] = getSingleKey(KeyType.FREEZE, KeyValueType.SECP256K1, abi.encodePacked(hex"02e35698a0273a8c6509ae4716c26a52eebca73e5de2c6677b189ef40f6fcd1fed"));
        keys[2] = getSingleKey(KeyType.SUPPLY, KeyValueType.SECP256K1, abi.encodePacked(hex"02e35698a0273a8c6509ae4716c26a52eebca73e5de2c6677b189ef40f6fcd1fed"));
        keys[3] = getSingleKey(KeyType.WIPE, KeyValueType.SECP256K1, abi.encodePacked(hex"02e35698a0273a8c6509ae4716c26a52eebca73e5de2c6677b189ef40f6fcd1fed"));

        int responseCode = MPCQTokenService.updateTokenKeys(token, keys);
        handleResponseCode(responseCode);
    }

    function getTokenExpiryInfoExternal(address token) external
    returns(int64, address, int64) {
        (int responseCode, IMPCQTokenService.Expiry memory expiryInfo) = MPCQTokenService.getTokenExpiryInfo(token);
        handleResponseCode(responseCode);
        return (
            expiryInfo.second,
            expiryInfo.autoRenewAccount,
            expiryInfo.autoRenewPeriod
        );
    }

    function isTokenExternal(address token) external returns(bool) {
        (int responseCode, bool isTokenFlag) = MPCQTokenService.isToken(token);
        handleResponseCode(responseCode);
        return isTokenFlag;
    }

    function getTokenKeyExternal(address token, uint keyType) external
    returns(bool, address, bytes memory, bytes memory, address) {
        (int responseCode, IMPCQTokenService.KeyValue memory key) = MPCQTokenService.getTokenKey(token, keyType);
        handleResponseCode(responseCode);
        return (
            key.inheritAccountKey,
            key.contractId,
            key.ed25519,
            key.ECDSA_secp256k1,
            key.delegatableContractId
        );
    }

    function allowanceExternal(address token, address owner, address spender) external returns(uint256) {
        (int responseCode, uint256 amount) = MPCQTokenService.allowance(token, owner, spender);
        handleResponseCode(responseCode);
        return amount;
    }

    function getApprovedExternal(address token, uint256 serialNumber) external returns(address) {
        (int responseCode, address approvedAddress) = MPCQTokenService.getApproved(token, serialNumber);
        handleResponseCode(responseCode);
        return approvedAddress;
    }

    function isApprovedForAllExternal(address token, address owner, address operator) external returns(bool) {
        (int responseCode, bool approved) = MPCQTokenService.isApprovedForAll(token, owner, operator);
        handleResponseCode(responseCode);
        return approved;
    }

    function getPseudorandomSeed() external returns (bytes32 randomBytes) {
        (bool success, bytes memory result) = PRNG_PRECOMPILE_ADDRESS.call(
            abi.encodeWithSignature("getPseudorandomSeed()"));
        require(success);
        randomBytes = abi.decode(result, (bytes32));
    }

    /**
     * Returns a pseudorandom number in the range [lo, hi) using the seed generated from "getPseudorandomSeed"
     */
    function getPseudorandomNumber(uint32 lo, uint32 hi) external returns (uint32) {
        (bool success, bytes memory result) = PRNG_PRECOMPILE_ADDRESS.call(
            abi.encodeWithSignature("getPseudorandomSeed()"));
        require(success);
        uint32 choice;
        assembly {
            choice := mload(add(result, 0x20))
        }
        return lo + (choice % (hi - lo));
    }

    function tinycentsToTinybars(uint256 tinycents) external returns (uint256 tinybars) {
        (bool success, bytes memory result) = EXCHANGE_RATE_PRECOMPILE_ADDRESS.call(
            abi.encodeWithSignature("tinycentsToTinybars(uint256)", tinycents));
        require(success);
        tinybars = abi.decode(result, (uint256));
    }

    function tinybarsToTinycents(uint256 tinybars) external returns (uint256 tinycents) {
        (bool success, bytes memory result) = EXCHANGE_RATE_PRECOMPILE_ADDRESS.call(
            abi.encodeWithSignature("tinybarsToTinycents(uint256)", tinybars));
        require(success);
        tinycents = abi.decode(result, (uint256));
    }
}
