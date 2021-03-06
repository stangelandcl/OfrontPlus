MODULE Kernel;
IMPORT SYSTEM, Platform, Out := Console;

TYPE
  HaltProcedure = PROCEDURE(code: INTEGER);
  SignalHandler = PROCEDURE(signal: INTEGER);

VAR
  HaltCode-: INTEGER;

(* WINDOWS *)

(* Signals and traps *)

(* PROCEDURE -signal(sig: INTEGER; func: SignalHandler) "signal(sig, func)"; *)

(* TODO *)

(* Ctrl/c handling *)

PROCEDURE -SetInterruptHandler*(h: SignalHandler) "SystemSetInterruptHandler((SYSTEM_ADR)h)";

PROCEDURE -SetQuitHandler*     (h: SignalHandler) "SystemSetQuitHandler((SYSTEM_ADR)h)";

PROCEDURE SetBadInstructionHandler*(handler: SignalHandler);
BEGIN (* TODO *) END SetBadInstructionHandler;

(* UNIX

(* Signals and traps *)

PROCEDURE -sethandler(s: INTEGER; h: SignalHandler) "SystemSetHandler(s, (SYSTEM_ADR)h)";

PROCEDURE SetInterruptHandler*(handler: SignalHandler);
BEGIN sethandler(2, handler); END SetInterruptHandler;

PROCEDURE SetQuitHandler*(handler: SignalHandler);
BEGIN sethandler(3, handler); END SetQuitHandler;

PROCEDURE SetBadInstructionHandler*(handler: SignalHandler);
BEGIN sethandler(4, handler); END SetBadInstructionHandler;

*)


PROCEDURE DisplayHaltCode(code: INTEGER);
BEGIN
  CASE code OF
  | -1: Out.String("Rider ReadBuf/WriteBuf transfer size longer than buffer.")
  | -2: Out.String("Index out of range.")
  | -3: Out.String("Reached end of function without reaching RETURN.")
  | -4: Out.String("CASE statement: no matching label and no ELSE.")
  | -5: Out.String("Type guard failed.")
  | -6: Out.String("Type equality failed.")
  | -7: Out.String("WITH statement type guard failed.")
  | -8: Out.String("SHORT: Value too large for shorter type.")
  | -9: Out.String("Heap interrupted while locked, but lockdepth = 0 at unlock.")
  |-15: Out.String("Type descriptor size mismatch.")
  |-20: Out.String("Too many, or negative number of, elements in dynamic array.")
  |-25: Out.String("Memory allocation error.")
  ELSE
  END
END DisplayHaltCode;

(* UNIX:

PROCEDURE DisplayHaltCode(code: INTEGER);
BEGIN
  CASE code OF
  | -1: errstring("Assertion failure.")
  | -2: errstring("Index out of range.")
  | -3: errstring("Reached end of function without reaching RETURN.")
  | -4: errstring("CASE statement: no matching label and no ELSE.")
  | -5: errstring("Type guard failed.")
  | -6: errstring("Implicit type guard in record assignment failed.")
  | -7: errstring("Invalid case in WITH statement.")
  | -8: errstring("Value out of range.")
  | -9: errstring("Heap interrupted while locked, but lockdepth = 0 at unlock.")
  |-10: errstring("NIL access.");
  |-11: errstring("Alignment error.");
  |-12: errstring("Divide by zero.");
  |-13: errstring("Arithmetic overflow/underflow.");
  |-14: errstring("Invalid function argument.");
  |-15: errstring("Internal error, e.g. Type descriptor size mismatch.")
  |-20: errstring("Too many, or negative number of, elements in dynamic array.")
  |-25: errstring("Memory allocation error.")
  ELSE
  END
END DisplayHaltCode;

*)


PROCEDURE Halt*(code: INTEGER);
BEGIN
  HaltCode := code;
  Out.String("Terminated by Halt("); Out.Int(code, 0); Out.String("). ");
  IF code < 0 THEN DisplayHaltCode(code) END;
  Out.Ln;
  Platform.ExitOS(code)
END Halt;

PROCEDURE AssertFail*(code: INTEGER);
BEGIN
  Out.String("Assertion failure.");
  IF code # 0 THEN
    Out.String(" ASSERT code "); Out.Int(code, 0); Out.Char(".")
  END;
  Out.Ln;
  Platform.ExitOS(code)
END AssertFail;

PROCEDURE Exit*(code: INTEGER);
BEGIN
  Platform.ExitOS(code)
END Exit;

PROCEDURE -AAExternHaltHandler "extern void (*SYSTEM_HaltHandler)(INTEGER code);";
PROCEDURE -AAExternAssertFailHandler "extern void (*SYSTEM_AssertFailHandler)(INTEGER code);";

PROCEDURE -SetHaltHandler (p: HaltProcedure) "SYSTEM_HaltHandler = p";
PROCEDURE -SetAssertFail (p: HaltProcedure) "SYSTEM_AssertFailHandler = p";

PROCEDURE SetHalt*(p: HaltProcedure); BEGIN SetHaltHandler(p) END SetHalt;

BEGIN
  HaltCode := -128; SetHalt(Halt); SetAssertFail(AssertFail);
END Kernel.
