import unittest
import q3

class q2Test(unittest.TestCase):
    
    def test2(self):
        self.assertEqual(q3.isprime(6), False, "Should be false")
        self.assertEqual(q3.isprime(99), False, "Should be false")
        self.assertEqual(q3.isprime(28), False, "Should be false")
        self.assertEqual(q3.isprime(7), True, "Should be true")

if __name__ == '__main__':
    unittest.main()