using System;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Text;

using static amoeba.amoeba;

namespace example;

static class Program
{
	static int Main(params String[] args)
	{
		// first, create a solver:
		am_Solver* S = am_newsolver(null, null);

		// create some variable:
		am_Var* l = am_newvariable(S);
		am_Var* m = am_newvariable(S);
		am_Var* r = am_newvariable(S);

		// create the constraint:
		am_Constraint* c1 = am_newconstraint(S, AM_REQUIRED);
		am_Constraint* c2 = am_newconstraint(S, AM_REQUIRED);

		// c1: m is in middle of l and r:
		//     i.e. m = (l + r) / 2, or 2*m = l + r
		am_addterm(c1, m, 2.f);
		am_setrelation(c1, AM_EQUAL);
		am_addterm(c1, l, 1.f);
		am_addterm(c1, r, 1.f);
		// apply c1
		am_add(c1);

		// c2: r - l >= 100
		am_addterm(c2, r, 1.f);
		am_addterm(c2, l, -1.f);
		am_setrelation(c2, AM_GREATEQUAL);
		am_addconstant(c2, 100.f);
		// apply c2
		am_add(c2);

		// now we set variable l to 20
		am_suggest(l, 20.f);

		// and see the value of m and r:
		am_updatevars(S);

		// r should by 20 + 100 == 120:
		Debug.Assert(am_value(r) == 120.f);

		// and m should in middle of l and r:
		Debug.Assert(am_value(m) == 70.f);

		// done with solver
		am_delsolver(S);
		return 0;
	}
}