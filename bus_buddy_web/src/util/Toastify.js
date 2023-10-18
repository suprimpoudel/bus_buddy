import { toast } from "react-toastify";


const HandleException = (error) => {
    if (error.response) {
        console.log(error.response.data)
        toast.error(`${parseErrorMessage(error.response.data)}`, {
            position: toast.POSITION.TOP_RIGHT
        });
    } else if (error.request) {
        toast.error(`${error.request}`, {
            position: toast.POSITION.TOP_RIGHT
        });
    } else {
        toast.error(`${error.message}`, {
            position: toast.POSITION.TOP_RIGHT
        });
    }
}

const parseErrorMessage = (errorResponse) => {
    if (errorResponse.errors === null || errorResponse.errors.length === 0) {
        return errorResponse.message;
    } else {
        return errorResponse.errors[0].message;
    }
}

export default HandleException;