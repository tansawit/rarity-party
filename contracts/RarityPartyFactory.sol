pragma solidity 0.8.2;

import "./RarityParty.sol";

contract RarityPartyFactory {
    using EnumerableSet for EnumerableSet.AddressSet;

    EnumerableSet.AddressSet internal _parties;

    mapping(uint256 => bool) inParty;

    event PartyCreated(
        address partyAddress,
        string name,
        string description,
        uint256 leadSummoner
    );

    event PartyDisbanded(
        address partAddress,
        string name,
        string description,
        uint256 leadSummoner
    );

    function createParty(
        uint256 summonerID,
        address _partyFactory,
        string memory _name,
        string memory _description
    ) external returns (address partyAddress) {
        require(!inParty[summonerID], "summoner-already-in-party");
        RarityParty party = new RarityParty(
            _partyFactory,
            summonerID,
            msg.sender,
            _name,
            _description
        );

        _parties.add(address(party));
        emit PartyCreated(address(party), _name, _description, summonerID);
        return address(party);
    }

    function parties() external view returns (address[] memory _partiesList) {
        return _parties.values();
    }

    function disbandParty(address partyAddress) external {
        RarityParty party = RarityParty(partyAddress);
        party.disband();
        _parties.remove(partyAddress);

        emit PartyDisbanded(
            address(party),
            party.name(),
            party.description(),
            party.leader()
        );
    }
}
