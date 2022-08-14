import jwt from 'jsonwebtoken';

const authenticate = (req, res, next) => {
    const headerToken = req.headers['authorization'];

    try {
        var decoded = jwt.verify(headerToken, process.env.SECRET_KEY);
        req.session.userId = decoded.userId
        next()
    } catch(err) {
        console.log(err.message)
        // FIXME: check if refresh token
        // if String(err.message).includes("expired") {

        // }
        res.status(401).send(err.message)
    }
}

export { authenticate }