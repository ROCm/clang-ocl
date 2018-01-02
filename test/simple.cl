
__kernel void write(__global int* data) { data[get_global_id(0)] *= 2; }
