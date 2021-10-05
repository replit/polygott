import unittest
import unit_tests
import os
import json
from time import sleep

suite = unittest.TestLoader().loadTestsFromTestCase(
    unit_tests.UnitTests)
f = open(os.devnull,"w")
test_res = unittest.TextTestRunner(stream=f).run(suite)

# Merge errors and failures and normalize to {name, stack}
failures = [
    {
        "name": r[0]._testMethodName,
        "stack": r[1],
    } for r in test_res.errors + test_res.failures
]

print('\n__GOVAL_UNIT_TEST_RESULTS__')
sleep(1)
print(json.dumps({
    "passed": test_res.wasSuccessful(),
    "failures": failures,
}))
print()
