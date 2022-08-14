import mongoose from 'mongoose'
import { User } from '../model/User.js';
import { Entry } from '../model/Entry.js';
import { Tag } from '../model/Tag.js';


let tags = [
    {
        "name": "Work",
        "moodValue": 0,
        "recent": 1

    },
    {
        "name": "Difficult Conversation",
        "moodValue": 0,
        "recent": 1
    },
    {
        "name": "Good Meal",
        "moodValue": 0,
        "recent": 1
    },
    {
        "name": "Presentation",
        "moodValue": 0,
        "recent": 1
    },
    {
        "name": "Swimming",
        "moodValue": 0,
        "recent": 1
    },
    {
        "name": "Energized",
        "moodValue": 0,
        "recent": 1
    },
    {
        "name": "Heart Broken",
        "moodValue": 0,
        "recent": 0
    },
    {
        "name": "Sleep",
        "moodValue": 0,
        "recent": 0
    },
    {
        "name": "Nervous",
        "moodValue": 0,
        "recent": 0
    },
    {
        "name": "Breakfast",
        "moodValue": 0,
        "recent": 0
    },
    {
        "name": "Lunch",
        "moodValue": 0,
        "recent": 0
    },
    {
        "name": "Dinner",
        "moodValue": 0,
        "recent": 0
    },
    {
        "name": "Exercise",
        "moodValue": 0,
        "recent": 0
    },
    {
        "name": "Study",
        "moodValue": 0,
        "recent": 0
    },
    {
        "name": "Read Book",
        "moodValue": 0,
        "recent": 0
    },
    {
        "name": "Read Webtoon",
        "moodValue": 0,
        "recent": 0
    },
    {
        "name": "Watch Series",
        "moodValue": 0,
        "recent": 0
    },
    {
        "name": "Watch Movie",
        "moodValue": 0,
        "recent": 0
    }
]

mongoose.connect('mongodb+srv://ivytanni:JesusLovesMe<3@cluster0.rmpuw.mongodb.net/MoodTracker?retryWrites=true&w=majority', {
    useNewUrlParser: true,
    useUnifiedTopology: true
  }).then(() => {
    console.log("Successfull connected to the database!!")
  }).catch(err => {
    console.log(err)
    console.log("Could not connect to the database. Will attempt to reconnect later...")
  });

Tag.insertMany(tags)
    .then(doc => {
        console.log(doc)
    })
    .catch(err => {
        console.log(err)
    })