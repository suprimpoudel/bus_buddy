import {Box, Typography, useTheme} from "@mui/material";
import {tokens} from "../../theme";
import Header from "../../components/Header";
import StatBox from "../../components/StatBox";
import React, {useEffect, useState} from 'react';
import axios from "axios";
import {adminDashboard} from "../../data/apiConstants.js";
import {PeopleOutline} from "@mui/icons-material";
import {pieArcClasses, PieChart} from '@mui/x-charts/PieChart';
import {BarChart, BarPlot} from "@mui/x-charts";
import HandleException from "../../util/Toastify";


const Dashboard = () => {
    const [dashboard, setDashboard] = useState(
        {
            message: "Successfully fetched dashboard",
            result: {
              user: {
                totalValue: 0,
                increasePercentage: 0
              },
              driver: {
                totalValue: 0,
                increasePercentage: 0
              },
              vehicleData: [
                {
                  label: "",
                  color: "",
                  value: 0
                },
                {
                  label: "",
                  color: "",
                  value: 0
                }
              ],
              routeAssessmentVisualization: {
                routeNames: [
                  "",
                  ""
                ],
                routeVehiclesCount: [
                  0,
                  0
                ]
              }
            }
          }
    );

    useEffect( () => {
        axios({
            method: 'get',
            url: adminDashboard,
            timeout: 1000
        }).then((response)=> {
         setDashboard(response.data);
        }).catch(function (error) {
            HandleException(error)
          });
    }, []);

    const theme = useTheme();
    const colors = tokens(theme.palette.mode);
    return (<Box m="20px">
            <Box display="flex" justifyContent="space-between" alignItems="center">
                <Header title="DASHBOARD" subtitle="Welcome to Bus Buddy dashboard"/>
            </Box>

            {/* GRID & CHARTS */}
            <Box
                display="grid"
                gridTemplateColumns="repeat(12, 1fr)"
                gridAutoRows="140px"
                gap="20px"
            >
                {/* ROW 1 */}
                <Box
                    gridColumn="span 6"
                    backgroundColor={colors.primary[400]}
                    display="flex"
                    alignItems="center"
                    justifyContent="center"
                >
                    <StatBox
                        title={dashboard?.result?.user?.totalValue || "0"}
                        subtitle="Total Users"
                        valueString={dashboard?.result?.user?.increasePercentage || "0"}
                        icon={<PeopleOutline
                            sx={{color: colors.greenAccent[600], fontSize: "26px"}}
                        />}
                    />
                </Box>
                <Box
                    gridColumn="span 6"
                    backgroundColor={colors.primary[400]}
                    display="flex"
                    alignItems="center"
                    justifyContent="center"
                >
                    <StatBox
                        title={dashboard?.result?.driver?.totalValue || "0"}
                        subtitle="Total Drivers"
                        valueString={dashboard?.result?.driver?.increasePercentage || "0"}
                        icon={<PeopleOutline
                            sx={{color: colors.greenAccent[600], fontSize: "26px"}}
                        />}
                    />
                </Box>

                {/* ROW 2 */}
                <Box
                    gridColumn="span 6"
                    gridRow="span 2"
                    backgroundColor={colors.primary[400]}
                >
                    <Box
                        mt="25px"
                        p="0 30px"
                        display="flex "
                        justifyContent="space-between"
                        alignItems="center"
                    >
                        <Box>
                            <Typography
                                variant="h5"
                                fontWeight="600"
                                color={colors.grey[100]}
                            >
                                Route Info
                            </Typography>
                            No of vehicles/ drivers assigned to route
                            <BarChart
                                width={500}
                                height={250}
                                series={[{
                                    data: dashboard?.result?.routeAssessmentVisualization?.routeVehiclesCount,
                                    type: 'bar'
                                }]}
                                xAxis={[{scaleType: 'band', data: dashboard.result?.routeAssessmentVisualization?.routeNames}]}
                            >
                                <BarPlot/>
                            </BarChart>
                            <Box/>
                        </Box>
                    </Box>
                    <Box height="250px" m="-20px 0 0 0">
                    </Box>
                </Box>
                <Box
                    gridColumn="span 6"
                    gridRow="span 2"
                    backgroundColor={colors.primary[400]}
                    overflow="auto"
                >
                    <Box
                        display="flex"
                        justifyContent="space-between"
                        alignItems="center"
                        colors={colors.grey[100]}
                        p="15px"
                    >
                        <Typography color={colors.grey[100]} variant="h5" fontWeight="600">
                            Vehicle Data
                        </Typography>
                    </Box>
                    <PieChart
                        series={[{
                            data: dashboard?.result?.vehicleData || [],
                            highlightScope: {faded: 'global', highlighted: 'item'},
                            faded: {innerRadius: 30, additionalRadius: -30},
                        },]}
                        sx={{
                            [`& .${pieArcClasses.faded}`]: {
                                fill: 'gray',
                            },
                        }}
                        width={400}
                        height={200}
                    />
                </Box>
            </Box>
        </Box>);
};

export default Dashboard;
