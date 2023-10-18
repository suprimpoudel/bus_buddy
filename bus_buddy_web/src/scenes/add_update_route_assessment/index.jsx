import React, {useEffect, useState} from 'react';
import {Field, Formik} from 'formik';
import axios from 'axios';
import * as yup from "yup";
import {Box, Button, FormControl, InputLabel, MenuItem, Select,} from '@mui/material';
import {
    allRouteEndPoint,
    allUnAssignedDriverEndPoint,
    allUnAssignedVehicleEndPoint,
    routeAssessmentEndPoint
} from "../../data/apiConstants";
import {useNavigate, useParams} from "react-router-dom";
import useMediaQuery from "@mui/material/useMediaQuery";
import Header from "../../components/Header";
import HandleException from "../../util/Toastify";
import {toast} from "react-toastify";

function AddUpdateRouteAssessment() {
    const navigator = useNavigate()
    const isNonMobile = useMediaQuery("(min-width:600px)");

    let {id} = useParams();
    const [routes, setRoutes] = useState([]);
    const [drivers, setDrivers] = useState([]);
    const [vehicles, setVehicles] = useState([]);
    const [routeAssessment, setRouteAssessment] = useState({
        id: null, route: {
            id: 0,
        }, driver: {
            id: 0,
        }, vehicle: {
            id: 0,
        },
    });

    const initialValues = {
        route: `${routeAssessment.route.id}`,
        driver: `${routeAssessment.driver.id}`,
        vehicle: `${routeAssessment.vehicle.id}`,
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
            .get(allUnAssignedDriverEndPoint)
            .then((response) => {
                setDrivers(response.data.result);
            })
            .catch((error) => {
                HandleException(error)
            });
        await axios
            .get(allUnAssignedVehicleEndPoint)
            .then((response) => {
                setVehicles(response.data.result);
            })
            .catch((error) => {
                HandleException(error)
            });

        if (id != null) {
            axios.get(routeAssessmentEndPoint + "/" + id)
                .then((response) => {
                    const routeAssessment = response.data.result;
                    setDrivers((prevState) => [...prevState, routeAssessment.driver]);
                    setVehicles((prevState) => [...prevState, routeAssessment.vehicle]);
                    setRouteAssessment(routeAssessment)
                })
                .catch((error) => {
                    HandleException(error)
                });
        }
    }


    const validationSchema = yup.object().shape({
        route: yup.string()
            .required('Route is required'), driver: yup.string()
            .required('Driver is required'), vehicle: yup.string()
            .required('Vehicle is required'),
    });

    const handleFormSubmit = async (values) => {
        const routeAssessmentToSave = {
            route: {
                id: parseInt(values.route)
            },
            driver: {
                id: parseInt(values.driver)
            },
            vehicle: {
                id: parseInt(values.vehicle)
            }
        };
        if(routeAssessment.id != null) {
            routeAssessmentToSave.id = parseInt(routeAssessment.id)
        }
        if (routeAssessmentToSave.id == null) {
            axios.post(routeAssessmentEndPoint, routeAssessmentToSave)
                .then(() => {
                    toast.success("Successfully created route assessment");
                    navigator(-1);
                })
                .catch((error) => {
                    HandleException(error);
                });
        } else {
            axios.put(`${routeAssessmentEndPoint}/${routeAssessment.id}`, routeAssessmentToSave)
                .then(() => {
                    toast.success("Successfully updated route assessment");
                    navigator(-1);
                })
                .catch((error) => {
                    HandleException(error);
                });
        }
    };


    return (<Box m="20px">
        {id == null ? <Header title="Create Route Assessment" subtitle="Create a New Route Assessment"/> :
            <Header title="Update Route Assessment" subtitle="Update Route Assessment Details"/>}

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
                                {routes.map((route) => (<MenuItem key={route.id} value={route.id}>
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
                            <InputLabel id="driver-label">Driver</InputLabel>
                            <Field
                                as={Select}
                                labelId="driver-label"
                                label="Driver"
                                id="driver"
                                name="driver"
                                error={touched.driver && !!errors.driver}
                            >
                                <MenuItem value="">
                                    <em>Select a driver</em>
                                </MenuItem>
                                {drivers.map((driver) => (<MenuItem key={driver.id} value={driver.id}>
                                    {driver.email}
                                </MenuItem>))}
                            </Field>
                        </FormControl>
                        {touched.driver && errors.driver && (<Box component="div" color="error.main">
                            {errors.driver}
                        </Box>)}
                    </Box>
                    <Box sx={{gridColumn: "span 2"}}>
                        <FormControl variant="outlined" fullWidth>
                            <InputLabel id="vehicle-label">Vehicle</InputLabel>
                            <Field
                                as={Select}
                                labelId="vehicle-label"
                                label="Vehicle"
                                id="vehicle"
                                name="vehicle"
                                error={touched.vehicle && !!errors.vehicle}
                            >
                                <MenuItem value="">
                                    <em>Select a vehicle</em>
                                </MenuItem>
                                {vehicles.map((vehicle) => (<MenuItem key={vehicle.id} value={vehicle.id}>
                                    {vehicle.vehicleNumber}
                                </MenuItem>))}
                            </Field>
                        </FormControl>
                        {touched.vehicle && errors.vehicle && (<Box component="div" color="error.main">
                            {errors.vehicle}
                        </Box>)}
                    </Box>
                </Box>
                <Box display="flex" justifyContent="end" mt="20px">

                    <Button type="submit" color="secondary" variant="contained">
                        {id == null ? "Create New Route Assessment" : "Update Route Assessment"}
                    </Button>
                </Box>
            </form>)}
        </Formik>
    </Box>);
}

export default AddUpdateRouteAssessment;
