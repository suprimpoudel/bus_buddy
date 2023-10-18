import React, {useEffect, useState} from 'react';
import Box from '@mui/material/Box';
import {DataGrid, GridToolbar} from '@mui/x-data-grid';
import Button from '@mui/material/Button';
import axios from 'axios';
import Header from '../../components/Header';
import {allRouteEndPoint, routeEndPoint} from '../../data/apiConstants';
import HandleException from '../../util/Toastify';
import {DeleteOutline, EditOutlined, RouteOutlined} from '@mui/icons-material';
import {useTheme} from '@emotion/react';
import {tokens} from '../../theme';
import {NavLink} from 'react-router-dom';
import {toast} from "react-toastify";
import {IconButton} from "@mui/material";

const AllRoutes = () => {

    const theme = useTheme();
    const colors = tokens(theme.palette.mode);
    const [data, setData] = useState([]);
    const handleDelete = async (id) => {
        await axios.delete(`${routeEndPoint}/${id}`)
            .then(() => {
                toast.success("Successfully deleted route");
                setData((prevData) => prevData.filter(item => item.id !== id));
            })
            .catch((error) => {
                HandleException(error);
            });
    }

    const columns = [
        {field: 'id', headerName: 'ID', flex: 1, hide: true},
        {field: 'name', headerName: 'Name', flex: 5},
        {
            field: 'update',
            headerName: 'Update',
            flex: 0.5,
            renderCell: (params) => (
                <NavLink
                    to={{
                        pathname: `/addUpdateRoute/${params.row.id}`,
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
        axios.get(allRouteEndPoint)
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
                title="Route"
                subtitle="Manage Routes"
            />
            <Box>
                <NavLink
                    to={{
                        pathname: '/addUpdateRoute',
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
                        <RouteOutlined sx={{mr: "10px"}}/>
                        Add Route
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

export default AllRoutes;
