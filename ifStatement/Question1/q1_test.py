import unittest
import q1

class q1Test(unittest.TestCase):

    def test1(self):
        self.assertEqual(q1.isPerfectSquare(5), False, "Should be false")
        self.assertEqual(q1.isPerfectSquare(4), True, "Should be true")
        self.assertEqual(q1.isPerfectSquare(62), False, "Should be false")

if __name__ == "__main__":
    unittest.main()