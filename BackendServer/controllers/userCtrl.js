import { User } from '../model/User.js';
import { Entry } from '../model/Entry.js';
import { Tag } from '../model/Tag.js';
import jwt from 'jsonwebtoken';
import bcrypt from 'bcrypt';
const saltRounds = 10;

const userCtrl = {
    
    login: (req, res) => {
        let userDetails

        User.findOne(
                {email: req.body.email}
            )
            .then(userDoc => {
                if (userDoc != null) {
                    userDetails = userDoc
                    return bcrypt.compare(req.body.password, userDoc.password)
                } else {
                    throw new Error("Incorrect email or password!")
                }
            })
            .then(result => {
                if (result) {
                    req.session.userId = userDetails._id
            
                    var token = jwt.sign({ userId: userDetails._id}, process.env.SECRET_KEY , {expiresIn: '2h'});

                    res.status(200).json(token)
                } else {
                    throw new Error("Incorrect email or password!")
                }
            })
            .catch(err => {
                console.log(err)
                res.status(500).send(err.message)
            })
    },

    logout: (req, res) => {
        req.session.destroy();

        res.status(200).json("Logout successful")
    },

    getUser: (req, res) => {
        var included = {
            name: 1, 
            email: 1,
            _id: 0
        }
        
        if (parseInt(req.query.includeEntries)) {
            included['entries'] = 1
        }
        
        User.findById(req.session.userId, '')
            .select(included)
            .then(doc => {
                res.status(200).json(doc)
            })
            .catch(err => {
                console.log(err)
                res.status(404).send('User not found');
            });
    },

    postUser: (req, res) => {

        if (!(req.body.email && req.body.password && req.body.name)) {
            return res.status(404).send('Fields cannot be empty')
        } 

        bcrypt.hash(req.body.password, saltRounds)
            .then(hashPassword => {
                let user = new User(req.body)
                user.password = hashPassword

                return user.save()
            })
            .then(userDoc => {
                console.log("New user created sucessfully!")
                
                var token = jwt.sign({ userId: userDoc._id}, process.env.SECRET_KEY , {expiresIn: '1d'})

                res.status(201).json(token)
            })
            .catch(err => {
                console.log(err)
                res.status(404).send(err.message);
            })
    },

    putUser: (req, res) => {
        User.findOneAndUpdate(
                { _id: req.session.userId},
                req.body,
                {upsert: true, new: true, runValidators: true, setDefaultsOnInsert: true, context: 'query'}
            )
            .then(userDoc => {
                res.status(200).json(userDoc)
            })
            .catch(err => {
                console.log(err)
                res.status(500).send('Internal Server Error');
            });
    },

    // TODO: check
    deleteUser: (req, res) => {
        User.deleteOne({ _id: req.session.userId})
            .then(userDoc => {
                res.status(200).send('User Deleted')
                return Entry.deleteMany(doc.entries)
            })
            .then()
            .catch(err => {
                console.log(err)
                res.status(500).send('Internal Server Error - unable to delete user');
            });
    }
}

export { userCtrl }