import Test from "../../Test";

/*const openProposalRegistration = () => {
    console.log('opening proposal')
}*/

function OpeningP() {
    return (
        <>
            <div className="row row-gap-1">
                <label className="fs-2 text-decoration-underline form-label">Propositions</label>
                <div className="d-flex justify-content-center">
                    <button className="btn btn-info col-6" onClick={Test.openProposalRegistration}>Commencer</button>
                </div>
            </div>
        </>
    );
  }
  
export default OpeningP;