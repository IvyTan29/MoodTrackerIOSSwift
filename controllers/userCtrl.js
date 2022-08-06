import { User } from '../model/User.js';
import { Entry } from '../model/Entry.js';
import { Tag } from '../model/Tag.js';
import jwt from 'jsonwebtoken';

const userCtrl = {
    login: (req, res) => {
        User.findOne(
                {email: req.body.email, password: req.body.password}
            )
            .then(userDoc => {
                if (userDoc != null) {
		            req.session.userId = userDoc._id
                    
                    var token = jwt.sign({ userId: userDoc._id}, process.env.SECRET_KEY , {expiresIn: '1d'});

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
        let user = new User(req.body);

        // FIXME: ADD HASHING
        user.save()
            .then(userDoc => {
                console.log("New user created sucessfully!")
                
                var token = jwt.sign({ userId: userDoc._id}, process.env.SECRET_KEY , {expiresIn: '1d'});

                res.status(201).json(token)
            })
            .catch(err => {
                console.log(err)

                //FIXME: place if statement
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