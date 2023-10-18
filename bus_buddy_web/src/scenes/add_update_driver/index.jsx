import React, {useEffect, useState} from 'react';
import {Box, Button, TextField} from "@mui/material";
import {Formik} from "formik";
import * as yup from "yup";
import useMediaQuery from "@mui/material/useMediaQuery";
import Header from "../../components/Header";
import {useNavigate, useParams} from "react-router-dom";
import axios from "axios";
import {userEndPoint} from "../../data/apiConstants";
import HandleException from "../../util/Toastify";
import {toast} from "react-toastify";
import {passwordRegRxp, phoneRegExp} from "../../util/constants/regex_constants";

const AddUpdateDriver = () => {
    const navigator = useNavigate()
    const isNonMobile = useMediaQuery("(min-width:600px)");

    let {id} = useParams();

    const [driver, setDriver] = useState({
        id: null, firstName: "", lastName: "", email: "", phoneNumber: "", drivingLicenseNumber: "", password: ""
    });

    const initialValues = {
        firstName: driver.firstName,
        lastName: driver.lastName,
        email: driver.email,
        phoneNumber: driver.phoneNumber,
        drivingLicenseNumber: driver.drivingLicenseNumber,
        password: driver.password,
    }

    const handleFormSubmit = async (values) => {
        values.userType = "DRIVER"

        if (driver.id == null) {
            axios.post(userEndPoint, values)
                .then(() => {
                    toast.success("Successfully created driver");
                    navigator(-1);
                })
                .catch((error) => {
                    HandleException(error);
                });
        } else {
            values.id = driver.id

            axios.put(`${userEndPoint}/${driver.id}`, values)
                .then(() => {
                    toast.success("Successfully updated driver");
                    navigator(-1);
                })
                .catch((error) => {
                    HandleException(error);
                });
        }
    };

    const checkoutSchema = yup.object().shape({
        firstName: yup.string().required("required"),
        lastName: yup.string().required("required"),
        drivingLicenseNumber: yup.string().required("required"),
        email: yup.string().email("invalid email").required("required"),
        phoneNumber: yup
            .string()
            .matches(phoneRegExp, "Phone number is not valid")
            .required("required"),
        password: yup
            .string()
            .when('id', {
                is: null,
                then: yup.string().matches(passwordRegRxp, "Password must be at least 8 characters long").required("required"),
                otherwise: yup.string(),
            }),
    });

    useEffect(() => {
        getDriverData()
    }, []);

    const getDriverData = () => {
        if (id != null) {
            axios.get(userEndPoint + "/" + id)
                .then((response) => {
                    const driver = response.data.result;
                    setDriver(driver)
                })
                .catch((error) => {
                    HandleException(error)
                });
        }
    }

    return (<Box m="20px">
        {id == null ? <Header title="Create Driver" subtitle="Create a New Driver"/> :
            <Header title="Update Driver" subtitle="Update Driver Details"/>}

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
                        label="First Name"
                        onBlur={handleBlur}
                        onChange={handleChange}
                        value={values.firstName} // Make sure this is correct
                        name="firstName"
                        error={!!touched.firstName && !!errors.firstName}
                        helperText={touched.firstName && errors.firstName}
                        sx={{gridColumn: "span 2"}}
                    />
                    <TextField
                        fullWidth
                        variant="filled"
                        type="text"
                        label="Last Name"
                        onBlur={handleBlur}
                        onChange={handleChange}
                        value={values.lastName}
                        name="lastName"
                        error={!!touched.lastName && !!errors.lastName}
                        helperText={touched.lastName && errors.lastName}
                        sx={{gridColumn: "span 2"}}
                    />
                    <TextField
                        fullWidth
                        variant="filled"
                        type="text"
                        label="Email"
                        onBlur={handleBlur}
                        onChange={handleChange}
                        value={values.email}
                        name="email"
                        error={!!touched.email && !!errors.email}
                        helperText={touched.email && errors.email}
                        sx={{gridColumn: "span 2"}}
                    />
                    <TextField
                        fullWidth
                        variant="filled"
                        type="text"
                        label="Phone Number"
                        onBlur={handleBlur}
                        onChange={handleChange}
                        value={values.phoneNumber}
                        name="phoneNumber"
                        error={!!touched.phoneNumber && !!errors.phoneNumber}
                        helperText={touched.phoneNumber && errors.phoneNumber}
                        sx={{gridColumn: "span 2"}}
                    />
                    <TextField
                        fullWidth
                        variant="filled"
                        type="text"
                        label="Driving License Number"
                        onBlur={handleBlur}
                        onChange={handleChange}
                        value={values.drivingLicenseNumber}
                        name="drivingLicenseNumber"
                        error={!!touched.drivingLicenseNumber && !!errors.drivingLicenseNumber}
                        helperText={touched.drivingLicenseNumber && errors.drivingLicenseNumber}
                        sx={{gridColumn: "span 2"}}
                    />

                    {id == null ? <TextField
                        fullWidth
                        variant="filled"
                        type="password"
                        label="Password"
                        onBlur={handleBlur}
                        onChange={handleChange}
                        value={values.password}
                        name="password"
                        error={!!touched.password && !!errors.password}
                        helperText={touched.password && errors.password}
                        sx={{gridColumn: "span 2"}}
                    /> : ''}

                </Box>
                <Box display="flex" justifyContent="end" mt="20px">

                    <Button type="submit" color="secondary" variant="contained">
                        {id == null ? "Create New Driver" : "Update Driver"}
                    </Button>
                </Box>
            </form>)}
        </Formik>
    </Box>);
};

export default AddUpdateDriver;
