import mongoose from 'mongoose';
// import { Entry } from './Entry';
// const { Entry } = require('./Entry')

const userSchema = new mongoose.Schema({
    name: {
        type: String,
        maxLength: 100,
        minLength: 2,
        required: true
    },
    email: {
        type: String,
        maxLength: 100,
        minLength: 4,
        required: true,
        unique: true
    }, 
    password: {
        type: String,
        maxLength: 100,
        minLength: 7,
        required: true
    }, 
    entries: [
        {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'Entry'
        }
    ],
    tags: [
        {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'Tag'
        }
    ]
})

const User = mongoose.model("User", userSchema, "User");
export { User }