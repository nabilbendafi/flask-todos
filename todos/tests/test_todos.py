def test_index(client):
    response = client.get('/')
    assert response.status_code == 200
    assert b'<p>TODO list!</p>' in response.data

def test_post(client):
    response = client.post('/', data=dict(todo="Something to do"))
    assert response.status_code == 200
    assert b'<li>Something to do</li>' in response.data
