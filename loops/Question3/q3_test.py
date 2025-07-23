import unittest
import q3

class q3Test(unittest.TestCase):

    def test3(self):
        self.assertEqual(q3.search(q3.list), 4, "Index should be 4")

if __name__ == "__main__":
    unittest.main()