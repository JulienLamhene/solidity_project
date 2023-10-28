import Proposals from "./components/Propositions";
import Title from "./components/Title/Title";
import Votes from "./components/Votes";
import Results from "./components/Results/Results";

function App() {
  return (
    <>
      <Title/>
      <Proposals />
      <Votes />
      <Results />
      <p className="fs-4 fw-bold fst-italic text-decoration-underline">La proposition gagnante est le n°: <span id="winningProposal"></span></p>
    </>
    
  );
}

export default App;
