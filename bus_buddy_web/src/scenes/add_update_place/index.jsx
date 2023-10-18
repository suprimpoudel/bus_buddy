import React, {useEffect, useState} from 'react';
import {Box, Button, TextField} from "@mui/material";
import {Formik} from "formik";
import * as yup from "yup";
import useMediaQuery from "@mui/material/useMediaQuery";
import Header from "../../components/Header";
import {useNavigate, useParams} from "react-router-dom";
import axios from "axios";
import {placeEndPoint} from "../../data/apiConstants";
import HandleException from "../../util/Toastify";
import {toast} from "react-toastify";

const AddUpdatePlace = () => {
    const navigator = useNavigate()
    const isNonMobile = useMediaQuery("(min-width:600px)");

    let {id} = useParams();

    const [place, setPlace] = useState({
        id: null, name: "", latitude: 0.0, longitude: 0.0
    });

    const initialValues = {
        name: place.name,
        latitude: place.latitude,
        longitude: place.longitude,
    }

    const handleFormSubmit = async (values) => {
        if (place.id == null) {
            axios.post(placeEndPoint, values)
                .then(() => {
                    toast.success("Successfully created place");
                    navigator(-1);
                })
                .catch((error) => {
                    HandleException(error);
                });
        } else {
            values.id = place.id
            axios.put(`${placeEndPoint}/${place.id}`, values)
                .then(() => {
                    toast.success("Successfully updated place");
                    navigator(-1);
                })
                .catch((error) => {
                    HandleException(error);
                });
        }
    };

    const checkoutSchema = yup.object().shape({
        name: yup.string().required("required"),
        latitude: yup.number().required("required"),
        longitude: yup.number().required("required"),
    });

    useEffect(() => {
        getPlaceData()
    }, []);

    const getPlaceData = () => {
        if (id != null) {
            axios.get(placeEndPoint + "/" + id)
                .then((response) => {
                    const place = response.data.result;
                    setPlace(place)
                })
                .catch((error) => {
                    HandleException(error)
                });
        }
    }

    return (
        <Box m="20px">
        {id == null ? <Header title="Create Place" subtitle="Create a New Place"/> :
            <Header title="Update Place" subtitle="Update Place Details"/>}

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
                        type="text"
                        label="Name"
                        onBlur={handleBlur}
                        onChange={handleChange}
                        value={values.name} // Make sure this is correct
                        name="name"
                        error={!!touched.name && !!errors.name}
                        helperText={touched.name && errors.name}
                        sx={{gridColumn: "span 4"}}
                    />
                    <TextField
                        fullWidth
                        variant="filled"
                        type="number"
                        label="latitude"
                        onBlur={handleBlur}
                        onChange={handleChange}
                        value={values.latitude}
                        name="latitude"
                        error={!!touched.latitude && !!errors.latitude}
                        helperText={touched.latitude && errors.latitude}
                        sx={{gridColumn: "span 2"}}
                    />
                    <TextField
                        fullWidth
                        variant="filled"
                        type="number"
                        label="Longitude"
                        onBlur={handleBlur}
                        onChange={handleChange}
                        value={values.longitude}
                        name="longitude"
                        error={!!touched.longitude && !!errors.longitude}
                        helperText={touched.longitude && errors.longitude}
                        sx={{gridColumn: "span 2"}}
                    />
                </Box>
                <Box display="flex" justifyContent="end" mt="20px">

                    <Button type="submit" color="secondary" variant="contained">
                        {id == null ? "Create New Place" : "Update Place"}
                    </Button>
                </Box>
            </form>)}
        </Formik>
    </Box>);
};

export default AddUpdatePlace;
