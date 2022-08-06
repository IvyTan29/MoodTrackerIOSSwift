import jwt from 'jsonwebtoken';

const authenticate = (req, res, next) => {
    const headerToken = req.headers['authorization'];

    // FIXME: refresh token
    try {
        var decoded = jwt.verify(headerToken, process.env.SECRET_KEY);
        req.session.userId = decoded.userId
        console.log(req.session.userId)
        next()
    } catch(err) {
        console.log(err.message)
        res.status(401).send(err.message)
    }
}

export { authenticate }