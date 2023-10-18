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

const AddUpdateUser = () => {
    const navigator = useNavigate()
    const isNonMobile = useMediaQuery("(min-width:600px)");

    let {id} = useParams();

    const [user, setUser] = useState({
        id: null, firstName: "", lastName: "", email: "", phoneNumber: "", password: ""
    });

    const initialValues = {
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        phoneNumber: user.phoneNumber,
        password: user.password,
    }

    const handleFormSubmit = async (values) => {
        values.userType = "USER"

        if (user.id == null) {
            axios.post(userEndPoint, values)
                .then(() => {
                    toast.success("Successfully created user");
                    navigator(-1);
                })
                .catch((error) => {
                    HandleException(error);
                });
        } else {
            values.id = user.id
            axios.put(`${userEndPoint}/${user.id}`, values)
                .then(() => {
                    toast.success("Successfully updated user");
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
        getUserData()
    }, []);

    const getUserData = () => {
        if (id != null) {
            axios.get(userEndPoint + "/" + id)
                .then((response) => {
                    const user = response.data.result;
                    setUser(user)
                })
                .catch((error) => {
                    HandleException(error)
                });
        }
    }

    return (<Box m="20px">
        {id == null ? <Header title="Create User" subtitle="Create a New User"/> :
            <Header title="Update User" subtitle="Update User Details"/>}

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
                        {id == null ? "Create New User" : "Update User"}
                    </Button>
                </Box>
            </form>)}
        </Formik>
    </Box>);
};

export default AddUpdateUser;
