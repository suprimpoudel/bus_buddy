import React, {useState} from "react";
import {Route, Routes} from "react-router-dom";
import TopBar from "./scenes/global/TopBar";
import Sidebar from "./scenes/global/Sidebar";
import Dashboard from "./scenes/dashboard";
import Users from "./scenes/users";
import TestForm from "./scenes/add_update_user";
import AddUpdateUser from "./scenes/add_update_user";
import {CssBaseline, ThemeProvider} from "@mui/material";
import {ColorModeContext, useMode} from "./theme";
import {ToastContainer} from "react-toastify";
import 'react-toastify/dist/ReactToastify.css';
import Drivers from "./scenes/drivers";
import Vehicles from "./scenes/vehicles";
import Places from "./scenes/places";
import AllRoutes from "./scenes/routes";
import RouteAssessment from "./scenes/route_assessment";
import AddUpdateDriver from "./scenes/add_update_driver";
import AddUpdateVehicle from "./scenes/add_update_vehicle";
import AddUpdatePlace from "./scenes/add_update_place";
import AddUpdateRoute from "./scenes/add_update_route";
import AddUpdateRouteAssessment from "./scenes/add_update_route_assessment";
import AddUpdateStop from "./scenes/add_update_stop";

function App() {
    const [theme, colorMode] = useMode();
    const [isSidebar, setIsSidebar] = useState(true);

    return (
        <ColorModeContext.Provider value={colorMode}>
            <ThemeProvider theme={theme}>
                <CssBaseline/>

                <div className="app">
                    <Sidebar isSidebar={isSidebar}/>
                    <main className="content">
                        <TopBar setIsSidebar={setIsSidebar}/>
                        <Routes>
                            <Route path="/" element={<Dashboard/>}/>
                            <Route path="/team" element={<TestForm/>}/>
                            <Route path="/users" element={<Users/>}/>
                            <Route path="/drivers" element={<Drivers/>}/>
                            <Route path="/vehicles" element={<Vehicles/>}/>
                            <Route path="/places" element={<Places/>}/>
                            <Route path="/routes" element={<AllRoutes/>}/>
                            <Route path="/routeAssessments" element={<RouteAssessment/>}/>
                            <Route path="/addUpdateUser/:id?" element={<AddUpdateUser/>}/>
                            <Route path="/addUpdateDriver/:id?" element={<AddUpdateDriver/>}/>
                            <Route path="/addUpdateVehicle/:id?" element={<AddUpdateVehicle/>}/>
                            <Route path="/addUpdatePlace/:id?" element={<AddUpdatePlace/>}/>
                            <Route path="/addUpdateRoute/:id?" element={<AddUpdateRoute/>}/>
                            <Route path="/addUpdateRouteAssessment/:id?" element={<AddUpdateRouteAssessment/>}/>
                            <Route path="/addUpdateStop/:id?" element={<AddUpdateStop/>}/>
                        </Routes>
                    </main>
                </div>
                <ToastContainer/>

            </ThemeProvider>
        </ColorModeContext.Provider>
    );
}

export default App;
