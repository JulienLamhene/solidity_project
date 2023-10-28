import Test from "../../Test";

function OpeningV() {
    return (
        <>
        <div className="row row-gap-1">
            <label className="fs-2 text-decoration-underline form-label">Votes</label>
            <div className="d-flex justify-content-center">
                <button className="btn btn-info col-6" onClick={Test.openVotingSession}>Commencer session de vote</button>
            </div>
        </div>
        </>
    );
  }
  
export default OpeningV;