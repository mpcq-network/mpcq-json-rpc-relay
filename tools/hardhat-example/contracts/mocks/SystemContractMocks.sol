import "@hashgraph/smart-contracts/contracts/libraries/Constants.sol";

import "@hashgraph/smart-contracts/test/foundry/mocks/hts-precompile/HtsSystemContractMock.sol";
import "@hashgraph/smart-contracts/test/foundry/mocks/hts-precompile/MPCQFungibleToken.sol";
import "@hashgraph/smart-contracts/test/foundry/mocks/exchange-rate-precompile/ExchangeRatePrecompileMock.sol";

contract ProxyToHtsMock is Constants {

    HtsSystemContractMock htsPrecompile = HtsSystemContractMock(HTS_PRECOMPILE);

    function createTokenForSender() external {

        address sender = address(this);
        string memory name = 'Token A';
        string memory symbol = 'TA';
        address treasury = sender;
        int64 initialTotalSupply = 1e16;
        int32 decimals = 8;

        _doCreateMPCQFungibleTokenViaHtsPrecompile(sender, name, symbol, treasury, initialTotalSupply, decimals);

    }

    function sweepToSender(address token) external {
        uint256 balance = MPCQFungibleToken(token).balanceOf(address(this));
        MPCQFungibleToken(token).transfer(msg.sender, balance);
    }

    function _doCreateMPCQFungibleTokenViaHtsPrecompile(
        address sender,
        string memory name,
        string memory symbol,
        address treasury,
        int64 initialTotalSupply,
        int32 decimals
    ) internal returns (address tokenAddress) {
        bool isToken;
        IMPCQTokenService.MPCQToken memory token = _getSimpleMPCQToken(name, symbol, treasury);

        (, isToken) = htsPrecompile.isToken(tokenAddress);

        int64 responseCode;
        (responseCode, tokenAddress) = htsPrecompile.createFungibleToken(token, initialTotalSupply, decimals);

        int32 tokenType;
        (, isToken) = htsPrecompile.isToken(tokenAddress);

        (responseCode, tokenType) = htsPrecompile.getTokenType(tokenAddress);
    }

    function _getSimpleMPCQToken(
        string memory name,
        string memory symbol,
        address treasury
    ) internal returns (IMPCQTokenService.MPCQToken memory token) {
        token.name = name;
        token.symbol = symbol;
        token.treasury = treasury;
    }

}
