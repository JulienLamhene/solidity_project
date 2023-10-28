// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2;

import "./Ownable.sol";

contract Voting is Ownable(msg.sender) {
    struct Voter {
        bool isRegistered; // voteur est enregistreé
        bool hasVoted; // voteur a déjà votée
        uint votedProposalId; // la proposition qu'il a voté
    }
    
    struct Proposal {
        address owner;
        string description;
        uint voteCount;
        bool isDeleted;
    }
    
    uint public winningProposalID;
    mapping(address => Voter) public voters;
    Proposal[] public propositions;

    uint public contractExpirationDate;
    uint public expirationDatePropositions = 10 minutes;

    enum WorkflowStatus {
        RegisteringVoters, // Registration des votants
        ProposalsRegistrationStarted, // Début des registration des propositions
        ProposalsRegistrationEnded, // Fin des registration des propositions
        VotingSessionStarted, // Début session de vote
        VotingSessionEnded, // Fin session de vote
        VotesTallied // Nombre des votes - Votes enregistrés
    }

    WorkflowStatus workflowStatus;

    event VoterRegistered(address voterAddress);
    event VoterRemoved(address voterAddress); 
    // Vote enregistré
    event WorkflowStatusChange(WorkflowStatus previousStatus, WorkflowStatus newStatus);
    // Changement du flux du statut de travail
    event ProposalRegistered(uint proposalId);
    // Proposition enregistré
    event Voted (address voter, uint proposalId);
    // Voté

    constructor() {
        workflowStatus = WorkflowStatus.RegisteringVoters;
        //contractExpirationDate = expirationDate;
    }

    function enregistreVoteur(address _voter) public onlyOwner() {
        require(workflowStatus == WorkflowStatus.RegisteringVoters, "L'enregistrement des voteurs est encore en cours");
        require(!voters[_voter].isRegistered, "Voteur deja enregistre");
        voters[_voter] = Voter(true, false, 0);
        emit VoterRegistered(_voter);
    }

    function ouvreSessionPropositions() public onlyOwner() {
        require(workflowStatus == WorkflowStatus.RegisteringVoters, "L'enregistrement des voteurs est encore en cours");
        workflowStatus = WorkflowStatus.ProposalsRegistrationStarted;
        emit WorkflowStatusChange(WorkflowStatus.RegisteringVoters, WorkflowStatus.ProposalsRegistrationStarted);
    }

    function fermeSessionPropositions() public onlyOwner() {
        require(workflowStatus == WorkflowStatus.ProposalsRegistrationStarted, "La soumission des propositions n'as pas encore commence");
        workflowStatus = WorkflowStatus.ProposalsRegistrationEnded;
        emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationStarted, WorkflowStatus.ProposalsRegistrationEnded);
    }

    function ouvreSessionVotes() public onlyOwner() {
        require(workflowStatus == WorkflowStatus.ProposalsRegistrationEnded, "La soumission des propositions est encore en cours");
        require(!estExpiree(), "Le contrat a expire.");
        workflowStatus = WorkflowStatus.VotingSessionStarted;
        emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationEnded, WorkflowStatus.VotingSessionStarted);
    }

    function fermeSessionVotes() public onlyOwner() {
        require(workflowStatus == WorkflowStatus.VotingSessionStarted, "Les votes n'ont pas encore commence");
        workflowStatus = WorkflowStatus.VotingSessionEnded;
        emit WorkflowStatusChange(WorkflowStatus.VotingSessionStarted, WorkflowStatus.VotingSessionEnded);
    }

    function enregistreProposition(string memory _description) public {
        require(workflowStatus == WorkflowStatus.ProposalsRegistrationStarted, "La soumission des propositions n'as pas encore commence");
        propositions.push(Proposal(msg.sender, _description, 0, false));
        uint proposalId = propositions.length - 1;
        emit ProposalRegistered(proposalId);
    }

    function vote(uint _proposalId) public {
        require(workflowStatus == WorkflowStatus.ProposalsRegistrationEnded, "La soumission des propositions est encore en cours");
        require(voters[msg.sender].isRegistered, "Vous n'etes pas encore enregistres");
        require(!voters[msg.sender].hasVoted, "Vous avez deja vote");
        require(_proposalId < propositions.length, "Cette id de proposition n'existe pas");
        require(!estExpiree(), "Le contrat a expire.");
        
        voters[msg.sender].hasVoted = true;
        voters[msg.sender].votedProposalId = _proposalId;
        propositions[_proposalId].voteCount++;

        emit Voted(msg.sender, _proposalId);
    }

    function compteVote() public onlyOwner() {
        require(workflowStatus == WorkflowStatus.VotingSessionEnded, "Les votes ne sont pas encore termine");
        require(!estExpiree(), "Le contrat a expire.");

        workflowStatus = WorkflowStatus.VotesTallied;
        emit WorkflowStatusChange(WorkflowStatus.VotingSessionEnded, WorkflowStatus.VotesTallied);

        uint nbrVote = 0;
        uint idGagnant = 0;
        for(uint i = 0; i < propositions.length; i++){
            if(propositions[i].voteCount > nbrVote){
                nbrVote = propositions[i].voteCount;
                idGagnant = i;
            }
        }
        winningProposalID = idGagnant;
    }

    function getGagnant() public view returns (uint) {
        require(workflowStatus == WorkflowStatus.VotesTallied, "Les votes n'ont pas encore tous etait compte");
        return winningProposalID;
    }

    function estExpiree() internal view returns (bool) {
        return (block.timestamp >= contractExpirationDate);
    }

    function getDetailsProposition(uint _proposalId) public view returns (string memory, uint) {
        require(_proposalId < propositions.length, "Cette id de proposition n'existe pas");
        return (propositions[_proposalId].description, propositions[_proposalId].voteCount);
    }

    function annuleVote() public {
        require(workflowStatus == WorkflowStatus.VotingSessionStarted, "Les votes n'ont pas encore commence");
        require(voters[msg.sender].isRegistered, "Vous n'etes pas encore enregistres");
        require(voters[msg.sender].hasVoted, "Vous n'avez pas encore vote");
        require(!estExpiree(), "Le contrat a expire.");

        uint propositionVotee = voters[msg.sender].votedProposalId;
        voters[msg.sender].hasVoted = false;
        propositions[propositionVotee].voteCount--;
        emit Voted(msg.sender, propositionVotee);
    }

    function fermeSessionSiExpiration() public {
        require(workflowStatus == WorkflowStatus.ProposalsRegistrationStarted, "La soumission des propositions n'as pas encore commence");
        require(block.timestamp >= expirationDatePropositions, "La session de propositions n'as pas encore expiree");
        workflowStatus = WorkflowStatus.ProposalsRegistrationEnded;
        emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationStarted, WorkflowStatus.ProposalsRegistrationEnded);
    }

    function retireVoteur(address _voter) public onlyOwner {
        require(voters[_voter].isRegistered, "Cet electeur n'est pas enregistre.");
        require(workflowStatus == WorkflowStatus.RegisteringVoters || workflowStatus == WorkflowStatus.ProposalsRegistrationStarted, "Impossible de retirer un electeur la session de vote a deja commence");
        
        voters[_voter].isRegistered = false;
        voters[_voter].hasVoted = false;
        voters[_voter].votedProposalId = 0;
        
        emit VoterRemoved(_voter);
    }

    function retirePropostion(uint _proposalId) public {
        require(workflowStatus == WorkflowStatus.ProposalsRegistrationStarted, "La soumission des propositions n'as pas encore commence");
        require(block.timestamp >= expirationDatePropositions, "La session de propositions n'as pas encore expiree");
        require(propositions[_proposalId].owner == msg.sender);
        
        require(_proposalId < propositions.length, "Cette id de proposition n'existe pas");
        for(uint i = _proposalId; i < propositions.length; i++){
            propositions[i] = propositions[i + 1];
        }
        propositions.pop();
    }

    function getWorkFlowStatus() public view returns (string memory) {
        return getWorkflowStatusString(workflowStatus);
    }

    function getWorkflowStatusString(WorkflowStatus status) internal pure returns (string memory) {
        if (status == WorkflowStatus.RegisteringVoters) {
            return "Registration des votants";
        } else if (status == WorkflowStatus.ProposalsRegistrationStarted) {
            return "Debut des registration des propositions";
        } else if (status == WorkflowStatus.ProposalsRegistrationEnded) {
            return "Fin des registration des propositions";
        } else if (status == WorkflowStatus.VotingSessionStarted) {
            return "Debut session de vote";
        } else if (status == WorkflowStatus.VotingSessionEnded) {
            return "Fin session de vote";
        } else if (status == WorkflowStatus.VotesTallied) {
            return "Nombre des votes - Votes enregistres";
        } else {
            return "Status inconnu";
        }
    }

}