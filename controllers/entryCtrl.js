import { User } from '../model/User.js';
import { Entry } from '../model/Entry.js';
import { Tag } from '../model/Tag.js';

const entryCtrl = {
    getEntriesOfUser: (req, res) => {

        User.findById(req.session.userId)
            .populate({
                path: 'entries',
                populate : {
                    path: 'tags',
                    model: Tag
                  }
            })
            .then(result => {
                if (result.entries.length === 0) {
                    res.status(404).send('Entries not found');
                } else {
                    res.status(200).json(result.entries)
                }
            })
            .catch(err => {
                console.log(err)
                res.status(404).send('Entries not found');
            });
        // User.aggregate([
        //         {$match: { $expr : { $eq: ['$_id' , { $toObjectId: req.session.userId }] } }},
        //         {$lookup: { 
        //         localField: 'entries', 
        //         from: 'Entry', 
        //         foreignField: '_id', 
        //         as: 'entry' 
        //         }},
        //         {$unwind: "$entry"},
        //         {$project: {entry: 1, _id: 0}}
        //     ])
        //     .then(listEntries => {
        //         console.log(listEntries)
        
        //         if (listEntries.length === 0) {
        //             res.status(404).send('Entries not found');
        //         } else {
        //             res.status(200).json(listEntries)
        //         }
        //     })
        //     .catch(err => {
        //         console.log(err)
        //         res.status(404).send('Entries not found');
        //     });
    },

    getEntriesDay: (req, res) => {
        User.findById(req.session.userId)
            .populate({
                path: 'entries',
                populate : {
                    path: 'tags',
                    model: Tag
                },
                match: {
                    'dateTime': {
                        $gte: req.query.fromDate, 
                        $lt: req.query.toDate 
                    }
                }
            })
            .then(result => {
                if (result.entries.length === 0) {
                    res.status(404).send('Entries not found');
                } else {
                    return res.status(200).
                    res.status(200).json(result.entries)
                }
            })
            .catch(err => {
                console.log(err)
                res.status(404).send('Entries not found');
            });
    },

    getOneEntryOfUser: (req, res) => {
        User.aggregate([
                {$match: { $expr : { $eq: ['$_id' , { $toObjectId: req.session.userId }] } }},
                {$unwind: "$entries"},
                {$match: { $expr : { $eq: ['$entries' , { $toObjectId: req.params.entryId }] } }},
                {$lookup: { 
                localField: 'entries', 
                from: 'Entry', 
                foreignField: '_id', 
                as: 'entry' 
                }},
                {$unwind: "$entry"},
                {$project: {entry: 1, _id: 0}}
            ])
            .then(listEntries => {
                if (listEntries.length === 0) {
                    res.status(404).send('Entry not found');
                } else {
                    res.status(200).json(listEntries[0])
                }
            })
            .catch(err => {
                console.log(err)
                res.status(404).send('Entry not found');
            });
    },

    postEntry: (req, res) => {
        // FIXME: checks first if user exists
        let entry = new Entry(req.body);
        console.log("POST ENTRY")
        console.log(req.body)
        entry.save()
            .then(entryDoc => {
                console.log("New entry created sucessfully!")
                console.log(entryDoc)
                res.status(201).json(entryDoc)
                return User.findByIdAndUpdate(
                                req.session.userId,
                                {$push: {"entries": entryDoc._id}}
                            ) 
            })
            .then(userDoc => {
                console.log(userDoc)
            })
            .catch(err => {
                console.log(err)
                res.status(404).send(err.message);
            })
    },

    putEntry: (req, res) => {
        // FIXME: checks first if user exists
        Entry.findOneAndUpdate(
                { _id: req.params.entryId},
                req.body,
                {new: true, runValidators: true, context: 'query'}
            )
            .select("_id dateTime moodValue note")
            .exec()
            .then(entryDoc => {
                entryDoc.tags = []
                res.status(200).json(entryDoc)
            })
            .catch(err => {
                console.log(err)
                res.status(500).send(err.message);
            });
    },

    deleteEntry: (req, res) => {
        // FIXME: checks first if user exists
        User.findByIdAndUpdate(
                req.session.userId,
                {$pull: {"entries": req.params.entryId}}
            ) 
            .then(userDoc => {
                return Entry.deleteOne({ _id: req.params.entryId})
            })
            .then(entryDoc => {
                res.status(200).send('Entry Deleted')
            })
            .catch(err => {
                console.log(err)
                res.status(500).send('Internal server error - unable to delete entry');
            });
    }
}

export { entryCtrl }