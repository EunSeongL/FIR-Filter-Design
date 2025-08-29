# workspace is syn이므로 ../rtl/my_design.v 이런식으로 파일 경로 잘 적어줘야함
read_verilog ../rtl/hamming_lowpass.v

current_design hamming_lowpass
source hamming_lowpass.con
redirect -tee -file precompile.rpt {link}
redirect -append -tee -file precompile.rpt {check_design}
redirect -append -tee -file precompile.rpt {source scr/hamming_lowpass.con}
redirect -append -tee -file precompile.rpt {report_port -verbose}
redirect -append -tee -file precompile.rpt {report_clock}
redirect -append -tee -file precompile.rpt {report_clock -skew}
redirect -append -tee -file precompile.rpt {check_timing}
redirect -append -tee -file compile.rpt {compile_ultra}
redirect -append -tee -file compile.rpt {report_constraint -all}
redirect -append -tee -file compile.rpt {report_timing}
redirect -append -tee -file compile.rpt {report_area}

set_fix_multiple_port_nets -all -buffer_constants
 
redirect -tee -file log/postcompile.rpt {compile_ultra -incremental -retime -timing} 
set_app_var verilogout_no_tri true
change_names -rules verilog -hier
 
redirect -append -tee -file log/report_constraint.rpt {report_constraint -all}
redirect -append -tee -file log/report_timing.rpt {report_timing}
redirect -append -tee -file log/report_area.rpt {report_area}


write_file -f verilog -hier -output net/hamming_lowpass.v
write_file -f ddc -hier -output mapped/hamming_lowpass.ddc

