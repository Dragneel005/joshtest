import unittest
import q1 as q1

class q1Test(unittest.TestCase):

    def test1(self):
        self.assertEqual(q1.evenNum(q1.numList), [2, 8, 12, 78], "Should only be even")

if __name__ == "__main__":
    unittest.main()