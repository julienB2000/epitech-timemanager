import http from './api.service';

export default class UserService {
    create(user) {
        return http.post('/users', user)
    }

    getSingle(userID) {
        return http.get('/users/' + Number(userID))
    }

    update(user, userID) {
        return http.put('/users/' + Number(userID), user)
    }

    delete(userID) {
        return http.delete('/users/' + Number(userID))
    }

    get_all(){
        return http.get('/users')
    }

}