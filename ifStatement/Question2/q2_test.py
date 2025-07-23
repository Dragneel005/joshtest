import unittest
import q2

class q2Test(unittest.TestCase):
    
    def test2(self):
        self.assertEqual(q2.isEvenThird(6), True, "Should be true")
        self.assertEqual(q2.isEvenThird(99), False, "Should be false")
        self.assertEqual(q2.isEvenThird(28), False, "Should be false")
        self.assertEqual(q2.isEvenThird(7), False, "Should be false")

if __name__ == '__main__':
    unittest.main()