import unittest
import q2


class q2Test(unittest.TestCase):

    def test2(self):
        self.assertEqual(q2.squareRoot(q2.num), 56, "Should be 56")

if __name__ == "__main__":
    unittest.main()