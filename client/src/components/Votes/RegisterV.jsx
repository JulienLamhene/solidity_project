import Test from "../../Test";

function RegisterV() {
    return (
        <>
        <div className="row row-gap-3 align-items-end">
            <label className="text-decoration-underline form-label">Inscriptions</label>
            <div className="col">
                <label htmlFor="voterAddress" className="form-label">Adresse du voteur: </label>
                <input type="text" id="voterAddress" className="form-control"></input>
            </div>
            <div className="d-flex justify-content-center mb-3">
                <button className="btn btn-primary p-2 col-6" onClick={Test.registerVoter}>Enregistrer Vote</button>
                <button className="btn btn-danger p-2 col-6" onClick={Test.removeVoter}>Retirer vote</button>
            </div>
        </div>
        </>
    );
  }
  
  export default RegisterV;
  