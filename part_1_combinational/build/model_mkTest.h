/*
 * Generated by Bluespec Compiler, version 2023.07 (build 0eb551d)
 * 
 * On Tue Feb 27 15:22:34 CET 2024
 * 
 */

/* Generation options: */
#ifndef __model_mkTest_h__
#define __model_mkTest_h__

#include "bluesim_types.h"
#include "bs_module.h"
#include "bluesim_primitives.h"
#include "bs_vcd.h"

#include "bs_model.h"
#include "mkTest.h"

/* Class declaration for a model of mkTest */
class MODEL_mkTest : public Model {
 
 /* Top-level module instance */
 private:
  MOD_mkTest *mkTest_instance;
 
 /* Handle to the simulation kernel */
 private:
  tSimStateHdl sim_hdl;
 
 /* Constructor */
 public:
  MODEL_mkTest();
 
 /* Functions required by the kernel */
 public:
  void create_model(tSimStateHdl simHdl, bool master);
  void destroy_model();
  void reset_model(bool asserted);
  void get_version(char const **name, char const **build);
  time_t get_creation_time();
  void * get_instance();
  void dump_state();
  void dump_VCD_defs();
  void dump_VCD(tVCDDumpType dt);
};

/* Function for creating a new model */
extern "C" {
  void * new_MODEL_mkTest();
}

#endif /* ifndef __model_mkTest_h__ */
