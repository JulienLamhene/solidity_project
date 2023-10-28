import Test from "../../Test";

function ClosingP() {
    return (
        <>
            <div className="row row-gap-1">
        <label className="text-decoration-underline form-label">Fermeture</label>
        <div className="d-flex justify-content-center">
            <button className="btn btn-danger col-6" onClick={Test.closeProposalRegistration}>Fermer</button>
        </div>
    </div>
        </>
    );
  }
  
  export default ClosingP;
  