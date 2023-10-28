import Test from "../../Test";

function Results() {
    return (
        <>
        <div className="row row-gap-1">
            <label className="text-decoration-underline form-label">Résultats</label>
            <div className="d-flex justify-content-center">
                <button className="btn btn-success col-6" onClick={Test.tallyVotes}>Obtenir résulats</button>
            </div>
        </div>
        </>
    );
}

export default Results;