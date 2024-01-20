from flask import request


def get_data_from_request(request):
    mimetype = request.mimetype
    if mimetype == 'application/x-www-form-urlencoded':
        data = request.form.to_dict()
    elif mimetype == 'multipart/form-data':
        data = dict(request.form)
    elif mimetype == 'application/json':
        data = request.json
    else:
        data = request.data.decode()
    return data
