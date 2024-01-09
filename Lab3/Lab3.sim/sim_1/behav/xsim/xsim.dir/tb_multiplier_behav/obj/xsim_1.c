/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/

#if defined(_WIN32)
 #include "stdio.h"
#endif
#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/

#if defined(_WIN32)
 #include "stdio.h"
#endif
#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
typedef void (*funcp)(char *, char *);
extern int main(int, char**);
extern void execute_8(char*, char *);
extern void execute_10(char*, char *);
extern void execute_11(char*, char *);
extern void execute_12(char*, char *);
extern void execute_13(char*, char *);
extern void execute_14(char*, char *);
extern void execute_15(char*, char *);
extern void execute_16(char*, char *);
extern void execute_17(char*, char *);
extern void execute_84(char*, char *);
extern void execute_151(char*, char *);
extern void execute_152(char*, char *);
extern void execute_153(char*, char *);
extern void execute_154(char*, char *);
extern void execute_221(char*, char *);
extern void execute_222(char*, char *);
extern void execute_223(char*, char *);
extern void execute_290(char*, char *);
extern void execute_291(char*, char *);
extern void execute_292(char*, char *);
extern void execute_359(char*, char *);
extern void execute_360(char*, char *);
extern void execute_361(char*, char *);
extern void execute_428(char*, char *);
extern void execute_429(char*, char *);
extern void execute_430(char*, char *);
extern void execute_497(char*, char *);
extern void execute_498(char*, char *);
extern void execute_499(char*, char *);
extern void execute_566(char*, char *);
extern void execute_567(char*, char *);
extern void execute_568(char*, char *);
extern void execute_635(char*, char *);
extern void execute_636(char*, char *);
extern void execute_637(char*, char *);
extern void execute_704(char*, char *);
extern void execute_771(char*, char *);
extern void execute_83(char*, char *);
extern void execute_20(char*, char *);
extern void execute_21(char*, char *);
extern void execute_23(char*, char *);
extern void execute_24(char*, char *);
extern void execute_27(char*, char *);
extern void execute_28(char*, char *);
extern void execute_31(char*, char *);
extern void execute_32(char*, char *);
extern void execute_33(char*, char *);
extern void execute_35(char*, char *);
extern void execute_36(char*, char *);
extern void execute_39(char*, char *);
extern void execute_40(char*, char *);
extern void execute_41(char*, char *);
extern void execute_43(char*, char *);
extern void execute_44(char*, char *);
extern void execute_47(char*, char *);
extern void execute_48(char*, char *);
extern void execute_49(char*, char *);
extern void execute_51(char*, char *);
extern void execute_52(char*, char *);
extern void execute_55(char*, char *);
extern void execute_56(char*, char *);
extern void execute_57(char*, char *);
extern void execute_59(char*, char *);
extern void execute_60(char*, char *);
extern void execute_63(char*, char *);
extern void execute_64(char*, char *);
extern void execute_65(char*, char *);
extern void execute_67(char*, char *);
extern void execute_68(char*, char *);
extern void execute_71(char*, char *);
extern void execute_72(char*, char *);
extern void execute_73(char*, char *);
extern void execute_75(char*, char *);
extern void execute_76(char*, char *);
extern void execute_79(char*, char *);
extern void execute_80(char*, char *);
extern void execute_81(char*, char *);
extern void vhdl_transfunc_eventcallback(char*, char*, unsigned, unsigned, unsigned, char *);
funcp funcTab[78] = {(funcp)execute_8, (funcp)execute_10, (funcp)execute_11, (funcp)execute_12, (funcp)execute_13, (funcp)execute_14, (funcp)execute_15, (funcp)execute_16, (funcp)execute_17, (funcp)execute_84, (funcp)execute_151, (funcp)execute_152, (funcp)execute_153, (funcp)execute_154, (funcp)execute_221, (funcp)execute_222, (funcp)execute_223, (funcp)execute_290, (funcp)execute_291, (funcp)execute_292, (funcp)execute_359, (funcp)execute_360, (funcp)execute_361, (funcp)execute_428, (funcp)execute_429, (funcp)execute_430, (funcp)execute_497, (funcp)execute_498, (funcp)execute_499, (funcp)execute_566, (funcp)execute_567, (funcp)execute_568, (funcp)execute_635, (funcp)execute_636, (funcp)execute_637, (funcp)execute_704, (funcp)execute_771, (funcp)execute_83, (funcp)execute_20, (funcp)execute_21, (funcp)execute_23, (funcp)execute_24, (funcp)execute_27, (funcp)execute_28, (funcp)execute_31, (funcp)execute_32, (funcp)execute_33, (funcp)execute_35, (funcp)execute_36, (funcp)execute_39, (funcp)execute_40, (funcp)execute_41, (funcp)execute_43, (funcp)execute_44, (funcp)execute_47, (funcp)execute_48, (funcp)execute_49, (funcp)execute_51, (funcp)execute_52, (funcp)execute_55, (funcp)execute_56, (funcp)execute_57, (funcp)execute_59, (funcp)execute_60, (funcp)execute_63, (funcp)execute_64, (funcp)execute_65, (funcp)execute_67, (funcp)execute_68, (funcp)execute_71, (funcp)execute_72, (funcp)execute_73, (funcp)execute_75, (funcp)execute_76, (funcp)execute_79, (funcp)execute_80, (funcp)execute_81, (funcp)vhdl_transfunc_eventcallback};
const int NumRelocateId= 78;

void relocate(char *dp)
{
	iki_relocate(dp, "xsim.dir/tb_multiplier_behav/xsim.reloc",  (void **)funcTab, 78);
	iki_vhdl_file_variable_register(dp + 42936);
	iki_vhdl_file_variable_register(dp + 42992);


	/*Populate the transaction function pointer field in the whole net structure */
}

void sensitize(char *dp)
{
	iki_sensitize(dp, "xsim.dir/tb_multiplier_behav/xsim.reloc");
}

void simulate(char *dp)
{
		iki_schedule_processes_at_time_zero(dp, "xsim.dir/tb_multiplier_behav/xsim.reloc");
	// Initialize Verilog nets in mixed simulation, for the cases when the value at time 0 should be propagated from the mixed language Vhdl net
	iki_execute_processes();

	// Schedule resolution functions for the multiply driven Verilog nets that have strength
	// Schedule transaction functions for the singly driven Verilog nets that have strength

}
#include "iki_bridge.h"
void relocate(char *);

void sensitize(char *);

void simulate(char *);

extern SYSTEMCLIB_IMP_DLLSPEC void local_register_implicit_channel(int, char*);
extern void implicit_HDL_SCinstantiate();

extern void implicit_HDL_SCcleanup();

extern SYSTEMCLIB_IMP_DLLSPEC int xsim_argc_copy ;
extern SYSTEMCLIB_IMP_DLLSPEC char** xsim_argv_copy ;

int main(int argc, char **argv)
{
    iki_heap_initialize("ms", "isimmm", 0, 2147483648) ;
    iki_set_sv_type_file_path_name("xsim.dir/tb_multiplier_behav/xsim.svtype");
    iki_set_crvs_dump_file_path_name("xsim.dir/tb_multiplier_behav/xsim.crvsdump");
    void* design_handle = iki_create_design("xsim.dir/tb_multiplier_behav/xsim.mem", (void *)relocate, (void *)sensitize, (void *)simulate, 0, isimBridge_getWdbWriter(), 0, argc, argv);
     iki_set_rc_trial_count(100);
    (void) design_handle;
    return iki_simulate_design();
}
