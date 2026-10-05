CS422 HW3

Implemented and tested with K v7.1.337 on WSL. Includes Exercises 1–5 and both versions of Exercise 4 for extra credit.

Files (paths relative to 1_k/):

1. Exercise 1: 1_lambda/lesson_8/lambda.k
   Three recursive programs are in hw3-tests/: sum.lambda, fib.lambda, and hanoi.lambda. Expected results: 55, 55, and 31. The mu macro uses a call-by-value fixed-point encoding for recursive functions.

2. Exercise 2: 2_imp/lesson_4/exercises/uninitialized-variables/imp.k
   Variables start as undefined. Reading an uninitialized variable causes execution to get stuck.

3. Exercise 3: 2_imp/lesson_4/exercises/purely-syntactic/imp.k
   Statements finish as {}. Sequencing uses strict(1), without explicit ~> in the definition.

4. Exercise 4: 3_lambda++/lesson_1/exercises/ (substitution) and 3_lambda++/lesson_6/exercises/ (environment).
   Each contains:
   - callCC/lambda.k: direct callCC definition.
   - from-call-CC-to-callcc/lambda.k: callcc defined using callCC.
   - from-callcc-to-call-CC/callcc.k: callCC defined using callcc, with macro expansion and a top-level program wrapper.
   The environment versions save and restore the environment with the continuation.

5. Exercise 5: 4_imp++/lesson_7/exercises/abort/imp.k
   abort; removes all threads. halt; still stops only the current thread.

Running

Enter the directory containing the source file, then run:

```bash
kompile SOURCE --main-module MAIN --syntax-module MAIN-SYNTAX
krun TEST --definition SOURCE-kompiled
```

Replace SOURCE with the filename in the kompile command, and with its basename (without .k) in the krun command. Replace MAIN and TEST with the module name and test path.

- imp.k: MAIN is IMP; definition directory is imp-kompiled.
- lambda.k: MAIN is LAMBDA, except for the environment from-call-CC-to-callcc version, which uses CALLCC. The definition directory is lambda-kompiled.
- callcc.k: MAIN is CALLCC; definition directory is callcc-kompiled.

For example, from the Exercise 1 directory:

```bash
kompile lambda.k --main-module LAMBDA --syntax-module LAMBDA-SYNTAX
krun hw3-tests/sum.lambda --definition lambda-kompiled
```

Selected tests are included in each exercise directory. Environment tests retain their tests/nondeterministic/ paths; the two additional tests in the environment from-call-CC-to-callcc directory are directly under tests/. Validation used individual executions, not exhaustive search.

The source definitions are based on the course PL tutorial. Original copyright notices and LICENSE.md are retained. Compiled files and backups are not included.
