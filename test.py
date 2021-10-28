# This is a longer comment, which spans multiple lines
# Blah blah blah
# And some more text - this should definitely be readable
def my_test_fn():
    # This is a comment that explains stuff
    if True:
        my_test_var = 1239
        print(f"My test var: {my_test_var}")
        print('a')
        for inner_var in range(5):
            print(f'i: {inner_var}')
            if True:
                print('another')
    pass

class Blah(object):
    """
    This is a longer string - this should also
    be very readable even when it
    spans a lot of lines
    """
    def __init__(self, other):
        print(f"Other: {other}")
        self._foo = other ** 2

    def another(self, foo):
        self._foo += foo
        _bar = baz
