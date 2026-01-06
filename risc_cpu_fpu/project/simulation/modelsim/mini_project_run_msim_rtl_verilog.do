transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/intel_quartus/sem_6/risc_cpu_fpu/project {D:/intel_quartus/sem_6/risc_cpu_fpu/project/main_decoder.v}
vlog -vlog01compat -work work +incdir+D:/intel_quartus/sem_6/risc_cpu_fpu/project {D:/intel_quartus/sem_6/risc_cpu_fpu/project/alu_decoder.v}
vlog -vlog01compat -work work +incdir+D:/intel_quartus/sem_6/risc_cpu_fpu/project {D:/intel_quartus/sem_6/risc_cpu_fpu/project/data_memory.v}
vlog -vlog01compat -work work +incdir+D:/intel_quartus/sem_6/risc_cpu_fpu/project {D:/intel_quartus/sem_6/risc_cpu_fpu/project/alu_unit.v}
vlog -vlog01compat -work work +incdir+D:/intel_quartus/sem_6/risc_cpu_fpu/project {D:/intel_quartus/sem_6/risc_cpu_fpu/project/sign_extend.v}
vlog -vlog01compat -work work +incdir+D:/intel_quartus/sem_6/risc_cpu_fpu/project {D:/intel_quartus/sem_6/risc_cpu_fpu/project/register_file.v}
vlog -vlog01compat -work work +incdir+D:/intel_quartus/sem_6/risc_cpu_fpu/project {D:/intel_quartus/sem_6/risc_cpu_fpu/project/mux2.v}
vlog -vlog01compat -work work +incdir+D:/intel_quartus/sem_6/risc_cpu_fpu/project {D:/intel_quartus/sem_6/risc_cpu_fpu/project/mux4.v}
vlog -vlog01compat -work work +incdir+D:/intel_quartus/sem_6/risc_cpu_fpu/project {D:/intel_quartus/sem_6/risc_cpu_fpu/project/adder.v}
vlog -vlog01compat -work work +incdir+D:/intel_quartus/sem_6/risc_cpu_fpu/project {D:/intel_quartus/sem_6/risc_cpu_fpu/project/data_path.v}
vlog -vlog01compat -work work +incdir+D:/intel_quartus/sem_6/risc_cpu_fpu/project {D:/intel_quartus/sem_6/risc_cpu_fpu/project/reset_ff.v}
vlog -vlog01compat -work work +incdir+D:/intel_quartus/sem_6/risc_cpu_fpu/project {D:/intel_quartus/sem_6/risc_cpu_fpu/project/control_unit.v}
vlog -vlog01compat -work work +incdir+D:/intel_quartus/sem_6/risc_cpu_fpu/project {D:/intel_quartus/sem_6/risc_cpu_fpu/project/CPU.v}
vlog -vlog01compat -work work +incdir+D:/intel_quartus/sem_6/risc_cpu_fpu/project {D:/intel_quartus/sem_6/risc_cpu_fpu/project/RISC_cpu.v}
vlog -vlog01compat -work work +incdir+D:/intel_quartus/sem_6/risc_cpu_fpu/project {D:/intel_quartus/sem_6/risc_cpu_fpu/project/mux8.v}
vlog -vlog01compat -work work +incdir+D:/intel_quartus/sem_6/risc_cpu_fpu/project {D:/intel_quartus/sem_6/risc_cpu_fpu/project/fp_add.v}
vlog -vlog01compat -work work +incdir+D:/intel_quartus/sem_6/risc_cpu_fpu/project {D:/intel_quartus/sem_6/risc_cpu_fpu/project/fp_sub.v}
vlog -vlog01compat -work work +incdir+D:/intel_quartus/sem_6/risc_cpu_fpu/project {D:/intel_quartus/sem_6/risc_cpu_fpu/project/fp_mul.v}
vlog -vlog01compat -work work +incdir+D:/intel_quartus/sem_6/risc_cpu_fpu/project {D:/intel_quartus/sem_6/risc_cpu_fpu/project/fp_div.v}
vlog -vlog01compat -work work +incdir+D:/intel_quartus/sem_6/risc_cpu_fpu/project {D:/intel_quartus/sem_6/risc_cpu_fpu/project/round_off.v}
vlog -vlog01compat -work work +incdir+D:/intel_quartus/sem_6/risc_cpu_fpu/project {D:/intel_quartus/sem_6/risc_cpu_fpu/project/fp_register_file.v}
vlog -vlog01compat -work work +incdir+D:/intel_quartus/sem_6/risc_cpu_fpu/project {D:/intel_quartus/sem_6/risc_cpu_fpu/project/fp_data_path.v}
vlog -vlog01compat -work work +incdir+D:/intel_quartus/sem_6/risc_cpu_fpu/project {D:/intel_quartus/sem_6/risc_cpu_fpu/project/fp_main.v}
vlog -vlog01compat -work work +incdir+D:/intel_quartus/sem_6/risc_cpu_fpu/project {D:/intel_quartus/sem_6/risc_cpu_fpu/project/pl_reg_fd.v}
vlog -vlog01compat -work work +incdir+D:/intel_quartus/sem_6/risc_cpu_fpu/project {D:/intel_quartus/sem_6/risc_cpu_fpu/project/pl_reg_de.v}
vlog -vlog01compat -work work +incdir+D:/intel_quartus/sem_6/risc_cpu_fpu/project {D:/intel_quartus/sem_6/risc_cpu_fpu/project/pl_reg_em.v}
vlog -vlog01compat -work work +incdir+D:/intel_quartus/sem_6/risc_cpu_fpu/project {D:/intel_quartus/sem_6/risc_cpu_fpu/project/pl_reg_mw.v}
vlog -vlog01compat -work work +incdir+D:/intel_quartus/sem_6/risc_cpu_fpu/project {D:/intel_quartus/sem_6/risc_cpu_fpu/project/data_hazards.v}
vlog -vlog01compat -work work +incdir+D:/intel_quartus/sem_6/risc_cpu_fpu/project {D:/intel_quartus/sem_6/risc_cpu_fpu/project/branch_prediction.v}
vlog -vlog01compat -work work +incdir+D:/intel_quartus/sem_6/risc_cpu_fpu/project {D:/intel_quartus/sem_6/risc_cpu_fpu/project/instruction_memory.v}

vlog -vlog01compat -work work +incdir+D:/intel_quartus/sem_6/risc_cpu_fpu/project/output_files {D:/intel_quartus/sem_6/risc_cpu_fpu/project/output_files/test_bench.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  test_bench

add wave *
view structure
view signals
run -all
