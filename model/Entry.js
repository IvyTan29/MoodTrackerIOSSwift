import mongoose from 'mongoose';

const entrySchema = new mongoose.Schema({ 
    dateTime: {
        type: Date, 
        default: () => Date.now()
        // immutable: true
    }, 
    moodValue: {
        type: Number,
        required: true
    }, 
    note: {
        type: String,
        maxLength: 250,
        minLength: 0
    },
    tags: [
        {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'Tag'
        }
    ]
})

const Entry = mongoose.model("Entry", entrySchema, "Entry");
export { Entry }