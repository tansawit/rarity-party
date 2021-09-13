pragma solidity 0.8.2;

interface IRarityPartyFactory {
    function parties() external view returns (address[] memory _partiesList);

    function createParty(
        uint256 summonerID,
        address _partyFactory,
        string memory _name,
        string memory _description
    ) external returns (address);

    function disbandParty(address partyAddress) external;
}
