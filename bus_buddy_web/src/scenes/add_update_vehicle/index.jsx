import React, {useEffect, useState} from 'react';
import {Box, Button, TextField} from "@mui/material";
import {Formik} from "formik";
import * as yup from "yup";
import useMediaQuery from "@mui/material/useMediaQuery";
import Header from "../../components/Header";
import {useNavigate, useParams} from "react-router-dom";
import axios from "axios";
import {vehicleEndPoint} from "../../data/apiConstants";
import HandleException from "../../util/Toastify";
import {toast} from "react-toastify";

const AddUpdateVehicle = () => {
    const navigator = useNavigate()
    const isNonMobile = useMediaQuery("(min-width:600px)");

    let {id} = useParams();

    const [vehicle, setVehicle] = useState({
        id: null, seatingCapacity: 0, model: "", email: "", vehicleNumber: ""
    });

    const initialValues = {
        seatingCapacity: vehicle.seatingCapacity, model: vehicle.model, vehicleNumber: vehicle.vehicleNumber,
    }

    const handleFormSubmit = async (values) => {
        if (vehicle.id == null) {
            axios.post(vehicleEndPoint, values)
                .then(() => {
                    toast.success("Successfully created vehicle");
                    navigator(-1);
                })
                .catch((error) => {
                    HandleException(error);
                });
        } else {
            values.id = vehicle.id
            axios.put(`${vehicleEndPoint}/${vehicle.id}`, values)
                .then(() => {
                    toast.success("Successfully updated vehicle");
                    navigator(-1);
                })
                .catch((error) => {
                    HandleException(error);
                });
        }
    };

    const checkoutSchema = yup.object().shape({
        seatingCapacity: yup.number().required("required"),
        model: yup.string().required("required"),
        vehicleNumber: yup.string().required("required"),
    });

    useEffect(() => {
        getVehicleData()
    }, []);

    const getVehicleData = () => {
        if (id != null) {
            axios.get(vehicleEndPoint + "/" + id)
                .then((response) => {
                    const vehicle = response.data.result;
                    setVehicle(vehicle)
                })
                .catch((error) => {
                    HandleException(error)
                });
        }
    }

    return (<Box m="20px">
        {id == null ? <Header title="Create Vehicle" subtitle="Create a New Vehicle"/> :
            <Header title="Update Vehicle" subtitle="Update Vehicle Details"/>}

        <Formik
            enableReinitialize={true}
            onSubmit={handleFormSubmit}
            initialValues={initialValues}
            validationSchema={checkoutSchema}
        >
            {({
                  values, errors, touched, handleBlur, handleChange, handleSubmit,
              }) => (<form onSubmit={handleSubmit}>
                <Box
                    display="grid"
                    gap="30px"
                    gridTemplateColumns="repeat(4, minmax(0, 1fr))"
                    sx={{
                        "& > div": {gridColumn: isNonMobile ? undefined : "span 4"},
                    }}
                >
                    <TextField
                        fullWidth
                        variant="filled"
                        type="number"
                        label="Seating Capacity"
                        onBlur={handleBlur}
                        onChange={handleChange}
                        value={values.seatingCapacity} // Make sure this is correct
                        name="seatingCapacity"
                        error={!!touched.seatingCapacity && !!errors.seatingCapacity}
                        helperText={touched.seatingCapacity && errors.seatingCapacity}
                        sx={{gridColumn: "span 2"}}
                    />
                    <TextField
                        fullWidth
                        variant="filled"
                        type="text"
                        label="Vehicle Number"
                        onBlur={handleBlur}
                        onChange={handleChange}
                        value={values.vehicleNumber}
                        name="vehicleNumber"
                        error={!!touched.vehicleNumber && !!errors.vehicleNumber}
                        helperText={touched.vehicleNumber && errors.vehicleNumber}
                        sx={{gridColumn: "span 2"}}
                    />
                    <TextField
                        fullWidth
                        variant="filled"
                        type="text"
                        label="model"
                        onBlur={handleBlur}
                        onChange={handleChange}
                        value={values.model}
                        name="model"
                        error={!!touched.model && !!errors.model}
                        helperText={touched.model && errors.model}
                        sx={{gridColumn: "span 2"}}
                    />
                </Box>
                <Box display="flex" justifyContent="end" mt="20px">

                    <Button type="submit" color="secondary" variant="contained">
                        {id == null ? "Create New Vehicle" : "Update Vehicle"}
                    </Button>
                </Box>
            </form>)}
        </Formik>
    </Box>);
};

export default AddUpdateVehicle;
