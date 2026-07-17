using System;
using System.Diagnostics;

using static amoeba.amoeba;

static
{
	[Test]
	static void test()
	{
		// first, create a solver:
		am_Solver* S = am_newsolver(null, null);

		int ret;

		// create some variable:
		am_Num l = ?, m = ?, r = ?;
		am_Id vl = am_newvariable(S, &l);
		am_Id vm = am_newvariable(S, &m);
		am_Id vr = am_newvariable(S, &r);

		// create the constraint:
		am_Constraint* c1 = am_newconstraint(S, AM_REQUIRED);
		am_Constraint* c2 = am_newconstraint(S, AM_REQUIRED);

		// c1: m is in middle of l and r:
		//     i.e. m = (l + r) / 2, or 2*m = l + r
		am_addterm(c1, vm, 2.f);
		am_setrelation(c1, AM_EQUAL);
		am_addterm(c1, vl, 1.f);
		am_addterm(c1, vr, 1.f);
		// apply c1
		ret = am_add(c1);
		Test.Assert(ret == AM_OK);

		// c2: r - l >= 100
		am_addterm(c2, vr, 1.f);
		am_addterm(c2, vl, -1.f);
		am_setrelation(c2, AM_GREATEQUAL);
		am_addconstant(c2, 100.f);
		// apply c2
		ret = am_add(c2);
		Test.Assert(ret == AM_OK);

		// now we set variable l to 20
		am_suggest(S, vl, 20.f);

		// and see the value of m and r:
		am_updatevars(S);

		// r should by 20 + 100 == 120:
		Test.Assert(r == 120.f);

		// and m should in middle of l and r:
		Test.Assert(m == 70.f);

		// done with solver
		am_delsolver(S);
	}
}