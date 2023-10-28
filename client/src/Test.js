import Web3 from "web3";
import Voting_V2 from '../../build/contracts/Voting.json';

console.log('ok')

const contractAddress = "0xC2ad3e3D5CCDD4d80aFf461A2c7c058C9C8E795c";
//const votingContract = await contractAddress.deployed();
const abi = Voting_V2.abi;
//const abi = require("Voting_V2"); 
const web3 = new Web3(Web3.givenProvider || 'http://localhost:7545');
const contract = new web3.eth.Contract(abi, contractAddress);

async function updateStatus() {
    console.log('update status')
    const status = await contract.methods.getWorkFlowStatus().call();
    document.getElementById('status').textContent = status;
    console.log(`Status est ${status}`)
}

async function registerVoter() {
    const voterAddress = document.getElementById('voterAddress').value;
    console.log(`Vote enregistre est ${voterAddress}`)
    await contract.methods.enregistreVoteur(voterAddress).send({ from: web3.eth.defaultAccount });
    updateStatus();
}

async function removeVoter() {
    const voterAddress = document.getElementById('voterAddress').value;
    console.log(`Vote enleve est ${voterAddress}`)
    await contract.methods.retireVoteur(voterAddress).send({ from: web3.eth.defaultAccount });
    updateStatus();
}

async function registerProposal() {
    const description = document.getElementById('proposalDescription').value;
    console.log(`Propoosition enlevé est ${description}`)
    await contract.methods.enregistreProposition(description).send({ from: web3.eth.defaultAccount });
    updateStatus();
}

async function openProposalRegistration() {
    console.log('hello world')
    await contract.methods.ouvreSessionPropositions().send({ from: web3.eth.defaultAccount });
    updateStatus();
}

async function closeProposalRegistration() {
    console.log(`close proposition`)
    await contract.methods.fermeSessionPropositions().send({ from: web3.eth.defaultAccount });
    updateStatus();
}

async function openVotingSession() {
    console.log(`close voting`)
    await contract.methods.ouvreSessionVotes().send({ from: web3.eth.defaultAccount });
    updateStatus();
}

async function closeVotingSession() {
    console.log(`close voting`)
    await contract.methods.fermeSessionVotes().send({ from: web3.eth.defaultAccount });
    updateStatus();
}

async function tallyVotes() {
    await contract.methods.compteVote().send({ from: web3.eth.defaultAccount });
    updateStatus();
    const winningProposal = await contract.methods.getGagnant().call();
    console.log(`get results ${winningProposal}`)
    document.getElementById('winningProposal').textContent = winningProposal;
}

window.addEventListener('load', async () => {
    // Utilisez le compte Ethereum du navigateur par défaut (Metamask, etc.)
    const accounts = await web3.eth.getAccounts();
    web3.eth.defaultAccount = accounts[0];
    // Vérifie si MetaMask est installé
    if (typeof window.ethereum !== "undefined") {
        //const web3 = new Web3(window.ethereum);
        try {
            // Demande la permission de se connecter à MetaMask
            await window.ethereum.enable();
        } catch (error) {
            // L'utilisateur a refusé la demande de connexion
            console.error("Permission denied");
        }
    } else {
        // MetaMask n'est pas installé
        console.error("MetaMask not detected");
    }

    // Mettez à jour le statut initial
    updateStatus();
});

const Test = {
    registerVoter,
    removeVoter,
    registerProposal,
    openProposalRegistration,
    closeProposalRegistration,
    openVotingSession,
    closeVotingSession,
    tallyVotes,
  };

export default Test;