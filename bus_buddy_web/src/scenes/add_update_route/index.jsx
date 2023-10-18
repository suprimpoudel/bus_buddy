import React, {useEffect, useState} from 'react';
import {Field, Formik} from 'formik';
import axios from 'axios';
import * as yup from "yup";
import {Box, Button, FormControl, InputLabel, MenuItem, Select, TextField,} from '@mui/material';
import {allPlaceEndPoint, routeEndPoint} from "../../data/apiConstants";
import {useNavigate, useParams} from "react-router-dom";
import useMediaQuery from "@mui/material/useMediaQuery";
import Header from "../../components/Header";
import HandleException from "../../util/Toastify";
import {toast} from "react-toastify";

function AddUpdateRoute() {
    const navigator = useNavigate()
    const isNonMobile = useMediaQuery("(min-width:600px)");

    let {id} = useParams();
    const [places, setPlaces] = useState([]);
    const [route, setRoute] = useState({
        id: null,
        name: '',
        startDestination: {
            id: 0,
            name: ""
        },
        endDestination: {
            id: 0,
            name: ""
        },
    });

    const initialValues = {
        name: route.name,
        startDestination: `${route.startDestination.id}`,
        endDestination: `${route.endDestination.id}`,
    };

    useEffect(() => {
        initSetup();
    }, []);

    const initSetup = async () => {
        await axios
            .get(allPlaceEndPoint)
            .then((response) => {
                setPlaces(response.data.result);
                getRouteData()
            })
            .catch((error) => {
                HandleException(error)
            });
    }

    const getRouteData = () => {
        if (id != null) {
            axios.get(routeEndPoint + "/" + id)
                .then((response) => {
                    const route = response.data.result;
                    setRoute(route)
                })
                .catch((error) => {
                    HandleException(error)
                });
        }
    }


    const validationSchema = yup.object().shape({
        name: yup.string().required('Name is required'),
        startDestination: yup.string()
            .notOneOf(
                [yup.ref('endDestination')],
                'Start and end destinations cannot be the same'
            )
            .required('Start Destination is required'),
        endDestination: yup.string().required('End Destination is required'),
    });

    const handleFormSubmit = async (values) => {
        let routeToSave = {
            id: route.id,
            startDestination: {
                id: parseInt(values.startDestination)
            },
            name: values.name,
            endDestination: {
                id: parseInt(values.endDestination)
            }
        }
        if (routeToSave.id == null) {
            axios.post(routeEndPoint, routeToSave)
                .then(() => {
                    toast.success("Successfully created route");
                    navigator(-1);
                })
                .catch((error) => {
                    HandleException(error);
                });
        } else {
            axios.put(`${routeEndPoint}/${route.id}`, routeToSave)
                .then(() => {
                    toast.success("Successfully updated route");
                    navigator(-1);
                })
                .catch((error) => {
                    HandleException(error);
                });
        }
    };


    return (
        <Box m="20px">
            {id == null ? <Header title="Create Route" subtitle="Create a New Route"/> :
                <Header title="Update Route" subtitle="Update Route Details"/>}

            <Formik
                enableReinitialize={true}
                onSubmit={handleFormSubmit}
                initialValues={initialValues}
                validationSchema={validationSchema}
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
                            variant="outlined"
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
                        <Box sx={{gridColumn: "span 2"}}>
                            <FormControl variant="outlined" fullWidth>
                                <InputLabel id="startDestination-label">Start Destination</InputLabel>
                                <Field
                                    as={Select}
                                    labelId="startDestination-label"
                                    label="Start Destination"
                                    id="startDestination"
                                    name="startDestination"
                                    error={touched.startDestination && !!errors.startDestination}
                                >
                                    <MenuItem value="">
                                        <em>Select a start destination</em>
                                    </MenuItem>
                                    {places.map((place) => (
                                        <MenuItem key={place.id} value={place.id}>
                                            {place.name}
                                        </MenuItem>
                                    ))}
                                </Field>
                            </FormControl>
                            {touched.startDestination && errors.startDestination && (
                                <Box component="div" color="error.main">
                                    {errors.startDestination}
                                </Box>
                            )}
                        </Box>
                        <Box sx={{gridColumn: "span 2"}}>
                            <FormControl variant="outlined" fullWidth>
                                <InputLabel id="endDestination-label">End Destination</InputLabel>
                                <Field
                                    as={Select}
                                    labelId="endDestination-label"
                                    label="End Destination"
                                    id="endDestination"
                                    name="endDestination"
                                    error={touched.endDestination && !!errors.endDestination}
                                >
                                    <MenuItem value="">
                                        <em>Select a end destination</em>
                                    </MenuItem>
                                    {places.map((place) => (
                                        <MenuItem key={place.id} value={place.id}>
                                            {place.name}
                                        </MenuItem>
                                    ))}
                                </Field>
                            </FormControl>
                            {touched.endDestination && errors.endDestination && (
                                <Box component="div" color="error.main">
                                    {errors.endDestination}
                                </Box>
                            )}
                        </Box>
                    </Box>
                    <Box display="flex" justifyContent="end" mt="20px">

                        <Button type="submit" color="secondary" variant="contained">
                            {id == null ? "Create New Route" : "Update Route"}
                        </Button>
                    </Box>
                </form>)}
            </Formik>
        </Box>
    );
}

export default AddUpdateRoute;
