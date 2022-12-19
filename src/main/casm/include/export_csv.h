#pragma once
union matrix_value{
    int i;
    unsigned int ui;
};

void export_dailymatrix(union matrix_value matrix[6][3]);