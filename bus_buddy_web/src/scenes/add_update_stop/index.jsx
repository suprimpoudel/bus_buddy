import React, {useEffect, useState} from 'react';
import {Field, Formik} from 'formik';
import axios from 'axios';
import * as yup from "yup";
import {Box, Button, FormControl, InputLabel, MenuItem, Select, TextField,} from '@mui/material';
import {
    allPlaceEndPoint,
    allRouteEndPoint, allStopEndPoint,
    allUnAssignedDriverEndPoint,
    allUnAssignedVehicleEndPoint,
    routeAssessmentEndPoint, stopEndPoint
} from "../../data/apiConstants";
import {useNavigate, useParams} from "react-router-dom";
import useMediaQuery from "@mui/material/useMediaQuery";
import Header from "../../components/Header";
import HandleException from "../../util/Toastify";
import {toast} from "react-toastify";

function AddUpdateStop() {
    const navigator = useNavigate()
    const isNonMobile = useMediaQuery("(min-width:600px)");

    let {id} = useParams();
    const [stop, setStop] = useState([]);
    const [place, setPlaces] = useState([]);
    const [route, setRoutes] = useState([]);
    const [routeAssessment, setRouteAssessment] = useState({
        id: null,
        stopTime: 1,
        orderNo: 1,
        place: {
            id: 0,
        }, route: {
            id: 0,
        },
    });

    const initialValues = {
        stopTime: 1,
        orderNo: 1,
        route: `${routeAssessment.route.id}`,
        place: `${routeAssessment.place.id}`,
    };

    useEffect(() => {
        initSetup();
    }, []);

    const initSetup = async () => {
        await axios
            .get(allRouteEndPoint)
            .then((response) => {
                setRoutes(response.data.result);
            })
            .catch((error) => {
                HandleException(error)
            });
        await axios
            .get(allPlaceEndPoint)
            .then((response) => {
                setPlaces(response.data.result);
            })
            .catch((error) => {
                HandleException(error)
            });

        if (id != null) {
            axios.get(stopEndPoint + "/" + id)
                .then((response) => {
                    const stop = response.data.result;
                    setStop(stop)
                })
                .catch((error) => {
                    HandleException(error)
                });
        }
    }


    const validationSchema = yup.object().shape({
        route: yup.string()
            .required('Route is required'),
        place: yup.string()
            .required('Place is required'),
        stopTime: yup.number()
            .required('Stop TIme is required'),
        orderNo: yup.number()
            .required('Order No is required'),
    });

    const handleFormSubmit = async (values) => {
        const stopToSave = {
            route: {
                id: parseInt(values.route)
            },
            place: {
                id: parseInt(values.place)
            },
            orderNo: values.orderNo,
            stopTime: values.stopTime
        };
        if(stop.id != null) {
            stopToSave.id = parseInt(stop.id)
        }
        if (stopToSave.id == null) {
            axios.post(stopEndPoint, stopToSave)
                .then(() => {
                    toast.success("Successfully created stop");
                    navigator(-1);
                })
                .catch((error) => {
                    HandleException(error);
                });
        } else {
            axios.put(`${stopEndPoint}/${routeAssessment.id}`, stopToSave)
                .then(() => {
                    toast.success("Successfully updated stop");
                    navigator(-1);
                })
                .catch((error) => {
                    HandleException(error);
                });
        }
    };


    return (<Box m="20px">
        {id == null ? <Header title="Create Stop" subtitle="Create a New Stop"/> :
            <Header title="Update Stop" subtitle="Update Stop Details"/>}

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
                        variant="filled"
                        type="number"
                        label="Stop Time"
                        onBlur={handleBlur}
                        onChange={handleChange}
                        value={values.stopTime}
                        name="stopTime"
                        error={!!touched.stopTime && !!errors.stopTime}
                        helperText={touched.stopTime && errors.stopTime}
                        sx={{gridColumn: "span 2"}}
                    />
                    <TextField
                        fullWidth
                        variant="filled"
                        type="number"
                        label="Order No"
                        onBlur={handleBlur}
                        onChange={handleChange}
                        value={values.orderNo}
                        name="orderNo"
                        error={!!touched.orderNo && !!errors.orderNo}
                        helperText={touched.orderNo && errors.orderNo}
                        sx={{gridColumn: "span 2"}}
                    />
                    <Box sx={{gridColumn: "span 2"}}>
                        <FormControl variant="outlined" fullWidth>
                            <InputLabel id="route-label">Route</InputLabel>
                            <Field
                                as={Select}
                                labelId="route-label"
                                label="Route"
                                id="route"
                                name="route"
                                error={touched.route && !!errors.route}
                            >
                                <MenuItem value="">
                                    <em>Select a route</em>
                                </MenuItem>
                                {route.map((route) => (<MenuItem key={route.id} value={route.id}>
                                    {route.name}
                                </MenuItem>))}
                            </Field>
                        </FormControl>
                        {touched.route && errors.route && (<Box component="div" color="error.main">
                            {errors.route}
                        </Box>)}
                    </Box>
                    <Box sx={{gridColumn: "span 2"}}>
                        <FormControl variant="outlined" fullWidth>
                            <InputLabel id="place-label">Place</InputLabel>
                            <Field
                                as={Select}
                                labelId="place-label"
                                label="Place"
                                id="place"
                                name="place"
                                error={touched.place && !!errors.place}
                            >
                                <MenuItem value="">
                                    <em>Select a place</em>
                                </MenuItem>
                                {place.map((p) => (<MenuItem key={p.id} value={p.id}>
                                    {p.name}
                                </MenuItem>))}
                            </Field>
                        </FormControl>
                        {touched.place && errors.place && (<Box component="div" color="error.main">
                            {errors.place}
                        </Box>)}
                    </Box>
                </Box>
                <Box display="flex" justifyContent="end" mt="20px">

                    <Button type="submit" color="secondary" variant="contained">
                        {id == null ? "Create New Stop" : "Update Stop"}
                    </Button>
                </Box>
            </form>)}
        </Formik>
    </Box>);
}

export default AddUpdateStop;
