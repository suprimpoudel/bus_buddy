import React, {useEffect, useState} from 'react';
import Box from '@mui/material/Box';
import {DataGrid, GridToolbar} from '@mui/x-data-grid';
import Button from '@mui/material/Button'; // Import Button from Material-UI
import axios from 'axios';
import Header from '../../components/Header';
import {allRouteAssessmentPoint, routeAssessmentEndPoint} from '../../data/apiConstants';
import HandleException from '../../util/Toastify';
import {DeleteOutline, EditOutlined, MapOutlined} from '@mui/icons-material';
import {useTheme} from '@emotion/react';
import {tokens} from '../../theme';
import {NavLink} from 'react-router-dom';
import {toast} from "react-toastify";
import {IconButton} from "@mui/material";

const RouteAssessment = () => {

    const theme = useTheme();
    const colors = tokens(theme.palette.mode);
    const [data, setData] = useState([]);
    const handleDelete = async (id) => {
        await axios.delete(`${routeAssessmentEndPoint}/${id}`)
            .then(() => {
                toast.success("Successfully deleted route assessment");
                setData((prevData) => prevData.filter(item => item.id !== id));
            })
            .catch((error) => {
                HandleException(error);
            });
    }

    const columns = [
        {field: 'id', headerName: 'ID', flex: 1, hide: true},
        {field: 'vehicle.model', headerName: 'Vehicle Model', flex: 1, valueGetter: params => params.row.vehicle.model},
        {
            field: 'vehicle.vehicleNumber',
            headerName: 'Vehicle Number',
            flex: 1,
            valueGetter: params => params.row.vehicle.vehicleNumber
        },
        {
            field: 'driver.lastName',
            headerName: 'Driver\'s Name',
            flex: 1,
            valueGetter: params => params.row.driver.firstName + " " + params.row.driver.lastName
        },
        {
            field: 'driver.drivingLicenseNumber',
            headerName: 'Driver\'s License Number',
            flex: 1,
            valueGetter: params => params.row.driver.drivingLicenseNumber
        },
        {field: 'route.name', headerName: 'Route Name', flex: 1, valueGetter: params => params.row.route.name},
        {
            field: 'update',
            headerName: 'Update',
            flex: 0.5,
            renderCell: (params) => (
                <NavLink
                    to={{
                        pathname: `/addUpdateRouteAssessment/${params.row.id}`,
                    }}
                >
                    <IconButton color="success">
                        <EditOutlined/>
                    </IconButton>
                </NavLink>
            ),
        },
        {
            field: 'delete',
            headerName: 'Delete',
            flex: 0.5,
            renderCell: (params) => (
                <IconButton color="error" onClick={() => handleDelete(params.row.id)}>
                    <DeleteOutline/>
                </IconButton>
            ),
        },
    ];

    useEffect(() => {
        axios.get(allRouteAssessmentPoint)
            .then((response) => {
                setData(response.data.result);
            })
            .catch((error) => {
                HandleException(error)
            });
    }, []);

    return (
        <Box m="20px">
            <Header
                title="Route Assessment"
                subtitle="Manage Route Assessment"
            />
            <Box>
                <NavLink
                    to={{
                        pathname: '/addUpdateRouteAssessment',
                    }}
                >
                    <Button
                        sx={{
                            backgroundColor: colors.blueAccent[700],
                            color: colors.grey[100],
                            fontSize: "14px",
                            fontWeight: "bold",
                            padding: "10px 20px",
                        }}
                    >
                        <MapOutlined sx={{mr: "10px"}}/>
                        Add Route Assessment
                    </Button>
                </NavLink>
            </Box>
            <Box
                m="40px 0 0 0"
                height="75vh"
                sx={{
                    // Your styling here
                }}
            >
                <DataGrid
                    rows={data}
                    columns={columns}
                    components={{Toolbar: GridToolbar}}
                />
            </Box>
        </Box>
    );
}

export default RouteAssessment;
