import mongoose from 'mongoose';

const tagSchema = new mongoose.Schema({
    name: {
        type: String,
        minlength: 2, 
        maxlength: 50
    },
    dateTime: {
        type: Number
    },
    moodValue: {
        type: Number
    },
    recent: {
        type: Number
    }
}); 

const Tag = mongoose.model("Tag", tagSchema, "Tag"); 
export { Tag }