def check_required(test, key):
    data = {**test.DEFAULT_DATA}
    data.pop(key, None)
    instance = test.Form(data=data)
    test.assertFalse(instance.is_valid())
    test.assertEquals(instance.errors.as_data()[key][0].code, 'required')


def check_unique(test, key, value):
    data = {**test.DEFAULT_DATA}
    data.update({key: value})
    instance = test.Form(data=data)
    test.assertFalse(instance.is_valid())
    test.assertEquals(instance.errors.as_data()[key][0].code, 'unique')
