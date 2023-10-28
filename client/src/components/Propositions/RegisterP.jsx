import Test from "../../Test";

function RegisterP() {
    return (
        <>
        <div className="row row-gap-1">
            <label className="text-decoration-underline form-label"> Entrées</label>
            <div className="row row-gap-3 align-items-end">
                <div className="col">
                    <label htmlFor="proposalDescription" className="form-label">Proposal Description : </label>
                    <input type="text" id="proposalDescription" className="form-control"></input>
                </div>
                <button className="btn btn-primary col h-50" onClick={Test.registerProposal}>Enregistrer la proposition</button>
            </div>
        </div>
        </>
    );
  }
  
  export default RegisterP;
  