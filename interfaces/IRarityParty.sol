pragma solidity 0.8.2;

interface IRarityParty {
    function members() external view returns (uint256[] memory);

    function addMembers(uint256[] calldata summonersArray) external;

    function addMember(uint256 summonerID) external;

    function getSummonersFromParty(uint256[] calldata summonersArray) external;

    function getSummonerFromParty(uint256 summoner) external;

    function forceSummonersOffParty(uint256[] calldata summonersArray) external;

    function forceSummonerOffParty(uint256 summoner) external;

    function action(address destContract, bytes memory data) external;

    function disband() external;
}
