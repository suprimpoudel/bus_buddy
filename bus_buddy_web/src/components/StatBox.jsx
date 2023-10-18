import {Box, Typography, useTheme} from "@mui/material";
import {tokens} from "../theme";
import React from 'react';
import {ArrowDownward, ArrowUpward} from "@mui/icons-material";

const StatBox = ({title, subtitle, icon, valueString}) => {
    let value = parseInt(valueString)
    const theme = useTheme();
    const colors = tokens(theme.palette.mode);

    return (
        <Box width="100%" m="0 30px">
            <Box display="flex" justifyContent="space-between">
                <Box>
                    {icon}
                    <Typography
                        variant="h4"
                        fontWeight="bold"
                        sx={{color: colors.grey[100]}}
                    >
                        {title}
                    </Typography>
                </Box>
                <Box>
                    {value > 0 ? (
                        <ArrowUpward
                            sx={{color: colors.greenAccent[600], fontSize: "26px"}}
                        />
                    ) : value < 0 ? (
                        <ArrowDownward
                            sx={{color: colors.redAccent[600], fontSize: "26px"}}
                        />
                    ) : null}
                </Box>

            </Box>
            <Box display="flex" justifyContent="space-between" mt="2px">
                <Typography variant="h5" sx={{color: colors.greenAccent[500]}}>
                    {subtitle}
                </Typography>
                <Typography
                    variant="h5"
                    fontStyle="italic"
                    sx={{
                        color: value > 0 ? colors.greenAccent[100] : value < 0 ? colors.redAccent[100] : 'defaultColor'
                    }}
                >
                    {value}%
                </Typography>
            </Box>
        </Box>
    );
};

export default StatBox;
